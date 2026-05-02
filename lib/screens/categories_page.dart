import 'package:flutter/material.dart';
import '../models/tourist_place.dart';
import '../data/translations.dart';
import 'category_details_screen.dart'; // it's still named category_details_screen.dart but contains CategoryPlacesScreen class

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'nameKey': 'tourist_places', 'icon': Icons.account_balance, 'type': PlaceCategory.touristPlaces, 'color': Colors.blue},
      {'nameKey': 'restaurants', 'icon': Icons.restaurant, 'type': PlaceCategory.restaurants, 'color': Colors.orange},
      {'nameKey': 'hotels', 'icon': Icons.hotel, 'type': PlaceCategory.hotels, 'color': Colors.purple},
      {'nameKey': 'markets', 'icon': Icons.storefront, 'type': PlaceCategory.markets, 'color': Colors.green},
      {'nameKey': 'activities', 'icon': Icons.local_activity, 'type': PlaceCategory.activitiesAndEntertainment, 'color': Colors.red},
      {'nameKey': 'services', 'icon': Icons.local_taxi, 'type': PlaceCategory.services, 'color': Colors.teal},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('categories'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.9,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          final translatedName = context.translate(cat['nameKey'] as String);
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryPlacesScreen(
                    categoryName: translatedName,
                    categoryType: cat['type'] as PlaceCategory,
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    (cat['color'] as Color).withOpacity(0.7),
                    (cat['color'] as Color),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: (cat['color'] as Color).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(cat['icon'] as IconData, size: 48, color: Colors.white),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      translatedName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

