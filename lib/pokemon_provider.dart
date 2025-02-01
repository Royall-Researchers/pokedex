import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PokemonProvider with ChangeNotifier {
  List pokedex = [];
  bool isLoading = false;

  Future<void> fetchPokemonData() async {
    isLoading = true;
    notifyListeners();

    var pokeApi = "https://pokeapi.co/api/v2/pokemon?limit=10&offset=0";
    var response = await http.get(Uri.parse(pokeApi));

    if (response.statusCode == 200) {
      var decodedJsonData = jsonDecode(response.body);
      pokedex = decodedJsonData['results'] ?? [];
    }

    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchPokemonDetails(String url) async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }
}