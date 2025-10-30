import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../app/app.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    final savedPassword = prefs.getString('userPassword');

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Если пользователь уже зарегистрирован
    if (savedEmail == email) {
      _showMessage("Пользователь уже зарегистрирован");
    } else {
      await prefs.setString('userEmail', email);
      await prefs.setString('userPassword', password);
      _showMessage("Регистрация успешна!");
    }

    setState(() => _isLoading = false);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    final savedPassword = prefs.getString('userPassword');

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (savedEmail == null || savedPassword == null) {
      _showMessage("Пользователь не зарегистрирован");
    } else if (savedEmail != email) {
      _showMessage("Пользователь не зарегистрирован");
    } else if (savedPassword != password) {
      _showMessage("Неверный пароль");
    } else {
      // успешный вход
      _showMessage("Успешный вход!");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MyApp()),
      );
    }

    setState(() => _isLoading = false);
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: Colors.blueAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      labelText: label,
      filled: true,
      fillColor: Colors.blue.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blueAccent,
        title: const Text("Регистрация / Вход"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Icon(Icons.shopping_bag, size: 80, color: Colors.blueAccent),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                maxLength: 30,
                decoration: _inputDecoration("Email", Icons.email),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите email";
                  } else if (value.length > 30) {
                    return "Не более 30 символов";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                maxLength: 30,
                decoration: _inputDecoration("Пароль", Icons.lock),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Введите пароль";
                  } else if (value.length > 30) {
                    return "Не более 30 символов";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                maxLength: 30,
                decoration: _inputDecoration("Повторите пароль", Icons.lock_outline),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return "Пароли не совпадают";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _register,
                        child: const Text(
                          "Зарегистрироваться",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          side: const BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        onPressed: _login,
                        child: const Text(
                          "Войти",
                          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
