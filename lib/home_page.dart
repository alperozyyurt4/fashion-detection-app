import 'package:fashion/features/seller/profile_view.dart';
import 'package:fashion/upload_image.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; // Aktif sayfa indeksi
  final List<Widget> _pages = [
    ImagePredictionPage(), // Tahmin sayfası
    ProfilePage(), // Profil sayfası
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex], // Mevcut sayfa
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Aktif sayfa
        onTap: (int index) {
          setState(() {
            _currentIndex = index; // Aktif sayfayı değiştir
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.image_search),
            label: 'Tahmin',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
