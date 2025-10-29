import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ad_model.dart';
import '../../../favorite/presentation/providers/favorites_provider.dart';
import '../../../favorite/presentation/pages/favorite_page.dart';
import 'ad_details_page.dart';
import '../../../chat/presentation/pages/chat_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey _overlayKey = GlobalKey();

  void _showFlyingHeart(BuildContext context, Offset position) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (_) => FlyingHeartAnimation(position: position),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 1), () => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final favoriteCount = favoritesProvider.favorites.length;

    final List<AdModel> ads = [
      AdModel(
        id: 1,
        title: 'iPhone 14 Pro 128GB',
        description: 'Продаю iPhone 14 Pro, в отличном состоянии.',
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-14-pro-family-hero',
        price: 88000,
        location: 'Москва',
        seller: 'Алексей',
      ),
      AdModel(
        id: 2,
        title: 'Ноутбук MacBook Air M2',
        description: 'Новый, 8GB RAM, 256GB SSD, цвет Starlight.',
        imageUrl:
        'https://frankfurt.apollo.olxcdn.com/v1/files/vkfzhxifcde71-KZ/image',
        price: 110000,
        location: 'Москва',
        seller: 'Екатерина',
      ),
      AdModel(
        id: 3,
        title: 'Электросамокат Xiaomi Mi Pro 2',
        description:
        'Батарея 100%, пробег 300 км, скорость до 25 км/ч. Зарядка в комплекте.',
        imageUrl:
        'https://tyumen.trade59.ru/content/files/catalog1/source/xes4prob2_1689770724.jpg',
        price: 32000,
        location: 'Казань',
        seller: 'Денис',
      ),
      AdModel(
        id: 4,
        title: 'Sony PlayStation 5 Digital Edition',
        description:
        'Консоль в идеале, коробка, чек, 1 геймпад, гарантия. Игра Horizon в подарок.',
        imageUrl:
        'https://avatars.mds.yandex.net/get-mpic/11482776/2a0000019335a14a1c8c2db9c0dbd561122b/orig',
        price: 68000,
        location: 'Екатеринбург',
        seller: 'Ирина',
      ),
      AdModel(
        id: 5,
        title: 'Шкаф-купе IKEA',
        description:
        'Шкаф-купе белый, 3 секции, зеркальная дверь, высота 2.2 м, ширина 1.8 м. Самовывоз.',
        imageUrl:
        'https://i.pinimg.com/736x/4b/2f/50/4b2f50fdcf9d7e14123376434236e096.jpg',
        price: 14000,
        location: 'Новосибирск',
        seller: 'Светлана',
      ),
      AdModel(
        id: 6,
        title: 'Кроссовки Nike Air Max 270',
        description:
        'Оригинал, размер 43, куплены весной, носил мало. Удобные и лёгкие.',
        imageUrl:
        'https://nizhniy-novgorod.streetfoot.ru/wp-content/uploads/2018/06/nike-air-max-270-black-red-nylon-1.jpg',
        price: 9500,
        location: 'Воронеж',
        seller: 'Павел',
      ),
      AdModel(
        id: 7,
        title: 'Apple Watch Series 9',
        description:
        'Новые, не вскрытые, гарантия 1 год. Цвет — Midnight. Отличный подарок.',
        imageUrl:
        'https://static.eldorado.ru/promo/src/prodazhi-smart-chasov/img/img3.webp',
        price: 43000,
        location: 'Москва',
        seller: 'Ольга',
      ),
      AdModel(
        id: 8,
        title: 'Смарт-телевизор Samsung 55"',
        description:
        '4K UHD, Smart TV, диагональ 55 дюймов, пульт с голосовым управлением. Состояние отличное.',
        imageUrl:
        'https://mobilo4ka.ru/image/catalog/TVs/UE55CU7100UXRU/UE55CU7100UXRU-1.jpg',
        price: 52000,
        location: 'Пермь',
        seller: 'Кирилл',
      ),
      AdModel(
        id: 9,
        title: 'Велосипед Trek Marlin 7',
        description:
        'Алюминиевая рама, гидравлические тормоза, 29 дюймов. Состояние отличное, 2023 год.',
        imageUrl: 'https://i.ytimg.com/vi/wgxxv1XkgCQ/maxresdefault.jpg',
        price: 58000,
        location: 'Тула',
        seller: 'Антон',
      ),
      AdModel(
        id: 10,
        title: 'Фен Dyson Pocket Ultra',
        description:
        'Фен оснащён двигателем Dyson V9 с цифровым управлением, который создаёт контролируемый воздушный поток для быстрого высушивания и укладки',
        imageUrl: 'https://ir.ozone.ru/s3/multimedia-1-6/w1200/7131101586.jpg',
        price: 43000,
        location: 'Москва',
        seller: 'Екатерина',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Поиск'),
        actions: [
          Stack(
            alignment: Alignment.topRight,
            children: [
              IconButton(
                icon: const Icon(Icons.favorite, color: Colors.redAccent),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const FavoritePage()));
                },
              ),
              if (favoriteCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$favoriteCount',
                      style:
                      const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),


      body: ListView.builder(
        key: _overlayKey,
        padding: const EdgeInsets.all(8),
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          final isFav = favoritesProvider.isFavorite(ad);

          return Stack(
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
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
                  trailing: IconButton(
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      favoritesProvider.toggleFavorite(ad);
                      final box = context.findRenderObject() as RenderBox?;
                      if (box != null) {
                        final position = box.localToGlobal(Offset.zero);
                        _showFlyingHeart(context, position);
                      }
                    },
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => AdDetailsPage(ad: ad)),
                  ),
                ),
              ),
            ],
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ChatPage()),
          );
        },
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }
}

class FlyingHeartAnimation extends StatefulWidget {
  final Offset position;
  const FlyingHeartAnimation({super.key, required this.position});

  @override
  State<FlyingHeartAnimation> createState() => _FlyingHeartAnimationState();
}

class _FlyingHeartAnimationState extends State<FlyingHeartAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;
  late final Animation<Offset> _offset;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(milliseconds: 800))
      ..forward();
    _scale = Tween<double>(begin: 0.5, end: 1.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 1, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _offset = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.5))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx + 60,
      top: widget.position.dy,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) => Opacity(
          opacity: _opacity.value,
          child: SlideTransition(
            position: _offset,
            child: Transform.scale(
              scale: _scale.value,
              child: const Icon(Icons.favorite, color: Colors.red, size: 40),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
