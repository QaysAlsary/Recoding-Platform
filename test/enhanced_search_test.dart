import 'package:flutter_test/flutter_test.dart';
import 'package:recoding_platform_project/features/home/services/enhanced_search_service.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';

void main() {
  group('EnhancedSearchService Tests', () {
    test('should find ساحة الامويين in local database', () async {
      final results = await EnhancedSearchService.searchPlaces(
        query: 'ساحة الامويين',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(
          results.any((r) =>
              r.name.contains('ساحة الامويين') || r.name.contains('Umayyad')),
          isTrue);
    });

    test('should find شارع الثورة in local database', () async {
      final results = await EnhancedSearchService.searchPlaces(
        query: 'شارع الثورة',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(
          results.any((r) =>
              r.name.contains('شارع الثورة') || r.name.contains('Revolution')),
          isTrue);
    });

    test('should find ساحة الشهبندر in local database', () async {
      final results = await EnhancedSearchService.searchPlaces(
        query: 'ساحة الشهبندر',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(
          results.any((r) =>
              r.name.contains('ساحة الشهبندر') ||
              r.name.contains('Shahbandar')),
          isTrue);
    });

    test('should handle partial search queries', () async {
      final results = await EnhancedSearchService.searchPlaces(
        query: 'الامويين',
        limit: 5,
      );

      expect(results, isNotEmpty);
      expect(results.any((r) => r.name.contains('الامويين')), isTrue);
    });

    test('should return empty results for non-existent places', () async {
      final results = await EnhancedSearchService.searchPlaces(
        query: 'مكان غير موجود',
        limit: 5,
      );

      expect(results, isEmpty);
    });
  });
}




