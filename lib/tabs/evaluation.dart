import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:triongle/models/pokemon.dart';

class EvolutionTab extends StatefulWidget {
  final Pokemon pokemon;

  const EvolutionTab({super.key, required this.pokemon});

  @override
  EvolutionTabState createState() => EvolutionTabState();
}

class EvolutionTabState extends State<EvolutionTab> {
  late Future<List<Map<String, String>>> evolutionChain;

  @override
  void initState() {
    super.initState();
    evolutionChain = fetchEvolutionChain(widget.pokemon.evolutionChainUrl);
  }

  Future<List<Map<String, String>>> fetchEvolutionChain(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, String>> evolutions = [];
      var chain = data['chain'];

      while (chain != null) {
        String speciesName = chain['species']['name'];
        String imageUrl = await fetchPokemonImage(speciesName);
        String level = chain['evolution_details'].isNotEmpty
            ? "Lvl ${chain['evolution_details'][0]['min_level'] ?? '??'}"
            : "Lvl ??";

        evolutions.add({'name': speciesName, 'imageUrl': imageUrl, 'level': level});
        chain = chain['evolves_to'].isEmpty ? null : chain['evolves_to'][0];
      }

      return evolutions;
    } else {
      throw Exception('Failed to load evolution data');
    }
  }

  Future<String> fetchPokemonImage(String speciesName) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$speciesName'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['sprites']['other']['official-artwork']['front_default'] ?? '';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: evolutionChain,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                for (int i = 0; i < snapshot.data!.length - 1; i++) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildPokemonColumn(snapshot.data![i]),
                      const SizedBox(width: 10),
                      buildEvolutionArrow(snapshot.data![i + 1]['level']!),
                      const SizedBox(width: 10),
                      buildPokemonColumn(snapshot.data![i + 1]),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          );
        } else {
          return const Center(child: Text("Evolution data not available"));
        }
      },
    );
  }

  Widget buildPokemonColumn(Map<String, String> pokemonData) {
    return Column(
      children: [
        Image.network(
          pokemonData['imageUrl']!,
          width: 130,
          height: 130,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50),
        ),
        const SizedBox(height: 5),
        Text(
          pokemonData['name']!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 16),
        ),
      ],
    );
  }

  Widget buildEvolutionArrow(String level) {
    return Column(
      children: [
        Text(
          level,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          "→",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
