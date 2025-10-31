class CustomList {
  final String id;
  final String name;
  final int colorValue;

  const CustomList({
    required this.id,
    required this.name,
    required this.colorValue,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'colorValue': colorValue};
  }

  factory CustomList.fromJson(Map<String, dynamic> json) {
    return CustomList(
      id: json['id'] as String,
      name: json['name'] as String,
      colorValue: json['colorValue'] as int,
    );
  }
}
