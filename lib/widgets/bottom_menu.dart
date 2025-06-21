import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0, // aktif sayfa index'i dinamik yapılabilir
      onTap: (index) {
        switch (index) {
          case 0:
            context.go("/home");
            break;
          case 1:
            context.go("/search");
            break;
          case 2:
            context.go("/tweet");
            break;
          case 3:
            context.go("/profile");
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Ana Sayfa"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Ara"),
        BottomNavigationBarItem(icon: Icon(Icons.edit), label: "Gönderi"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
      selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
    );
  }
}
