import 'package:flutter/material.dart';

/// A travel/umrah provider company shown in the horizontal scroller
/// and used as the taggable company list in the post composer.
class ProviderCompany {
  /// Real backend company id — null for locally-seeded/demo entries that
  /// have no matching `/companies/{id}` record to open a profile page for.
  final int? id;
  final String name;
  final Color color;
  final String letter;
  final String stars;
  final int trips;

  /// Latin @handle used for mention-style ("@name") tagging in the post
  /// composer's autocomplete.
  final String handle;

  /// Home country this company operates out of, e.g. 'EG', 'SA'.
  final String countryCode;

  const ProviderCompany({
    this.id,
    required this.name,
    required this.color,
    required this.letter,
    this.stars = '★★★★★',
    this.trips = 0,
    this.handle = '',
    this.countryCode = 'EG',
  });
}
