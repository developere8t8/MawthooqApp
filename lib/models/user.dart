class UserData {
  String? message;
  String? redirect;
  bool? success;
  var token;
  User? user;

  UserData(
      {required this.message,
      required this.redirect,
      required this.success,
      required this.token,
      required this.user});

  factory UserData.fromjson(Map<String, dynamic> comjson) {
    return UserData(
        message: comjson['message'],
        redirect: comjson['redirect'],
        success: comjson['success'],
        token: comjson['token'],
        user: User.fromjson(comjson['user']));
  }
}

class User {
  String? address;
  String? deviceID;
  String? bussinessName;
  String? coordinates;
  int? countryID;
  String? createdON;
  String? deletedAt;
  String? dob;
  String? education;
  String? email;
  String? verifyEmailAt;
  int? featured;
  String? firebaseMail;
  String? gender;
  int? userid;
  String? idPhoto;
  String? iosDeviceID;
  int? isOnline;
  String? languages;
  String? locale;
  String? mobileNumber;
  String? name;
  String? nicPassport;
  int? openStatus;
  var photo;
  int? role;
  int? roomStatus;
  String? social;
  int? status;
  int? tableStatus;
  String? theme;
  String? type;
  String? updatedAt;
  int? userType;
  String? userName;
  String? vendorType;
  String? webDeviceID;
  String? token;

  User(
      {required this.deviceID,
      required this.bussinessName,
      required this.coordinates,
      required this.countryID,
      required this.createdON,
      required this.deletedAt,
      required this.dob,
      required this.education,
      required this.email,
      required this.verifyEmailAt,
      required this.featured,
      required this.firebaseMail,
      required this.gender,
      required this.userid,
      required this.idPhoto,
      required this.iosDeviceID,
      required this.isOnline,
      required this.languages,
      required this.locale,
      required this.mobileNumber,
      required this.name,
      required this.nicPassport,
      required this.openStatus,
      required this.photo,
      required this.role,
      required this.roomStatus,
      required this.social,
      required this.status,
      required this.tableStatus,
      required this.theme,
      required this.type,
      required this.updatedAt,
      required this.userType,
      required this.userName,
      required this.vendorType,
      required this.webDeviceID,
      required this.token,
      required this.address});

  factory User.fromjson(Map<String?, dynamic> json) {
    return User(
        deviceID: json['android_device_id'],
        bussinessName: json['business_name'],
        coordinates: json['coordinates'],
        countryID: json['country_id'],
        createdON: json['created_at'],
        deletedAt: json['deleted_at'],
        dob: json['dob'],
        education: json['education'],
        email: json['email'],
        verifyEmailAt: json['email_verified_at'],
        featured: json['featured'],
        firebaseMail: json['firebase_email'],
        gender: json['gender'],
        userid: json['id'],
        idPhoto: json['id_photo'],
        iosDeviceID: json['ios_device_id'],
        isOnline: json['is_online'],
        languages: json['languages'],
        locale: json['locale'],
        mobileNumber: json['mobile'],
        name: json['name'],
        nicPassport: json['nic_passport'],
        openStatus: json['is_online'],
        photo: json['photo'],
        role: json['role'],
        roomStatus: json['room_status'],
        social: json['social'],
        status: json['status'],
        tableStatus: json['table_status'],
        theme: json['theme'],
        type: json['type'],
        updatedAt: json['updated_at'],
        userType: json['user_type'],
        userName: json['username'],
        vendorType: json['vendor_type'],
        webDeviceID: json['web_device_id'],
        token: json['token'],
        address: json['address']);
  }
}

class UpdateUser {
  bool? success;
  String? message;
  String? redirect;
  UserProfile? userProfile;

  UpdateUser({this.success, this.message, this.redirect, this.userProfile});

  UpdateUser.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    redirect = json['redirect'];
    userProfile = json['user_profile'] != null ? new UserProfile.fromJson(json['user_profile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['redirect'] = this.redirect;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.toJson();
    }
    return data;
  }
}

