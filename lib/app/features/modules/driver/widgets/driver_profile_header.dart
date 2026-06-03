import 'package:flutter/material.dart';
import '../../../../core/themes/app_palette.dart';

class DriverProfileHeader extends StatelessWidget {
  final String name;
  final String phoneNumber; // repurposed to show location
  final double rating;
  final int ratingCount;
  final bool isVerified;
  final String? profileImageUrl;
  final String bio;
  final double hourlyRate;
  final int yearsExperience;
  final List<String> languages;
  final bool isLoading;

  const DriverProfileHeader({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.rating,
    this.ratingCount = 0,
    this.isVerified = false,
    this.profileImageUrl,
    this.bio = '',
    this.hourlyRate = 0.0,
    this.yearsExperience = 0,
    this.languages = const [],
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppPalette.brandBlue.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
        border: Border.all(color: AppPalette.brandBlue.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          // ── Premium Top Banner ────────────────────────────
          Container(
            height: 100,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppPalette.brandBlue,
                  Color(0xFF1E88E5),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -30,
                  top: -20,
                  child: Icon(
                    Icons.security_rounded,
                    size: 140,
                    color: AppPalette.pureWhite.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
          ),

          // ── Profile Content with Overlapping Avatar ───────
          Transform.translate(
            offset: const Offset(0, -50),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Animated Avatar
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppPalette.pureWhite,
                          shape: BoxShape.circle,
                        ),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor:
                              AppPalette.brandBlue.withValues(alpha: 0.1),
                          backgroundImage: (profileImageUrl != null &&
                                  profileImageUrl!.isNotEmpty)
                              ? NetworkImage(profileImageUrl!)
                              : null,
                          child: (profileImageUrl == null ||
                                  profileImageUrl!.isEmpty)
                              ? const Icon(Icons.person,
                                  size: 54, color: AppPalette.brandBlue)
                              : null,
                        ),
                      ),
                      if (isVerified)
                        Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: AppPalette.pureWhite,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            color: AppPalette.brandBlue,
                            size: 28,
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Name and Rating
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppPalette.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded,
                          color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        rating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: AppPalette.textPrimary,
                        ),
                      ),
                      Text(
                        ' • $ratingCount Reviews',
                        style: const TextStyle(
                          color: AppPalette.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Visual Stats Grid ──────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppPalette.brandBlue.withValues(alpha: 0.04),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppPalette.brandBlue.withValues(alpha: 0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatBox(
                          icon: Icons.history_rounded,
                          value: '${yearsExperience}y+',
                          label: 'Experience',
                        ),
                        _buildDivider(),
                        _buildStatBox(
                          icon: Icons.payments_rounded,
                          value: '\$${hourlyRate.toStringAsFixed(0)}',
                          label: 'Per Hour',
                        ),
                        _buildDivider(),
                        _buildStatBox(
                          icon: Icons.translate_rounded,
                          value: '${languages.length}',
                          label: 'Languages',
                        ),
                      ],
                    ),
                  ),

                  if (bio.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Text(
                      'About Driver',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppPalette.brandBlue,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppPalette.textSecondary,
                        fontSize: 14,
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() => Container(
        height: 30,
        width: 1,
        color: AppPalette.brandBlue.withValues(alpha: 0.1),
      );

  Widget _buildStatBox({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppPalette.brandBlue, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppPalette.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: AppPalette.textSecondary,
          ),
        ),
      ],
    );
  }
}
