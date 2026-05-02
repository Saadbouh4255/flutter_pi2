import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tourist_place.dart';
import 'db_helper.dart';
import 'translations.dart';

List<TouristPlace> _parsePlaces(List<int> responseBytes) {
  try {
    final decodedData = json.decode(utf8.decode(responseBytes, allowMalformed: true));
    final List<dynamic> data = decodedData is List ? decodedData : (decodedData['places'] ?? []);
    final List<TouristPlace> parsed = [];
    for (var item in data) {
      try {
        parsed.add(TouristPlace.fromJson(item as Map<String, dynamic>));
      } catch (e) {
        // Ignore individual parsing errors
      }
    }
    return parsed;
  } catch (e) {
    return [];
  }
}

class AppState extends ChangeNotifier {
  List<TouristPlace> _places = [];
  Timer? _timer;
  bool _isOffline = false;
  bool _isLoading = true;
  final LocalizationProvider localization = LocalizationProvider();

  List<TouristPlace> get places => _places;
  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;

  AppState() {
    localization.addListener(notifyListeners);
    _initData();
  }

  Future<void> _initData() async {
    // First, load from local DB so app opens instantly with data
    await loadFromLocalDb();
    
    // Then fetch from network
    await fetchPlaces();

    // Setup periodic sync
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      fetchPlaces();
    });
  }

  Future<void> loadFromLocalDb() async {
    try {
      final localPlaces = await DbHelper.instance.getAllPlaces();
      if (localPlaces.isNotEmpty) {
        _places = localPlaces;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print("Error loading from local DB: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    localization.removeListener(notifyListeners);
    localization.dispose();
    super.dispose();
  }

  String? _lastResponseBody;

  Future<void> fetchPlaces() async {
    try {
      final response = await http.get(Uri.parse('https://nouakchott-backend-1-7hhh.onrender.com/api/places')).timeout(const Duration(seconds: 60));
      if (response.statusCode == 200) {
        if (_lastResponseBody == response.body) {
          _isOffline = false;
          notifyListeners();
          return; // No changes
        }
        _lastResponseBody = response.body;

        // Parse directly on main thread because Web Worker serialization overhead is too slow
        final parsed = _parsePlaces(response.bodyBytes);
        
        _places = parsed;
        _isOffline = false;
        _isLoading = false;
        
        // Save to SQLite
        await DbHelper.instance.insertPlaces(parsed);
        
        notifyListeners();
      } else {
        _isOffline = true;
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching places: $e');
      _isOffline = true;
      _isLoading = false;
      notifyListeners();
    }
  }

  List<TouristPlace> getPlacesByCategory(PlaceCategory category) {
    return _places.where((p) => p.category == category).toList();
  }

  List<TouristPlace> searchPlaces(String query) {
    final lowerQuery = query.toLowerCase();
    return _places.where((p) {
      final translatedName = localization.translate(p.name).toLowerCase();
      final translatedDesc = localization.translate(p.description).toLowerCase();
      return translatedName.contains(lowerQuery) || 
             translatedDesc.contains(lowerQuery);
    }).toList();
  }
}

