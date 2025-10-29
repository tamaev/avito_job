import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app/app.dart';
import 'features/favorite/presentation/providers/favorites_provider.dart';
import 'features/auth/presentation/pages/register_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const AvitoJobApp(),
    ),
  );
}

class AvitoJobApp extends StatelessWidget {
  const AvitoJobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Avito Job',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const RegisterPage(), //
    );
  }
}
