import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mm_exam/data/region_model.dart';
import 'package:mm_exam/data/year_model.dart';

// Import your models
// import 'region_model.dart';
// import 'year_model.dart';

class ApiService {
  static const String _baseUrl = 'your-api-endpoint-here';

  /// Mock data from your JSON
  static const String _mockJsonData = '''[
  {
    "year": 2024,
    "regions": [
      { "name": "ရန်ကုန်တိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/ygn.html" },
      { "name": "မန္တလေးတိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/mdy.html" },
      { "name": "နေပြည်တော်", "link": "https://2024.myanmarexam.org/npw.html" },
      { "name": "ဧရာဝတီတိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/ayy.html" },
      { "name": "စစ်ကိုင်းတိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/sgg.html" },
      { "name": "မကွေးတိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/mgy.html" },
      { "name": "ပဲခူးတိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/bgo.html" },
      { "name": "တနင်္သာရီတိုင်းဒေသကြီး", "link": "https://2024.myanmarexam.org/tni.html" },
      { "name": "ကချင်ပြည်နယ်", "link": "https://2024.myanmarexam.org/kcn.html" },
      { "name": "ကယားပြည်နယ်", "link": "https://2024.myanmarexam.org/special.html" },
      { "name": "ကရင်ပြည်နယ်", "link": "https://2024.myanmarexam.org/kyn.html" },
      { "name": "ချင်းပြည်နယ်", "link": "https://2024.myanmarexam.org/chn.html" },
      { "name": "မွန်ပြည်နယ်", "link": "https://2024.myanmarexam.org/mon.html" },
      { "name": "ရခိုင်ပြည်နယ်", "link": "https://2024.myanmarexam.org/rke.html" },
      { "name": "ရှမ်းပြည်နယ်", "link": "https://2024.myanmarexam.org/shn.html" },
      { "name": "နိုင်ငံခြား", "link": "https://2024.myanmarexam.org/special.html" }
    ]
  },
  {
    "year": 2023,
    "regions": [
      { "name": "ရန်ကုန်တိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/ygn.html" },
      { "name": "မန္တလေးတိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/mdy.html" },
      { "name": "နေပြည်တော်", "link": "https://2023.myanmarexam.org/npw.html" },
      { "name": "ဧရာဝတီတိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/ayy.html" },
      { "name": "စစ်ကိုင်းတိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/sgg.html" },
      { "name": "မကွေးတိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/mgy.html" },
      { "name": "ပဲခူးတိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/bgo.html" },
      { "name": "တနင်္သာရီတိုင်းဒေသကြီး", "link": "https://2023.myanmarexam.org/tni.html" },
      { "name": "ကချင်ပြည်နယ်", "link": "https://2023.myanmarexam.org/kcn.html" },
      { "name": "ကယားပြည်နယ်", "link": "https://2023.myanmarexam.org/special.html" },
      { "name": "ကရင်ပြည်နယ်", "link": "https://2023.myanmarexam.org/kyn.html" },
      { "name": "ချင်းပြည်နယ်", "link": "https://2023.myanmarexam.org/chn.html" },
      { "name": "မွန်ပြည်နယ်", "link": "https://2023.myanmarexam.org/mon.html" },
      { "name": "ရခိုင်ပြည်နယ်", "link": "https://2023.myanmarexam.org/rke.html" },
      { "name": "ရှမ်းပြည်နယ်", "link": "https://2023.myanmarexam.org/shn.html" },
      { "name": "နိုင်ငံခြား", "link": "https://2023.myanmarexam.org/special.html" }
    ]
  },
  {
    "year": 2022,
    "regions": [
      { "name": "ရန်ကုန်တိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/ygn.html" },
      { "name": "မန္တလေးတိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/mdy.html" },
      { "name": "နေပြည်တော်", "link": "https://2022.myanmarexam.org/npw.html" },
      { "name": "ဧရာဝတီတိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/ayy.html" },
      { "name": "စစ်ကိုင်းတိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/sgg.html" },
      { "name": "မကွေးတိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/mgy.html" },
      { "name": "ပဲခူးတိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/bgo.html" },
      { "name": "တနင်္သာရီတိုင်းဒေသကြီး", "link": "https://2022.myanmarexam.org/tni.html" },
      { "name": "ကချင်ပြည်နယ်", "link": "https://2022.myanmarexam.org/kcn.html" },
      { "name": "ကယားပြည်နယ်", "link": "https://2022.myanmarexam.org/special.html" },
      { "name": "ကရင်ပြည်နယ်", "link": "https://2022.myanmarexam.org/kyn.html" },
      { "name": "ချင်းပြည်နယ်", "link": "https://2022.myanmarexam.org/chn.html" },
      { "name": "မွန်ပြည်နယ်", "link": "https://2022.myanmarexam.org/mon.html" },
      { "name": "ရခိုင်ပြည်နယ်", "link": "https://2022.myanmarexam.org/rke.html" },
      { "name": "ရှမ်းပြည်နယ်", "link": "https://2022.myanmarexam.org/shn.html" },
      { "name": "နိုင်ငံခြား", "link": "https://2022.myanmarexam.org/special.html" }
    ]
  }
]''';

