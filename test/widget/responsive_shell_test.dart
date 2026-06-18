import 'package:carrental/app/core/widgets/responsive_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps [ResponsiveShell] at a given logical width and returns the width the
/// child subtree actually sees via MediaQuery.
Future<double> _widthSeenByChild(WidgetTester tester, double screenWidth) async {
  late double seen;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(size: Size(screenWidth, 800)),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ResponsiveShell(
          child: Builder(
            builder: (context) {
              seen = MediaQuery.of(context).size.width;
              return const SizedBox();
            },
          ),
        ),
      ),
    ),
  );
  return seen;
}

void main() {
  group('ResponsiveShell', () {
    testWidgets('passes through full width on phones (<= 480)', (tester) async {
      expect(await _widthSeenByChild(tester, 390), 390);
    });

    testWidgets('constrains the child to phone width on large screens',
        (tester) async {
      // A 1200px laptop window must present a 480px viewport to the app so
      // mobile-first layouts render correctly instead of stretching.
      expect(await _widthSeenByChild(tester, 1200), ResponsiveShell.maxContentWidth);
    });

    testWidgets('renders its child in both modes', (tester) async {
      await tester.pumpWidget(
        const MediaQuery(
          data: MediaQueryData(size: Size(1200, 800)),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ResponsiveShell(child: Text('hello')),
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
    });
  });
}
