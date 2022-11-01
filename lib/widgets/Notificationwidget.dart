import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:seller_side/widgets/loader.dart';

class NotificationList extends StatefulWidget {
  final String title;
  final String created_at;
  final String description;
  final String status;
  final int alertId;
  final UserData userData;

  const NotificationList(
      {Key? key,
      required this.title,
      required this.created_at,
      required this.description,
      required this.status,
      required this.userData,
      required this.alertId})
      : super(key: key);

  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  bool isLoading = false;
  bool visible = true;
  //updating notification
  Future updateNotification() async {
    setState(() => isLoading = true);

    var token = widget.userData.token;
    final response = await http.post(Uri.parse('$baseUrl/update-alert'), headers: {
      //'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'alert_id': widget.alertId.toString()
    });
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      setState(() {
        visible = false;
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
    visible = widget.status == '0' ? true : false;
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const Loading()
      : InkWell(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            margin: const EdgeInsets.only(top: 15.0),
            //height: 170,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.black, borderRadius: BorderRadius.circular(20.0)),
                        child: Center(
                          child: Text(
                            widget.created_at,
                            style: const TextStyle(color: Colors.white),
                          ),
                        )),
                    Visibility(
                        visible: visible,
                        child: Container(
                            height: 30,
                            width: 80,
                            decoration: BoxDecoration(
                                color: Colors.red, borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                                AppLocalizations.of(context)!.unread, //'Unread',
                                style: const TextStyle(color: Colors.white),
                              ),
                            )))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        widget.title, //'Alert Title',
                        style: const TextStyle(
                            color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        widget.description,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
          onTap: () {
            updateNotification();
          },
        );
  //}

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
