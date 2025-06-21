import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/session.dart';
import '../core/storage.dart';
import '../models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _errorMessage;

  void _kayitOl() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => _errorMessage = null);

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = "Lütfen tüm bilgileri giriniz.");
      return;
    }

    if (password.length < 8) {
      setState(() => _errorMessage = "Şifre en az 8 karakter olmalıdır.");
      return;
    }

    final existingUser = await StorageService.getUser();
    if (existingUser != null && existingUser['email'] == email) {
      setState(() => _errorMessage = "Bu e-posta zaten kayıtlı.");
      return;
    }

    final random = Random();
    final username = "Kullanici${random.nextInt(10000)}";
    final avatarUrl = "https://i.pravatar.cc/150?img=${random.nextInt(70) + 1}";

    final user = User(
      name: username,
      email: email,
      password: password,
      avatarUrl: avatarUrl,
    );

    await Session.login(user);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kayıt Ol')),
      body: Center(
        child: SizedBox(
          width: 320,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    hintText: "E-Posta",
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    hintText: "Şifre",
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _kayitOl,
                  child: const Text("Kayıt Ol"),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.push('/login'),
                  child: const Text("Giriş Yap"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
