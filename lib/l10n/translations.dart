import '../state/locale_state.dart';
import 'sections/auth.dart';
import 'sections/common.dart';
import 'sections/company_profile.dart';
import 'sections/countries.dart';
import 'sections/design.dart';
import 'sections/feats.dart';
import 'sections/header.dart';
import 'sections/legal.dart';
import 'sections/more_menu.dart';
import 'sections/nav.dart';
import 'sections/orders.dart';
import 'sections/photos.dart';
import 'sections/seed_companies.dart';
import 'sections/seed_orders.dart';
import 'sections/seed_posts.dart';
import 'sections/seed_trips.dart';
import 'sections/seed_trips_sa.dart';
import 'sections/seed_trips_uae.dart';
import 'sections/seed_umrah_results.dart';
import 'sections/settings.dart';
import 'sections/trip.dart';

final Map<String, Map<String, String>> _all = _buildAll();

Map<String, Map<String, String>> _buildAll() {
  final sections = [
    commonTranslations,
    navTranslations,
    headerTranslations,
    settingsTranslations,
    moreMenuTranslations,
    ordersTranslations,
    legalTranslations,
    authTranslations,
    designTranslations,
    tripTranslations,
    countryTranslations,
    photosTranslations,
    companyProfileTranslations,
    featsTranslations,
    seedTripsTranslations,
    seedTripsSaTranslations,
    seedTripsUaeTranslations,
    seedPostsTranslations,
    seedOrdersTranslations,
    seedCompaniesTranslations,
    seedUmrahResultsTranslations,
  ];
  final result = <String, Map<String, String>>{
    for (final l in LocaleState.supportedLocales) l.languageCode: {},
  };
  for (final section in sections) {
    for (final entry in section.entries) {
      result[entry.key]!.addAll(entry.value);
    }
  }
  return result;
}

/// Looks up [key] in the active locale ([LocaleState.locale]), falling back
/// to Arabic, then to the raw key itself so a missing translation is
/// visibly obvious instead of crashing.
String tr(String key) {
  final code = LocaleState.locale.value.languageCode;
  return _all[code]?[key] ?? _all['ar']?[key] ?? key;
}
