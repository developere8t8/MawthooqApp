class Commission {
  bool? success;
  String? message;
  String? redirect;
  CommissionData? data;

  Commission({required this.data, required this.message, required this.redirect, required this.success});

  factory Commission.fromJson(Map<String, dynamic> json) {
    return Commission(
        data: CommissionData.fromJson(json['data']),
        message: json['message'],
        redirect: json['redirect'],
        success: json['success']);
  }
}

class CommissionData {
  double? commision;

  CommissionData({required this.commision});

  factory CommissionData.fromJson(Map<String, dynamic> dataJson) {
    return CommissionData(commision: double.parse(dataJson['commision'].toString()));
  }
}
