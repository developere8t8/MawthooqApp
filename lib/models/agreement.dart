class AgrrementTxt {
  final bool success;
  final AgreementData data;

  AgrrementTxt({required this.data, required this.success});

  factory AgrrementTxt.fromJson(Map<String, dynamic> agjson) {
    return AgrrementTxt(data: AgreementData.fromJson(agjson['data']??""), success: agjson['success']);
  }
}

class AgreementData {
  final String txt;
  AgreementData({required this.txt});
  factory AgreementData.fromJson(Map<String, dynamic> json) {
    return AgreementData(txt: json['text']);
  }
}
