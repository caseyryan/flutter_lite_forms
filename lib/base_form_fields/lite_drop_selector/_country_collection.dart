part of 'lite_country_selector.dart';

class CountryData with SearchQueryMixin {
  final String name;
  final String simplifiedName;
  final String isoCode;
  final String threeLetterCode;
  final String phoneCode;
  final Map<String, String> localizedNames;

  /// Tries to search a country by a name, iso code or a three letter code
  static CountryData? find(String any) {
    return tryFindCountries(any).first;
  }

  String get countryId {
    return isoCode;
  }

  /// [locale] two letter locale, e.g. "ru"
  /// at the moment, only "en" and "ru" are supported
  String localizedName(String locale) {
    return localizedNames[locale] ?? name;
  }

  int sortOrder = 0;

  CountryData({
    required this.name,
    required this.simplifiedName,
    required this.isoCode,
    required this.threeLetterCode,
    required this.phoneCode,
    this.localizedNames = const {},
  }) {
    prepareSearch([
      simplifiedName,
      isoCode,
      threeLetterCode,
      phoneCode,
      ...localizedNames.values.toList(),
    ]);
  }

  Map toMap() {
    return {
      'name': name,
      'simplifiedName': simplifiedName,
      'isoCode': isoCode,
      'threeLetterCode': threeLetterCode,
      'phoneCode': phoneCode,
      'localizedNames': localizedNames,
    };
  }

  @override
  bool operator ==(covariant CountryData other) {
    return other.isoCode == isoCode;
  }

  @override
  int get hashCode {
    return isoCode.hashCode;
  }

  String get lowerIsoCode {
    return isoCode.toLowerCase();
  }
}

/// Tries to search a country by a name, iso code or a three letter code
List<CountryData?> tryFindCountries(String value) {
  final byId = findCountryById(value);
  if (byId != null) {
    return [byId];
  }
  return allCountries.where((e) => e.isMatchingSearch(value)).toList();
}

CountryData? findCountryById(String countryId) {
  return allCountries.firstWhereOrNull((e) => e.isoCode == countryId);
}

