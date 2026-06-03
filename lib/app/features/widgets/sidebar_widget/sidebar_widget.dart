// lib/app/features/widgets/sidebar_widget/sidebar_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../modules/promo_code/views/promo_code_screen.dart';
import '../../modules/profile/views/rental_history_view.dart';
import '../../../routes/app_routes.dart';
import '../../../core/themes/app_palette.dart';

class SidebarWidget extends StatefulWidget {
  final Widget child;
  final bool initiallyOpen;

  const SidebarWidget({
    super.key,
    required this.child,
    this.initiallyOpen = false,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget>
    with SingleTickerProviderStateMixin {
  final GetStorage storage = GetStorage();
  bool _isSidebarOpen = false;
  int _selectedIndex = 0;
  late AnimationController _animController;
  late Animation<double> _slideAnim;

  static const _active = AppPalette.brandBlue;
  static const _bg = AppPalette.pureWhite;

  final List<_SidebarItem> _sidebarItems = [
    _SidebarItem(
        icon: Icons.home_rounded, title: 'Home', route: AppRoutes.main),
    _SidebarItem(
        icon: Icons.person_search_rounded,
        title: 'Find Drivers',
        route: AppRoutes.drivers),
    _SidebarItem(
        icon: Icons.calendar_month_rounded,
        title: 'My Bookings',
        route: AppRoutes.myBookings),
    _SidebarItem(
        icon: Icons.person_outline_rounded,
        title: 'Profile',
        route: AppRoutes.profile),
    _SidebarItem(
        icon: Icons.local_offer_rounded,
        title: 'Promo Codes',
        route: AppRoutes.promoCodes),
    _SidebarItem(
        icon: Icons.credit_card_rounded,
        title: 'Payment Methods',
        route: AppRoutes.addCard),
    _SidebarItem(
        icon: Icons.settings_rounded, title: 'Settings', route: AppRoutes.settings),
    _SidebarItem(
        icon: Icons.help_outline_rounded,
        title: 'Help & Support',
        route: '/support'),
  ];

  @override
  void initState() {
    super.initState();
    _isSidebarOpen = widget.initiallyOpen;
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _slideAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    if (_isSidebarOpen) _animController.value = 1.0;
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
    if (_isSidebarOpen) {
      _animController.forward();
    } else {
      _animController.reverse();
    }
  }

  void _navigateTo(int index) {
    final item = _sidebarItems[index];
    setState(() => _selectedIndex = index);
    _toggleSidebar();

    // Small delay to let sidebar close before pushing
    Future.delayed(const Duration(milliseconds: 180), () {
      _handleNavigation(item);
    });
  }

  void _handleNavigation(_SidebarItem item) {
    switch (item.route) {
      case AppRoutes.main:
      case '/home':
        // Already home, do nothing
        break;
      case AppRoutes.drivers:
        Get.toNamed(AppRoutes.drivers);
        break;
      case AppRoutes.myBookings:
        Get.toNamed(AppRoutes.myBookings);
        break;
      case AppRoutes.profile:
        Get.toNamed(AppRoutes.profile);
        break;
      case AppRoutes.promoCodes:
        Get.to(() => const PromoCodeScreen());
        break;
      case AppRoutes.addCard:
        Get.toNamed(AppRoutes.addCard);
        break;
      case AppRoutes.settings:
        Get.toNamed(AppRoutes.settings);
        break;
      default:
        Get.snackbar(
          'Coming Soon',
          '${item.title} feature is under development',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black87,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = storage.read('user_data') ?? {};
    final userName = userData['full_name'] ?? 'Guest';
    final userEmail = userData['email'] ?? 'guest@example.com';
    final initials = userName.isNotEmpty ? userName[0].toUpperCase() : 'G';

    return Scaffold(
      body: Stack(
        children: [
          // ── Main content page ───────────────────────────────────────────
          Positioned.fill(child: widget.child),

          // ── Semi-transparent overlay ────────────────────────────────────
          AnimatedBuilder(
            animation: _slideAnim,
            builder: (_, __) {
              if (_slideAnim.value == 0) return const SizedBox.shrink();
              return GestureDetector(
                onTap: _toggleSidebar,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.6 * _slideAnim.value),
                ),
              );
            },
          ),

          // ── Drawer panel ────────────────────────────────────────────────
          AnimatedBuilder(
            animation: _slideAnim,
            builder: (_, child) {
              return Transform.translate(
                offset: Offset(-300 * (1 - _slideAnim.value), 0),
                child: child,
              );
            },
            child: SizedBox(
              width: 300,
              height: double.infinity,
              child: Material(
                elevation: 16,
                color: _bg,
                child: Column(
                  children: [
                    // ── User Header ───────────────────────────────────────
                    Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20,
                        left: 20,
                        right: 20,
                        bottom: 24,
                      ),
                      decoration: const BoxDecoration(
                        gradient: AppPalette.brandGradient,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Avatar
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _active,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _active.withValues(alpha: 0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    initials,
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppPalette.pureWhite,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      userEmail,
                                      style: GoogleFonts.poppins(
                                        fontSize: 11,
                                        color: Colors.white54,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: _toggleSidebar,
                                icon: const Icon(Icons.close,
                                    color: Colors.white54, size: 20),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Premium badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 5),
                            decoration: BoxDecoration(
                              color:
                                  AppPalette.pureWhite.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: AppPalette.pureWhite
                                      .withValues(alpha: 0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star,
                                    color: AppPalette.pureWhite, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  'Premium Member',
                                  style: GoogleFonts.poppins(
                                    fontSize: 11,
                                    color: AppPalette.pureWhite,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Menu Items ────────────────────────────────────────
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 12),
                        itemCount: _sidebarItems.length,
                        itemBuilder: (context, index) {
                          final item = _sidebarItems[index];
                          final isSelected = _selectedIndex == index;
                          return _buildMenuItem(item, index, isSelected);
                        },
                      ),
                    ),

                    // ── Logout ────────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          storage.remove('user_data');
                          storage.remove('auth_token');
                          Get.offAllNamed(AppRoutes.login);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.redAccent.withValues(alpha: 0.1),
                          foregroundColor: Colors.redAccent,
                          elevation: 0,
                          side: const BorderSide(
                              color: Colors.redAccent, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        icon: const Icon(Icons.logout_rounded, size: 18),
                        label: Text(
                          'Logout',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Hamburger button ─────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 12,
            child: AnimatedBuilder(
              animation: _slideAnim,
              builder: (_, __) => Opacity(
                opacity: 1.0,
                child: GestureDetector(
                  onTap: _toggleSidebar,
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isSidebarOpen ? Icons.close : Icons.menu_rounded,
                      color: AppPalette.brandBlue,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(_SidebarItem item, int index, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isSelected ? AppPalette.pureWhite : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateTo(index),
          splashColor: _active.withValues(alpha: 0.05),
          highlightColor: _active.withValues(alpha: 0.02),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                // Soft colored icon background
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _active.withValues(alpha: 0.12)
                        : AppPalette.textSecondary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item.icon,
                    size: 22,
                    color: isSelected
                        ? _active
                        : AppPalette.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(width: 16),

                // Smooth Text Translation
                Expanded(
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: GoogleFonts.poppins(
                      color: isSelected
                          ? AppPalette.textPrimary
                          : AppPalette.textSecondary,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      fontSize: 15,
                    ),
                    child: Text(item.title),
                  ),
                ),

                // Minimal Active Indicator
                if (isSelected)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 250),
                    opacity: isSelected ? 1.0 : 0.0,
                    child: Container(
                      width: 4,
                      height: 18,
                      decoration: BoxDecoration(
                        color: _active,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String title;
  final String route;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.route,
  });
}
