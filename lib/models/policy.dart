import 'package:http/retry.dart';

class Policy {
  bool? success;
  String? message;
  String? redirect;
  PolicyData? data;

  Policy({required this.data, required this.success});

  factory Policy.fromJson(Map<String, dynamic> pjson) {
    return Policy(data: PolicyData.fromJson(pjson['data']), success: pjson['success']);
  }
}

class PolicyData {
  String? id;
  String? slug;
  String? name;
  String? status;
  String? createdat;
  String? updatedat;
  String? type;
  Title? title;
  ContentData? contentData;

  PolicyData(
      {required this.id,
      required this.name,
      required this.slug,
      required this.title,
      required this.contentData,
      required this.createdat,
      required this.status,
      required this.type,
      required this.updatedat});

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
        id: json['id'].toString(),
        name: json['name'],
        slug: json['slug'],
        title: Title.fromJson(json['title']),
        contentData: ContentData.fromJson(json['content']),
        status: json['status'],
        type: json['type'].toString(),
        updatedat: json['updated_at'],
        createdat: json['created_at']);
  }
}

class Title {
  String? ar;
  String? en;
  Title({required this.ar, required this.en});

  factory Title.fromJson(Map<String, dynamic> titlejson) {
    return Title(ar: titlejson['ar'], en: titlejson['es']);
  }
}

class ContentData {
  String? ardata;
  String? endata;
  ContentData({required this.ardata, required this.endata});

  factory ContentData.fromJson(Map<String, dynamic> contentJson) {
    return ContentData(ardata: contentJson['ar'], endata: contentJson['en']);
  }
}
