import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// Search Analytics (optional - for tracking search performance)
class SearchAnalytics {
  static const String _analyticsKey = 'search_analytics';
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Track search query
  static Future<void> trackSearch(
      String query, int resultCount, Duration responseTime) async {
    await init();

    final analytics = await getAnalytics();
    analytics.add(SearchAnalyticsItem(
      query: query,
      resultCount: resultCount,
      responseTime: responseTime,
      timestamp: DateTime.now(),
    ));

    // Keep only last 100 searches
    if (analytics.length > 100) {
      analytics.removeRange(0, analytics.length - 100);
    }

    // Save analytics
    final analyticsJson =
        analytics.map((item) => jsonEncode(item.toJson())).toList();
    await _prefs?.setStringList(_analyticsKey, analyticsJson);
  }

  // Get analytics data
  static Future<List<SearchAnalyticsItem>> getAnalytics() async {
    await init();
    final analyticsJson = _prefs?.getStringList(_analyticsKey) ?? [];

    return analyticsJson
        .map((json) {
          try {
            return SearchAnalyticsItem.fromJson(jsonDecode(json));
          } catch (e) {
            return null;
          }
        })
        .where((item) => item != null)
        .cast<SearchAnalyticsItem>()
        .toList();
  }

  // Get popular search queries
  static Future<List<String>> getPopularQueries({int limit = 10}) async {
    final analytics = await getAnalytics();
    final Map<String, int> queryCount = {};

    for (final item in analytics) {
      queryCount[item.query.toLowerCase()] =
          (queryCount[item.query.toLowerCase()] ?? 0) + 1;
    }

    final sorted = queryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).map((e) => e.key).toList();
  }

  // Clear analytics
  static Future<void> clearAnalytics() async {
    await init();
    await _prefs?.remove(_analyticsKey);
  }
}

// Search analytics item model
class SearchAnalyticsItem {
  final String query;
  final int resultCount;
  final Duration responseTime;
  final DateTime timestamp;

  SearchAnalyticsItem({
    required this.query,
    required this.resultCount,
    required this.responseTime,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'query': query,
        'resultCount': resultCount,
        'responseTime': responseTime.inMilliseconds,
        'timestamp': timestamp.millisecondsSinceEpoch,
      };

  factory SearchAnalyticsItem.fromJson(Map<String, dynamic> json) {
    return SearchAnalyticsItem(
      query: json['query'],
      resultCount: json['resultCount'],
      responseTime: Duration(milliseconds: json['responseTime']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
    );
  }
}




