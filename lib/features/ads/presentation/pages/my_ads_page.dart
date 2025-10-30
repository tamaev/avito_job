import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../chat/presentation/pages/chat_page.dart';
import '../models/ad_model.dart';

class MyAdsPage extends StatefulWidget {
  const MyAdsPage({super.key});

  @override
  State<MyAdsPage> createState() => _MyAdsPageState();
}

class _MyAdsPageState extends State<MyAdsPage> {
  List<AdModel> myAds = [];

  final List<String> templateImages = [
    'https://avatars.dzeninfra.ru/get-zen_doc/271828/pub_6874fa66ef09bd32e52bfdc6_6874fa9ad97ee50e8a71517b/scale_1200',
    'https://cdn1.ozone.ru/s3/multimedia-1/6152877997.jpg',
    'https://images.macrumors.com/t/5qniIh0ci_t8vWfp7RjUzVXQI2I=/2500x/article-new/2023/08/Apple-Watch-Series-9-Pink-Aluminum-Feature.jpg',
    'https://mobilo4ka.ru/image/catalog/TVs/UE55CU7100UXRU/UE55CU7100UXRU-1.jpg',
    'https://cdn0.youla.io/files/images/780_780/63/5f/635f946748f96668540cdf84-1.jpg',
    'https://avatars.mds.yandex.net/get-mpic/5234821/img_id4009715928955772149.jpeg/orig',
  ];

  @override
  void initState() {
    super.initState();
    _loadAds();
  }

  Future<void> _loadAds() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedAds = prefs.getString('my_ads');
    if (savedAds != null) {
      final List decoded = jsonDecode(savedAds);
      setState(() {
        myAds = decoded.map((e) => AdModel.fromJson(e)).toList();
      });
    }
  }

  Future<void> _saveAds() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(myAds.map((e) => e.toJson()).toList());
    await prefs.setString('my_ads', encoded);
  }

  void _addNewAd() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        String title = '';
        String price = '';
        String? selectedImage;

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Добавить объявление',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Название товара
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Название товара (до 22 символов)',
                      ),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(22),
                      ],
                      onChanged: (value) => title = value,
                    ),

                    // Цена
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Цена (₽)',
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(7),
                      ],
                      onChanged: (value) => price = value,
                    ),

                    const SizedBox(height: 12),
                    const Text(
                      'Выберите фото:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),

                    // Выбор изображения
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: templateImages.map((url) {
                        final isSelected = selectedImage == url;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() => selectedImage = url);
                          },
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  url,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              if (isSelected)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // Добавить
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        if (title.isEmpty || price.isEmpty || selectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Заполните все поля'),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        final newAd = AdModel(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: title,
                          description: 'Новое объявление пользователя',
                          imageUrl: selectedImage!,
                          price: int.tryParse(price) ?? 0,
                          location: 'Москва',
                          seller: 'Продавец',
                        );

                        setState(() {
                          myAds.add(newAd);
                        });

                        await _saveAds();
                        Navigator.pop(context);
                      },
                      child: const Text('Добавить'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _removeAd(AdModel ad) async {
    setState(() {
      myAds.remove(ad);
    });
    await _saveAds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Мои объявления')),
      body: myAds.isEmpty
          ? const Center(child: Text('У вас пока нет объявлений'))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: myAds.length,
        itemBuilder: (context, index) {
          final ad = myAds[index];
          return Dismissible(
            key: ValueKey(ad.id),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              color: Colors.redAccent,
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => _removeAd(ad),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8.0, left: 8.0, right: 8.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(seller: ad.seller),
                          ),
                        );
                      },
                      icon: const Icon(Icons.message),
                      label: const Text('Написать пользователю'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        minimumSize: const Size.fromHeight(40),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: _addNewAd,
        child: const Icon(Icons.add),
      ),
    );
  }
}
