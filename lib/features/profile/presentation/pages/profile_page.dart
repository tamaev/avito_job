import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../auth/presentation/pages/register_page.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Иван Иванов';
  String userEmail = 'ivan@example.com';
  String? userImagePath;
  bool isDarkTheme = false;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Иван Иванов';
      userEmail = prefs.getString('userEmail') ?? 'ivan@example.com';
      userImagePath = prefs.getString('userImagePath');
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
    if (userImagePath != null) {
      await prefs.setString('userImagePath', userImagePath!);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => userImagePath = picked.path);
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userImagePath', picked.path);
    }
  }

  void _editProfile() {
    String newName = userName;
    String newEmail = userEmail;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Редактировать профиль',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Имя'),
                controller: TextEditingController(text: userName),
                onChanged: (value) => newName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: userEmail),
                onChanged: (value) => newEmail = value,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    userName = newName;
                    userEmail = newEmail;
                  });
                  _saveProfileData();
                  Navigator.pop(context);
                },
                child: const Text('Сохранить'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SettingsPage(
          isDarkTheme: isDarkTheme,
          onThemeChanged: (value) async {
            setState(() => isDarkTheme = value);
            final prefs = await SharedPreferences.getInstance();
            prefs.setBool('isDarkTheme', value);
          },
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const RegisterPage()),
            (route) => false, // полностью очищает стек
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = isDarkTheme ? ThemeData.dark() : ThemeData.light();

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(title: const Text('Профиль')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: userImagePath != null
                      ? FileImage(File(userImagePath!))
                      : const NetworkImage(
                    'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                  ) as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.camera_alt,
                          size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(userEmail, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Редактировать профиль'),
                onTap: _editProfile,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Настройки'),
                onTap: _openSettings,
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title:
                const Text('Выйти', style: TextStyle(color: Colors.red)),
                onTap: _logout, //
              ),
            ],
          ),
        ),
      ),
    );
  }
}
