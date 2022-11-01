class Request {
  final String message;
  final bool success;
  final RequestData reqData;

  Request({required this.message, required this.reqData, required this.success});

  factory Request.fromJson(Map<String, dynamic> reqjson) {
    return Request(
        message: reqjson['message'],
        reqData: RequestData.fromJson(reqjson['data']),
        success: reqjson['success']);
  }
}

class RequestData {
  final int userID;
  final String itemType;
  final String price;
  final String details;
  final int status;
  final String updatedAt;
  final String createdAt;
  final int requestID;

  RequestData({
    required this.userID,
    required this.itemType,
    required this.price,
    required this.details,
    required this.status,
    required this.updatedAt,
    required this.requestID,
    required this.createdAt,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) {
    return RequestData(
        createdAt: json['created_at'],
        details: json['details'],
        itemType: json['item_type'],
        price: json['price'],
        requestID: json['id'],
        status: json['status'],
        updatedAt: json['updated_at'],
        userID: json['user_id']);
  }
}
