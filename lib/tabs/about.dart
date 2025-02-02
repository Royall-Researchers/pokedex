import 'package:flutter/material.dart';
import '../../models/pokemon.dart';

class AboutTab extends StatelessWidget {
  final Pokemon pokemon;

  const AboutTab({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Pokémon Info"),
          _buildDetailRow("Species", pokemon.species),
          _buildDetailRow("Type", pokemon.type),
          _buildDetailRow("Height", "${pokemon.height} m"),
          _buildDetailRow("Weight", "${pokemon.weight} kg"),

          _buildDivider(),

          _buildSectionTitle("Abilities"),
          _buildDetailRow("Abilities", pokemon.abilities.isNotEmpty
              ? pokemon.abilities.join(', ')
              : "Unknown"),

          _buildDivider(),

          _buildSectionTitle("Breeding"),
          _buildDetailRow("Gender", pokemon.gender.isNotEmpty ? pokemon.gender : "Unknown"),
          _buildDetailRow("Egg Groups", pokemon.eggGroups.isNotEmpty
              ? pokemon.eggGroups.join(', ')
              : "Unknown"),
          _buildDetailRow("Egg Cycle", pokemon.eggCycle > 0
              ? "${pokemon.eggCycle} steps"
              : "Unknown"),
        ],
      ),
    );
  }

  /// **Helper method to create section title**
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// **Helper method to create each row with proper spacing & alignment**
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Flexible(
            child: Text(
              value.isNotEmpty ? value : "Unknown",
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  /// **Helper method to create a subtle divider**
  Widget _buildDivider() {
    return const Divider(thickness: 1, color: Colors.grey, height: 20);
  }
}
