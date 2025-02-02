import 'package:flutter/material.dart';
import '../../models/pokemon.dart';

class BaseStatsTab extends StatelessWidget {
  final Pokemon pokemon;

  const BaseStatsTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: pokemon.stats.entries.map((stat) {
          String statName = _getShortenedStatName(stat.key); // Get the readable stat name for display
          Color progressBarColor = _getProgressBarColor(stat.key); // Get color based on the original key
          double normalizedValue = (stat.value / 255).clamp(0.0, 1.0);

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Left-aligned stat name
                SizedBox(
                  width: 120,
                  child: Text(
                    statName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Centered stat value
                SizedBox(
                  width: 50,
                  child: Text(
                    "${stat.value}",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                ),

                // Progress bar with color mapping based on stat key
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: LinearProgressIndicator(
                      value: normalizedValue,
                      minHeight: 8,
                      color: progressBarColor,
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // Static color map for fast lookup using the original stat names
  static const Map<String, Color> _statColors = {
    'hp': Colors.green,
    'attack': Colors.red,
    'defense': Colors.blue,
    'special-attack': Colors.orange,
    'special-defense': Colors.purple,
    'speed': Colors.yellow,
  };

  // Function to get progress bar color based on stat key
  Color _getProgressBarColor(String statName) {
    return _statColors[statName.toLowerCase()] ?? Colors.grey;
  }

  // Function to return a more readable stat name (e.g., 'special-attack' -> 'Special Attack')
  String _getShortenedStatName(String statName) {
    // Replace hyphens with spaces, but keep the original names for color mapping
    if (statName == 'special-attack') {
      return 'Special Attack'; // Display name with space
    } else if (statName == 'special-defense') {
      return 'Special Defense'; // Display name with space
    } else {
      // Capitalize first letter for other stats
      return statName[0].toUpperCase() + statName.substring(1);
    }
  }
}
