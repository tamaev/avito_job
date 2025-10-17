import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/favorite/presentation/providers/favorites_provider.dart';
import 'app/app.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}
