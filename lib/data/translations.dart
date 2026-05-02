import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import 'db_translations.dart';

class Translations {
  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'Nouakchott Guide',
      'home': 'Home',
      'categories': 'Categories',
      'search': 'Search',
      'settings': 'Settings',
      'language': 'Language',
      'search_places': 'Search places...',
      'no_results': 'No results found',
      'explore_nouakchott': 'Explore Nouakchott',
      'discover_city': 'Discover the best places in the city',
      'offline_mode': 'Offline Mode - Showing local data',
      'view_on_map': 'View on Google Maps',
      'no_map_link': 'No map link available',
      'tourist_places': 'Tourist Places',
      'touristPlaces': 'Tourist Places',
      'restaurants': 'Restaurants',
      'hotels': 'Hotels',
      'markets': 'Markets',
      'activities': 'Activities & Entertainment',
      'activitiesAndEntertainment': 'Activities & Entertainment',
      'services': 'Services',
    },
    'fr': {
      'app_title': 'Guide de Nouakchott',
      'home': 'Accueil',
      'categories': 'Catégories',
      'search': 'Recherche',
      'settings': 'Paramètres',
      'language': 'Langue',
      'search_places': 'Rechercher des lieux...',
      'no_results': 'Aucun résultat trouvé',
      'explore_nouakchott': 'Explorer Nouakchott',
      'discover_city': 'Découvrez les meilleurs endroits de la ville',
      'offline_mode': 'Mode hors ligne - Affichage des données locales',
      'view_on_map': 'Voir sur Google Maps',
      'no_map_link': 'Aucun lien de carte disponible',
      'tourist_places': 'Lieux touristiques',
      'touristPlaces': 'Lieux touristiques',
      'restaurants': 'Restaurants',
      'hotels': 'Hôtels',
      'markets': 'Marchés',
      'activities': 'Activités et loisirs',
      'activitiesAndEntertainment': 'Activités et loisirs',
      'services': 'Services',
    },
    'ar': {
      'app_title': 'دليل نواكشوط',
      'home': 'الرئيسية',
      'categories': 'الفئات',
      'search': 'بحث',
      'settings': 'الإعدادات',
      'language': 'اللغة',
      'search_places': 'البحث عن الأماكن...',
      'no_results': 'لم يتم العثور على نتائج',
      'explore_nouakchott': 'استكشف نواكشوط',
      'discover_city': 'اكتشف أفضل الأماكن في المدينة',
      'offline_mode': 'وضع عدم الاتصال - عرض البيانات المحلية',
      'view_on_map': 'عرض على خرائط جوجل',
      'no_map_link': 'لا يوجد رابط خريطة',
      'tourist_places': 'أماكن سياحية',
      'touristPlaces': 'أماكن سياحية',
      'restaurants': 'مطاعم',
      'hotels': 'فنادق',
      'markets': 'أسواق',
      'activities': 'أنشطة وترفيه',
      'activitiesAndEntertainment': 'أنشطة وترفيه',
      'services': 'خدمات',
    },
  };

  static String translate(String key, String langCode) {
    if (_localizedValues[langCode] != null && _localizedValues[langCode]!.containsKey(key)) {
      return _localizedValues[langCode]![key]!;
    }
    if (langCode == 'en' && DbTranslations.en.containsKey(key)) {
      return DbTranslations.en[key]!;
    }
    if (langCode == 'ar' && DbTranslations.ar.containsKey(key)) {
      return DbTranslations.ar[key]!;
    }
    return _localizedValues['en']?[key] ?? key;
  }
}

class LocalizationProvider extends ChangeNotifier {
  String _currentLanguage = 'fr';
  
  String get currentLanguage => _currentLanguage;

  LocalizationProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString('language_code') ?? 'fr';
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    if (_currentLanguage == langCode) return;
    _currentLanguage = langCode;
    notifyListeners(); // Instant UI update

    SharedPreferences.getInstance().then((prefs) {
      prefs.setString('language_code', langCode);
    });
  }

  String translate(String key) {
    return Translations.translate(key, _currentLanguage);
  }
}

// Extension to make translation easier on BuildContext
extension LocalizationExtension on BuildContext {
  String translate(String key) {
    // Register dependency on the locale to rebuild instantly when language changes
    try {
      Localizations.localeOf(this);
    } catch (_) {}
    return AppStateProvider.of(this).localization.translate(key);
  }
}

