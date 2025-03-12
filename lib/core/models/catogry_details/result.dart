class CatogryResult {
  int? id;
  String? name;

  CatogryResult({this.id, this.name});

  factory CatogryResult.fromJson(Map<String, dynamic> json) => CatogryResult(
        id: json['id'] as int?,
        name: json['name'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
