import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PlaceCategory {
  touristPlaces,
  restaurants,
  hotels,
  markets,
  activitiesAndEntertainment,
  services
}

class TouristPlace {
  final String id;
  final String name;
  final String imagePath;
  final String description;
  final PlaceCategory category;
  final String? mapsLien;
  Uint8List? _cachedImageBytes;

  TouristPlace({
    required this.id,
    required this.name,
    required this.imagePath,
    required this.description,
    required this.category,
    this.mapsLien,
  });

  factory TouristPlace.fromJson(Map<String, dynamic> json) {
    return TouristPlace(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      imagePath: json['imagePath']?.toString() ?? json['imageUrl']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      mapsLien: json['mapsLien']?.toString(),
      category: PlaceCategory.values.firstWhere(
        (e) {
          final catString = json['category']?.toString();
          if (catString == null) return false;
          
          final lowerCat = catString.toLowerCase();
          final enumName = e.name.toLowerCase();
          
          if (e.toString() == catString || enumName == lowerCat) {
            return true;
          }
          
          if (enumName == 'touristplaces' && (lowerCat.contains('touristique') || lowerCat.contains('tourist') || lowerCat.contains('attraction'))) return true;
          if (enumName == 'restaurants' && lowerCat.contains('restaurant')) return true;
          if (enumName == 'hotels' && (lowerCat.contains('hotel') || lowerCat.contains('hôtel') || lowerCat.contains('htel') || lowerCat.startsWith('h'))) return true;
          if (enumName == 'markets' && (lowerCat.contains('marché') || lowerCat.contains('market') || lowerCat.contains('marche') || lowerCat.contains('march'))) return true;
          if (enumName == 'activitiesandentertainment' && (lowerCat.contains('activit') || lowerCat.contains('loisir') || lowerCat.contains('activit'))) return true;
          if (enumName == 'services' && lowerCat.contains('service')) return true;
          
          return false;
        },
        orElse: () => PlaceCategory.touristPlaces,
      ),
    ).._preloadImage();
  }

  void _preloadImage() {
    if (imagePath.startsWith('data:image') && _cachedImageBytes == null) {
      try {
        final base64Str = imagePath.split(',').last;
        _cachedImageBytes = base64Decode(base64Str);
      } catch (e) {
        // Ignore base64 decode errors
      }
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'description': description,
      'category': category.name,
      'mapsLien': mapsLien,
    };
  }

  Widget buildImage({double? height, double? width, BoxFit? fit}) {
    if (imagePath.isEmpty) {
      return _errorContainer(height);
    } else if (imagePath.startsWith('data:image')) {
      if (_cachedImageBytes == null) {
        _preloadImage();
      }
      if (_cachedImageBytes == null) return _errorContainer(height);
      return Image.memory(
        _cachedImageBytes!,
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _errorContainer(height),
      );
    } else if (imagePath.startsWith('http')) {
      return Image.network(
        imagePath,
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _errorContainer(height),
      );
    } else {
      if (kIsWeb) {
        return _errorContainer(height); // Local files not supported on Web
      }
      return Image.file(
        File(imagePath),
        height: height,
        width: width,
        fit: fit,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) => _errorContainer(height),
      );
    }
  }

  Widget _errorContainer(double? height) {
    return Container(
      height: height ?? 200,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
    );
  }
}

extension PlaceCategoryExtension on PlaceCategory {
  String get displayName {
    switch (this) {
      case PlaceCategory.touristPlaces:
        return '🏛️ Lieux touristiques';
      case PlaceCategory.restaurants:
        return '🍽️ Restaurants';
      case PlaceCategory.hotels:
        return '🏨 Hôtels';
      case PlaceCategory.markets:
        return '🛍️ Marchés';
      case PlaceCategory.activitiesAndEntertainment:
        return '🎯 Activités et loisirs';
      case PlaceCategory.services:
        return '🚕 Services';
    }
  }

  Color get color {
    switch (this) {
      case PlaceCategory.touristPlaces:
        return Colors.blue;
      case PlaceCategory.restaurants:
        return Colors.orange;
      case PlaceCategory.hotels:
        return Colors.purple;
      case PlaceCategory.markets:
        return Colors.green;
      case PlaceCategory.activitiesAndEntertainment:
        return Colors.red;
      case PlaceCategory.services:
        return Colors.teal;
    }
  }
}