class UserProfile {
  int? id;
  String? name;
  String? username;
  String? email;
  String? firebaseEmail;
  String? mobile;
  int? countryId;
  String? nicPassport;
  String? education;
  String? languages;
  String? idPhoto;
  var photo;
  String? type;
  int? role;
  String? emailVerifiedAt;
  String? social;
  String? theme;
  String? locale;
  String? createdAt;
  String? updatedAt;
  String? businessName;
  String? dob;
  String? gender;
  String? address;
  String? coordinates;
  int? vendorTypeId;
  int? roomStatus;
  int? tableStatus;
  int? featured;
  int? openStatus;
  String? iosDeviceId;
  String? androidDeviceId;
  String? webDeviceId;
  int? userType;
  int? status;
  int? isOnline;
  String? deletedAt;

  UserProfile(
      {this.id,
      this.name,
      this.username,
      this.email,
      this.firebaseEmail,
      this.mobile,
      this.countryId,
      this.nicPassport,
      this.education,
      this.languages,
      this.idPhoto,
      this.photo,
      this.type,
      this.role,
      this.emailVerifiedAt,
      this.social,
      this.theme,
      this.locale,
      this.createdAt,
      this.updatedAt,
      this.businessName,
      this.dob,
      this.gender,
      this.address,
      this.coordinates,
      this.vendorTypeId,
      this.roomStatus,
      this.tableStatus,
      this.featured,
      this.openStatus,
      this.iosDeviceId,
      this.androidDeviceId,
      this.webDeviceId,
      this.userType,
      this.status,
      this.isOnline,
      this.deletedAt});

  UserProfile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    username = json['username'];
    email = json['email'];
    firebaseEmail = json['firebase_email'];
    mobile = json['mobile'];
    countryId = json['country_id'];
    nicPassport = json['nic_passport'];
    education = json['education'];
    languages = json['languages'];
    idPhoto = json['id_photo'];
    photo = json['photo'];
    type = json['type'];
    role = json['role'];
    emailVerifiedAt = json['email_verified_at'];
    social = json['social'];
    theme = json['theme'];
    locale = json['locale'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    businessName = json['business_name'];
    dob = json['dob'];
    gender = json['gender'];
    address = json['address'];
    coordinates = json['coordinates'];
    vendorTypeId = json['vendor_type_id'];
    roomStatus = json['room_status'];
    tableStatus = json['table_status'];
    featured = json['featured'];
    openStatus = json['open_status'];
    iosDeviceId = json['ios_device_id'];
    androidDeviceId = json['android_device_id'];
    webDeviceId = json['web_device_id'];
    userType = json['user_type'];
    status = json['status'];
    isOnline = json['is_online'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['email'] = this.email;
    data['firebase_email'] = this.firebaseEmail;
    data['mobile'] = this.mobile;
    data['country_id'] = this.countryId;
    data['nic_passport'] = this.nicPassport;
    data['education'] = this.education;
    data['languages'] = this.languages;
    data['id_photo'] = this.idPhoto;
    data['photo'] = this.photo;
    data['type'] = this.type;
    data['role'] = this.role;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['social'] = this.social;
    data['theme'] = this.theme;
    data['locale'] = this.locale;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['business_name'] = this.businessName;
    data['dob'] = this.dob;
    data['gender'] = this.gender;
    data['address'] = this.address;
    data['coordinates'] = this.coordinates;
    data['vendor_type_id'] = this.vendorTypeId;
    data['room_status'] = this.roomStatus;
    data['table_status'] = this.tableStatus;
    data['featured'] = this.featured;
    data['open_status'] = this.openStatus;
    data['ios_device_id'] = this.iosDeviceId;
    data['android_device_id'] = this.androidDeviceId;
    data['web_device_id'] = this.webDeviceId;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['is_online'] = this.isOnline;
    data['deleted_at'] = this.deletedAt;
    return data;
  }
}
