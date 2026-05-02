import 'package:flutter/material.dart';
import '../main.dart';
import '../models/tourist_place.dart';
import '../data/translations.dart';
import 'place_details_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('search'), style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: context.translate('search_places'),
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: AnimatedBuilder(
              animation: appState,
              builder: (context, child) {
                final places = _searchQuery.isEmpty 
                    ? <TouristPlace>[] 
                    : appState.searchPlaces(_searchQuery);

                if (_searchQuery.isNotEmpty && places.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(context.translate('no_results'), style: const TextStyle(fontSize: 18, color: Colors.grey)),
                      ],
                    ),
                  );
                } else if (_searchQuery.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.travel_explore, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(context.translate('search_places'), style: const TextStyle(fontSize: 18, color: Colors.grey)),
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
                             Stack(
                               children: [
                                 place.buildImage(height: 200, width: double.infinity, fit: BoxFit.cover),
                                Positioned(
                                  top: 16,
                                  right: 16,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: place.category.color.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      context.translate(place.category.name), // will use translated name if added to map or fallback
                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                               ],
                             ),
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
          ),
        ],
      ),
    );
  }
}

