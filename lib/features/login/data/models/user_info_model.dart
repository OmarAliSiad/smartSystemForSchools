class UserInfoModel {
  String? userId;
  dynamic message;
  bool? isAuthenticated;
  String? username;
  String? email;
  List<dynamic>? roles;
  String? token;
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
        roles: json['roles'],
        address: json['address'] as String?,
        gender: json['gender'] as String?,
        phone: json['phone'] as String?,
        token: json['token'] as String?,
        owner: json['owner'] as bool?,
        schoolTenantId: json['schoolTenantId'] as String?,
        refreshTokenExpiration: json['refreshTokenExpiration'] == null
            ? null
            : DateTime.parse(json['refreshTokenExpiration'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': userId,
        'message': message,
        'isAuthenticated': isAuthenticated,
        'username': username,
        'email': email,
        'roles': roles,
        'token': token,
        'owner': owner,
        'schoolTenantId': schoolTenantId,
        'refreshTokenExpiration': refreshTokenExpiration?.toIso8601String(),
      };
}
