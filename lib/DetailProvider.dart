import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonDetailProvider with ChangeNotifier {
  Map<String, dynamic>? _pokemonDetail;
  bool _isLoading = true;

  Map<String, dynamic>? get pokemonDetail => _pokemonDetail;
  bool get isLoading => _isLoading;

  Future<void> fetchPokemonDetails(int pokemonId) async {
    final url = 'https://pokeapi.co/api/v2/pokemon/$pokemonId/';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _pokemonDetail = json.decode(response.body);
    } else {
      // Handle error response
      _pokemonDetail = null;
    }
    _isLoading = false;
    notifyListeners();
  }
}