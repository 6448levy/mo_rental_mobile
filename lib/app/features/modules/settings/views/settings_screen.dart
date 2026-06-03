import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/themes/app_palette.dart';
import '../../../../routes/app_routes.dart';

import '../../../../core/themes/theme_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _sectionHeader('Account'),
          _settingsCard([
            _settingsItem(
              icon: Icons.person_outline_rounded,
              title: 'Personal Information',
              onTap: () => Get.toNamed(AppRoutes.profile),
            ),
            _settingsItem(
              icon: Icons.calendar_month_rounded,
              title: 'My Bookings',
              onTap: () => Get.toNamed(AppRoutes.myBookings),
            ),
            _settingsItem(
              icon: Icons.payment_rounded,
              title: 'Payment Methods',
              onTap: () => Get.toNamed(AppRoutes.addCard),
            ),
          ]),
          
          const SizedBox(height: 32),
          _sectionHeader('App Settings'),
          _settingsCard([
            Obx(() => _settingsItem(
              icon: Icons.dark_mode_rounded,
              title: 'Dark Mode',
              trailing: Switch.adaptive(
                value: themeController.isDarkMode.value,
                activeColor: AppPalette.brandBlue,
                onChanged: (val) => themeController.toggleTheme(),
              ),
              onTap: () => themeController.toggleTheme(),
            )),
            _settingsItem(
              icon: Icons.notifications_none_rounded,
              title: 'Notifications',
              trailing: const Icon(Icons.chevron_right_rounded, color: AppPalette.textDisabled),
              onTap: () {},
            ),
            _settingsItem(
              icon: Icons.security_rounded,
              title: 'Security & Privacy',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 32),
          _sectionHeader('Support'),
          _settingsCard([
            _settingsItem(
              icon: Icons.help_outline_rounded,
              title: 'Help Center',
              onTap: () {},
            ),
            _settingsItem(
              icon: Icons.info_outline_rounded,
              title: 'About Mo Rental',
              onTap: () {},
            ),
            _settingsItem(
              icon: Icons.description_outlined,
              title: 'Terms of Service',
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Version 1.0.4 (Build 102)',
              style: GoogleFonts.poppins(
                color: AppPalette.textDisabled,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          color: AppPalette.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Builder(
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: context.theme.cardTheme.color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(children: children),
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) => Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppPalette.brandBlue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: AppPalette.brandBlue, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.poppins(
                      color: context.theme.textTheme.titleLarge?.color,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                trailing ?? const Icon(Icons.arrow_forward_ios_rounded, color: AppPalette.textDisabled, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
