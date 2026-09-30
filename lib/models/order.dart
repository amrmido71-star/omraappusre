enum OrderStatus { pending, confirmed, completed, cancelled }

class OrderBusInfo {
  final String num;
  final String cap;
  final String supervisor;
  final String phone;
  const OrderBusInfo({
    required this.num,
    required this.cap,
    required this.supervisor,
    required this.phone,
  });
}

class OrderHotelInfo {
  final String name;
  final String stars;
  final String location;
  final String room;
  final String roomType;
  final List<String> roommates;
  const OrderHotelInfo({
    required this.name,
    required this.stars,
    required this.location,
    required this.room,
    required this.roomType,
    this.roommates = const [],
  });
}

class Order {
  /// Backend booking id — null for local seed/demo orders.
  final int? apiId;
  /// Backend umrah-trip id — lets the card's "عرض الرحلة" open the trip.
  final int? tripId;
  /// `Y-m-d` strings from the bookings API — shown on the card exactly like
  /// the website's "تاريخ الحجز / تاريخ الانطلاق" row.
  final String? bookingDate;
  final String? departureDate;
  final int personsCount;
  final String id;
  final String trip;
  final String emoji;
  /// A real photo URL from the backend — takes priority over [emoji]
  /// wherever the order's trip image is shown.
  final String? networkImage;
  final String provider;
  final String date;
  final String duration;
  final String pax;
  final String departureCity; // e.g. 'city.cairo', 'city.riyadh'
  final OrderStatus status;
  final String statusText;
  final OrderBusInfo? bus;
  final OrderHotelInfo hotel;
  final bool hotelAssigned;
  final bool roomAssigned;
  final String priceUnit;
  final String total;
  final String action;
  /// unpaid | paid | failed — null for local seed/demo orders or bookings
  /// with no online payment attached yet (`bookings.payment_status`, a
  /// distinct column from the `payments` table's own pending/captured/
  /// failed status).
  final String? paymentStatus;
  /// full | commission | unconfirmed — mirrors [ApiBooking.paymentOption].
  final String? paymentOption;

  /// Whether this booking still needs (and can accept) an online card
  /// payment — same rule as the website's "ادفع الآن" button in
  /// `profile-bookings.blade.php`: pending, not paid, and a card-payable
  /// payment option.
  bool get needsPayment =>
      apiId != null &&
      status == OrderStatus.pending &&
      paymentStatus != 'paid' &&
      (paymentOption == 'full' || paymentOption == 'commission');

  /// Mirrors the website's `BookingController::cancel()` rule exactly —
  /// only a still-pending, still-unpaid booking can be self-cancelled by
  /// the customer; once confirmed or paid, only an admin can cancel it.
  bool get canCancel =>
      apiId != null && status == OrderStatus.pending && paymentStatus != 'paid';

  const Order({
    this.apiId,
    this.tripId,
    this.bookingDate,
    this.departureDate,
    this.personsCount = 1,
    required this.id,
    required this.trip,
    required this.emoji,
    this.networkImage,
    required this.provider,
    required this.date,
    required this.duration,
    required this.pax,
    this.departureCity = 'city.cairo',
    required this.status,
    required this.statusText,
    this.bus,
    required this.hotel,
    this.hotelAssigned = true,
    this.roomAssigned = true,
    required this.priceUnit,
    required this.total,
    required this.action,
    this.paymentStatus,
    this.paymentOption,
  });
}
