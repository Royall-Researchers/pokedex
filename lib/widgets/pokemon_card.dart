import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../screens/details_screen.dart';

class PokemonCard extends StatelessWidget {
  final Pokemon pokemon;

  const PokemonCard({super.key, required this.pokemon});

  Color getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'grass': return Colors.green;
      case 'fire': return Colors.red;
      case 'water': return Colors.blue;
      case 'electric': return Colors.amber;
      case 'bug': return Colors.brown;
      case 'poison': return Colors.purple;
      case 'psychic': return Colors.pink;
      case 'ground': return Colors.orange;
      case 'rock': return Colors.grey;
      case 'fighting': return Colors.deepOrange;
      case 'ghost': return Colors.indigo;
      case 'ice': return Colors.cyan;
      case 'dragon': return Colors.deepPurple;
      case 'dark': return Colors.black87;
      case 'steel': return Colors.blueGrey;
      case 'fairy': return Colors.pinkAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => DetailsScreen(pokemon: pokemon)),
      ),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        color: getTypeColor(pokemon.type), // Background color based on type
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Stack(
            children: [
              // Right Side: Pokémon Image with Pokéball Background
              Positioned.fill(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Pokéball Background
                        Opacity(
                          opacity: 0.35,
                          child: Image.asset(
                            'images/pokeball.png', // Ensure this file exists in the correct folder
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                        // Pokémon Image (with error handling)
                        Image.network(
                          pokemon.imageUrl,
                          width: 90,
                          height: 90,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            'images/pokeball.png', // Fallback image if network fails
                            width: 80,
                            height: 80,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Left Side: Name and Type
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name[0].toUpperCase() + pokemon.name.substring(1).toLowerCase(),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 8),

                  // Pokémon Type with Styled Background
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      pokemon.type,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
