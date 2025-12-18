// lib/presentation/pages/adopter_home_page.dart
import 'package:flutter/material.dart';
import 'package:petadoptapp/features/adopters/presentation/pages/browse_pet_page.dart';
import 'package:petadoptapp/features/adopters/presentation/pages/application_page.dart';
import 'package:petadoptapp/features/adopters/presentation/pages/profile_page.dart';

class AdopterHomePage extends StatefulWidget {
  const AdopterHomePage({super.key});

  @override
  State<AdopterHomePage> createState() => _AdopterHomePageState();
}

class _AdopterHomePageState extends State<AdopterHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const BrowsePetsPage(), // Browse pets
    const MyApplicationsPage(), // Adoption status
    const ProfilePage(), // Profile
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            backgroundColor: Colors.white,
            selectedItemColor:
                Colors.orange, // You can use AppTheme.primaryOrange
            unselectedItemColor: Colors.grey[600],
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.search),
                activeIcon: Icon(Icons.search, size: 24),
                label: 'Browse',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list_alt_outlined),
                activeIcon: Icon(Icons.list_alt, size: 24),
                label: 'My Applications',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person, size: 24),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
