class UserInfoModel {
  String? userId;
  dynamic message;
  bool? isAuthenticated;
  String? username;
  String? email;
  List<dynamic>? roles;
  String? token; // Access token
  String? refreshToken; // NEW: Refresh token to be stored/retrieved
  bool? owner;
  String? phone;
  String? gender;
  String? address;
  String? schoolTenantId;
  DateTime? refreshTokenExpiration;

  UserInfoModel({
    this.userId,
    this.message,
    this.isAuthenticated,
    this.username,
    this.email,
    this.roles,
    this.token,
    this.refreshToken, // Add to constructor
    this.owner,
    this.phone,
    this.gender,
    this.address,
    this.schoolTenantId,
    this.refreshTokenExpiration,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        userId: json['userId'] as String?,
        message: json['message'] as dynamic,
        isAuthenticated: json['isAuthenticated'] as bool?,
        username: json['username'] as String?,
        email: json['email'] as String?,
        roles: json['roles'] is List ? (json['roles'] as List) : null,
        address: json['address'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
        token: json['token'] as String?,
        refreshToken:
            json['refreshToken'] as String?, // NEW: Parse refreshToken
        owner: json['owner'] as bool?,
        schoolTenantId: json['schoolTenantId'] as String?,
        refreshTokenExpiration: json['refreshTokenExpiration'] == null
            ? null
            : DateTime.parse(json['refreshTokenExpiration'] as String),
      );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'message': message,
        'isAuthenticated': isAuthenticated,
        'username': username,
        'email': email,
        'roles': roles,
        'token': token,
        'refreshToken': refreshToken, // Add to toJson
        'owner': owner,
        'phone': phone,
        'gender': gender,
        'address': address,
        'schoolTenantId': schoolTenantId,
        'refreshTokenExpiration': refreshTokenExpiration?.toIso8601String(),
      };
}
