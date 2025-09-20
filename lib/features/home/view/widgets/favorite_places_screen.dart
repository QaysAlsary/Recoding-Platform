import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recoding_platform_project/features/home/services/favorites_manager.dart';
import 'package:recoding_platform_project/features/home/models/location_suggestion_model.dart';
import 'package:recoding_platform_project/src/themes/app_colors.dart';
import 'package:recoding_platform_project/features/home/bloc/home_bloc.dart';
import 'package:shimmer/shimmer.dart';

class FavoritePlacesScreen extends StatefulWidget {
  const FavoritePlacesScreen({super.key});

  @override
  State<FavoritePlacesScreen> createState() => _FavoritePlacesScreenState();
}

class _FavoritePlacesScreenState extends State<FavoritePlacesScreen> {
  late Future<List<LocationSuggestion>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    setState(() {
      _favoritesFuture = FavoritesManager.getFavorites();
    });
  }

  Future<void> _removeFavorite(LocationSuggestion suggestion) async {
    await FavoritesManager.removeFavorite(suggestion);
    await _loadFavorites();
  }

  void _onCardTap(LocationSuggestion suggestion) {
    // First, communicate with the HomeBloc to move the map to the selected location
    context.read<HomeBloc>().add(SelectLocationSuggestionEvent(suggestion));

    // Then navigate back to the map screen
    Navigator.of(context).pop();
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border,
                size: 100, color: AppColors.primary.withValues(alpha: 0.3)),
            const SizedBox(height: 24),
            Text(
              'No favorite places yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.black073,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'You can save places as favorites from the search bar. They will appear here for quick access.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.black015,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoriteCard(
      LocationSuggestion fav, Animation<double> animation) {
    final subtitle = [
      if (fav.address != null && fav.address!.isNotEmpty) fav.address,
      if (fav.city != null && fav.city!.isNotEmpty) fav.city,
      if (fav.country != null && fav.country!.isNotEmpty) fav.country,
    ].whereType<String>().toList().join(' • ');

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        color: const Color(0xffebebeb),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _onCardTap(fav),
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.place, color: AppColors.primary, size: 24),
            ),
            title: Text(
              fav.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17,
                color: AppColors.black,
              ),
            ),
            subtitle: subtitle.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xff1e1e1e),
                        fontSize: 14,
                      ),
                    ),
                  )
                : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.map, color: AppColors.blue, size: 20),
                  tooltip: 'Show on map',
                  onPressed: () => _onCardTap(fav),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  tooltip: 'Remove from favorites',
                  onPressed: () => _removeFavorite(fav),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffebebeb),
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 12),
            const Text(
              'Favorite Places',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 24, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: RefreshIndicator(
          onRefresh: _loadFavorites,
          color: AppColors.primary,
          child: FutureBuilder<List<LocationSuggestion>>(
            future: _favoritesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return _buildEmptyState(context);
              }
              final favorites = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.only(top: 16, bottom: 32),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final fav = favorites[index];
                  return Dismissible(
                    key: ValueKey(
                        '${fav.name}_${fav.coordinates.latitude}_${fav.coordinates.longitude}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 32),
                      child:
                          const Icon(Icons.delete, color: Colors.red, size: 32),
                    ),
                    onDismissed: (_) => _removeFavorite(fav),
                    child: _buildFavoriteCard(fav, kAlwaysCompleteAnimation),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
