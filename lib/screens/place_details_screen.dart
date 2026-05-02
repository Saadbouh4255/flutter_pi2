import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/tourist_place.dart';
import '../data/translations.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final TouristPlace place;

  const PlaceDetailsScreen({super.key, required this.place});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate(place.name), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: place.category.color,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            place.buildImage(height: 250, width: double.infinity, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.translate(place.name),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    context.translate(place.description),
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  const Divider(),
                  const SizedBox(height: 16),
                  if (place.mapsLien != null && place.mapsLien!.isNotEmpty)
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () => _launchUrl(place.mapsLien!),
                        icon: const Icon(Icons.map),
                        label: Text(context.translate('view_on_map')),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          backgroundColor: place.category.color,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        context.translate('no_map_link'),
                        style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
