import 'package:mm_exam/data/region_model.dart';

class YearModel {
  final int year;
  final List<RegionModel> regions;

  const YearModel({
    required this.year,
    required this.regions,
  });

  factory YearModel.fromJson(Map<String, dynamic> json) {
    return YearModel(
      year: json['year'] as int,
      regions: (json['regions'] as List<dynamic>)
          .map((regionJson) => RegionModel.fromJson(regionJson as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'regions': regions.map((region) => region.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Year(year: $year, regions: ${regions.length} regions)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is YearModel &&
        other.year == year &&
        _listEquals(other.regions, regions);
  }

  @override
  int get hashCode => year.hashCode ^ regions.hashCode;

  static bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}