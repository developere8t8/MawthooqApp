import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/constants.dart';
import 'package:http/http.dart' as http;
import 'package:seller_side/widgets/loader.dart';
import '../models/alert.dart';
import '../models/user.dart';
import '../widgets/Notificationwidget.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class NotificationScreen extends StatefulWidget {
  final UserData userData;
  const NotificationScreen({Key? key, required this.userData}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int listItem = 0;
  AlertModel? model;
  bool isLoading = false;
  Future getAlertData() async {
    setState(() => isLoading = true);

    var token = widget.userData.token;
    final response = await http.get(
      Uri.parse('$baseUrl/alerts'),
      headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      setState(() {
        model = AlertModel.fromJson(jsonDecode(response.body));
        listItem = model!.data.length;
      });
    } else {
      _showMsg('Server Error ${response.statusCode}', const Icon(Icons.close, color: Colors.red));
    }
  }

  //clear all alerts

  Future clearAlerts() async {
    setState(() => isLoading = true);

    var token = widget.userData.token;
    final response = await http.get(
      Uri.parse('$baseUrl/clear-alerts'),
      headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // print(response.body);
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      setState(() {
        listItem = 0;
      });
    } else {
      _showMsg('Server Error ${response.statusCode}', const Icon(Icons.close, color: Colors.red));
    }
  }

  @override
  void initState() {
    super.initState();
    getAlertData();
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
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.alerts, //'Alerts',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                          InkWell(
                            child: Text(
                              AppLocalizations.of(context)!.clearAll, //'Clear All',
                              style: const TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              clearAlerts();
                            },
                          )
                        ],
                      ),
                      isLoading
                          ? const Loading()
                          : Expanded(
                              child: ListView.builder(
                                itemCount: listItem,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return NotificationList(
                                    title: model!.data[index].title!,
                                    created_at: model!.data[index].createdAt!,
                                    description: model!.data[index].description!,
                                    status: model!.data[index].status!,
                                    userData: widget.userData,
                                    alertId: model!.data[index].id!,
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ))));
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
