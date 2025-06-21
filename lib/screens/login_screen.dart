import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/session.dart';
import '../core/storage.dart';
import '../models/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _errorMessage;

  void _girisYap() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    setState(() => _errorMessage = null);

    final userData = await StorageService.getUser();

    if (userData == null) {
      setState(() => _errorMessage = "Kayıtlı kullanıcı bulunamadı.");
      return;
    }

    if (userData['email'] != email || userData['password'] != password) {
      setState(() => _errorMessage = "E-posta veya şifre hatalı.");
      return;
    }

    final user = User(
      name: userData['username']!,
      email: userData['email']!,
      password: userData['password']!,
      avatarUrl: userData['avatar']!,
    );

    await Session.login(user);
    if (!mounted) return;
    context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Giriş Yap")),
      body: Center(
        child: SizedBox(
          width: 300,
          child: SingleChildScrollView(
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
                  onPressed: _girisYap,
                  child: const Text("Giriş Yap"),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.push('/register'),
                  child: const Text("Kayıt Ol"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
