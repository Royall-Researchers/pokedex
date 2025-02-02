import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/pokemon_provider.dart';
import '../widgets/pokemon_card.dart';
import 'package:flutter/services.dart'; // For SystemNavigator

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Exiting the app when back arrow is pressed
            SystemNavigator.pop(); // Close the app
          },
        ),
        title: const Text(
          'Pokédex',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: Image.asset('images/pokeball.png', fit: BoxFit.cover),
                ),
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  onPressed: () {
                    // Implement menu functionality here
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      body: Consumer<PokemonProvider>(
        builder: (context, pokemonProvider, child) {
          if (pokemonProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (pokemonProvider.pokemonList.isEmpty) {
            return const Center(child: Text('No Pokémon found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: pokemonProvider.pokemonList.length,
            itemBuilder: (context, index) {
              return PokemonCard(pokemon: pokemonProvider.pokemonList[index]);
            },
          );
        },
      ),
    );
  }
}
