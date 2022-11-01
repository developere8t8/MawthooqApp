import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/setting/setting.dart';

import '../constants.dart';
import '../models/bankaccountmodel.dart';
import '../models/user.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';
import 'package:http/http.dart' as http;


class Bank_Info extends StatefulWidget {
  final UserData userData;
  const Bank_Info({Key? key, required this.userData}) : super(key: key);

  @override
  State<Bank_Info> createState() => _Bank_InfoState();
}

class _Bank_InfoState extends State<Bank_Info> {
  TextEditingController _bankName = TextEditingController();
  TextEditingController _accountHolder = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _iban = TextEditingController();

  Future<BankInfo> createAlbum(String bank_name,String account_holder_name,String account_number,String iban) async {
    var token = widget.userData.token;
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/update_bank_account'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        "bank_name": _bankName.text,
        "account_holder_name": _accountHolder.text,
        "account_number": _accountName.text,
        "iban": _iban.text,
      }),
    );
    print(response.statusCode);
    if (response.statusCode == 200  ) {
      print(response.body);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  SettingScreen(userData: widget.userData)));
      return BankInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SettingScreen(userData: widget.userData,)));
            },
            child: Icon(Icons.arrow_back, color: Color(0xFF383838),size: 35,)),
        title: Text(AppLocalizations.of(context)!.bankinfo,
          style: TextStyle(color: Color(0xFF383838)),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,top: 20, right: 20.0),
                        child: Text(AppLocalizations.of(context)!.bankname, //"Item Type",
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        child: ApptextField(
                          controller: _bankName,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,top: 20, right: 20.0),
                        child: Text(AppLocalizations.of(context)!.accountholder, //"Item Type",
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        child: ApptextField(
                          controller: _accountHolder,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,top: 20, right: 20.0),
                        child: Text(AppLocalizations.of(context)!.accountnumber, //"Item Type",
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        child: ApptextField(
                          controller: _accountName,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 40.0,top: 20, right: 20.0),
                        child: Text(AppLocalizations.of(context)!.iban, //"Item Type",
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                        child: ApptextField(
                          controller: _iban,
                        ),
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                        child: AppButton(
                          color: const Color(0xff128383),
                          onpressed: (){
                            if(_bankName.text.isNotEmpty&&_accountHolder.text.isNotEmpty
                            &&_accountName.text.isNotEmpty&&_iban.text.isNotEmpty){
                              setState(() {
                                createAlbum(
                                    _bankName.text.toString(),
                                    _accountHolder.text.toString(),
                                    _accountName.text.toString(),
                                    _iban.text.toString());
                              });
                            }else {
                              _showMsg(
                                  AppLocalizations.of(context)!.allfields,
                                  Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ));
                            }
                          },
                          text: AppLocalizations.of(context)!.update,
                          textColor: Colors.white,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  _showMsg(String msg, Icon icon) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              msg,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          icon
        ],
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
