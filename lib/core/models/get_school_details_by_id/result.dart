class ResultForSpecificSchool {
  String? schoolTenantId;
  String? name;
  String? description;
  String? address;
  String? country;
  String? phoneNumber;
  String? email;
  String? schoolLogo;
  DateTime? createdOn;

  ResultForSpecificSchool({
    this.schoolTenantId,
    this.name,
    this.description,
    this.address,
    this.country,
    this.phoneNumber,
    this.email,
    this.schoolLogo,
    this.createdOn,
  });

  factory ResultForSpecificSchool.fromJson(Map<String, dynamic> json) =>
      ResultForSpecificSchool(
        schoolTenantId: json['schoolTenantId'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        address: json['address'] as String?,
        country: json['country'] as String?,
        phoneNumber: json['phoneNumber'] as String?,
        email: json['email'] as String?,
        schoolLogo: json['schoolLogo'] as String?,
        createdOn: json['createdOn'] == null
            ? null
            : DateTime.parse(json['createdOn'] as String),
      );

  Map<String, dynamic> toJson() => {
        'schoolTenantId': schoolTenantId,
        'name': name,
        'description': description,
        'address': address,
        'country': country,
        'phoneNumber': phoneNumber,
        'email': email,
        'schoolLogo': schoolLogo,
        'createdOn': createdOn?.toIso8601String(),
      };
}
