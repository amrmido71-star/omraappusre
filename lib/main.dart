import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/system_bars.dart';
import 'l10n/translations.dart';
import 'state/app_state.dart';
import 'state/locale_state.dart';
import 'app_shell.dart';
import 'screens/more/notifications_screen.dart';
import 'services/live_updates.dart';
import 'services/push_service.dart';

/// Lets a tapped push notification open the notifications screen from
/// outside the widget tree.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PushService.instance.init();
  LiveUpdates.instance.start();
  PushService.instance.onTap.listen((_) => _openNotifications());
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState()..restoreSession(),
      child: const RihlatyApp(),
    ),
  );
  // App launched by tapping a notification while it was fully closed.
  if (PushService.instance.pendingLaunchTap != null) {
    PushService.instance.pendingLaunchTap = null;
    WidgetsBinding.instance.addPostFrameCallback((_) => _openNotifications());
  }
}

void _openNotifications() {
  navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => const NotificationsScreen()));
}

class RihlatyApp extends StatelessWidget {
  const RihlatyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: LocaleState.locale,
      builder: (context, locale, _) {
        final isRtl = LocaleState.rtlLocales.contains(locale.languageCode);
        return MaterialApp(
          navigatorKey: navigatorKey,
          title: tr('header.appName'),
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme,
          locale: locale,
          supportedLocales: LocaleState.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // Previously capped every route to a fixed 430px "phone frame"
          // width (mirroring `.app{max-width:430px;margin:0 auto}` from the
          // original web prototype, rehlaty.html) — invisible on an
          // ordinary phone (screen width is already under 430), but on a
          // wide unfolded foldable (e.g. a Galaxy Z Fold, reported by a
          // user) it letterboxed the whole app with large empty margins on
          // both sides instead of using the real screen width. That framing
          // made sense for a *web* demo running inside a desktop browser;
          // it doesn't for a native app that should just fill whatever
          // screen it's actually running on. Just switches direction
          // reactively with the selected language now.
          builder: (context, child) => Directionality(
            textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
            child: safeAppFrame(child!),
          ),
          // Keying on the locale forces Flutter to tear down and rebuild the
          // whole app subtree on every language switch. Without this key,
          // `const AppShell()` is an identical widget instance across
          // rebuilds, so Flutter's element diffing skips rebuilding
          // anything below it — only widgets with their own independent
          // listener (e.g. CountryState) would happen to refresh, while
          // every plain `tr()` call elsewhere stays frozen at whatever
          // locale was active the last time that widget actually built.
          home: AppShell(key: ValueKey(locale.languageCode)),
        );
      },
    );
  }
}
