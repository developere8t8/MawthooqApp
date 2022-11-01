import 'package:flutter/material.dart';
import 'package:seller_side/home_screen/home.dart';
import 'package:seller_side/setting/setting.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import '../models/user.dart';
import '../notification/notification.dart';

class Welcome extends StatefulWidget {
  final UserData userData;

  const Welcome({Key? key, required this.userData}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int currentIndex = 0;
  var screens = [];

  @override
  void initState() {
    super.initState();
    screens = [
      HomeScreen(userData: widget.userData),
      NotificationScreen(userData: widget.userData),
      SettingScreen(
        userData: widget.userData,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home, //'Home',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.notifications),
              label: AppLocalizations.of(context)!.alerts, //'Alerts',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.more_vert),
              label: AppLocalizations.of(context)!.more, //'More',
            )
          ]),
    ));
  }
}
