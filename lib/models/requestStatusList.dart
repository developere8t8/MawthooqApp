import 'package:seller_side/models/searchreq.dart';
import 'package:seller_side/models/user.dart';

class RequestStatusList {
  bool? success;
  List<RequestDetailData> requestData;

  RequestStatusList({
    required this.requestData,
    required this.success,
  });

  factory RequestStatusList.fromjson(Map<String, dynamic> reqjson) {
    var list = reqjson['data'] as List;
    return RequestStatusList(
      //requestData: reqjson.map((e) => RequestDetailData.fromjson(e)).toList(),
      success: reqjson['success'],
      requestData: list.map((e) => RequestDetailData.fromjson(e)).toList(),
    );
  }
}

class RequestDetailData {
  int? id;
  int? userId;
  String? itemType;
  String? price;
  String? details;
  int? status;
  String? createdAt;
  String? updatedAt;
  int? deliveryMethod;
  var paymentMethod;
  String? paymentStatus;
  String? deliveryCompany;
  String? trackingNumber;
  int? sellerId;
  List<ReqAttachments>? attachment;
  List<ReqAttachments>? deliveryDocs;
  User? buyer;

  RequestDetailData(
      {required this.id,
      required this.userId,
      required this.itemType,
      required this.price,
      required this.details,
      required this.status,
      required this.createdAt,
      required this.updatedAt,
      required this.deliveryMethod,
      required this.paymentMethod,
      required this.paymentStatus,
      required this.sellerId,
      required this.attachment,
      required this.buyer,
      required this.deliveryCompany,
      required this.trackingNumber,
      required this.deliveryDocs});

  factory RequestDetailData.fromjson(Map<String, dynamic> json) {
    var attacmentsList = json['attachment'] as List;
    var deliverylist = json['delivery_docs'] as List;
    return RequestDetailData(
      id: json['id'],
      userId: json['user_id'],
      itemType: json['item_type'],
      price: json['price'],
      details: json['details'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deliveryMethod: json['delivery_method'],
      paymentMethod: json['payment_method'],
      paymentStatus: json['payment_status'].toString(),
      sellerId: json['seller_id'],
      attachment: attacmentsList.map((e) => ReqAttachments.fromjson(e)).toList(),
      deliveryDocs: deliverylist.map((d) => ReqAttachments.fromjson(d)).toList(),
      buyer: User.fromjson(json['buyer']),
      trackingNumber: json['delivery_tracking_no'],
      deliveryCompany: json['delivery_company_name'],
    );
  }
}
