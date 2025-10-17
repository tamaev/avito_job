import 'package:flutter/material.dart';
import '../../../ads/presentation/models/ad_model.dart';

class FavoritesProvider extends ChangeNotifier {
  final List<AdModel> _favorites = [];

  List<AdModel> get favorites => _favorites;

  bool isFavorite(AdModel ad) => _favorites.any((item) => item.id == ad.id);

  void toggleFavorite(AdModel ad) {
    if (isFavorite(ad)) {
      _favorites.removeWhere((item) => item.id == ad.id);
    } else {
      _favorites.add(ad);
    }
    notifyListeners();
  }
}
