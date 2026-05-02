import 'package:flutter/material.dart';
import 'home_page.dart';
import 'search_page.dart';
import 'categories_page.dart';
import '../data/translations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const CategoriesPage(),
    const SearchPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: context.translate('home'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category),
            label: context.translate('categories'),
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: context.translate('search'),
          ),
        ],
      ),
    );
  }
}

