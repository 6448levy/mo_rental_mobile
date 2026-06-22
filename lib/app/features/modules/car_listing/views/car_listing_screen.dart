import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_palette.dart';
import '../../car_details/views/car_detail_screen.dart';
import '../data/showcase_cars.dart';

class CarListingScreen extends StatefulWidget {
  const CarListingScreen({super.key});

  @override
  State<CarListingScreen> createState() => _CarListingScreenState();
}

class _CarListingScreenState extends State<CarListingScreen> {
  String _category = 'All';
  String _query = '';
  final Set<String> _favorites = {};

  List<ShowcaseCar> get _filtered {
    return showcaseCars.where((car) {
      final matchesCategory = _category == 'All' || car.category == _category;
      final q = _query.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          car.name.toLowerCase().contains(q) ||
          car.tagline.toLowerCase().contains(q) ||
          car.category.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final cars = _filtered;
    return Scaffold(
      backgroundColor: AppPalette.premiumDark,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildSearchBar(),
            _buildCategoryChips(),
            const SizedBox(height: 4),
            Expanded(
              child: cars.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      physics: const BouncingScrollPhysics(),
                      itemCount: cars.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (context, i) => _CarCard(
                        car: cars[i],
                        isFavorite: _favorites.contains(cars[i].name),
                        onFavorite: () => setState(() {
                          final name = cars[i].name;
                          _favorites.contains(name)
                              ? _favorites.remove(name)
                              : _favorites.add(name);
                        }),
                        onTap: () => Get.to(
                          () => CarDetailsScreen(car: cars[i]),
                          transition: Transition.cupertino,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.premiumCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white10),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _query = v),
          style: const TextStyle(color: Colors.white),
          cursorColor: AppPalette.accent,
          decoration: const InputDecoration(
            hintText: 'Search cars, brands…',
            hintStyle: TextStyle(color: Colors.white38),
            prefixIcon: Icon(Icons.search_rounded, color: Colors.white54),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const BouncingScrollPhysics(),
        itemCount: carCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, i) {
          final cat = carCategories[i];
          final selected = cat == _category;
          return GestureDetector(
            onTap: () => setState(() => _category = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? AppPalette.accent : AppPalette.premiumCard,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: selected ? AppPalette.accent : Colors.white10,
                ),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.white60,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.no_crash_outlined,
              size: 64, color: Colors.white.withValues(alpha: 0.15)),
          const SizedBox(height: 16),
          const Text(
            'No cars here yet',
            style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try a different category or search.',
            style: TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _CarCard extends StatelessWidget {
  final ShowcaseCar car;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onTap;

  const _CarCard({
    required this.car,
    required this.isFavorite,
    required this.onFavorite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppPalette.premiumCard,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image with overlays ──────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  child: Hero(
                    tag: 'car-${car.name}',
                    child: Image.asset(
                      car.image,
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _pill(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star_rounded,
                            color: Color(0xFFFFC107), size: 15),
                        const SizedBox(width: 3),
                        Text(
                          car.rating.toString(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: _pill(
                      padding: const EdgeInsets.all(7),
                      child: Icon(
                        isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isFavorite ? AppPalette.error : Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: _pill(
                    color: AppPalette.accent.withValues(alpha: 0.9),
                    child: Text(
                      car.category,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),

            // ── Details ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    car.name,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    car.tagline,
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _spec(Icons.event_seat_outlined, '${car.seats}'),
                      const SizedBox(width: 16),
                      _spec(Icons.settings_outlined, car.transmission),
                      const SizedBox(width: 16),
                      _spec(Icons.local_gas_station_outlined, car.fuel),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: car.priceLabel,
                                style: const TextStyle(
                                    color: AppPalette.accentLight,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800),
                              ),
                              const TextSpan(
                                text: ' /day',
                                style: TextStyle(
                                    color: Colors.white38, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppPalette.accent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Rent',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _spec(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.white54),
        const SizedBox(width: 5),
        Text(label,
            style: const TextStyle(color: Colors.white60, fontSize: 12.5)),
      ],
    );
  }

  Widget _pill({
    required Widget child,
    Color? color,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.black.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
