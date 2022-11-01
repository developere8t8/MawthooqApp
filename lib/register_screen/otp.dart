import 'dart:async';
import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/register_screen/register_data.dart';
import 'package:seller_side/register_screen/registration.dart';
import 'package:seller_side/widgets/app_textfield.dart';
import 'package:seller_side/widgets/header_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/widgets/loader.dart';
import '../widgets/app_button.dart';
import 'package:http/http.dart' as http;

class OTP extends StatefulWidget {
  final String? otp;
  final String? mobileNumber;
  final String? countryName;
  const OTP({Key? key, this.otp, this.mobileNumber, this.countryName}) : super(key: key);

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  int seconds = 60;
  Timer? timer;
  TextEditingController otpValue = TextEditingController();
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>(); //form validation key

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer!.cancel();
  }

  //verifiying otp
  Future verifyOTP() async {
    setState(() => isLoading = true); //showing loader
    String apiUrl = '$baseUrl/verify_otp?mobile=${widget.mobileNumber}&otp=${widget.otp}&language=en';
    final response = await http.post(Uri.parse(apiUrl), headers: {'Accept': 'application/json'});
    setState(() => isLoading = false); //hiding loader
    if (response.statusCode == 200) {
      final raw = jsonDecode(response.body);
      String message = raw['message'].toString();
      if (message.toLowerCase() == 'otp verified') {
        _showMsg(
            // ignore: use_build_context_synchronously
            AppLocalizations.of(context)!.oTPVerified,
            const Icon(
              Icons.check,
              color: Colors.green,
            ));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => RegisterData(
                      phone: widget.mobileNumber.toString(),
                      countryName: widget.countryName.toString(),
                    )));
      }
    } else {
      _showMsg(
          'Server Error ${response.statusCode}',
          const Icon(
            Icons.close,
            color: Colors.red,
          ));
    }
  }

  //resending otp
  Future registerNumber() async {
    setState(() => isLoading = true);
    String apiUrl = '$baseUrl/signup?mobile_no=${widget.mobileNumber}&language=en';
    final response = await http.post(Uri.parse(apiUrl), headers: {'Accept': 'application/json'});
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      final raw = jsonDecode(response.body);
      setState(() {
        otpValue.text = raw['otp'].toString();
      });
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
  void initState() {
    super.initState();
    otpValue.text = widget.otp!;
    startTimer();
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AppHeader(
                          visible: true,
                          text: AppLocalizations.of(context)!.oTP, //'OTP',
                          dothis: () {
                            Navigator.pushReplacement(
                                context, MaterialPageRoute(builder: (context) => const Registration()));
                          },
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Column(
                          children: [
                            isLoading
                                ? const Center(child: Loading())
                                : Column(
                                    children: [
                                      Text(AppLocalizations.of(context)!.enterOTP),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(20.0),
                                                child: ApptextField(controller: otpValue),
                                          )),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 10.0, left: 30.0, right: 30.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                                child: InkWell(
                                              onTap: () {
                                                if (otpValue.text.isEmpty) {
                                                  setState(() {
                                                    seconds = 60;
                                                  });
                                                  startTimer();
                                                  registerNumber();
                                                } else {
                                                  stopTimer();
                                                  _showMsg(
                                                      'you already have an otp',
                                                      const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ));
                                                }
                                              },
                                                  child: Text(
                                                    AppLocalizations.of(context)!.resendOTP, //'Resend OTP',
                                                    style: const TextStyle(color: Colors.blue),
                                                  ),
                                            )),
                                            Text(
                                              '${AppLocalizations.of(context)!.timer} - 00:$seconds',
                                              style: const TextStyle(color: Colors.grey),
                                            )
                                          ],
                                        ),
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
                                                if (otpValue.text.isNotEmpty) {
                                                  stopTimer();
                                                  verifyOTP();
                                                } else {
                                                  _showMsg(
                                                      AppLocalizations.of(context)!.wrongOTP, //enter a valaid OTP
                                                      const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ));
                                                }
                                              },
                                              text: AppLocalizations.of(context)!.next, //'Next',
                                              textColor: Colors.white,
                                            ),
                                          ))
                                        ],
                                      ),
                                    ],
                                  )
                          ],
                        )
                      ],
                    ),
              )),
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
  //}
}
