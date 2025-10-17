import 'package:flutter/material.dart';
import '../models/ad_model.dart';

class AdDetailsPage extends StatelessWidget {
  final AdModel ad;
  const AdDetailsPage({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ad.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              ad.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ad.title,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ad.price} ₽',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 20),
                      const SizedBox(width: 4),
                      Text(ad.location,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Описание:",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(ad.description,
                      style: const TextStyle(fontSize: 16, height: 1.4)),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Продавец: ${ad.seller}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text("Написать"),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Открыт чат с ${ad.seller} (заглушка)')),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
