import 'package:flutter/foundation.dart';
import '../models/country.dart';

/// Mirrors [LocaleState]'s static-ValueNotifier idiom. `selected` is
/// deliberately nullable: null means "unresolved" (still detecting, or
/// detection failed and the user hasn't picked yet) — no code path may
/// treat null as an implicit Egypt default.
class CountryState {
  CountryState._();
  static final ValueNotifier<Country?> selected = ValueNotifier<Country?>(null);
  /// The real backend departure-city id (see `AppState.fetchDepartureCities`)
  /// — null means "all cities in the country". Replaced the old static
  /// per-country `cityKeys` catalog (hand-typed, capped at 1-2 cities),
  /// which never actually affected trip filtering anyway.
  static final ValueNotifier<int?> selectedCityId = ValueNotifier<int?>(null);
  /// Already server-localized display name for [selectedCityId] — no local
  /// `tr()` key exists for an arbitrary real city, unlike the old catalog.
  static final ValueNotifier<String?> selectedCityName = ValueNotifier<String?>(null);
  static final ValueNotifier<bool> detecting = ValueNotifier<bool>(true);
}
