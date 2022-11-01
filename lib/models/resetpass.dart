class ResetPass {
  bool? success;
  String? message;
  String? redirect;

  ResetPass({required this.message, required this.redirect, required this.success});

  factory ResetPass.fromjson(Map<String, dynamic> json) {
    return ResetPass(message: json['message'], success: json['success'], redirect: json['redirect']);
  }
}
