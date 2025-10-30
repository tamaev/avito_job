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
  String userGender = 'Не указан';
  String? userBirthDate;
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
      userGender = prefs.getString('userGender') ?? 'Не указан';
      userBirthDate = prefs.getString('userBirthDate');
      userImagePath = prefs.getString('userImagePath');
      isDarkTheme = prefs.getBool('isDarkTheme') ?? false;
    });
  }

  Future<void> _saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', userName);
    await prefs.setString('userEmail', userEmail);
    await prefs.setString('userGender', userGender);
    if (userBirthDate != null) await prefs.setString('userBirthDate', userBirthDate!);
    if (userImagePath != null) await prefs.setString('userImagePath', userImagePath!);
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => userBirthDate = "${picked.day}.${picked.month}.${picked.year}");
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userBirthDate', userBirthDate!);
    }
  }

  void _editProfile() {
    String newName = userName;
    String newEmail = userEmail;
    String newGender = userGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            top: 16,
          ),
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
                maxLength: 22,
                onChanged: (value) => newName = value,
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                controller: TextEditingController(text: userEmail),
                maxLength: 22,
                onChanged: (value) => newEmail = value,
              ),
              DropdownButtonFormField<String>(
                value: newGender,
                items: const [
                  DropdownMenuItem(value: 'Не указан', child: Text('Не указан')),
                  DropdownMenuItem(value: 'Мужской', child: Text('Мужской')),
                  DropdownMenuItem(value: 'Женский', child: Text('Женский')),
                ],
                onChanged: (value) => newGender = value ?? 'Не указан',
                decoration: const InputDecoration(labelText: 'Пол'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    userName = newName;
                    userEmail = newEmail;
                    userGender = newGender;
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
            (route) => false,
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
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(userEmail, style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text("Пол: $userGender"),
              Text("Дата рождения: ${userBirthDate ?? 'Не указана'}"),
              const SizedBox(height: 30),
              ListTile(
                leading: const Icon(Icons.cake),
                title: const Text('Указать дату рождения'),
                onTap: _pickDate,
              ),
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
                title: const Text('Выйти', style: TextStyle(color: Colors.red)),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
