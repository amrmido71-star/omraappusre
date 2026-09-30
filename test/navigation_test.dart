import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rihlaty_mobile/main.dart';
import 'package:rihlaty_mobile/widgets/bottom_nav_bar.dart';
import 'package:rihlaty_mobile/screens/more/more_screen.dart';

/// Each case boots a fresh app and drives it to one screen/modal, to catch
/// render-time exceptions (overflows, bad Container args, etc.) that a
/// single static pump of the home tab wouldn't exercise. Exceptions are
/// left uncaught so the test framework prints full widget-tree detail.
void main() {
  Future<void> boot(WidgetTester tester) async {
    await tester.pumpWidget(const RihlatyApp());
    await tester.pumpAndSettle();
  }

  // "المزيد" (and other tab labels) also appear as "see more" links inside
  // page content, so bottom-nav taps must be scoped to the nav bar itself.
  Future<void> tapTab(WidgetTester tester, String label) async {
    final finder = find.descendant(
        of: find.byType(AppBottomNavBar), matching: find.text(label));
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // MoreScreen's menu is a real (lazily-built) ListView, so items below the
  // fold don't exist in the Element tree until scrolled into view.
  Future<void> tapAfterScrollingTo(WidgetTester tester, String label) async {
    final scrollable = find
        .descendant(
            of: find.byType(MoreScreen), matching: find.byType(Scrollable))
        .first;
    for (var i = 0; i < 10 && find.text(label).evaluate().isEmpty; i++) {
      await tester.drag(scrollable, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    await tester.ensureVisible(find.text(label).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(label).first);
    await tester.pumpAndSettle();
  }

  testWidgets('bottom nav tabs all render', (tester) async {
    await boot(tester);
    for (final label in ['العمرة', 'السياحة', 'لقطات', 'المزيد', 'الرئيسية']) {
      await tapTab(tester, label);
    }
  });

  testWidgets('umrah wizard: all 8 steps render', (tester) async {
    await boot(tester);
    await tester.tap(find.byIcon(FontAwesomeIcons.route.data).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('صمّم عمرتك').first);
    await tester.pumpAndSettle();
    for (var i = 0; i < 7; i++) {
      await tester.tap(find.text('التالي').first);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('tourism design form renders', (tester) async {
    await boot(tester);
    await tester.tap(find.byIcon(FontAwesomeIcons.route.data).first);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('صمّم رحلتك').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('صمّم رحلتك').first);
    await tester.pumpAndSettle();
    expect(find.text('معلومات أساسية'), findsOneWidget,
        reason: 'tourism form content should be visible');
  });

  testWidgets('trip detail + booking sheet render', (tester) async {
    await boot(tester);
    await tester.tap(find.text('العمرة الميسرة').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('احجز الآن').first);
    await tester.pumpAndSettle();
  });

  testWidgets('login sheet renders', (tester) async {
    await boot(tester);
    await tester.tap(find.text('تسجيل الدخول').first);
    await tester.pumpAndSettle();
  });

  testWidgets('every "more" sub-screen renders', (tester) async {
    await boot(tester);
    await tapTab(tester, 'المزيد');

    final subScreens = [
      'المفضلة',
      'عمرتي',
      'الملف الشخصي',
      'الإشعارات',
      'الإعدادات',
      'مركز المساعدة',
      'تواصل معنا',
      'الشروط والأحكام',
      'سياسة الخصوصية',
      'عن عمرتي'
    ];
    for (final label in subScreens) {
      await tapAfterScrollingTo(tester, label);
      await tester.tap(find.byIcon(FontAwesomeIcons.arrowRight.data).first);
      await tester.pumpAndSettle();
    }
  });

  testWidgets('order detail sheet renders', (tester) async {
    await boot(tester);
    await tapTab(tester, 'المزيد');
    await tapAfterScrollingTo(tester, 'عمرتي');
    await tester.tap(find.text('#RH-2025-001').first);
    await tester.pumpAndSettle();
  });

  testWidgets('photos tab: post composer modal renders', (tester) async {
    await boot(tester);
    await tapTab(tester, 'لقطات');
    await tester.tap(find.text('شارك رحلتك أو تجربتك مع الآخرين...').first);
    await tester.pumpAndSettle();
  });
}
