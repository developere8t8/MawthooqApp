import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/forgot%20password/resetpassword.dart';
import 'package:seller_side/login_screen/login.dart';
import 'package:seller_side/widgets/app_textfield.dart';
import '../widgets/app_button.dart';
import '../widgets/header_container.dart';
import '../widgets/loader.dart';
import 'package:http/http.dart' as http;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phone = TextEditingController();

  bool isLoading = false;
  Color? bymobile = Colors.black;
  Color bymobileTxt = Colors.white;
  Color? byemail = Colors.grey[300];
  Color byemailTxt = Colors.grey;
  bool email = false;

  //rest password api
  Future resetPasword() async {
    setState(() => isLoading = true);

    String encodedJson = jsonEncode(
        <String, dynamic>{'email': emailcontroller.text, 'mobile': phone.text, 'user_type': '1'});

    final response = await http.post(Uri.parse('$baseUrl/forget_password'),
        body: encodedJson, headers: {'Accept': 'application/json', 'content-Type': 'application/json'});
    setState(() => isLoading = false);

    if (response.statusCode == 200) {
      // showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //           content: Text(response.body),
      //         ));
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPassword(
                    phone: phone.text,
                  )));
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
                  text: AppLocalizations.of(context)!.forgotpassword,
                  dothis: () {
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }),
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
                                    AppLocalizations.of(context)!.resetoption, //"Confirmation",
                                    style: const TextStyle(
                                        fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 18),
                                  ),
                                ))
                              ]),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: InkWell(
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0), color: bymobile),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.bymobile, //'By Hand',
                                          style: TextStyle(color: bymobileTxt, fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        bymobile = Colors.black;
                                        bymobileTxt = Colors.white;
                                        byemail = Colors.grey[300];
                                        byemailTxt = Colors.grey;
                                        email = false;
                                      });
                                    },
                                  )),
                                  Expanded(
                                      child: InkWell(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0), color: byemail),
                                      height: 50,
                                      width: MediaQuery.of(context).size.width / 2,
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.byemail, //'By Post',
                                          style: TextStyle(color: byemailTxt, fontSize: 18.0),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      setState(() {
                                        bymobile = Colors.grey[300];
                                        bymobileTxt = Colors.grey;
                                        byemail = Colors.black;
                                        byemailTxt = Colors.white;
                                        email = true;
                                      });
                                    },
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 40.0,
                              ),
                              Visibility(
                                  //visible: visible,
                                  child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text(AppLocalizations.of(context)!.email),
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
                                            controller: emailcontroller,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child:
                                            Text(AppLocalizations.of(context)!.phone), //Text('Number'),
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
                                            controller: phone,
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
                                        if (emailcontroller.text.isEmpty) {
                                          _showMsg(
                                              AppLocalizations.of(context)!.providevalidemail,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        } else if (phone.text.isEmpty) {
                                          _showMsg(
                                              AppLocalizations.of(context)!.enteravalidPhoneNumber,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        } else if (emailcontroller.text.isEmpty && phone.text.isEmpty) {
                                          _showMsg(
                                              AppLocalizations.of(context)!.emailphone,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        } else {
                                          resetPasword();
                                        }
                                      },
                                      text: AppLocalizations.of(context)!.reset, //'Login',
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
