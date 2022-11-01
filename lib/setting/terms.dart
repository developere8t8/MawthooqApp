import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/models/policy.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../widgets/header_container.dart';
import 'package:flutter_html/flutter_html.dart';

class TermsConditions extends StatefulWidget {
  final UserData user;
  const TermsConditions({Key? key, required this.user}) : super(key: key);

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  String policyTxt = '';
  bool isLoading = false;

  //getting policy txt

  Future getPolicy() async {
    setState(() => isLoading = true);
    var token = widget.user.token;
    final response = await http.post(
      Uri.parse('$baseUrl/pages'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        //'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, dynamic>{
        'id': '1',
      }),
    );
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      Policy policy = Policy.fromJson(jsonDecode(response.body));
      if (policy.data != null) {
        setState(() {
          policyTxt = policy.data!.contentData!.endata!;
        });
      }
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
    getPolicy();
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
                text: AppLocalizations.of(context)!.termsConditions,
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
                  : Padding(padding: const EdgeInsets.all(15.0), child: Html(data: policyTxt))
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
