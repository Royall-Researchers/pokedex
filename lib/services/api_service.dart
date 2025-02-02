import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/pokemon.dart';

class ApiService {
  static const String _baseUrl = 'https://pokeapi.co/api/v2';

  /// **Fetch list of Pokémon**
  static Future<List<Pokemon>> fetchPokemonList({int limit = 10}) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/pokemon?limit=$limit'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> results = data['results'];

        // Use Future.wait to fetch Pokémon details and species data in parallel
        List<Future<Pokemon>> pokemonFutures = results.map((result) async {
          return await _fetchPokemonByUrl(result['url']);
        }).toList();

        return await Future.wait(pokemonFutures);
      } else {
        throw Exception("Failed to load Pokémon list");
      }
    } catch (e) {
      throw Exception("Error fetching Pokémon list: $e");
    }
  }

  /// **Fetch a single Pokémon by ID**
  static Future<Pokemon> fetchPokemon(int id) async {
    try {
      return await _fetchPokemonByUrl('$_baseUrl/pokemon/$id');
    } catch (e) {
      throw Exception("Error fetching Pokémon with ID $id: $e");
    }
  }

  /// **Private helper function to fetch Pokémon by URL**
  static Future<Pokemon> _fetchPokemonByUrl(String url) async {
    try {
      final pokemonResponse = await http.get(Uri.parse(url));

      if (pokemonResponse.statusCode == 200) {
        final pokemonData = json.decode(pokemonResponse.body);

        // Fetch species data in parallel
        final speciesResponse = await http.get(Uri.parse(pokemonData['species']['url']));
        final speciesData = json.decode(speciesResponse.body);

        return Pokemon.fromJson(pokemonData, speciesData);
      } else {
        throw Exception('Failed to load Pokémon data');
      }
    } catch (e) {
      throw Exception("Error fetching Pokémon data from $url: $e");
    }
  }
}
