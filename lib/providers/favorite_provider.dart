import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class FavoriteProvider extends ChangeNotifier {
  final List<int> _favoriteIds = [];
  bool _isLoaded = false;

  FavoriteProvider() {
    _loadFavorites();
  }

  List<int> get favoriteIds => List.unmodifiable(_favoriteIds);
  bool get isLoaded => _isLoaded;

  bool isFavorite(int productId) => _favoriteIds.contains(productId);

  Future<void> toggleFavorite(Product product) async {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    await _persist();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('favorite_product_ids') ?? [];
    _favoriteIds
      ..clear()
      ..addAll(savedIds.map(int.parse).whereType<int>());
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'favorite_product_ids',
      _favoriteIds.map((id) => id.toString()).toList(),
    );
  }
}
