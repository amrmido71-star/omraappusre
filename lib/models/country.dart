/// A selectable country in the country/city picker. `hasContent` marks
/// whether real trip/company seed data exists for it — every other field
/// is populated for all countries so the picker itself is never artificially
/// limited to only content-backed countries.
class Country {
  final String code; // ISO 3166-1 alpha-2, e.g. 'EG', 'SA', 'AE'
  final String nameKey; // tr() key, e.g. 'country.egypt'
  final String flagEmoji; // e.g. '🇪🇬'
  final String currencyCode; // ISO 4217, e.g. 'EGP' — plain, not translated
  final List<String> cityKeys; // departure/home-city tr() keys in this country
  final bool hasContent;

  const Country({
    required this.code,
    required this.nameKey,
    required this.flagEmoji,
    required this.currencyCode,
    this.cityKeys = const [],
    this.hasContent = false,
  });
}

/// A real departure city fetched from the backend (see
/// `AppState.fetchDepartureCities`) — [isFeatured] drives the same
/// "المدينة الرئيسية" / "مدن أخرى" (main/other) grouping the website's own
/// location picker uses.
class CityOption {
  final int id;
  final String name;
  final bool isFeatured;
  const CityOption({required this.id, required this.name, this.isFeatured = false});

  factory CityOption.fromJson(Map<String, dynamic> j) => CityOption(
        id: j['id'] as int,
        name: j['name'] as String? ?? '',
        isFeatured: j['is_featured'] as bool? ?? false,
      );
}
