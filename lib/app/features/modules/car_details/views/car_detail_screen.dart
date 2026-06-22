import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/themes/app_palette.dart';
import '../../car_listing/data/showcase_cars.dart';

class CarDetailsScreen extends StatefulWidget {
  final ShowcaseCar car;

  /// Primary constructor — pass a fully described [ShowcaseCar].
  CarDetailsScreen({super.key, ShowcaseCar? car, String? carName, String? image})
      : assert(car != null || (carName != null && image != null),
            'Provide either a car or carName + image'),
        car = car ??
            ShowcaseCar.resolve(name: carName!, image: image!);

  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  bool _isFavorite = false;

  ShowcaseCar get car => widget.car;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppPalette.premiumDark,
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHero(context),
                Transform.translate(
                  offset: const Offset(0, -28),
                  child: _buildDetails(),
                ),
              ],
            ),
          ),
          _buildTopBar(context),
        ],
      ),
      bottomNavigationBar: _buildBookBar(),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'car-${car.name}',
          child: Image.asset(
            car.image,
            height: 380,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.35),
                  Colors.transparent,
                  AppPalette.premiumDark.withValues(alpha: 0.6),
                  AppPalette.premiumDark,
                ],
                stops: const [0.0, 0.35, 0.85, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          left: 24,
          bottom: 44,
          right: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _glassPill(
                color: AppPalette.accent.withValues(alpha: 0.9),
                child: Text(
                  car.category,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                car.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.star_rounded,
                      color: Color(0xFFFFC107), size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '${car.rating}',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '(${car.reviews} reviews)',
                    style: const TextStyle(color: Colors.white60, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _circleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: () => Get.back<void>(),
            ),
            _circleButton(
              icon: _isFavorite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              iconColor: _isFavorite ? AppPalette.error : Colors.white,
              onTap: () => setState(() => _isFavorite = !_isFavorite),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppPalette.premiumDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            car.tagline,
            style: const TextStyle(
                color: AppPalette.accentLight,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _specTile(Icons.event_seat_outlined, '${car.seats}', 'Seats'),
              const SizedBox(width: 12),
              _specTile(Icons.settings_outlined, car.transmission, 'Gearbox'),
              const SizedBox(width: 12),
              _specTile(Icons.local_gas_station_outlined, car.fuel, 'Fuel'),
              const SizedBox(width: 12),
              _specTile(Icons.speed_outlined, '${car.topSpeed}', 'km/h'),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.bolt_rounded,
                  color: AppPalette.accentLight, size: 20),
              const SizedBox(width: 6),
              Text(
                '${car.power} • ${car.transmission} transmission',
                style: const TextStyle(color: Colors.white70, fontSize: 13.5),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'About this car',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            car.description,
            style: const TextStyle(
                color: Colors.white60, fontSize: 14, height: 1.55),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildBookBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
          24, 16, 24, 16 + MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: AppPalette.premiumCard,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Total price',
                  style: TextStyle(color: Colors.white38, fontSize: 12)),
              const SizedBox(height: 2),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: car.priceLabel,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                    const TextSpan(
                      text: ' /day',
                      style: TextStyle(color: Colors.white38, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {
              Get.snackbar(
                'Booking',
                '${car.name} — booking flow coming soon',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppPalette.accent,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.accent,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text('Rent Now',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          ),
        ],
      ),
    );
  }

  // ── Small building blocks ─────────────────────────────────────────────
  Widget _specTile(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        decoration: BoxDecoration(
          color: AppPalette.premiumCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppPalette.accentLight, size: 22),
            const SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white38, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
    Color iconColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        width: 42,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
    );
  }

  Widget _glassPill({required Widget child, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}
