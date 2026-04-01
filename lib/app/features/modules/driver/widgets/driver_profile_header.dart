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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppPalette.outline),
        boxShadow: [
          BoxShadow(
            color: AppPalette.cardShadow.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Row: Avatar + Name + Rating ────────────────────────────
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image
              Stack(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: AppPalette.brandBlue.withOpacity(0.1),
                    backgroundImage: (profileImageUrl != null &&
                            profileImageUrl!.isNotEmpty)
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: (profileImageUrl == null ||
                            profileImageUrl!.isEmpty)
                        ? const Icon(Icons.person, size: 34, color: AppPalette.brandBlue)
                        : null,
                  ),
                  if (isLoading)
                    Positioned.fill(
                      child: CircleAvatar(
                        radius: 34,
                        backgroundColor: Colors.white.withOpacity(0.6),
                        child: const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: AppPalette.brandBlue),
                        ),
                      ),
                    ),
                  // Online indicator dot
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: isVerified ? Colors.green.shade600 : Colors.orange.shade700,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppPalette.pureWhite, width: 2),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              // Name + location + verified badge
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: AppPalette.textPrimary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isVerified)
                          const Icon(
                            Icons.verified,
                            color: AppPalette.brandBlue,
                            size: 18,
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        color: AppPalette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Rating row
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 15),
                        const SizedBox(width: 3),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppPalette.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '($ratingCount reviews)',
                          style: TextStyle(
                              color: AppPalette.textDisabled, fontSize: 12),
                        ),
                        const Spacer(),
                        // Status chip
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isVerified
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isVerified ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2)),
                          ),
                          child: Text(
                            isVerified ? "Approved" : "Pending",
                            style: TextStyle(
                              color: isVerified ? Colors.green.shade700 : Colors.orange.shade800,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Divider ────────────────────────────────────────────────────
          if (bio.isNotEmpty || hourlyRate > 0 || yearsExperience > 0) ...[
            const SizedBox(height: 14),
            Divider(color: AppPalette.outline, height: 1),
            const SizedBox(height: 14),
          ],

          // ── Bio ────────────────────────────────────────────────────────
          if (bio.isNotEmpty) ...[
            Text(
              bio,
              style: TextStyle(
                color: AppPalette.textPrimary,
                fontSize: 13,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ],

          // ── Stats Row ──────────────────────────────────────────────────
          if (hourlyRate > 0 || yearsExperience > 0)
            Row(
              children: [
                if (hourlyRate > 0)
                  _buildStatChip(
                    icon: Icons.attach_money,
                    label: '\$${hourlyRate.toStringAsFixed(0)}/hr',
                    color: Colors.green.shade600,
                  ),
                if (hourlyRate > 0 && yearsExperience > 0)
                  const SizedBox(width: 8),
                if (yearsExperience > 0)
                  _buildStatChip(
                    icon: Icons.work_outline,
                    label: '$yearsExperience yrs exp',
                    color: AppPalette.brandBlue,
                  ),
              ],
            ),

          // ── Languages ─────────────────────────────────────────────────
          if (languages.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: languages
                  .map(
                    (lang) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppPalette.brandBlue.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppPalette.brandBlue.withOpacity(0.1)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.language,
                              size: 12, color: AppPalette.brandBlue),
                          const SizedBox(width: 4),
                           Text(
                            lang,
                            style: const TextStyle(fontSize: 12, color: AppPalette.textPrimary),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
