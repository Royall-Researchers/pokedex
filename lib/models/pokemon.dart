class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final String type;
  final double height;
  final double weight;
  final List<String> abilities;
  final String species;
  final String gender;
  final List<String> eggGroups;
  final int eggCycle;
  final Map<String, int> stats;
  final String evolutionChainUrl;

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.type,
    required this.height,
    required this.weight,
    required this.abilities,
    required this.species,
    required this.gender,
    required this.eggGroups,
    required this.eggCycle,
    required this.stats,
    required this.evolutionChainUrl,
  });

  /// Creates a Pokemon instance from JSON response
  factory Pokemon.fromJson(
      Map<String, dynamic> json, Map<String, dynamic> speciesJson) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      type: json['types'][0]['type']['name'],
      height: json['height'] / 10.0,
      weight: json['weight'] / 10.0,
      abilities: List<String>.from(json['abilities'].map((a) => a['ability']['name'])),
      species: speciesJson['name'],
      gender: _getGender(speciesJson['gender_rate']),
      eggGroups: List<String>.from(speciesJson['egg_groups'].map((e) => e['name'])),
      eggCycle: speciesJson['hatch_counter'],
      stats: {
        'hp': json['stats'][0]['base_stat'],
        'attack': json['stats'][1]['base_stat'],
        'defense': json['stats'][2]['base_stat'],
        'specialAttack': json['stats'][3]['base_stat'],
        'specialDefense': json['stats'][4]['base_stat'],
        'speed': json['stats'][5]['base_stat'],
      },
      evolutionChainUrl: speciesJson['evolution_chain']['url'],
    );
  }

  /// Converts gender_rate into a readable format
  static String _getGender(int genderRate) {
    if (genderRate == -1) return "Genderless";
    if (genderRate == 0) return "100% ♂";
    if (genderRate == 8) return "100% ♀";
    return "${(genderRate / 8) * 100}% ♀, ${(1 - (genderRate / 8)) * 100}% ♂";
  }
}
