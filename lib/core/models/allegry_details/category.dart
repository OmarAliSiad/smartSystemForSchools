class Category {
  int? id;
  String? name;
  String? schoolTenantId;

  Category({this.id, this.name, this.schoolTenantId});

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        schoolTenantId: json['schoolTenantId'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'schoolTenantId': schoolTenantId,
      };
}
