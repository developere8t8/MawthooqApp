class AcceptRequest {
  bool? success;
  int? status;
  String? message;

  AcceptRequest({required this.message, required this.status, required this.success});

  factory AcceptRequest.fromjson(Map<String, dynamic> json) {
    return AcceptRequest(message: json['message'], status: json['status'], success: json['success']);
  }
}
