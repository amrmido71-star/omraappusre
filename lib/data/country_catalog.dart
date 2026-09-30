import '../models/country.dart';

/// Static catalog of all selectable countries in the country/city picker.
/// Mirrors the static-utility-class idiom used by `SeedData`.
class CountryCatalog {
  CountryCatalog._();

  static const egypt = Country(
    code: 'EG',
    nameKey: 'country.egypt',
    flagEmoji: '🇪🇬',
    currencyCode: 'EGP',
    cityKeys: ['city.cairo'],
    hasContent: true,
  );
  static const saudi = Country(
    code: 'SA',
    nameKey: 'country.saudi',
    flagEmoji: '🇸🇦',
    currencyCode: 'SAR',
    cityKeys: ['city.riyadh', 'city.jeddah'],
    hasContent: true,
  );
  static const uae = Country(
    code: 'AE',
    nameKey: 'country.uae',
    flagEmoji: '🇦🇪',
    currencyCode: 'AED',
    cityKeys: ['city.dubai', 'city.abudhabi'],
    hasContent: true,
  );
  static const kuwait = Country(
    code: 'KW',
    nameKey: 'country.kuwait',
    flagEmoji: '🇰🇼',
    currencyCode: 'KWD',
  );
  static const qatar = Country(
    code: 'QA',
    nameKey: 'country.qatar',
    flagEmoji: '🇶🇦',
    currencyCode: 'QAR',
  );
  static const jordan = Country(
    code: 'JO',
    nameKey: 'country.jordan',
    flagEmoji: '🇯🇴',
    currencyCode: 'JOD',
  );
  static const morocco = Country(
    code: 'MA',
    nameKey: 'country.morocco',
    flagEmoji: '🇲🇦',
    currencyCode: 'MAD',
  );
  static const algeria = Country(
    code: 'DZ',
    nameKey: 'country.algeria',
    flagEmoji: '🇩🇿',
    currencyCode: 'DZD',
  );
  static const tunisia = Country(
    code: 'TN',
    nameKey: 'country.tunisia',
    flagEmoji: '🇹🇳',
    currencyCode: 'TND',
  );
  static const iraq = Country(
    code: 'IQ',
    nameKey: 'country.iraq',
    flagEmoji: '🇮🇶',
    currencyCode: 'IQD',
  );
  static const palestine = Country(
    code: 'PS',
    nameKey: 'country.palestine',
    flagEmoji: '🇵🇸',
    currencyCode: 'ILS',
  );
  static const sudan = Country(
    code: 'SD',
    nameKey: 'country.sudan',
    flagEmoji: '🇸🇩',
    currencyCode: 'SDG',
  );
  static const yemen = Country(
    code: 'YE',
    nameKey: 'country.yemen',
    flagEmoji: '🇾🇪',
    currencyCode: 'YER',
  );
  static const bahrain = Country(
    code: 'BH',
    nameKey: 'country.bahrain',
    flagEmoji: '🇧🇭',
    currencyCode: 'BHD',
  );
  static const oman = Country(
    code: 'OM',
    nameKey: 'country.oman',
    flagEmoji: '🇴🇲',
    currencyCode: 'OMR',
  );
  static const lebanon = Country(
    code: 'LB',
    nameKey: 'country.lebanon',
    flagEmoji: '🇱🇧',
    currencyCode: 'LBP',
  );
  static const syria = Country(
    code: 'SY',
    nameKey: 'country.syria',
    flagEmoji: '🇸🇾',
    currencyCode: 'SYP',
  );
  static const libya = Country(
    code: 'LY',
    nameKey: 'country.libya',
    flagEmoji: '🇱🇾',
    currencyCode: 'LYD',
  );
  static const pakistan = Country(
    code: 'PK',
    nameKey: 'country.pakistan',
    flagEmoji: '🇵🇰',
    currencyCode: 'PKR',
  );
  static const india = Country(
    code: 'IN',
    nameKey: 'country.india',
    flagEmoji: '🇮🇳',
    currencyCode: 'INR',
  );
  static const bangladesh = Country(
    code: 'BD',
    nameKey: 'country.bangladesh',
    flagEmoji: '🇧🇩',
    currencyCode: 'BDT',
  );
  static const turkey = Country(
    code: 'TR',
    nameKey: 'country.turkey',
    flagEmoji: '🇹🇷',
    currencyCode: 'TRY',
  );
  static const indonesia = Country(
    code: 'ID',
    nameKey: 'country.indonesia',
    flagEmoji: '🇮🇩',
    currencyCode: 'IDR',
  );
  static const malaysia = Country(
    code: 'MY',
    nameKey: 'country.malaysia',
    flagEmoji: '🇲🇾',
    currencyCode: 'MYR',
  );
  static const nigeria = Country(
    code: 'NG',
    nameKey: 'country.nigeria',
    flagEmoji: '🇳🇬',
    currencyCode: 'NGN',
  );
  static const somalia = Country(
    code: 'SO',
    nameKey: 'country.somalia',
    flagEmoji: '🇸🇴',
    currencyCode: 'SOS',
  );
  static const senegal = Country(
    code: 'SN',
    nameKey: 'country.senegal',
    flagEmoji: '🇸🇳',
    currencyCode: 'XOF',
  );
  static const djibouti = Country(
    code: 'DJ',
    nameKey: 'country.djibouti',
    flagEmoji: '🇩🇯',
    currencyCode: 'DJF',
  );
  static const comoros = Country(
    code: 'KM',
    nameKey: 'country.comoros',
    flagEmoji: '🇰🇲',
    currencyCode: 'KMF',
  );
  static const mauritania = Country(
    code: 'MR',
    nameKey: 'country.mauritania',
    flagEmoji: '🇲🇷',
    currencyCode: 'MRU',
  );
  static const brunei = Country(
    code: 'BN',
    nameKey: 'country.brunei',
    flagEmoji: '🇧🇳',
    currencyCode: 'BND',
  );
  static const afghanistan = Country(
    code: 'AF',
    nameKey: 'country.afghanistan',
    flagEmoji: '🇦🇫',
    currencyCode: 'AFN',
  );
  static const iran = Country(
    code: 'IR',
    nameKey: 'country.iran',
    flagEmoji: '🇮🇷',
    currencyCode: 'IRR',
  );
  static const usa = Country(
    code: 'US',
    nameKey: 'country.usa',
    flagEmoji: '🇺🇸',
    currencyCode: 'USD',
  );
  static const uk = Country(
    code: 'GB',
    nameKey: 'country.uk',
    flagEmoji: '🇬🇧',
    currencyCode: 'GBP',
  );
  static const france = Country(
    code: 'FR',
    nameKey: 'country.france',
    flagEmoji: '🇫🇷',
    currencyCode: 'EUR',
  );
  static const germany = Country(
    code: 'DE',
    nameKey: 'country.germany',
    flagEmoji: '🇩🇪',
    currencyCode: 'EUR',
  );
  static const canada = Country(
    code: 'CA',
    nameKey: 'country.canada',
    flagEmoji: '🇨🇦',
    currencyCode: 'CAD',
  );
  static const australia = Country(
    code: 'AU',
    nameKey: 'country.australia',
    flagEmoji: '🇦🇺',
    currencyCode: 'AUD',
  );
  static const other = Country(
    code: 'XX',
    nameKey: 'country.other',
    flagEmoji: '🏳️',
    currencyCode: '',
  );

  static const all = [
    egypt,
    saudi,
    uae,
    kuwait,
    qatar,
    jordan,
    morocco,
    algeria,
    tunisia,
    iraq,
    palestine,
    sudan,
    yemen,
    bahrain,
    oman,
    lebanon,
    syria,
    libya,
    pakistan,
    india,
    bangladesh,
    turkey,
    indonesia,
    malaysia,
    nigeria,
    somalia,
    senegal,
    djibouti,
    comoros,
    mauritania,
    brunei,
    afghanistan,
    iran,
    usa,
    uk,
    france,
    germany,
    canada,
    australia,
    other,
  ];

  static Country? byCode(String code) {
    for (final c in all) {
      if (c.code == code) return c;
    }
    return null;
  }
}
