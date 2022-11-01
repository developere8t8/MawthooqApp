import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/forgot%20password/forgotpassword.dart';
import 'package:seller_side/models/user.dart';
import 'package:seller_side/post_login/welcome.dart';
import 'package:seller_side/provider/local_provider.dart';
import 'package:seller_side/register_screen/registration.dart';
import 'package:seller_side/widgets/app_button.dart';
import 'package:seller_side/widgets/app_textfield.dart';
import 'package:seller_side/widgets/header_container.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/widgets/loader.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey(); //form validation key
  String validationTxt = '';
  bool isLoading = false;
  bool isAuth = false;
  bool isEnable = true; //enable disable button

//getting already logged in info
  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userID = localStorage.getString('username');
    var savpassword = localStorage.getString('password');
    var userType = localStorage.getString('user_type');
    if (userID != null && savpassword != null) {
      setState(() {
        isLoading = true;
        isEnable = false;
      });
      String encodedJson = jsonEncode(<String, dynamic>{
        'username': jsonDecode(userID),
        'password': jsonDecode(savpassword),
        'user_type': jsonDecode(userType!)
      });
      final response = await http.post(Uri.parse('$baseUrl/login'),
          body: encodedJson,
          headers: {'Accept': 'application/json', 'content-Type': 'application/json'});
      setState(() {
        isLoading = false;
        isEnable = true;
      });

      if (response.statusCode == 200) {
        UserData userData = UserData.fromjson(jsonDecode(response.body));
        if (userData.user != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Welcome(
                        userData: userData,
                      )));
        } else {
          _showMsg(
              'check user name and password',
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
  }

//loging in
  login() async {
    setState(() {
      isLoading = true;
      isEnable = false;
    });
    String encodedJson = jsonEncode(
        <String, dynamic>{'username': email.text, 'password': password.text, 'user_type': '1'});
    final response = await http.post(Uri.parse('$baseUrl/login'),
        body: encodedJson, headers: {'Accept': 'application/json', 'content-Type': 'application/json'});
    setState(() {
      isLoading = false;
      isEnable = true;
    });

    if (response.statusCode == 200) {
      var temp = jsonDecode(response.body)['user'];
      if (temp != null) {
        UserData userData = UserData.fromjson(jsonDecode(response.body));
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('username', jsonEncode(email.text));
        localStorage.setString('password', jsonEncode(password.text));
        localStorage.setString('user_type', jsonEncode('1'));

        if (userData.user != null) {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Welcome(
                        userData: userData,
                      )));
        } else {
          _showMsg(
              'check Email ID/ Phone Number or password',
              const Icon(
                Icons.check,
                color: Colors.green,
              ));
        }
      } else {
        _showMsg(
            'check Email ID/ Phone Number or password',
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

  //getting saved language by default

  getLanguage() async {
    SharedPreferences localstorage = await SharedPreferences.getInstance();
    String? lang = localstorage.getString('lang');
    // ignore: use_build_context_synchronously
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    if (lang != null) {
      provider.setLocale(Locale(lang));
    } else {
      provider.setLocale(const Locale('en'));
    }
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
    _checkIfLoggedIn();
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppHeader(
              text: AppLocalizations.of(context)!.login, //'Login',
              visible: false,
            ),
            const SizedBox(
              height: 50.0,
            ),
            Column(
              children: [
                isLoading
                    ? const Center(
                        child: Loading(),
                      )
                    : Column(
                        children: [
                          Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                        child: Text(AppLocalizations.of(context)!
                                            .emailIDNumber), //Text('Email/ID Number'),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: ApptextField(controller: email),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                                        child: Text(
                                            AppLocalizations.of(context)!.password), //Text('Password'),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: ApptextField(
                                            controller: password,
                                            obscureText: true,
                                          ),
                                        ),
                                      ),
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
                                          onpressed: isEnable
                                              ? () {
                                                  if (email.text.isEmpty && password.text.isEmpty) {
                                                    setState(() => validationTxt =
                                                        AppLocalizations.of(context)!.emailphone);
                                                    _showMsg(
                                                        validationTxt,
                                                        const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ));
                                                  } else if (password.text.isEmpty) {
                                                    setState(() => validationTxt =
                                                        AppLocalizations.of(context)!.phoneOnly);
                                                    _showMsg(
                                                        validationTxt,
                                                        const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ));
                                                  } else if (email.text.isEmpty) {
                                                    setState(() => validationTxt =
                                                        AppLocalizations.of(context)!.phoneorEmail);
                                                    _showMsg(
                                                        validationTxt,
                                                        const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ));
                                                  } else {
                                                    login();
                                                  }
                                                }
                                              : null,
                                          text: AppLocalizations.of(context)!.login, //'Login',
                                          textColor: Colors.white,
                                        ),
                                      ))
                                    ],
                                  ),
                                ],
                              )),
                          const SizedBox(
                            height: 20.0,
                          ),
                          InkWell(
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword, //'Forgot Password?',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(
                                  context, MaterialPageRoute(builder: (context) => ForgotPassword()));
                            },
                          ),
                          const SizedBox(
                            height: 60,
                          ),
                          Text(
                            AppLocalizations.of(context)!.newUser, //'New User?',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          InkWell(
                            child: Text(
                              AppLocalizations.of(context)!.registerhere, //'Register here',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) => const Registration()));
                            },
                          )
                        ],
                      )
              ], //copy here
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
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
