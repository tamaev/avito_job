// lib/app/app.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/ads/presentation/pages/search_page.dart';
import '../features/favorite/presentation/pages/favorite_page.dart';
import '../features/chat/presentation/pages/chat_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/ads/presentation/pages/my_ads_page.dart';
import '../features/favorite/presentation/providers/favorites_provider.dart';

/// 🔹 Глобальный контроллер навигации
final ValueNotifier<int> bottomNavIndex = ValueNotifier<int>(0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final List<Widget> pages = [
      SearchPage(),
      FavoritePage(),
      MyAdsPage(),
      ChatPage(seller: 'Пользователь'),
      ProfilePage(),
    ];

    return ValueListenableBuilder<int>(
      valueListenable: bottomNavIndex,
      builder: (context, index, _) {
        return Scaffold(
          body: pages[index],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: index,
            onTap: (newIndex) => bottomNavIndex.value = newIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                label: 'Поиск',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.favorite),
                    if (favoritesProvider.favorites.isNotEmpty)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                          child: Text(
                            '${favoritesProvider.favorites.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Избранное',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.list_alt),
                label: 'Мои объявления',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Сообщения',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Профиль',
              ),
            ],
          ),
        );
      },
    );
  }
}
