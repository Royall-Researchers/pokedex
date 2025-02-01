import 'dart:convert'; // Add this import for JSON decoding
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http; // Add this import for HTTP requests
import 'pokemon_provider.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int pokemonId;
  final Color color;
  final int heroTag;

  const PokemonDetailScreen({
    super.key,
    required this.pokemonId,
    required this.color,
    required this.heroTag,
  });

  @override
  _PokemonDetailScreenState createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  late Map<String, dynamic> pokemonDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchPokemonDetails();
  }

  Future<void> fetchPokemonDetails() async {
    final pokemonProvider = Provider.of<PokemonProvider>(context, listen: false);
    final url = 'https://pokeapi.co/api/v2/pokemon/${widget.pokemonId}/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        pokemonDetail = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: widget.color,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Fetch image and other details
    String imageUrl = pokemonDetail['sprites']?['other']?['home']?['front_default'] ?? '';
    String name = pokemonDetail['name'];
    List types = pokemonDetail['types']?.map((t) => t['type']['name']).toList() ?? [];
    String firstType = types.isNotEmpty ? types[0] : 'Unknown';
    String pokemonHeight = pokemonDetail['height'] != null
        ? (pokemonDetail['height'] / 10).toString() + ' m'
        : 'Unknown';

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: widget.color,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 30,
            left: 1,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned(
            top: 70,
            left: 5,
            child: Text(
              name.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
          Positioned(
            top: 140,
            left: 20,
            child: Container(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0, bottom: 4.0),
              child: Text(
                types.join(' , ').toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
            ),
          ),
          Positioned(
            top: height * 0.18,
            right: -30,
            child: Image.asset(
              'images/pokeball.png',
              height: 200,
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: width,
              height: height * 0.6,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.3,
                            child: const Text("Name"),
                          ),
                          Container(
                            width: width * 0.3,
                            child: Text(
                              name.toLowerCase(),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: width * 0.3,
                            child: const Text("Height"),
                          ),
                          Container(
                            width: width * 0.3,
                            child: Text(
                              pokemonHeight,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: height * 0.18,
            left: width / 2 - 100,
            child: Image.network(
              imageUrl,
              height: 200,
              fit: BoxFit.fitHeight,
            ),
          ),
        ],
      ),
    );
  }
}