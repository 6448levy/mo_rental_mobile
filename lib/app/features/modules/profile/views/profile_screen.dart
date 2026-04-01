import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../../core/themes/app_palette.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GetStorage storage = GetStorage();
    final AuthController authController = Get.find<AuthController>();
    final userData = storage.read('user_data') ?? {};
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppPalette.pureWhite, // Force light background
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: AppPalette.brandBlue,
        foregroundColor: AppPalette.pureWhite,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppPalette.brandBlue, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppPalette.brandBlue.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 56,
                      backgroundColor: AppPalette.pureWhite,
                      child: Text(
                        userData['full_name'] != null ? userData['full_name'][0].toUpperCase() : 'G',
                        style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppPalette.brandBlue),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppPalette.brandBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit_rounded, size: 16, color: AppPalette.pureWhite),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              userData['full_name'] ?? 'Premium User',
              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
            ),
            const SizedBox(height: 4),
            Text(
              userData['email'] ?? 'Welcome to MoRental',
              style: theme.textTheme.bodyMedium?.copyWith(color: AppPalette.textSecondary),
            ),
            
            const SizedBox(height: 40),
            
            // Stats Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSimpleStat('0', 'Bookings'),
                _buildSimpleStat('0', 'Favorites'),
                _buildSimpleStat('Gold', 'Status'),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Account Information
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppPalette.pureWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppPalette.outline),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded, color: AppPalette.brandBlue, size: 20),
                      const SizedBox(width: 12),
                      Text(
                        'Account Information',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: AppPalette.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildInfoRow(Icons.phone_iphone_rounded, 'Phone', userData['phone'] ?? 'Not set'),
                  const Divider(height: 32, color: AppPalette.outline),
                  _buildInfoRow(Icons.pin_rounded, 'User ID', userData['_id']?.toString() ?? 'N/A'),
                  const Divider(height: 32, color: AppPalette.outline),
                  _buildInfoRow(Icons.verified_user_rounded, 'Account Status', (userData['status'] ?? 'Active').toString().toUpperCase()),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Action Menu
            Column(
              children: [
                _buildActionTile(Icons.history_rounded, 'Booking History', () {}),
                _buildActionTile(Icons.payment_rounded, 'Payment Methods', () {}),
                _buildActionTile(Icons.notifications_none_rounded, 'Notifications', () {}),
                _buildActionTile(Icons.headset_mic_outlined, 'Support Center', () {}),
                const SizedBox(height: 20),
                _buildActionTile(
                  Icons.logout_rounded, 
                  'Logout', 
                  () => authController.logout(),
                  isDestructive: true,
                ),
              ],
            ),
            
            // Version Info
            const SizedBox(height: 40),
            const Text(
              'MoRental v1.2.0-stable',
              style: TextStyle(color: AppPalette.textDisabled, fontSize: 10, letterSpacing: 1),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSimpleStat(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppPalette.textPrimary)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: AppPalette.textSecondary)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9), // Light background for the icon
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: AppPalette.brandBlue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: AppPalette.textSecondary)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppPalette.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    final color = isDestructive ? Colors.redAccent.shade400 : AppPalette.textPrimary;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDestructive ? Colors.redAccent.withOpacity(0.05) : AppPalette.pureWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDestructive ? Colors.redAccent.withOpacity(0.1) : AppPalette.outline,
        ),
        boxShadow: !isDestructive ? [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ] : null,
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: color, size: 22),
        title: Text(
          title, 
          style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w500),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: color.withOpacity(0.3), size: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }
}
