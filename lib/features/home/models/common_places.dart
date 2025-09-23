import 'package:latlong2/latlong.dart';
import 'location_suggestion_model.dart';

class CommonPlaces {
  static List<LocationSuggestion> getCommonPlaces(String query) {
    final lowerQuery = query.toLowerCase();
    final suggestions = <LocationSuggestion>[];

    // Major Syrian Cities
    if (lowerQuery.contains('damascus') || lowerQuery.contains('دمشق')) {
      suggestions.add(LocationSuggestion(
        name: 'Damascus',
        address: 'Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5138, 36.2765),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('aleppo') || lowerQuery.contains('حلب')) {
      suggestions.add(LocationSuggestion(
        name: 'Aleppo',
        address: 'Aleppo, Syria',
        city: 'Aleppo',
        country: 'Syria',
        coordinates: const LatLng(36.2021, 37.1343),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('homs') || lowerQuery.contains('حمص')) {
      suggestions.add(LocationSuggestion(
        name: 'Homs',
        address: 'Homs, Syria',
        city: 'Homs',
        country: 'Syria',
        coordinates: const LatLng(34.7324, 36.7137),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('latakia') || lowerQuery.contains('اللاذقية')) {
      suggestions.add(LocationSuggestion(
        name: 'Latakia',
        address: 'Latakia, Syria',
        city: 'Latakia',
        country: 'Syria',
        coordinates: const LatLng(35.5407, 35.7828),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('hama') || lowerQuery.contains('حماة')) {
      suggestions.add(LocationSuggestion(
        name: 'Hama',
        address: 'Hama, Syria',
        city: 'Hama',
        country: 'Syria',
        coordinates: const LatLng(35.1313, 36.7578),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('tartus') || lowerQuery.contains('طرطوس')) {
      suggestions.add(LocationSuggestion(
        name: 'Tartus',
        address: 'Tartus, Syria',
        city: 'Tartus',
        country: 'Syria',
        coordinates: const LatLng(34.8950, 35.8867),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('deir ez-zor') ||
        lowerQuery.contains('دير الزور')) {
      suggestions.add(LocationSuggestion(
        name: 'Deir ez-Zor',
        address: 'Deir ez-Zor, Syria',
        city: 'Deir ez-Zor',
        country: 'Syria',
        coordinates: const LatLng(35.3333, 40.1500),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('raqqa') || lowerQuery.contains('الرقة')) {
      suggestions.add(LocationSuggestion(
        name: 'Raqqa',
        address: 'Raqqa, Syria',
        city: 'Raqqa',
        country: 'Syria',
        coordinates: const LatLng(35.9500, 39.0167),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('idlib') || lowerQuery.contains('إدلب')) {
      suggestions.add(LocationSuggestion(
        name: 'Idlib',
        address: 'Idlib, Syria',
        city: 'Idlib',
        country: 'Syria',
        coordinates: const LatLng(35.9333, 36.6333),
        type: 'city',
      ));
    }

    if (lowerQuery.contains('daraa') || lowerQuery.contains('درعا')) {
      suggestions.add(LocationSuggestion(
        name: 'Daraa',
        address: 'Daraa, Syria',
        city: 'Daraa',
        country: 'Syria',
        coordinates: const LatLng(32.6189, 36.1025),
        type: 'city',
      ));
    }

    // Historical and Religious Sites
    if (lowerQuery.contains('umayyad mosque') ||
        lowerQuery.contains('الجامع الأموي')) {
      suggestions.add(LocationSuggestion(
        name: 'Umayyad Mosque',
        address: 'Umayyad Mosque, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5117, 36.3064),
        type: 'landmark',
      ));
    }

    if (lowerQuery.contains('citadel') || lowerQuery.contains('قلعة')) {
      suggestions.add(LocationSuggestion(
        name: 'Aleppo Citadel',
        address: 'Aleppo Citadel, Aleppo, Syria',
        city: 'Aleppo',
        country: 'Syria',
        coordinates: const LatLng(36.1994, 37.1625),
        type: 'landmark',
      ));
    }

    if (lowerQuery.contains('palmyra') || lowerQuery.contains('تدمر')) {
      suggestions.add(LocationSuggestion(
        name: 'Palmyra',
        address: 'Palmyra, Syria',
        city: 'Palmyra',
        country: 'Syria',
        coordinates: const LatLng(34.5560, 38.2739),
        type: 'landmark',
      ));
    }

    if (lowerQuery.contains('krak des chevaliers') ||
        lowerQuery.contains('قلعة الحصن')) {
      suggestions.add(LocationSuggestion(
        name: 'Krak des Chevaliers',
        address: 'Krak des Chevaliers, Syria',
        city: 'Homs',
        country: 'Syria',
        coordinates: const LatLng(34.7569, 36.2944),
        type: 'landmark',
      ));
    }

    if (lowerQuery.contains('bosra') || lowerQuery.contains('بصرى')) {
      suggestions.add(LocationSuggestion(
        name: 'Bosra',
        address: 'Bosra, Syria',
        city: 'Daraa',
        country: 'Syria',
        coordinates: const LatLng(32.5167, 36.4833),
        type: 'landmark',
      ));
    }

    // Popular Areas in Damascus
    if (lowerQuery.contains('old city') ||
        lowerQuery.contains('المدينة القديمة')) {
      suggestions.add(LocationSuggestion(
        name: 'Old City of Damascus',
        address: 'Old City, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5138, 36.2765),
        type: 'area',
      ));
    }

    if (lowerQuery.contains('abu rummaneh') ||
        lowerQuery.contains('أبو رمانة')) {
      suggestions.add(LocationSuggestion(
        name: 'Abu Rummaneh',
        address: 'Abu Rummaneh, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5200, 36.2800),
        type: 'area',
      ));
    }

    if (lowerQuery.contains('malki') || lowerQuery.contains('المالكي')) {
      suggestions.add(LocationSuggestion(
        name: 'Malki',
        address: 'Malki, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5100, 36.2700),
        type: 'area',
      ));
    }

    if (lowerQuery.contains('kafr souseh') || lowerQuery.contains('كفر سوسة')) {
      suggestions.add(LocationSuggestion(
        name: 'Kafr Souseh',
        address: 'Kafr Souseh, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5000, 36.2900),
        type: 'area',
      ));
    }

    // Popular Areas in Aleppo
    if (lowerQuery.contains('old aleppo') ||
        lowerQuery.contains('حلب القديمة')) {
      suggestions.add(LocationSuggestion(
        name: 'Old City of Aleppo',
        address: 'Old City, Aleppo, Syria',
        city: 'Aleppo',
        country: 'Syria',
        coordinates: const LatLng(36.2021, 37.1343),
        type: 'area',
      ));
    }

    // Universities
    if (lowerQuery.contains('university') || lowerQuery.contains('جامعة')) {
      suggestions.add(LocationSuggestion(
        name: 'Damascus University',
        address: 'Damascus University, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5100, 36.2800),
        type: 'institution',
      ));
      suggestions.add(LocationSuggestion(
        name: 'Aleppo University',
        address: 'Aleppo University, Aleppo, Syria',
        city: 'Aleppo',
        country: 'Syria',
        coordinates: const LatLng(36.2100, 37.1400),
        type: 'institution',
      ));
    }

    // Airports
    if (lowerQuery.contains('airport') || lowerQuery.contains('مطار')) {
      suggestions.add(LocationSuggestion(
        name: 'Damascus International Airport',
        address: 'Damascus International Airport, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.4106, 36.5144),
        type: 'airport',
      ));
      suggestions.add(LocationSuggestion(
        name: 'Aleppo International Airport',
        address: 'Aleppo International Airport, Aleppo, Syria',
        city: 'Aleppo',
        country: 'Syria',
        coordinates: const LatLng(36.1806, 37.2244),
        type: 'airport',
      ));
    }

    // Hospitals
    if (lowerQuery.contains('hospital') || lowerQuery.contains('مستشفى')) {
      suggestions.add(LocationSuggestion(
        name: 'Al-Mouwasat University Hospital',
        address: 'Al-Mouwasat University Hospital, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5200, 36.2900),
        type: 'hospital',
      ));
    }

    // Shopping Centers
    if (lowerQuery.contains('mall') || lowerQuery.contains('مركز تجاري')) {
      suggestions.add(LocationSuggestion(
        name: 'Damascus Mall',
        address: 'Damascus Mall, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5000, 36.2800),
        type: 'shopping',
      ));
    }

    // Restaurants
    if (lowerQuery.contains('restaurant') || lowerQuery.contains('مطعم')) {
      suggestions.add(LocationSuggestion(
        name: 'Beit Al Wali Restaurant',
        address: 'Beit Al Wali Restaurant, Damascus, Syria',
        city: 'Damascus',
        country: 'Syria',
        coordinates: const LatLng(33.5150, 36.2780),
        type: 'restaurant',
      ));
    }

    return suggestions;
  }
}
