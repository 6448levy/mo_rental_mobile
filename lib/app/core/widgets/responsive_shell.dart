// core/widgets/responsive_shell.dart
import 'package:flutter/material.dart';
import '../themes/app_palette.dart';

/// Wraps the entire app so a mobile-first UI fits *any* screen.
///
/// On phones (width <= [maxContentWidth]) the app renders edge-to-edge exactly
/// as before. On larger screens (tablets, laptops, desktop, web) the content is
/// constrained to a phone-like column and centred on a dimmed backdrop, so
/// nothing stretches or breaks.
///
/// Crucially it ALSO overrides [MediaQuery] for the subtree, so any screen that
/// reads `MediaQuery.of(context).size.width` sees the constrained width and lays
/// out as a phone would — not the full window width.
class ResponsiveShell extends StatelessWidget {
  const ResponsiveShell({super.key, required this.child});

  final Widget child;

  /// Phone-like max width. Above this, content is centred with side gutters.
  static const double maxContentWidth = 480;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    // Phone / narrow window: render exactly as the original mobile design.
    if (mq.size.width <= maxContentWidth) return child;

    // Wide window: centre a phone-width column on a dim backdrop.
    final constrainedWidth = maxContentWidth;
    return ColoredBox(
      color: const Color(0xFF0B0B14), // slightly darker than the app background
      child: Center(
        child: Container(
          width: constrainedWidth,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppPalette.premiumDark,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                spreadRadius: 4,
              ),
            ],
          ),
          child: MediaQuery(
            // Tell descendants they live in a phone-width viewport.
            data: mq.copyWith(size: Size(constrainedWidth, mq.size.height)),
            child: child,
          ),
        ),
      ),
    );
  }
}
