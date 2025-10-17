import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ad_model.dart';
import '../../../favorite/presentation/providers/favorites_provider.dart';
import '../../../favorite/presentation/pages/favorite_page.dart';
import 'ad_details_page.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);

    final List<AdModel> ads = [
      AdModel(
        id: 1,
        title: 'iPhone 14 Pro 128GB',
        description: 'Продаю iPhone 14 Pro, в отличном состоянии.',
        imageUrl: 'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-14-pro-family-hero',
        price: 88000,
        location: 'Москва',
        seller: 'Алексей',
      ),
      AdModel(
        id: 2,
        title: 'Ноутбук MacBook Air M2',
        description: 'Новый, 8GB RAM, 256GB SSD, цвет Starlight.',
        imageUrl: 'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-air-m2-chip-hero',
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
        imageUrl:
        'https://trek.scene7.com/is/image/TrekBicycleProducts/Marlin7_23_37286_A_Primary',
        price: 58000,
        location: 'Тула',
        seller: 'Антон',
      ),
      AdModel(
        id: 10,
        title: 'Ноутбук MacBook Air M2',
        description:
        'Новый, 8GB RAM, 256GB SSD, цвет Starlight. Гарантия 1 год, в коробке.',
        imageUrl:
        'https://store.storeimages.cdn-apple.com/4668/as-images.apple.com/is/macbook-air-m2-chip-hero',
        price: 110000,
        location: 'Москва',
        seller: 'Екатерина',
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Поиск')),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: ads.length,
        itemBuilder: (context, index) {
          final ad = ads[index];
          final isFav = favoritesProvider.isFavorite(ad);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Image.network(ad.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
              title: Text(ad.title),
              subtitle: Text('${ad.price} ₽ — ${ad.location}'),
              trailing: IconButton(
                icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.red : Colors.grey),
                onPressed: () => favoritesProvider.toggleFavorite(ad),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AdDetailsPage(ad: ad))),
            ),
          );
        },
      ),
    );
  }
}
