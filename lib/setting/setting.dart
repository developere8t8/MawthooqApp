import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seller_side/login_screen/login.dart';
import 'package:seller_side/models/user.dart';
import 'package:seller_side/provider/local_provider.dart';
import 'package:seller_side/setting/bank_info.dart';
import 'package:seller_side/setting/privacy.dart';
import 'package:seller_side/setting/support.dart';
import 'package:seller_side/setting/terms.dart';
import 'package:seller_side/widgets/app_button.dart';
import 'package:seller_side/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:http/http.dart' as http;
import '../constants.dart';
import '../edit_profile/edit_profile.dart';

class SettingScreen extends StatefulWidget {
  final UserData userData;
  const SettingScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isLoading = false;
  int labelindex = 0; //language switch index

//logging out
  Future logOut() async {
    setState(() => isLoading = true);
    var token = widget.userData.token;
    final response = await http.get(
      Uri.parse('$baseUrl/logout'),
      headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      final success = localStorage.remove('username');
      final success2 = localStorage.remove('password');
      final success3 = localStorage.remove('user_type');

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(response.statusCode.toString()),
                content: Text(response.body.toString()),
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
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.more, //'More',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        widget.userData.user!.photo != null
                            ? InkWell(
                                child: CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: NetworkImage(widget.userData.user!.photo),
                                ),
                                onTap: () {},
                              )
                            : InkWell(
                                child: const CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage: AssetImage('assets/imagegirl.png'),
                                ),
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Update_User(
                                                userData: widget.userData,
                                              )));
                                },
                              ),
                        Text(widget.userData.user!.name.toString()),
                        Container(
                          margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          color: Colors.grey,
                          height: 2.0,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Column(
                          children: [
                            isLoading
                                ? const Center(
                                    child: Loading(),
                                  )
                                : ListView(
                                    shrinkWrap: true,
                                    children: [
                                      ListTile(
                                          leading: CircleAvatar(
                                            radius: 20.0,
                                            backgroundColor: Colors.transparent,
                                            child: Image.asset('assets/lang.png'),
                                          ),
                                          title: Text(AppLocalizations.of(context)!
                                              .language), //const Text('Language'),
                                          trailing: Container(
                                            padding: const EdgeInsets.all(3.0),
                                            width: 135.0,
                                            height: 35.0,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20.0),
                                                border: Border.all(color: Colors.grey[400]!),
                                                color: Colors.grey[100]),
                                            child: ToggleSwitch(
                                              minWidth: 60.0,
                                              minHeight: 25.0,
                                              cornerRadius: 20.0,
                                              activeBgColors: const [
                                                [Colors.black],
                                                [Colors.black],
                                              ],
                                              activeFgColor: Colors.white,
                                              inactiveBgColor: Colors.grey[100],
                                              inactiveFgColor: Colors.black,
                                              initialLabelIndex: labelindex,
                                              totalSwitches: 2,
                                              labels: const ['Eng', 'العربية'],
                                              radiusStyle: true,
                                              onToggle: (index) async {
                                                SharedPreferences localstorage =
                                                    await SharedPreferences.getInstance();
                                                // ignore: use_build_context_synchronously
                                                final provider =
                                                    Provider.of<LocaleProvider>(context, listen: false);
                                                if (index == 0) {
                                                  setState(() {
                                                    provider.setLocale(const Locale('en'));
                                                    labelindex = 0;
                                                    localstorage.setString('lang', 'en');
                                                  });
                                                } else {
                                                  setState(() {
                                                    provider.setLocale(const Locale('ar'));
                                                    labelindex = 1;
                                                    localstorage.setString('lang', 'ar');
                                                  });
                                                }
                                              },
                                            ),
                                          )),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/credit_card.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .bankinfo), //const Text('About'),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => Bank_Info(
                                                            userData: widget.userData,
                                                          )));
                                            },
                                            icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/privacy.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .privacy), //const Text('Privacy'),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PrivacyPolicy(user: widget.userData)));
                                            },
                                            icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/tc.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .termsConditions), //const Text('Terms & Conditions'),
                                        trailing: IconButton(
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          TermsConditions(user: widget.userData)));
                                            },
                                            icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/about.png'),
                                        ),
                                        title: Text(
                                            AppLocalizations.of(context)!.about), //const Text('About'),
                                        trailing: IconButton(
                                            onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/support.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .support), //const Text('Support'),
                                        trailing: IconButton(
                                            onPressed: () {
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //             Support(user: widget.userData)));
                                            },
                                            icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/export.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .shareApp), //const Text('Share App'),
                                        trailing: IconButton(
                                            onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/rate.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .rateUs), //const Text('Rate Us'),
                                        trailing: IconButton(
                                            onPressed: () {}, icon: const Icon(Icons.arrow_forward)),
                                      ),
                                      ListTile(
                                        leading: CircleAvatar(
                                          radius: 20.0,
                                          backgroundColor: Colors.transparent,
                                          child: Image.asset('assets/logout.png'),
                                        ),
                                        title: Text(AppLocalizations.of(context)!
                                            .logout), //const Text('Logout'),
                                        trailing: IconButton(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                        title: const Text('Confirm Please'),
                                                        content: const Text('Are You sure to logout'),
                                                        actions: [
                                                          AppButton(
                                                            color: const Color(0xff128383),
                                                            text: 'Yes',
                                                            onpressed: () {
                                                              Navigator.pop(context);
                                                              logOut();
                                                            },
                                                          ),
                                                          AppButton(
                                                            text: 'No',
                                                            onpressed: () {
                                                              Navigator.pop(context);
                                                            },
                                                            color: Colors.red,
                                                          ),
                                                        ],
                                                      ));
                                            },
                                            icon: const Icon(Icons.arrow_forward)),
                                      )
                                    ],
                                  )
                          ],
                        )
                      ],
                    ),
                  ),
                ))));
  }
}
