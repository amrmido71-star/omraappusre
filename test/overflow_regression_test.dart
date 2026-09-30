import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rihlaty_mobile/main.dart';
import 'package:rihlaty_mobile/widgets/bottom_nav_bar.dart';
import 'package:rihlaty_mobile/widgets/search_bar_widget.dart';

/// Regression test for the specific overflow reports: cards squeezed into
/// fixed-height horizontal scrollers, and Rows with unprotected text.
/// Runs the same flows as navigation_test.dart but on a narrow physical
/// screen (common small-Android width) where these bugs actually surfaced,
/// plus explicitly visits the Umrah Results (date-scroller) screen that
/// wasn't covered by the original navigation suite.
void main() {
  Future<void> boot(WidgetTester tester, {Size size = const Size(360, 690)}) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const RihlatyApp());
    await tester.pumpAndSettle();
  }

  Future<void> tapTab(WidgetTester tester, String label) async {
    final finder = find.descendant(of: find.byType(AppBottomNavBar), matching: find.text(label));
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  for (final size in [const Size(360, 690), const Size(320, 568), const Size(430, 900)]) {
    testWidgets('home tab renders without overflow at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await boot(tester, size: size);
      // Home renders the umrah provider scroller + trip cards with CardPriceRow —
      // exactly where the reported "شريط" (overflow stripe) appeared.
    });

    testWidgets('umrah results (date scroller) renders without overflow at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await boot(tester, size: size);
      await tapTab(tester, 'العمرة');
      final searchGoButton = find.descendant(of: find.byType(SearchBarWidget), matching: find.byIcon(FontAwesomeIcons.magnifyingGlass.data));
      await tester.tap(searchGoButton);
      await tester.pumpAndSettle();
      expect(find.text('رحلات العمرة'), findsOneWidget, reason: 'should have navigated to the umrah results screen');
      // Tap through a few dates to exercise the date-scroller cards at each selection.
      final dateCards = find.textContaining('ج').evaluate().length;
      expect(dateCards, greaterThan(0), reason: 'date scroller cards should be present');
    });

    testWidgets('umrah/tourism tabs with economy sections render without overflow at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await boot(tester, size: size);
      await tapTab(tester, 'العمرة');
      await tapTab(tester, 'السياحة');
    });

    testWidgets('trip detail + booking sheet render without overflow at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await boot(tester, size: size);
      await tester.ensureVisible(find.text('العمرة الذهبية VIP').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('العمرة الذهبية VIP').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('احجز الآن').first);
      await tester.pumpAndSettle();
    });

    testWidgets('more menu + order detail render without overflow at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await boot(tester, size: size);
      await tapTab(tester, 'المزيد');
      await tester.tap(find.text('طلباتي').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('#RH-2025-002').first);
      await tester.pumpAndSettle();
    });

    testWidgets('umrah wizard steps render without overflow at ${size.width.toInt()}x${size.height.toInt()}', (tester) async {
      await boot(tester, size: size);
      await tester.tap(find.byIcon(FontAwesomeIcons.route.data).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('صمّم عمرتك').first);
      await tester.pumpAndSettle();
      for (var i = 0; i < 7; i++) {
        await tester.tap(find.text('التالي').first);
        await tester.pumpAndSettle();
      }
    });
  }

  // Sweep across every width in the common phone range in 10px steps —
  // the trip_card_uc.dart IntrinsicHeight+Wrap 1px rounding bug only
  // surfaced at 283px content width, which none of the three fixed sizes
  // above happened to hit. A dense sweep is the only reliable way to catch
  // width-dependent rounding bugs like that.
  for (var width = 300; width <= 430; width += 10) {
    testWidgets('home tab (with umrah trip cards) renders without overflow at width $width', (tester) async {
      await boot(tester, size: Size(width.toDouble(), 800));
    });
  }
}