  /// Fetches exam years data with mock data (simulate network delay)
  static Future<List<YearModel>> getExamYears() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Return mock data
      return _parseYearsFromJson(jsonDecode(_mockJsonData));
    } catch (e) {
      throw Exception('Error fetching exam years: $e');
    }
  }

  /// Fetches exam years data from actual API
  static Future<List<YearModel>> getExamYearsFromApi() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl), headers: {'Content-Type': 'application/json', 'Accept': 'application/json'});

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        return _parseYearsFromJson(jsonData);
      } else {
        throw Exception('Failed to load exam years: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching exam years: $e');
    }
  }

  /// Parses JSON string to List<YearModel>
  static List<YearModel> parseFromJsonString(String jsonString) {
    try {
      final List<dynamic> jsonData = jsonDecode(jsonString);
      return _parseYearsFromJson(jsonData);
    } catch (e) {
      throw Exception('Error parsing JSON string: $e');
    }
  }

  /// Parses List<dynamic> to List<YearModel>
  static List<YearModel> parseFromJsonList(List<dynamic> jsonList) {
    try {
      return _parseYearsFromJson(jsonList);
    } catch (e) {
      throw Exception('Error parsing JSON list: $e');
    }
  }

  /// Internal method to parse years from JSON
  static List<YearModel> _parseYearsFromJson(List<dynamic> jsonData) {
    return jsonData.map((yearJson) => YearModel.fromJson(yearJson as Map<String, dynamic>)).toList();
  }

  /// Converts List<YearModel> back to JSON
  static List<Map<String, dynamic>> convertToJson(List<YearModel> years) {
    return years.map((year) => year.toJson()).toList();
  }

  /// Converts List<YearModel> to JSON string
  static String convertToJsonString(List<YearModel> years) {
    final jsonList = convertToJson(years);
    return jsonEncode(jsonList);
  }

  /// Helper method to get a specific year
  static YearModel? getYearByNumber(List<YearModel> years, int yearNumber) {
    try {
      return years.firstWhere((year) => year.year == yearNumber);
    } catch (e) {
      return null;
    }
  }

  /// Helper method to get available years (sorted descending)
  static List<int> getAvailableYears(List<YearModel> years) {
    return years.map((year) => year.year).toList()..sort((a, b) => b.compareTo(a));
  }

  /// Helper method to find region by name in a specific year
  static RegionModel? getRegionByName(List<YearModel> years, int yearNumber, String regionName) {
    final year = getYearByNumber(years, yearNumber);
    if (year == null) return null;

    try {
      return year.regions.firstWhere((region) => region.name == regionName);
    } catch (e) {
      return null;
    }
  }
}
