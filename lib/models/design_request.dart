/// Stages of an in-progress "صمّم عمرتك" design request, in order.
enum DesignRequestStage { accepted, contacted, prepared, completed }

/// A previously submitted "صمّم عمرتك" wizard request — mirrors the exact
/// inputs collected by [UmrahWizardScreen], not a confirmed booking (no
/// bus/hotel assignment, no supervisor contact).
class UmrahDesignRequest {
  final String id;
  final String date;
  final DesignRequestStage stage;
  final String startPoint;
  final int adults;
  final int makkaDays;
  final int madinaDays;
  final String hotelStars;
  final String roomType;
  final List<String> hotelPrefs;
  final String departureCity;
  final String flightClass;
  final String? extraService;
  final String name;
  final String phone;
  final String notes;

  const UmrahDesignRequest({
    required this.id,
    required this.date,
    required this.stage,
    required this.startPoint,
    required this.adults,
    required this.makkaDays,
    required this.madinaDays,
    required this.hotelStars,
    required this.roomType,
    this.hotelPrefs = const [],
    required this.departureCity,
    required this.flightClass,
    this.extraService,
    required this.name,
    required this.phone,
    this.notes = '',
  });
}
