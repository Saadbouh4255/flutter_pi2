import 'package:flutter/material.dart';
import '../main.dart';
import '../models/tourist_place.dart';
import '../data/translations.dart';
import 'place_details_screen.dart';

class CategoryPlacesScreen extends StatelessWidget {
  final String categoryName;
  final PlaceCategory categoryType;

  const CategoryPlacesScreen({
    super.key,
    required this.categoryName,
    required this.categoryType,
  });

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: categoryType.color,
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: appState,
        builder: (context, child) {
          final places = appState.getPlacesByCategory(categoryType);
          
          if (places.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    context.translate('no_results'),
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(place: place),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      place.buildImage(height: 200, width: double.infinity, fit: BoxFit.cover),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (place.name.isNotEmpty)
                              Text(context.translate(place.name), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            if (place.name.isNotEmpty)
                              const SizedBox(height: 8),
                            Text(context.translate(place.description), style: const TextStyle(fontSize: 16, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

