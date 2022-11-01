import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/login_screen/login.dart';

import 'package:seller_side/register_screen/otp.dart';
import 'package:seller_side/widgets/header_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/widgets/loader.dart';
import '../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController phone = TextEditingController(); //phone number
  final GlobalKey<FormState> _formKey = GlobalKey(); //form validation key
  bool isLoading = false;
  String? countryName;
  //getting otp
  Future registerNumber() async {
    setState(() => isLoading = true);
    String apiUrl = '$baseUrl/signup?mobile_no=${phone.text}&language=en';
    final response = await http.post(Uri.parse(apiUrl), headers: {'Accept': 'application/json'});
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      final raw = jsonDecode(response.body);
      String otp = raw['otp'].toString();
      // ignore: use_build_context_synchronously
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OTP(
                    otp: otp,
                    mobileNumber: phone.text,
                    countryName: countryName,
                  )));
    } else {
      _showMsg(
          'Server Error ${response.statusCode}',
          const Icon(
            Icons.close,
            color: Colors.red,
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
              text: AppLocalizations.of(context)!.register,
              dothis: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => const LoginScreen()));
              },
            ),
            const SizedBox(
              height: 30.0,
            ),
            Column(
              children: [
                isLoading
                    ? const Loading()
                    : Column(
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 30.0),
                                child: Text(AppLocalizations.of(context)!
                                    .enteryourmobilenumber), //Text('Enter your mobile number'),
                              )
                            ],
                          ),
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: IntlPhoneField(
                                          onChanged: (number) => phone.text = number.completeNumber,
                                          initialCountryCode: 'SA',
                                          onCountryChanged: (country) =>
                                              setState(() => countryName = country.code),
                                          decoration: InputDecoration(
                                              isDense: true,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(40.0),
                                              ),
                                              filled: true,
                                              fillColor: const Color(0xffF0F0F0)),
                                        ),
                                      ))
                                    ],
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
                                            bool? yes = _formKey.currentState
                                                ?.validate(); // if (phone.text.isEmpty) {
                                            if (yes!) {
                                              registerNumber();
                                            } else {
                                              _showMsg(
                                                  AppLocalizations.of(context)!
                                                      .enteravalidPhoneNumber, //enter a valaid mobile number
                                                  const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ));
                                            }
                                            //Navigator.push(context, MaterialPageRoute(builder: (context) => const OTP()));
                                          },
                                          text: AppLocalizations.of(context)!.sendotp, //'Login',
                                          textColor: Colors.white,
                                        ),
                                      ))
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      )
              ],
            )
          ],
        ),
      ),
    )));
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
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
