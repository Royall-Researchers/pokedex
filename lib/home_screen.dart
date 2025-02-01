import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pokemon_detail_screen.dart';
import 'pokemon_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pokemonProvider = Provider.of<PokemonProvider>(context);
    if (pokemonProvider.pokedex.isEmpty) {
      pokemonProvider.fetchPokemonData();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {},
                ),
                const Text(
                  "Pokedex",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'images/pokeball.png',
                        height: 80,
                        width: 80,
                      ),
                    ),
                    const Icon(
                      Icons.menu,
                      size: 28,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: pokemonProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),
                itemCount: pokemonProvider.pokedex.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<Map<String, dynamic>>(
                    future: pokemonProvider.fetchPokemonDetails(
                        pokemonProvider.pokedex[index]['url']),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError || snapshot.data == null) {
                        return const Center(child: Text('Error loading Pokémon'));
                      }

                      var pokemonData = snapshot.data!;
                      var types = (pokemonData['types'] as List?)
                          ?.map((typeInfo) => typeInfo['type']['name'])
                          .toList() ??
                          [];
                      String firstType = types.isNotEmpty ? types[0] : 'unknown';
                      Color bgColor = getTypeColor(firstType);

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PokemonDetailScreen(
                                pokemonId: pokemonData['id'],
                                color: bgColor,
                                heroTag: index,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: -10,
                                right: -10,
                                child: Opacity(
                                  opacity: 0.2,
                                  child: Image.asset(
                                    'images/pokeball.png',
                                    height: 120,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pokemonProvider.pokedex[index]['name']
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        firstType.toUpperCase(),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: Image.network(
                                  pokemonData['sprites']?['front_default'] ?? '',
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'grass':
        return Colors.green;
      case 'fire':
        return Colors.redAccent;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.yellow.shade700;
      case 'bug':
        return Colors.lightGreen;
      case 'normal':
        return Colors.grey;
      default:
        return Colors.purpleAccent;
    }
  }
}