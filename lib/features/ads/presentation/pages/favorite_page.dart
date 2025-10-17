import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ads/presentation/models/ad_model.dart';
import '../../../favorite/presentation/providers/favorites_provider.dart';
import '../../../ads/presentation/pages/ad_details_page.dart';

class FavoritePage extends StatelessWidget {
  const FavoritePage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;


    return Scaffold(
      appBar: AppBar(title: const Text("Избранное")),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          'Пока нет избранных объявлений ❤️',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final ad = favorites[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                ad.imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(ad.title),
            subtitle: Text('${ad.price} ₽ — ${ad.location}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AdDetailsPage(ad: ad)),
              );
            },
          );
        },
      ),
    );
  }
}