final List<CountryData> allCountries = [
  CountryData(
    name: "Austria",
    simplifiedName: "austria",
    isoCode: "AT",
    threeLetterCode: "AUT",
    phoneCode: "+43",
    localizedNames: {
      "ru": "Австрия",
    },
  ),
  CountryData(
    name: "Belgium",
    simplifiedName: "belgium",
    isoCode: "BE",
    threeLetterCode: "BEL",
    phoneCode: "+32",
    localizedNames: {
      "ru": "Бельгия",
    },
  ),
  CountryData(
    name: "Canada",
    simplifiedName: "canada",
    isoCode: "CA",
    threeLetterCode: "CAN",
    phoneCode: "+1",
    localizedNames: {
      "ru": "Канада",
    },
  ),
  CountryData(
    name: "Czech Republic",
    simplifiedName: "czech republic",
    isoCode: "CZ",
    threeLetterCode: "CZE",
    phoneCode: "+420",
    localizedNames: {
      "ru": "Чешская Республика",
    },
  ),
  CountryData(
    name: "Denmark",
    simplifiedName: "denmark",
    isoCode: "DK",
    threeLetterCode: "DNK",
    phoneCode: "+45",
    localizedNames: {
      "ru": "Дания",
    },
  ),
  CountryData(
    name: "Finland",
    simplifiedName: "finland",
    isoCode: "FI",
    threeLetterCode: "FIN",
    phoneCode: "+358",
    localizedNames: {
      "ru": "Финляндия",
    },
  ),
  CountryData(
    name: "France",
    simplifiedName: "france",
    isoCode: "FR",
    threeLetterCode: "FRA",
    phoneCode: "+33",
    localizedNames: {
      "ru": "Франция",
    },
  ),
  CountryData(
    name: "Germany",
    simplifiedName: "germany",
    isoCode: "DE",
    threeLetterCode: "DEU",
    phoneCode: "+49",
    localizedNames: {
      "ru": "Германия",
    },
  ),
  CountryData(
    name: "Greece",
    simplifiedName: "greece",
    isoCode: "GR",
    threeLetterCode: "GRC",
    phoneCode: "+30",
    localizedNames: {
      "ru": "Греция",
    },
  ),
  CountryData(
    name: "Iceland",
    simplifiedName: "iceland",
    isoCode: "IS",
    threeLetterCode: "ISL",
    phoneCode: "+354",
    localizedNames: {
      "ru": "Исландия",
    },
  ),
  CountryData(
    name: "Ireland",
    simplifiedName: "ireland",
    isoCode: "IE",
    threeLetterCode: "IRL",
    phoneCode: "+353",
    localizedNames: {
      "ru": "Ирландия",
    },
  ),
  CountryData(
    name: "Italy",
    simplifiedName: "italy",
    isoCode: "IT",
    threeLetterCode: "ITA",
    phoneCode: "+39",
    localizedNames: {
      "ru": "Италия",
    },
  ),
  CountryData(
    name: "Latvia",
    simplifiedName: "latvia",
    isoCode: "LV",
    threeLetterCode: "LVA",
    phoneCode: "+371",
    localizedNames: {
      "ru": "Латвия",
    },
  ),
  CountryData(
    name: "Luxembourg",
    simplifiedName: "luxembourg",
    isoCode: "LU",
    threeLetterCode: "LUX",
    phoneCode: "+352",
    localizedNames: {
      "ru": "Люксембург",
    },
  ),
  CountryData(
    name: "Malta",
    simplifiedName: "malta",
    isoCode: "MT",
    threeLetterCode: "MLT",
    phoneCode: "+356",
    localizedNames: {
      "ru": "Мальта",
    },
  ),
  CountryData(
    name: "Netherlands",
    simplifiedName: "netherlands",
    isoCode: "NL",
    threeLetterCode: "NLD",
    phoneCode: "+31",
    localizedNames: {
      "ru": "Нидерланды",
    },
  ),
  CountryData(
    name: "Norway",
    simplifiedName: "norway",
    isoCode: "NO",
    threeLetterCode: "NOR",
    phoneCode: "+47",
    localizedNames: {
      "ru": "Норвегия",
    },
  ),
  CountryData(
    name: "Poland",
    simplifiedName: "poland",
    isoCode: "PL",
    threeLetterCode: "POL",
    phoneCode: "+48",
    localizedNames: {
      "ru": "Польша",
    },
  ),
  CountryData(
    name: "Portugal",
    simplifiedName: "portugal",
    isoCode: "PT",
    threeLetterCode: "PRT",
    phoneCode: "+351",
    localizedNames: {
      "ru": "Португалия",
    },
  ),
  CountryData(
    name: "Romania",
    simplifiedName: "romania",
    isoCode: "RO",
    threeLetterCode: "ROU",
    phoneCode: "+40",
    localizedNames: {
      "ru": "Румыния",
    },
  ),
  CountryData(
    name: "Slovakia",
    simplifiedName: "slovakia",
    isoCode: "SK",
    threeLetterCode: "SVK",
    phoneCode: "+421",
    localizedNames: {
      "ru": "Словакия",
    },
  ),
  CountryData(
    name: "Spain",
    simplifiedName: "spain",
    isoCode: "ES",
    threeLetterCode: "ESP",
    phoneCode: "+34",
    localizedNames: {
      "ru": "Испания",
    },
  ),
  CountryData(
    name: "Sweden",
    simplifiedName: "sweden",
    isoCode: "SE",
    threeLetterCode: "SWE",
    phoneCode: "+46",
    localizedNames: {
      "ru": "Швеция",
    },
  ),
  CountryData(
    name: "Switzerland",
    simplifiedName: "switzerland",
    isoCode: "CH",
    threeLetterCode: "CHE",
    phoneCode: "+41",
    localizedNames: {
      "ru": "Швейцария",
    },
  ),
  CountryData(
    name: "United Kingdom",
    simplifiedName: "united kingdom of great britain and northern ireland",
    isoCode: "GB",
    threeLetterCode: "GBR",
    phoneCode: "+44",
    localizedNames: {
      "ru": "Великобритания",
    },
  ),
  CountryData(
    name: "United States of America",
    simplifiedName: "united states of america",
    isoCode: "US",
    threeLetterCode: "USA",
    phoneCode: "+1",
    localizedNames: {
      "ru": "США",
    },
  ),
  CountryData(
    name: "Viet Nam",
    simplifiedName: "viet nam",
    isoCode: "VN",
    threeLetterCode: "VNM",
    phoneCode: "+84",
    localizedNames: {
      "ru": "Вьетнам",
    },
  ),
  CountryData(
    name: "Afghanistan",
    simplifiedName: "afghanistan",
    isoCode: "AF",
    threeLetterCode: "AFG",
    phoneCode: "+93",
    localizedNames: {
      "ru": "Афганистан",
    },
  ),
  CountryData(
    name: "Aland Islands",
    simplifiedName: "aland islands",
    isoCode: "AX",
    threeLetterCode: "ALA",
    phoneCode: "+354",
    localizedNames: {
      "ru": "Острова суши",
    },
  ),
  CountryData(
    name: "Albania",
    simplifiedName: "albania",
    isoCode: "AL",
    threeLetterCode: "ALB",
    phoneCode: "+355",
    localizedNames: {
      "ru": "Албания",
    },
  ),
  CountryData(
    name: "Algeria",
    simplifiedName: "algeria",
    isoCode: "DZ",
    threeLetterCode: "DZA",
    phoneCode: "+213",
    localizedNames: {
      "ru": "Алжир",
    },
  ),
  CountryData(
    name: "American Samoa",
    simplifiedName: "american samoa",
    isoCode: "AS",
    threeLetterCode: "ASM",
    phoneCode: "+1684",
    localizedNames: {
      "ru": "Американское Самоа",
    },
  ),
  CountryData(
    name: "Andorra",
    simplifiedName: "andorra",
    isoCode: "AD",
    threeLetterCode: "AND",
    phoneCode: "+376",
    localizedNames: {
      "ru": "Андорра",
    },
  ),
  CountryData(
    name: "Angola",
    simplifiedName: "angola",
    isoCode: "AO",
    threeLetterCode: "AGO",
    phoneCode: "+244",
    localizedNames: {
      "ru": "Ангола",
    },
  ),
  CountryData(
    name: "Anguilla",
    simplifiedName: "anguilla",
    isoCode: "AI",
    threeLetterCode: "AIA",
    phoneCode: "+1264",
    localizedNames: {
      "ru": "Ангилья",
    },
  ),
  CountryData(
    name: "Antigua and Barbuda",
    simplifiedName: "antigua and barbuda",
    isoCode: "AG",
    threeLetterCode: "ATG",
    phoneCode: "+1268",
    localizedNames: {
      "ru": "Антигуа и Барбуда",
    },
  ),
  CountryData(
    name: "Argentina",
    simplifiedName: "argentina",
    isoCode: "AR",
    threeLetterCode: "ARG",
    phoneCode: "+54",
    localizedNames: {
      "ru": "Аргентина",
    },
  ),
  CountryData(
    name: "Armenia",
    simplifiedName: "armenia",
    isoCode: "AM",
    threeLetterCode: "ARM",
    phoneCode: "+374",
    localizedNames: {
      "ru": "Армения",
    },
  ),
  CountryData(
    name: "Aruba",
    simplifiedName: "aruba",
    isoCode: "AW",
    threeLetterCode: "ABW",
    phoneCode: "+297",
    localizedNames: {
      "ru": "Аруба",
    },
  ),
  CountryData(
    name: "Australia",
    simplifiedName: "australia",
    isoCode: "AU",
    threeLetterCode: "AUS",
    phoneCode: "+61",
    localizedNames: {
      "ru": "Австралия",
    },
  ),
  CountryData(
    name: "Azerbaijan",
    simplifiedName: "azerbaijan",
    isoCode: "AZ",
    threeLetterCode: "AZE",
    phoneCode: "+994",
    localizedNames: {
      "ru": "Азербайджан",
    },
  ),
  CountryData(
    name: "Bahamas",
    simplifiedName: "bahamas",
    isoCode: "BS",
    threeLetterCode: "BHS",
    phoneCode: "+1242",
    localizedNames: {
      "ru": "Багамские острова",
    },
  ),
  CountryData(
    name: "Bahrain",
    simplifiedName: "bahrain",
    isoCode: "BH",
    threeLetterCode: "BHR",
    phoneCode: "+973",
    localizedNames: {
      "ru": "Бахрейн",
    },
  ),
  CountryData(
    name: "Bangladesh",
    simplifiedName: "bangladesh",
    isoCode: "BD",
    threeLetterCode: "BGD",
    phoneCode: "+880",
    localizedNames: {
      "ru": "Бангладеш",
    },
  ),
  CountryData(
    name: "Barbados",
    simplifiedName: "barbados",
    isoCode: "BB",
    threeLetterCode: "BRB",
    phoneCode: "+1246",
    localizedNames: {
      "ru": "Барбадос",
    },
  ),
  CountryData(
    name: "Belarus",
    simplifiedName: "belarus",
    isoCode: "BY",
    threeLetterCode: "BLR",
    phoneCode: "+375",
    localizedNames: {
      "ru": "Беларусь",
    },
  ),
  CountryData(
    name: "Belize",
    simplifiedName: "belize",
    isoCode: "BZ",
    threeLetterCode: "BLZ",
    phoneCode: "+501",
    localizedNames: {
      "ru": "Белиз",
    },
  ),
  CountryData(
    name: "Benin",
    simplifiedName: "benin",
    isoCode: "BJ",
    threeLetterCode: "BEN",
    phoneCode: "+229",
    localizedNames: {
      "ru": "Бенин",
    },
  ),
  CountryData(
    name: "Bermuda",
    simplifiedName: "bermuda",
    isoCode: "BM",
    threeLetterCode: "BMU",
    phoneCode: "+1441",
    localizedNames: {
      "ru": "Бермуды",
    },
  ),
  CountryData(
    name: "Bhutan",
    simplifiedName: "bhutan",
    isoCode: "BT",
    threeLetterCode: "BTN",
    phoneCode: "+975",
    localizedNames: {
      "ru": "Бутан",
    },
  ),
  CountryData(
    name: "Bolivia",
    simplifiedName: "bolivia",
    isoCode: "BO",
    threeLetterCode: "BOL",
    phoneCode: "+591",
    localizedNames: {
      "ru": "Боливия, Многонациональное Государство",
    },
  ),
  CountryData(
    name: "Bosnia and Herzegovina",
    simplifiedName: "bosnia and herzegovina",
    isoCode: "BA",
    threeLetterCode: "BIH",
    phoneCode: "+387",
    localizedNames: {
      "ru": "Босния и Герцеговина",
    },
  ),
  CountryData(
    name: "Botswana",
    simplifiedName: "botswana",
    isoCode: "BW",
    threeLetterCode: "BWA",
    phoneCode: "+267",
    localizedNames: {
      "ru": "Ботсвана",
    },
  ),
  CountryData(
    name: "Brazil",
    simplifiedName: "brazil",
    isoCode: "BR",
    threeLetterCode: "BRA",
    phoneCode: "+55",
    localizedNames: {
      "ru": "Бразилия",
    },
  ),
  CountryData(
    name: "British Virgin Islands",
    simplifiedName: "british virgin islands",
    isoCode: "VG",
    threeLetterCode: "VGB",
    phoneCode: "+1284",
    localizedNames: {
      "ru": "Виргинские острова, Британские",
    },
  ),
  CountryData(
    name: "British Indian Ocean Territory",
    simplifiedName: "british indian ocean territory",
    isoCode: "IO",
    threeLetterCode: "IOT",
    phoneCode: "+246",
    localizedNames: {
      "ru": "Британская территория в Индийском океане",
    },
  ),
  CountryData(
    name: "Brunei Darussalam",
    simplifiedName: "brunei darussalam",
    isoCode: "BN",
    threeLetterCode: "BRN",
    phoneCode: "+673",
    localizedNames: {
      "ru": "Бруней-Даруссалам",
    },
  ),
  CountryData(
    name: "Bulgaria",
    simplifiedName: "bulgaria",
    isoCode: "BG",
    threeLetterCode: "BGR",
    phoneCode: "+359",
    localizedNames: {
      "ru": "Болгария",
    },
  ),
  CountryData(
    name: "Burkina Faso",
    simplifiedName: "burkina faso",
    isoCode: "BF",
    threeLetterCode: "BFA",
    phoneCode: "+226",
    localizedNames: {
      "ru": "Буркина-Фасо",
    },
  ),
  CountryData(
    name: "Burundi",
    simplifiedName: "burundi",
    isoCode: "BI",
    threeLetterCode: "BDI",
    phoneCode: "+257",
    localizedNames: {
      "ru": "Бурунди",
    },
  ),
  CountryData(
    name: "Cambodia",
    simplifiedName: "cambodia",
    isoCode: "KH",
    threeLetterCode: "KHM",
    phoneCode: "+855",
    localizedNames: {
      "ru": "Камбоджа",
    },
  ),
  CountryData(
    name: "Cameroon",
    simplifiedName: "cameroon",
    isoCode: "CM",
    threeLetterCode: "CMR",
    phoneCode: "+237",
    localizedNames: {
      "ru": "Камерун",
    },
  ),
  CountryData(
    name: "Cape Verde",
    simplifiedName: "cape verde",
    isoCode: "CV",
    threeLetterCode: "CPV",
    phoneCode: "+238",
    localizedNames: {
      "ru": "Кабо-Верде",
    },
  ),
  CountryData(
    name: "Cayman Islands",
    simplifiedName: "cayman islands",
    isoCode: "KY",
    threeLetterCode: "CYM",
    phoneCode: "+345",
    localizedNames: {
      "ru": "Каймановы острова",
    },
  ),
  CountryData(
    name: "Central African Republic",
    simplifiedName: "central african republic",
    isoCode: "CF",
    threeLetterCode: "CAF",
    phoneCode: "+236",
    localizedNames: {
      "ru": "Центральноафриканская Республика",
    },
  ),
  CountryData(
    name: "Chad",
    simplifiedName: "chad",
    isoCode: "TD",
    threeLetterCode: "TCD",
    phoneCode: "+235",
    localizedNames: {
      "ru": "Чад",
    },
  ),
  CountryData(
    name: "Chile",
    simplifiedName: "chile",
    isoCode: "CL",
    threeLetterCode: "CHL",
    phoneCode: "+56",
    localizedNames: {
      "ru": "Чили",
    },
  ),
  CountryData(
    name: "China",
    simplifiedName: "china",
    isoCode: "CN",
    threeLetterCode: "CHN",
    phoneCode: "+86",
    localizedNames: {
      "ru": "Китай",
    },
  ),
  CountryData(
    name: "Hong Kong, SAR China",
    simplifiedName: "hong kong, sar china",
    isoCode: "HK",
    threeLetterCode: "HKG",
    phoneCode: "+852",
    localizedNames: {
      "ru": "Гонконг",
    },
  ),
  CountryData(
    name: "Macao, SAR China",
    simplifiedName: "macao, sar china",
    isoCode: "MO",
    threeLetterCode: "MAC",
    phoneCode: "+853",
    localizedNames: {
      "ru": "Макао",
    },
  ),
  CountryData(
    name: "Christmas Island",
    simplifiedName: "christmas island",
    isoCode: "CX",
    threeLetterCode: "CXR",
    phoneCode: "+61",
    localizedNames: {
      "ru": "Остров Рождества",
    },
  ),
  CountryData(
    name: "Cocos (Keeling) Islands",
    simplifiedName: "cocos (keeling) islands",
    isoCode: "CC",
    threeLetterCode: "CCK",
    phoneCode: "+61",
    localizedNames: {
      "ru": "Кокосовые (Килинг) острова",
    },
  ),
  CountryData(
    name: "Colombia",
    simplifiedName: "colombia",
    isoCode: "CO",
    threeLetterCode: "COL",
    phoneCode: "+57",
    localizedNames: {
      "ru": "Колумбия",
    },
  ),
  CountryData(
    name: "Comoros",
    simplifiedName: "comoros",
    isoCode: "KM",
    threeLetterCode: "COM",
    phoneCode: "+269",
    localizedNames: {
      "ru": "Коморские острова",
    },
  ),
  CountryData(
    name: "Congo (Brazzaville)",
    simplifiedName: "congo (brazzaville)",
    isoCode: "CG",
    threeLetterCode: "COG",
    phoneCode: "+242",
    localizedNames: {
      "ru": "Конго",
    },
  ),
  CountryData(
    name: "Congo, (Kinshasa)",
    simplifiedName: "congo, (kinshasa)",
    isoCode: "CD",
    threeLetterCode: "COD",
    phoneCode: "+243",
    localizedNames: {
      "ru": "Конго, Демократическая Республика",
    },
  ),
  CountryData(
    name: "Cook Islands",
    simplifiedName: "cook islands",
    isoCode: "CK",
    threeLetterCode: "COK",
    phoneCode: "+682",
    localizedNames: {
      "ru": "Острова Кука",
    },
  ),
  CountryData(
    name: "Costa Rica",
    simplifiedName: "costa rica",
    isoCode: "CR",
    threeLetterCode: "CRI",
    phoneCode: "+506",
    localizedNames: {
      "ru": "Коста-Рика",
    },
  ),
  CountryData(
    name: "Côte d'Ivoire",
    simplifiedName: "cote d'ivoire",
    isoCode: "CI",
    threeLetterCode: "CIV",
    phoneCode: "+225",
    localizedNames: {
      "ru": "Кот-д'Ивуара",
    },
  ),
  CountryData(
    name: "Croatia",
    simplifiedName: "croatia",
    isoCode: "HR",
    threeLetterCode: "HRV",
    phoneCode: "+385",
    localizedNames: {
      "ru": "Хорватия",
    },
  ),
  CountryData(
    name: "Cuba",
    simplifiedName: "cuba",
    isoCode: "CU",
    threeLetterCode: "CUB",
    phoneCode: "+53",
    localizedNames: {
      "ru": "Куба",
    },
  ),
  CountryData(
    name: "Cyprus",
    simplifiedName: "cyprus",
    isoCode: "CY",
    threeLetterCode: "CYP",
    phoneCode: "+357",
    localizedNames: {
      "ru": "Кипр",
    },
  ),
  CountryData(
    name: "Djibouti",
    simplifiedName: "djibouti",
    isoCode: "DJ",
    threeLetterCode: "DJI",
    phoneCode: "+253",
    localizedNames: {
      "ru": "Джибути",
    },
  ),
  CountryData(
    name: "Dominica",
    simplifiedName: "dominica",
    isoCode: "DM",
    threeLetterCode: "DMA",
    phoneCode: "+1767",
    localizedNames: {
      "ru": "Доминика",
    },
  ),
  CountryData(
    name: "Dominican Republic",
    simplifiedName: "dominican republic",
    isoCode: "DO",
    threeLetterCode: "DOM",
    phoneCode: "+1809",
    localizedNames: {
      "ru": "Доминиканская Республика",
    },
  ),
  CountryData(
    name: "Ecuador",
    simplifiedName: "ecuador",
    isoCode: "EC",
    threeLetterCode: "ECU",
    phoneCode: "+593",
    localizedNames: {
      "ru": "Эквадор",
    },
  ),
  CountryData(
    name: "Egypt",
    simplifiedName: "egypt",
    isoCode: "EG",
    threeLetterCode: "EGY",
    phoneCode: "+20",
    localizedNames: {
      "ru": "Египет",
    },
  ),
  CountryData(
    name: "El Salvador",
    simplifiedName: "el salvador",
    isoCode: "SV",
    threeLetterCode: "SLV",
    phoneCode: "+503",
    localizedNames: {
      "ru": "Сальвадор",
    },
  ),
  CountryData(
    name: "Equatorial Guinea",
    simplifiedName: "equatorial guinea",
    isoCode: "GQ",
    threeLetterCode: "GNQ",
    phoneCode: "+240",
    localizedNames: {
      "ru": "Экваториальная Гвинея",
    },
  ),
  CountryData(
    name: "Eritrea",
    simplifiedName: "eritrea",
    isoCode: "ER",
    threeLetterCode: "ERI",
    phoneCode: "+291",
    localizedNames: {
      "ru": "Эритрея",
    },
  ),
  CountryData(
    name: "Estonia",
    simplifiedName: "estonia",
    isoCode: "EE",
    threeLetterCode: "EST",
    phoneCode: "+372",
    localizedNames: {
      "ru": "Эстония",
    },
  ),
  CountryData(
    name: "Ethiopia",
    simplifiedName: "ethiopia",
    isoCode: "ET",
    threeLetterCode: "ETH",
    phoneCode: "+251",
    localizedNames: {
      "ru": "Эфиопия",
    },
  ),
  CountryData(
    name: "Falkland Islands (Malvinas)",
    simplifiedName: "falkland islands (malvinas)",
    isoCode: "FK",
    threeLetterCode: "FLK",
    phoneCode: "+500",
    localizedNames: {
      "ru": "Фолклендские (Мальвинские) острова",
    },
  ),
  CountryData(
    name: "Faroe Islands",
    simplifiedName: "faroe islands",
    isoCode: "FO",
    threeLetterCode: "FRO",
    phoneCode: "+298",
    localizedNames: {
      "ru": "Фарерские острова",
    },
  ),
  CountryData(
    name: "Fiji",
    simplifiedName: "fiji",
    isoCode: "FJ",
    threeLetterCode: "FJI",
    phoneCode: "+679",
    localizedNames: {
      "ru": "Фиджи",
    },
  ),
  CountryData(
    name: "French Guiana",
    simplifiedName: "french guiana",
    isoCode: "GF",
    threeLetterCode: "GUF",
    phoneCode: "+594",
    localizedNames: {
      "ru": "Французская Гвиана",
    },
  ),
  CountryData(
    name: "French Polynesia",
    simplifiedName: "french polynesia",
    isoCode: "PF",
    threeLetterCode: "PYF",
    phoneCode: "+689",
    localizedNames: {
      "ru": "Французская Полинезия",
    },
  ),
  CountryData(
    name: "Gabon",
    simplifiedName: "gabon",
    isoCode: "GA",
    threeLetterCode: "GAB",
    phoneCode: "+241",
    localizedNames: {
      "ru": "Габон",
    },
  ),
  CountryData(
    name: "Gambia",
    simplifiedName: "gambia",
    isoCode: "GM",
    threeLetterCode: "GMB",
    phoneCode: "+220",
    localizedNames: {
      "ru": "Гамбия",
    },
  ),
  CountryData(
    name: "Georgia",
    simplifiedName: "georgia",
    isoCode: "GE",
    threeLetterCode: "GEO",
    phoneCode: "+995",
    localizedNames: {
      "ru": "Грузия",
    },
  ),
  CountryData(
    name: "Ghana",
    simplifiedName: "ghana",
    isoCode: "GH",
    threeLetterCode: "GHA",
    phoneCode: "+233",
    localizedNames: {
      "ru": "Гана",
    },
  ),
  CountryData(
    name: "Gibraltar",
    simplifiedName: "gibraltar",
    isoCode: "GI",
    threeLetterCode: "GIB",
    phoneCode: "+350",
    localizedNames: {
      "ru": "Гибралтар",
    },
  ),
  CountryData(
    name: "Greenland",
    simplifiedName: "greenland",
    isoCode: "GL",
    threeLetterCode: "GRL",
    phoneCode: "+299",
    localizedNames: {
      "ru": "Гренландия",
    },
  ),
  CountryData(
    name: "Grenada",
    simplifiedName: "grenada",
    isoCode: "GD",
    threeLetterCode: "GRD",
    phoneCode: "+1473",
    localizedNames: {
      "ru": "Гренада",
    },
  ),
  CountryData(
    name: "Guadeloupe",
    simplifiedName: "guadeloupe",
    isoCode: "GP",
    threeLetterCode: "GLP",
    phoneCode: "+590",
    localizedNames: {
      "ru": "Гваделупа",
    },
  ),
  CountryData(
    name: "Guam",
    simplifiedName: "guam",
    isoCode: "GU",
    threeLetterCode: "GUM",
    phoneCode: "+1671",
    localizedNames: {
      "ru": "Гуам",
    },
  ),
  CountryData(
    name: "Guatemala",
    simplifiedName: "guatemala",
    isoCode: "GT",
    threeLetterCode: "GTM",
    phoneCode: "+502",
    localizedNames: {
      "ru": "Гватемала",
    },
  ),
  CountryData(
    name: "Guernsey",
    simplifiedName: "guernsey",
    isoCode: "GG",
    threeLetterCode: "GGY",
    phoneCode: "+44",
    localizedNames: {
      "ru": "Гернси",
    },
  ),
  CountryData(
    name: "Guinea",
    simplifiedName: "guinea",
    isoCode: "GN",
    threeLetterCode: "GIN",
    phoneCode: "+224",
    localizedNames: {
      "ru": "Гвинея",
    },
  ),
  CountryData(
    name: "Guinea-Bissau",
    simplifiedName: "guinea-bissau",
    isoCode: "GW",
    threeLetterCode: "GNB",
    phoneCode: "+245",
    localizedNames: {
      "ru": "Гвинея-Бисау",
    },
  ),
  CountryData(
    name: "Guyana",
    simplifiedName: "guyana",
    isoCode: "GY",
    threeLetterCode: "GUY",
    phoneCode: "+592",
    localizedNames: {
      "ru": "Гайана",
    },
  ),
  CountryData(
    name: "Haiti",
    simplifiedName: "haiti",
    isoCode: "HT",
    threeLetterCode: "HTI",
    phoneCode: "+509",
    localizedNames: {
      "ru": "Гаити",
    },
  ),
  CountryData(
    name: "Honduras",
    simplifiedName: "honduras",
    isoCode: "HN",
    threeLetterCode: "HND",
    phoneCode: "+504",
    localizedNames: {
      "ru": "Гондурас",
    },
  ),
  CountryData(
    name: "Hungary",
    simplifiedName: "hungary",
    isoCode: "HU",
    threeLetterCode: "HUN",
    phoneCode: "+36",
    localizedNames: {
      "ru": "Венгрия",
    },
  ),
  CountryData(
    name: "India",
    simplifiedName: "india",
    isoCode: "IN",
    threeLetterCode: "IND",
    phoneCode: "+91",
    localizedNames: {
      "ru": "Индия",
    },
  ),
  CountryData(
    name: "Indonesia",
    simplifiedName: "indonesia",
    isoCode: "ID",
    threeLetterCode: "IDN",
    phoneCode: "+62",
    localizedNames: {
      "ru": "Индонезия",
    },
  ),
  CountryData(
    name: "Iran, Islamic Republic of",
    simplifiedName: "iran, islamic republic of",
    isoCode: "IR",
    threeLetterCode: "IRN",
    phoneCode: "+98",
    localizedNames: {
      "ru": "Иран, Исламская Республика",
    },
  ),
  CountryData(
    name: "Iraq",
    simplifiedName: "iraq",
    isoCode: "IQ",
    threeLetterCode: "IRQ",
    phoneCode: "+964",
    localizedNames: {
      "ru": "Ирак",
    },
  ),
  CountryData(
    name: "Israel",
    simplifiedName: "israel",
    isoCode: "IL",
    threeLetterCode: "ISR",
    phoneCode: "+972",
    localizedNames: {
      "ru": "Израиль",
    },
  ),
  CountryData(
    name: "Jamaica",
    simplifiedName: "jamaica",
    isoCode: "JM",
    threeLetterCode: "JAM",
    phoneCode: "+1876",
    localizedNames: {
      "ru": "Ямайка",
    },
  ),
  CountryData(
    name: "Japan",
    simplifiedName: "japan",
    isoCode: "JP",
    threeLetterCode: "JPN",
    phoneCode: "+81",
    localizedNames: {
      "ru": "Япония",
    },
  ),
  CountryData(
    name: "Jordan",
    simplifiedName: "jordan",
    isoCode: "JO",
    threeLetterCode: "JOR",
    phoneCode: "+962",
    localizedNames: {
      "ru": "Джордан",
    },
  ),
  CountryData(
    name: "Kazakhstan",
    simplifiedName: "kazakhstan",
    isoCode: "KZ",
    threeLetterCode: "KAZ",
    phoneCode: "+77",
    localizedNames: {
      "ru": "Казахстан",
    },
  ),
  CountryData(
    name: "Kenya",
    simplifiedName: "kenya",
    isoCode: "KE",
    threeLetterCode: "KEN",
    phoneCode: "+254",
    localizedNames: {
      "ru": "Кения",
    },
  ),
  CountryData(
    name: "Kiribati",
    simplifiedName: "kiribati",
    isoCode: "KI",
    threeLetterCode: "KIR",
    phoneCode: "+686",
    localizedNames: {
      "ru": "Кирибати",
    },
  ),
  CountryData(
    name: "Korea (North)",
    simplifiedName: "korea (north)",
    isoCode: "KP",
    threeLetterCode: "PRK",
    phoneCode: "+850",
    localizedNames: {
      "ru": "Корея, Народно-Демократическая Республика",
    },
  ),
  CountryData(
    name: "Korea (South)",
    simplifiedName: "korea (south)",
    isoCode: "KR",
    threeLetterCode: "KOR",
    phoneCode: "+82",
    localizedNames: {
      "ru": "Корея, Республика",
    },
  ),
  CountryData(
    name: "Kuwait",
    simplifiedName: "kuwait",
    isoCode: "KW",
    threeLetterCode: "KWT",
    phoneCode: "+965",
    localizedNames: {
      "ru": "Кувейт",
    },
  ),
  CountryData(
    name: "Kyrgyzstan",
    simplifiedName: "kyrgyzstan",
    isoCode: "KG",
    threeLetterCode: "KGZ",
    phoneCode: "+996",
    localizedNames: {
      "ru": "Кыргызстан",
    },
  ),
  CountryData(
    name: "Lao PDR",
    simplifiedName: "lao pdr",
    isoCode: "LA",
    threeLetterCode: "LAO",
    phoneCode: "+856",
    localizedNames: {
      "ru": "(Лаос) Лаосская Народно-Демократическая Республика",
    },
  ),
  CountryData(
    name: "Lebanon",
    simplifiedName: "lebanon",
    isoCode: "LB",
    threeLetterCode: "LBN",
    phoneCode: "+961",
    localizedNames: {
      "ru": "Ливан",
    },
  ),
  CountryData(
    name: "Lesotho",
    simplifiedName: "lesotho",
    isoCode: "LS",
    threeLetterCode: "LSO",
    phoneCode: "+266",
    localizedNames: {
      "ru": "Лесото",
    },
  ),
  CountryData(
    name: "Liberia",
    simplifiedName: "liberia",
    isoCode: "LR",
    threeLetterCode: "LBR",
    phoneCode: "+231",
    localizedNames: {
      "ru": "Либерия",
    },
  ),
  CountryData(
    name: "Libya",
    simplifiedName: "libya",
    isoCode: "LY",
    threeLetterCode: "LBY",
    phoneCode: "+218",
    localizedNames: {
      "ru": "Ливийская Арабская Джамахирия",
    },
  ),
  CountryData(
    name: "Liechtenstein",
    simplifiedName: "liechtenstein",
    isoCode: "LI",
    threeLetterCode: "LIE",
    phoneCode: "+423",
    localizedNames: {
      "ru": "Лихтенштейн",
    },
  ),
  CountryData(
    name: "Lithuania",
    simplifiedName: "lithuania",
    isoCode: "LT",
    threeLetterCode: "LTU",
    phoneCode: "+370",
    localizedNames: {
      "ru": "Литва",
    },
  ),
  CountryData(
    name: "Macedonia, Republic of",
    simplifiedName: "macedonia, republic of",
    isoCode: "MK",
    threeLetterCode: "MKD",
    phoneCode: "+389",
    localizedNames: {
      "ru": "Македония",
    },
  ),
  CountryData(
    name: "Madagascar",
    simplifiedName: "madagascar",
    isoCode: "MG",
    threeLetterCode: "MDG",
    phoneCode: "+261",
    localizedNames: {
      "ru": "Мадакаскар",
    },
  ),
  CountryData(
    name: "Malawi",
    simplifiedName: "malawi",
    isoCode: "MW",
    threeLetterCode: "MWI",
    phoneCode: "+265",
    localizedNames: {
      "ru": "Малави",
    },
  ),
  CountryData(
    name: "Malaysia",
    simplifiedName: "malaysia",
    isoCode: "MY",
    threeLetterCode: "MYS",
    phoneCode: "+60",
    localizedNames: {
      "ru": "Малазия",
    },
  ),
  CountryData(
    name: "Maldives",
    simplifiedName: "maldives",
    isoCode: "MV",
    threeLetterCode: "MDV",
    phoneCode: "+960",
    localizedNames: {
      "ru": "Мальдивы",
    },
  ),
  CountryData(
    name: "Mali",
    simplifiedName: "mali",
    isoCode: "ML",
    threeLetterCode: "MLI",
    phoneCode: "+223",
    localizedNames: {
      "ru": "Мали",
    },
  ),
  CountryData(
    name: "Marshall Islands",
    simplifiedName: "marshall islands",
    isoCode: "MH",
    threeLetterCode: "MHL",
    phoneCode: "+692",
    localizedNames: {
      "ru": "Маршаловы острова",
    },
  ),
  CountryData(
    name: "Martinique",
    simplifiedName: "martinique",
    isoCode: "MQ",
    threeLetterCode: "MTQ",
    phoneCode: "+596",
    localizedNames: {
      "ru": "Мартиника",
    },
  ),
  CountryData(
    name: "Mauritania",
    simplifiedName: "mauritania",
    isoCode: "MR",
    threeLetterCode: "MRT",
    phoneCode: "+222",
    localizedNames: {
      "ru": "Мавритания",
    },
  ),
  CountryData(
    name: "Mauritius",
    simplifiedName: "mauritius",
    isoCode: "MU",
    threeLetterCode: "MUS",
    phoneCode: "+230",
    localizedNames: {
      "ru": "Маврикий",
    },
  ),
  CountryData(
    name: "Mayotte",
    simplifiedName: "mayotte",
    isoCode: "YT",
    threeLetterCode: "MYT",
    phoneCode: "+262",
    localizedNames: {
      "ru": "Майотта",
    },
  ),
  CountryData(
    name: "Mexico",
    simplifiedName: "mexico",
    isoCode: "MX",
    threeLetterCode: "MEX",
    phoneCode: "+52",
    localizedNames: {
      "ru": "Мехико",
    },
  ),
  CountryData(
    name: "Micronesia, Federated States of",
    simplifiedName: "micronesia, federated states of",
    isoCode: "FM",
    threeLetterCode: "FSM",
    phoneCode: "+691",
    localizedNames: {
      "ru": "Микронезия, Федеративные Штаты",
    },
  ),
  CountryData(
    name: "Moldova",
    simplifiedName: "moldova",
    isoCode: "MD",
    threeLetterCode: "MDA",
    phoneCode: "+373",
    localizedNames: {
      "ru": "Молдова, Республика",
    },
  ),
  CountryData(
    name: "Monaco",
    simplifiedName: "monaco",
    isoCode: "MC",
    threeLetterCode: "MCO",
    phoneCode: "+377",
    localizedNames: {
      "ru": "Монако",
    },
  ),
  CountryData(
    name: "Mongolia",
    simplifiedName: "mongolia",
    isoCode: "MN",
    threeLetterCode: "MNG",
    phoneCode: "+976",
    localizedNames: {
      "ru": "Монголия",
    },
  ),
  CountryData(
    name: "Montenegro",
    simplifiedName: "montenegro",
    isoCode: "ME",
    threeLetterCode: "MNE",
    phoneCode: "+382",
    localizedNames: {
      "ru": "Черногория",
    },
  ),
  CountryData(
    name: "Montserrat",
    simplifiedName: "montserrat",
    isoCode: "MS",
    threeLetterCode: "MSR",
    phoneCode: "+1664",
    localizedNames: {
      "ru": "Монтсеррат",
    },
  ),
  CountryData(
    name: "Morocco",
    simplifiedName: "morocco",
    isoCode: "MA",
    threeLetterCode: "MAR",
    phoneCode: "+212",
    localizedNames: {
      "ru": "Марокко",
    },
  ),
  CountryData(
    name: "Mozambique",
    simplifiedName: "mozambique",
    isoCode: "MZ",
    threeLetterCode: "MOZ",
    phoneCode: "+258",
    localizedNames: {
      "ru": "Мозамбик",
    },
  ),
  CountryData(
    name: "Myanmar",
    simplifiedName: "myanmar",
    isoCode: "MM",
    threeLetterCode: "MMR",
    phoneCode: "+95",
    localizedNames: {
      "ru": "Мьянма",
    },
  ),
  CountryData(
    name: "Namibia",
    simplifiedName: "namibia",
    isoCode: "NA",
    threeLetterCode: "NAM",
    phoneCode: "+264",
    localizedNames: {
      "ru": "Намибиа",
    },
  ),
  CountryData(
    name: "Nauru",
    simplifiedName: "nauru",
    isoCode: "NR",
    threeLetterCode: "NRU",
    phoneCode: "+674",
    localizedNames: {
      "ru": "Науру",
    },
  ),
  CountryData(
    name: "Nepal",
    simplifiedName: "nepal",
    isoCode: "NP",
    threeLetterCode: "NPL",
    phoneCode: "+977",
    localizedNames: {
      "ru": "Непал",
    },
  ),
  CountryData(
    name: "Netherlands Antilles",
    simplifiedName: "netherlands antilles",
    isoCode: "AN",
    threeLetterCode: "ANT",
    phoneCode: "+599",
    localizedNames: {
      "ru": "Нидерландские Антильские острова",
    },
  ),
  CountryData(
    name: "New Caledonia",
    simplifiedName: "new caledonia",
    isoCode: "NC",
    threeLetterCode: "NCL",
    phoneCode: "+687",
    localizedNames: {
      "ru": "Новая Каледония",
    },
  ),
  CountryData(
    name: "New Zealand",
    simplifiedName: "new zealand",
    isoCode: "NZ",
    threeLetterCode: "NZL",
    phoneCode: "+64",
    localizedNames: {
      "ru": "Новая Зеландия",
    },
  ),
  CountryData(
    name: "Nicaragua",
    simplifiedName: "nicaragua",
    isoCode: "NI",
    threeLetterCode: "NIC",
    phoneCode: "+505",
    localizedNames: {
      "ru": "Никарагуа",
    },
  ),
  CountryData(
    name: "Niger",
    simplifiedName: "niger",
    isoCode: "NE",
    threeLetterCode: "NER",
    phoneCode: "+227",
    localizedNames: {
      "ru": "Нигер",
    },
  ),
  CountryData(
    name: "Nigeria",
    simplifiedName: "nigeria",
    isoCode: "NG",
    threeLetterCode: "NGA",
    phoneCode: "+234",
    localizedNames: {
      "ru": "Нигерия",
    },
  ),
  CountryData(
    name: "Niue",
    simplifiedName: "niue",
    isoCode: "NU",
    threeLetterCode: "NIU",
    phoneCode: "+683",
    localizedNames: {
      "ru": "Ниуэ",
    },
  ),
  CountryData(
    name: "Norfolk Island",
    simplifiedName: "norfolk island",
    isoCode: "NF",
    threeLetterCode: "NFK",
    phoneCode: "+672",
    localizedNames: {
      "ru": "Остров Норфолк",
    },
  ),
  CountryData(
    name: "Northern Mariana Islands",
    simplifiedName: "northern mariana islands",
    isoCode: "MP",
    threeLetterCode: "MNP",
    phoneCode: "+1670",
    localizedNames: {
      "ru": "Северные Марианские острова",
    },
  ),
  CountryData(
    name: "Oman",
    simplifiedName: "oman",
    isoCode: "OM",
    threeLetterCode: "OMN",
    phoneCode: "+968",
    localizedNames: {
      "ru": "Оман",
    },
  ),
  CountryData(
    name: "Pakistan",
    simplifiedName: "pakistan",
    isoCode: "PK",
    threeLetterCode: "PAK",
    phoneCode: "+92",
    localizedNames: {
      "ru": "Пакистан",
    },
  ),
  CountryData(
    name: "Palau",
    simplifiedName: "palau",
    isoCode: "PW",
    threeLetterCode: "PLW",
    phoneCode: "+680",
    localizedNames: {
      "ru": "Палау",
    },
  ),
  CountryData(
    name: "Palestinian Territory",
    simplifiedName: "palestinian territory",
    isoCode: "PS",
    threeLetterCode: "PSE",
    phoneCode: "+970",
    localizedNames: {
      "ru": "Палестина",
    },
  ),
  CountryData(
    name: "Panama",
    simplifiedName: "panama",
    isoCode: "PA",
    threeLetterCode: "PAN",
    phoneCode: "+507",
    localizedNames: {
      "ru": "Панама",
    },
  ),
  CountryData(
    name: "Papua New Guinea",
    simplifiedName: "papua new guinea",
    isoCode: "PG",
    threeLetterCode: "PNG",
    phoneCode: "+675",
    localizedNames: {
      "ru": "Папуа-Новая Гвинея",
    },
  ),
  CountryData(
    name: "Paraguay",
    simplifiedName: "paraguay",
    isoCode: "PY",
    threeLetterCode: "PRY",
    phoneCode: "+595",
    localizedNames: {
      "ru": "Парагвай",
    },
  ),
  CountryData(
    name: "Peru",
    simplifiedName: "peru",
    isoCode: "PE",
    threeLetterCode: "PER",
    phoneCode: "+51",
    localizedNames: {
      "ru": "Перу",
    },
  ),
  CountryData(
    name: "Philippines",
    simplifiedName: "philippines",
    isoCode: "PH",
    threeLetterCode: "PHL",
    phoneCode: "+63",
    localizedNames: {
      "ru": "Филипины",
    },
  ),
  CountryData(
    name: "Pitcairn",
    simplifiedName: "pitcairn",
    isoCode: "PN",
    threeLetterCode: "PCN",
    phoneCode: "+64",
    localizedNames: {
      "ru": "Питкэрн",
    },
  ),
  CountryData(
    name: "Puerto Rico",
    simplifiedName: "puerto rico",
    isoCode: "PR",
    threeLetterCode: "PRI",
    phoneCode: "+1939",
    localizedNames: {
      "ru": "Пуэрто-Рико",
    },
  ),
  CountryData(
    name: "Qatar",
    simplifiedName: "qatar",
    isoCode: "QA",
    threeLetterCode: "QAT",
    phoneCode: "+974",
    localizedNames: {
      "ru": "Катар",
    },
  ),
  CountryData(
    name: "Réunion",
    simplifiedName: "reunion",
    isoCode: "RE",
    threeLetterCode: "REU",
    phoneCode: "+262",
    localizedNames: {
      "ru": "Реюньон",
    },
  ),
  CountryData(
    name: "Russian Federation",
    simplifiedName: "russian federation",
    isoCode: "RU",
    threeLetterCode: "RUS",
    phoneCode: "+7",
    localizedNames: {
      "ru": "Россия",
    },
  ),
  CountryData(
    name: "Rwanda",
    simplifiedName: "rwanda",
    isoCode: "RW",
    threeLetterCode: "RWA",
    phoneCode: "+250",
    localizedNames: {
      "ru": "Руанда",
    },
  ),
  CountryData(
    name: "Saint-Barthélemy",
    simplifiedName: "saint-barthelemy",
    isoCode: "BL",
    threeLetterCode: "BLM",
    phoneCode: "+590",
    localizedNames: {
      "ru": "Сен-Бартелеми",
    },
  ),
  CountryData(
    name: "Saint Helena",
    simplifiedName: "saint helena",
    isoCode: "SH",
    threeLetterCode: "SHN",
    phoneCode: "+290",
    localizedNames: {
      "ru": "Святой Елены, Вознесения и Тристан-да-Кунья",
    },
  ),
  CountryData(
    name: "Saint Kitts and Nevis",
    simplifiedName: "saint kitts and nevis",
    isoCode: "KN",
    threeLetterCode: "KNA",
    phoneCode: "+1869",
    localizedNames: {
      "ru": "Сент-Китс и Невис",
    },
  ),
  CountryData(
    name: "Saint Lucia",
    simplifiedName: "saint lucia",
    isoCode: "LC",
    threeLetterCode: "LCA",
    phoneCode: "+1758",
    localizedNames: {
      "ru": "Сент-Люсия",
    },
  ),
  CountryData(
    name: "Saint-Martin (French part)",
    simplifiedName: "saint-martin (french part)",
    isoCode: "MF",
    threeLetterCode: "MAF",
    phoneCode: "+590",
    localizedNames: {
      "ru": "Сен-Мартен",
    },
  ),
  CountryData(
    name: "Saint Pierre and Miquelon",
    simplifiedName: "saint pierre and miquelon",
    isoCode: "PM",
    threeLetterCode: "SPM",
    phoneCode: "+508",
    localizedNames: {
      "ru": "Сен-Пьер и Микелон",
    },
  ),
  CountryData(
    name: "Saint Vincent and Grenadines",
    simplifiedName: "saint vincent and grenadines",
    isoCode: "VC",
    threeLetterCode: "VCT",
    phoneCode: "+1784",
    localizedNames: {
      "ru": "Сент-Винсент и Гренадины",
    },
  ),
  CountryData(
    name: "Samoa",
    simplifiedName: "samoa",
    isoCode: "WS",
    threeLetterCode: "WSM",
    phoneCode: "+685",
    localizedNames: {
      "ru": "Самоа",
    },
  ),
  CountryData(
    name: "San Marino",
    simplifiedName: "san marino",
    isoCode: "SM",
    threeLetterCode: "SMR",
    phoneCode: "+378",
    localizedNames: {
      "ru": "Сан-Марино",
    },
  ),
  CountryData(
    name: "Sao Tome and Principe",
    simplifiedName: "sao tome and principe",
    isoCode: "ST",
    threeLetterCode: "STP",
    phoneCode: "+239",
    localizedNames: {
      "ru": "Сент-Винсент и Гренадины",
    },
  ),
  CountryData(
    name: "Saudi Arabia",
    simplifiedName: "saudi arabia",
    isoCode: "SA",
    threeLetterCode: "SAU",
    phoneCode: "+966",
    localizedNames: {
      "ru": "Саудовская Аравия",
    },
  ),
  CountryData(
    name: "Senegal",
    simplifiedName: "senegal",
    isoCode: "SN",
    threeLetterCode: "SEN",
    phoneCode: "+221",
    localizedNames: {
      "ru": "Сенегал",
    },
  ),
  CountryData(
    name: "Serbia",
    simplifiedName: "serbia",
    isoCode: "RS",
    threeLetterCode: "SRB",
    phoneCode: "+381",
    localizedNames: {
      "ru": "Сербия",
    },
  ),
  CountryData(
    name: "Seychelles",
    simplifiedName: "seychelles",
    isoCode: "SC",
    threeLetterCode: "SYC",
    phoneCode: "+248",
    localizedNames: {
      "ru": "Сейшельские острова",
    },
  ),
  CountryData(
    name: "Sierra Leone",
    simplifiedName: "sierra leone",
    isoCode: "SL",
    threeLetterCode: "SLE",
    phoneCode: "+232",
    localizedNames: {
      "ru": "Сьерра-Леоне",
    },
  ),
  CountryData(
    name: "Singapore",
    simplifiedName: "singapore",
    isoCode: "SG",
    threeLetterCode: "SGP",
    phoneCode: "+65",
    localizedNames: {
      "ru": "Сингапур",
    },
  ),
  CountryData(
    name: "Slovenia",
    simplifiedName: "slovenia",
    isoCode: "SI",
    threeLetterCode: "SVN",
    phoneCode: "+386",
    localizedNames: {
      "ru": "Словения",
    },
  ),
  CountryData(
    name: "Solomon Islands",
    simplifiedName: "solomon islands",
    isoCode: "SB",
    threeLetterCode: "SLB",
    phoneCode: "+677",
    localizedNames: {
      "ru": "Соломоновы острова",
    },
  ),
  CountryData(
    name: "Somalia",
    simplifiedName: "somalia",
    isoCode: "SO",
    threeLetterCode: "SOM",
    phoneCode: "+252",
    localizedNames: {
      "ru": "Сомали",
    },
  ),
  CountryData(
    name: "South Africa",
    simplifiedName: "south africa",
    isoCode: "ZA",
    threeLetterCode: "ZAF",
    phoneCode: "+27",
    localizedNames: {
      "ru": "Южная Африка",
    },
  ),
  CountryData(
    name: "South Georgia and the South Sandwich Islands",
    simplifiedName: "south georgia and the south sandwich islands",
    isoCode: "GS",
    threeLetterCode: "SGS",
    phoneCode: "+500",
    localizedNames: {
      "ru": "Южная Георгия и Южные Сандвичевы острова",
    },
  ),
  CountryData(
    name: "Sri Lanka",
    simplifiedName: "sri lanka",
    isoCode: "LK",
    threeLetterCode: "LKA",
    phoneCode: "+94",
    localizedNames: {
      "ru": "Шри-Ланка",
    },
  ),
  CountryData(
    name: "Sudan",
    simplifiedName: "sudan",
    isoCode: "SD",
    threeLetterCode: "SDN",
    phoneCode: "+249",
    localizedNames: {
      "ru": "Судан",
    },
  ),
  CountryData(
    name: "Suri'name'",
    simplifiedName: "suri'name'",
    isoCode: "SR",
    threeLetterCode: "SUR",
    phoneCode: "+597",
    localizedNames: {
      "ru": "Суринам",
    },
  ),
  CountryData(
    name: "Svalbard and Jan Mayen Islands",
    simplifiedName: "svalbard and jan mayen islands",
    isoCode: "SJ",
    threeLetterCode: "SJM",
    phoneCode: "+47",
    localizedNames: {
      "ru": "Шпицберген и Ян-Майен",
    },
  ),
  CountryData(
    name: "Swaziland",
    simplifiedName: "swaziland",
    isoCode: "SZ",
    threeLetterCode: "SWZ",
    phoneCode: "+268",
    localizedNames: {
      "ru": "Свазиленд",
    },
  ),
  CountryData(
    name: "Syrian Arab Republic (Syria)",
    simplifiedName: "syrian arab republic (syria)",
    isoCode: "SY",
    threeLetterCode: "SYR",
    phoneCode: "+963",
    localizedNames: {
      "ru": "Сирийская Арабская Республика",
    },
  ),
  CountryData(
    name: "Taiwan, Republic of China",
    simplifiedName: "taiwan, republic of china",
    isoCode: "TW",
    threeLetterCode: "TWN",
    phoneCode: "+886",
    localizedNames: {
      "ru": "Тайвань",
    },
  ),
  CountryData(
    name: "Tajikistan",
    simplifiedName: "tajikistan",
    isoCode: "TJ",
    threeLetterCode: "TJK",
    phoneCode: "+992",
    localizedNames: {
      "ru": "Таджикистан",
    },
  ),
  CountryData(
    name: "Tanzania, United Republic of",
    simplifiedName: "tanzania, united republic of",
    isoCode: "TZ",
    threeLetterCode: "TZA",
    phoneCode: "+255",
    localizedNames: {
      "ru": "Танзания",
    },
  ),
  CountryData(
    name: "Thailand",
    simplifiedName: "thailand",
    isoCode: "TH",
    threeLetterCode: "THA",
    phoneCode: "+66",
    localizedNames: {
      "ru": "Тайланд",
    },
  ),
  CountryData(
    name: "Timor-Leste",
    simplifiedName: "timor-leste",
    isoCode: "TL",
    threeLetterCode: "TLS",
    phoneCode: "+670",
    localizedNames: {
      "ru": "Тимор-Лешти",
    },
  ),
  CountryData(
    name: "Togo",
    simplifiedName: "togo",
    isoCode: "TG",
    threeLetterCode: "TGO",
    phoneCode: "+228",
    localizedNames: {
      "ru": "Того",
    },
  ),
  CountryData(
    name: "Tokelau",
    simplifiedName: "tokelau",
    isoCode: "TK",
    threeLetterCode: "TKL",
    phoneCode: "+690",
    localizedNames: {
      "ru": "Токелау",
    },
  ),
  CountryData(
    name: "Tonga",
    simplifiedName: "tonga",
    isoCode: "TO",
    threeLetterCode: "TON",
    phoneCode: "+676",
    localizedNames: {
      "ru": "Тонга",
    },
  ),
  CountryData(
    name: "Trinidad and Tobago",
    simplifiedName: "trinidad and tobago",
    isoCode: "TT",
    threeLetterCode: "TTO",
    phoneCode: "+1868",
    localizedNames: {
      "ru": "Тринидад и Тобаго",
    },
  ),
  CountryData(
    name: "Tunisia",
    simplifiedName: "tunisia",
    isoCode: "TN",
    threeLetterCode: "TUN",
    phoneCode: "+216",
    localizedNames: {
      "ru": "Тунис",
    },
  ),
  CountryData(
    name: "Turkey",
    simplifiedName: "turkey",
    isoCode: "TR",
    threeLetterCode: "TUR",
    phoneCode: "+90",
    localizedNames: {
      "ru": "Турция",
    },
  ),
  CountryData(
    name: "Turkmenistan",
    simplifiedName: "turkmenistan",
    isoCode: "TM",
    threeLetterCode: "TKM",
    phoneCode: "+993",
    localizedNames: {
      "ru": "Туркменистан",
    },
  ),
  CountryData(
    name: "Turks and Caicos Islands",
    simplifiedName: "turks and caicos islands",
    isoCode: "TC",
    threeLetterCode: "TCA",
    phoneCode: "+1649",
    localizedNames: {
      "ru": "Острова Теркс и Кайкос",
    },
  ),
  CountryData(
    name: "Tuvalu",
    simplifiedName: "tuvalu",
    isoCode: "TV",
    threeLetterCode: "TUV",
    phoneCode: "+688",
    localizedNames: {
      "ru": "Тувалу",
    },
  ),
  CountryData(
    name: "Uganda",
    simplifiedName: "uganda",
    isoCode: "UG",
    threeLetterCode: "UGA",
    phoneCode: "+256",
    localizedNames: {
      "ru": "Уганда",
    },
  ),
  CountryData(
    name: "Ukraine",
    simplifiedName: "ukraine",
    isoCode: "UA",
    threeLetterCode: "UKR",
    phoneCode: "+380",
    localizedNames: {
      "ru": "Украина",
    },
  ),
  CountryData(
    name: "United Arab Emirates",
    simplifiedName: "united arab emirates",
    isoCode: "AE",
    threeLetterCode: "ARE",
    phoneCode: "+971",
    localizedNames: {
      "ru": "Объединенные Арабские Эмираты",
    },
  ),
  CountryData(
    name: "Uruguay",
    simplifiedName: "uruguay",
    isoCode: "UY",
    threeLetterCode: "URY",
    phoneCode: "+598",
    localizedNames: {
      "ru": "Уругвай",
    },
  ),
  CountryData(
    name: "Uzbekistan",
    simplifiedName: "uzbekistan",
    isoCode: "UZ",
    threeLetterCode: "UZB",
    phoneCode: "+998",
    localizedNames: {
      "ru": "Узбекистан",
    },
  ),
  CountryData(
    name: "Vanuatu",
    simplifiedName: "vanuatu",
    isoCode: "VU",
    threeLetterCode: "VUT",
    phoneCode: "+678",
    localizedNames: {
      "ru": "Вануату",
    },
  ),
  CountryData(
    name: "Venezuela (Bolivarian Republic)",
    simplifiedName: "venezuela (bolivarian republic)",
    isoCode: "VE",
    threeLetterCode: "VEN",
    phoneCode: "+58",
    localizedNames: {
      "ru": "Венесуэла, Боливарианская Республика",
    },
  ),
  CountryData(
    name: "Virgin Islands, US",
    simplifiedName: "virgin islands, us",
    isoCode: "VI",
    threeLetterCode: "VIR",
    phoneCode: "+1340",
    localizedNames: {
      "ru": "Виргинские острова, США",
    },
  ),
  CountryData(
    name: "Wallis and Futuna Islands",
    simplifiedName: "wallis and futuna islands",
    isoCode: "WF",
    threeLetterCode: "WLF",
    phoneCode: "+681",
    localizedNames: {
      "ru": "Уоллис и Футуна",
    },
  ),
  CountryData(
    name: "Yemen",
    simplifiedName: "yemen",
    isoCode: "YE",
    threeLetterCode: "YEM",
    phoneCode: "+967",
    localizedNames: {
      "ru": "Йемен",
    },
  ),
  CountryData(
    name: "Zambia",
    simplifiedName: "zambia",
    isoCode: "ZM",
    threeLetterCode: "ZMB",
    phoneCode: "+260",
    localizedNames: {
      "ru": "Замбия",
    },
  ),
  CountryData(
    name: "Zimbabwe",
    simplifiedName: "zimbabwe",
    isoCode: "ZW",
    threeLetterCode: "ZWE",
    phoneCode: "+263",
    localizedNames: {
      "ru": "Зибваве",
    },
  ),
];
