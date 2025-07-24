class RegionModel {
  final String name;
  final String link;

  const RegionModel({
    required this.name,
    required this.link,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      name: json['name'] as String,
      link: json['link'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'link': link,
    };
  }

  @override
  String toString() {
    return 'Region(name: $name, link: $link)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RegionModel && other.name == name && other.link == link;
  }

  @override
  int get hashCode => name.hashCode ^ link.hashCode;
}
