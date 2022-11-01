import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/models/policy.dart';
import 'package:seller_side/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:http/http.dart' as http;
import '../widgets/header_container.dart';

class Support extends StatefulWidget {
  final UserData user;
  const Support({Key? key, required this.user}) : super(key: key);

  @override
  State<Support> createState() => _SupportState();
}

class _SupportState extends State<Support> {
  String policyTxt = '';
  bool isLoading = false;

  //getting policy txt

  Future getSupport() async {
    setState(() => isLoading = true);
    var token = widget.user.token;
    final response = await http.get(
      Uri.parse('$baseUrl/support-text'),
      headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      Policy policy = Policy.fromJson(jsonDecode(response.body));
      // if (policy.data!.text!.isNotEmpty) {
      //   setState(() {
      //     policyTxt = policy.data!.text!;
      //   });
      // }
    } else {
      _showMsg(
          'Server error ${response.statusCode}',
          const Icon(
            Icons.close,
            color: Colors.red,
          ));
    }
  }

  @override
  void initState() {
    super.initState();
    getSupport();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SafeArea(
          child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              AppHeader(
                visible: true,
                dothis: () {
                  Navigator.pop(context);
                },
                text: AppLocalizations.of(context)!.support,
              ),
              const SizedBox(
                height: 20,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        policyTxt,
                        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
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
