import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/session.dart';
import '../widgets/bottom_menu.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Session.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profilim"),
      ),
      body: user == null
          ? const Center(child: Text("Kullanıcı bilgisi bulunamadı."))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(user.avatarUrl),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(user.name),
                          subtitle: const Text("Kullanıcı Adı"),
                        ),
                        ListTile(
                          leading: const Icon(Icons.email),
                          title: Text(user.email),
                          subtitle: const Text("E-posta"),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    await Session.logout();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Çıkış Yap"),
                ),
              ],
            ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
