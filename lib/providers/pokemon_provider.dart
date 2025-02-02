import 'package:flutter/material.dart';
import '../models/pokemon.dart';
import '../services/api_service.dart';

class PokemonProvider with ChangeNotifier {
  List<Pokemon> _pokemonList = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Pokemon> get pokemonList => _pokemonList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch Pokémon list from API
  Future<void> fetchPokemonList({int limit = 10}) async {
    _setLoadingState(true);

    try {
      _pokemonList = await ApiService.fetchPokemonList(limit: limit);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to fetch Pokémon: $e";
    } finally {
      _setLoadingState(false);
    }
  }

  /// Refresh Pokémon list
  Future<void> refreshPokemonList({int limit = 10}) async {
    await fetchPokemonList(limit: limit);
  }

  /// Private method to set loading state and notify listeners
  void _setLoadingState(bool state) {
    _isLoading = state;
    notifyListeners();
  }
}
