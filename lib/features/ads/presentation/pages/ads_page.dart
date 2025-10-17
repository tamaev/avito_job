import 'package:flutter/material.dart';

class AdsPage extends StatelessWidget {
  const AdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Мои объявления"),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          "У вас пока нет объявлений",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
    );
  }
}
