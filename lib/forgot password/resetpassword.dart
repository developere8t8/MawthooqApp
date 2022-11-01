import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:http/http.dart' as http;
import 'package:seller_side/constants.dart';
import 'package:seller_side/login_screen/login.dart';
import 'package:seller_side/models/resetpass.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';
import '../widgets/header_container.dart';
import '../widgets/loader.dart';

class ResetPassword extends StatefulWidget {
  final String phone;
  const ResetPassword({super.key, required this.phone});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController newpassword = TextEditingController();
  TextEditingController confirmpassword = TextEditingController();
  bool isLoading = false;

//rest password
  Future resetPasword() async {
    setState(() => isLoading = true);

    String encodedJson = jsonEncode(<String, dynamic>{
      'language': 'en',
      'mobile': widget.phone,
      'new_password': newpassword.text,
      'confirm_password': confirmpassword.text
    });

    final response = await http.post(Uri.parse('$baseUrl/reset_password'),
        body: encodedJson, headers: {'Accept': 'application/json', 'content-Type': 'application/json'});
    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      ResetPass resetPass = ResetPass.fromjson(jsonDecode(response.body));
      if (resetPass.success == true) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        _showMsg(
            '${resetPass.message!} for ${widget.phone}',
            const Icon(
              Icons.check,
              color: Colors.green,
            ));
      }
    } else {
      _showMsg(
          response.statusCode.toString(),
          const Icon(
            Icons.check,
            color: Colors.green,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: Text(AppLocalizations.of(context)!.backagaintoexit),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppHeader(
                visible: true,
                text: AppLocalizations.of(context)!.reset,
                dothis: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    isLoading
                        ? const Loading()
                        : Column(
                            children: [
                              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Expanded(
                                    child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.newpassword, //"Confirmation",
                                    style: const TextStyle(
                                        fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ))
                              ]),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Visibility(
                                  //visible: visible,
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text(AppLocalizations.of(context)!.passwordnew),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ApptextField(
                                            controller: newpassword,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text(AppLocalizations.of(context)!
                                            .confirmpassword), //Text('Number'),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: ApptextField(
                                            controller: confirmpassword,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: AppButton(
                                      color: const Color(0xff128383),
                                      onpressed: () {
                                        if (newpassword.text.isEmpty) {
                                          _showMsg(
                                              AppLocalizations.of(context)!.providenewpass,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        } else if (confirmpassword.text.isEmpty) {
                                          _showMsg(
                                              AppLocalizations.of(context)!.confirmpassword,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        } else if (newpassword.text.isEmpty &&
                                            confirmpassword.text.isEmpty) {
                                          _showMsg(
                                              AppLocalizations.of(context)!.newconfirmpass,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        } else {
                                          if (newpassword.text == confirmpassword.text) {
                                            resetPasword();
                                          } else {
                                            _showMsg(
                                                AppLocalizations.of(context)!.passnotmatch,
                                                const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                ));
                                          }
                                        }
                                      },
                                      text: AppLocalizations.of(context)!.confirmreset, //'Login',
                                      textColor: Colors.white,
                                    ),
                                  ))
                                ],
                              ),
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      )),
    );
  }

  //for shwing Error messages
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
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
