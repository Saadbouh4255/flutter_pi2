import 'package:flutter/material.dart';
import '../data/translations.dart';
import '../models/tourist_place.dart';
import 'place_details_screen.dart';
import '../main.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppStateProvider.of(context);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250.0,
            floating: false,
            pinned: true,
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.language, color: Colors.white),
                onSelected: (String code) {
                  appState.localization.setLanguage(code);
                },
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem(value: 'fr', child: Text('Français')),
                  const PopupMenuItem(value: 'en', child: Text('English')),
                  const PopupMenuItem(value: 'ar', child: Text('العربية')),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                context.translate('app_title'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4.0,
                      color: Colors.black87,
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              centerTitle: true,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    'lib/resources/NKTT.jpeg',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.teal[800],
                      child: const Center(
                        child: Icon(Icons.location_city, size: 80, color: Colors.white54),
                      ),
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.black87],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Offline banner removed completely
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category = PlaceCategory.values[index];
                final places = appState.getPlacesByCategory(category);

                String catTitle;
                switch (category) {
                  case PlaceCategory.touristPlaces:
                    catTitle = context.translate('tourist_places');
                    break;
                  case PlaceCategory.restaurants:
                    catTitle = context.translate('restaurants');
                    break;
                  case PlaceCategory.hotels:
                    catTitle = context.translate('hotels');
                    break;
                  case PlaceCategory.markets:
                    catTitle = context.translate('markets');
                    break;
                  case PlaceCategory.activitiesAndEntertainment:
                    catTitle = context.translate('activities');
                    break;
                  case PlaceCategory.services:
                    catTitle = context.translate('services');
                    break;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                      child: Row(
                        children: [
                          Icon(Icons.category, color: category.color),
                          const SizedBox(width: 8),
                          Text(
                            catTitle,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (places.isEmpty)
                      Container(
                        height: 120,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: appState.isLoading 
                          ? const CircularProgressIndicator()
                          : Text(
                              context.translate('no_results'),
                              style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                            ),
                      )
                    else
                      SizedBox(
                        height: 220,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: places.length,
                          itemBuilder: (context, placeIndex) {
                            final place = places[placeIndex];
                            return _buildPlaceCard(context, place);
                          },
                        ),
                      ),
                  ],
                );
              },
              childCount: PlaceCategory.values.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, TouristPlace place) {
    return Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Card(
        elevation: 4,
        shadowColor: Colors.black26,
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
              Expanded(
                flex: 3,
                child: place.buildImage(fit: BoxFit.cover),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        context.translate(place.name),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        context.translate(place.description),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


