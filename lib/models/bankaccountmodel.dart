class BankInfo {
  final String bank_name;
  final String account_holder_name;
  final String account_number;
  final String iban;

  BankInfo({required this.bank_name,required this.iban,required this.account_holder_name,required this.account_number});

  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      bank_name: json['bank_name']??'',
      iban: json['iban']??'',
      account_holder_name: json['account_holder_name']??'',
      account_number: json['account_number']??'',
    );
  }
}