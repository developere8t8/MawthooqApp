import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/models/comission.dart';
import 'package:seller_side/post_login/welcome.dart';
import 'package:seller_side/widgets/loader.dart';
import 'package:share_plus/share_plus.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import '../models/request.dart';
import '../models/user.dart';

class BuyerConfirmation extends StatefulWidget {
  final UserData userData;
  final Request request;
  const BuyerConfirmation({Key? key, required this.request, required this.userData}) : super(key: key);

  @override
  State<BuyerConfirmation> createState() => _BuyerConfirmationState();
}

class _BuyerConfirmationState extends State<BuyerConfirmation> {
  double netTotal = 0;
  bool isLoading = false;
  int paymentMethod = 1;
  Color creditcardColor = Colors.black;
  Color crediteCardTxt = Colors.white;
  Color walletColor = const Color(0xFFE3E1E1);
  Color walletTxt = const Color(0xFF969696);
  Commission? commission;
  //get commission
  Future getCommission() async {
    setState(() {
      isLoading = true;
    });
    var token = widget.userData.token;
    final response = await http.get(
      Uri.parse('$baseUrl/get_general_data'),
      headers: {
        //'content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      setState(() {
        commission = Commission.fromJson(jsonDecode(response.body));
        netTotal = double.parse(widget.request.reqData.price) + commission!.data!.commision!;
      });
    }
  }

  // update payment method

  Future setPaymentMethod() async {
    setState(() => isLoading = true);
    var token = widget.userData.token;
    final response = await http.post(Uri.parse('$baseUrl/update-request'), headers: {
      //'content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    }, body: {
      'request_id': widget.request.reqData.requestID.toString(),
      'payment_method': paymentMethod.toString()
    });
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    AppLocalizations.of(context)!.messages,
                    style: const TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF383838)),
                  ),
                ),
                content: SizedBox(
                  height: 80,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 16, color: Color(0xFF969696)),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.invoice34 +
                            widget.request.reqData.requestID.toString(),
                        style: const TextStyle(
                            fontFamily: 'Roboto', fontSize: 16, color: Color(0xFF1BA9E4)),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    width: 400,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: MaterialButton(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(70))),
                        color: const Color(0xFF128383),
                        onPressed: () {
                          Share.share('Invoice # ${widget.request.reqData.requestID}');
                        },
                        child: Text(
                          AppLocalizations.of(context)!.shareInvoiceNumber,
                          style: const TextStyle(
                              fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold),
                        )),
                  ),
                  CloseButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Welcome(userData: widget.userData)));
                    },
                  )
                ],
              ));
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
    getCommission();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
        body: DoubleBackToCloseApp(
      snackBar: SnackBar(
        content: Text(AppLocalizations.of(context)!.backagaintoexit),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
              child: Row(
                children: [
                  InkWell(
                      onTap: () => Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Welcome(userData: widget.userData))),
                      child: const Icon(
                        Icons.arrow_back,
                      )),
                  SizedBox(
                    width: width * 0.02,
                  ),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.confirmation, //"Confirmation",
                      style: const TextStyle(
                          fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: isLoading
                    ? const Loading()
                    : Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(AppLocalizations.of(context)!.total, //"Total",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF969696),
                                      )),
                                ),
                                SizedBox(
                                  width: width * 0.40,
                                ),
                                Expanded(
                                    child: Text(
                                  "\$${widget.request.reqData.price}",
                                  style:
                                      const TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(AppLocalizations.of(context)!.commission, //"Commission",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF969696),
                                      )),
                                ),
                                SizedBox(
                                  width: width * 0.40,
                                ),
                                Expanded(
                                    child: Text(
                                  commission != null ? '\$${commission!.data!.commision}' : '\$0.00',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ))
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.02, width * 0.05, 0),
                            child: const Divider(color: Color(0xFF969696)),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(AppLocalizations.of(context)!.netAmmount, //"Net Amount",
                                      style: const TextStyle(
                                        fontFamily: 'Roboto',
                                        color: Color(0xFF969696),
                                      )),
                                ),
                                SizedBox(
                                  width: width * 0.40,
                                ),
                                Expanded(
                                    child: Text("\$${netTotal}",
                                        style: const TextStyle(
                                            color: Color(0xFF1BA9E4),
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.bold)))
                              ],
                            ),
                          ),
                          Container(
                            color: const Color(0xFF969696),
                            height: 0.8,
                            margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.02, width * 0.05, 0),
                          ),
                          Container(
                              margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.03, width * 0.05, 0),
                              child: Text(
                                AppLocalizations.of(context)!.paymentMethod, //"Payment Method",
                                style: const TextStyle(
                                    fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 18),
                              )),
                          Container(
                            width: width * 1,
                            padding: const EdgeInsets.all(2),
                            margin: EdgeInsets.fromLTRB(width * 0.05, height * 0.02, width * 0.05, 0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width * 0.42,
                                  child: MaterialButton(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(70))),
                                      color: creditcardColor,
                                      onPressed: () {
                                        setState(() {
                                          creditcardColor = Colors.black;
                                          crediteCardTxt = Colors.white;
                                          walletColor = const Color(0xFFE3E1E1);
                                          walletTxt = const Color(0xFF969696);
                                          paymentMethod = 1;
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.creditCard, //Credit Card",
                                        style: TextStyle(
                                          color: crediteCardTxt,
                                          fontFamily: 'Roboto',
                                        ),
                                      )),
                                ),
                                SizedBox(
                                  width: width * 0.04,
                                ),
                                SizedBox(
                                  width: width * 0.42,
                                  child: MaterialButton(
                                      shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(70))),
                                      color: walletColor,
                                      elevation: 0,
                                      onPressed: () {
                                        setState(() {
                                          creditcardColor = const Color(0xFFE3E1E1);
                                          crediteCardTxt = const Color(0xFF969696);
                                          walletColor = Colors.black;
                                          walletTxt = Colors.white;
                                          paymentMethod = 0;
                                        });
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.wallet, //"Wallet",
                                        style: TextStyle(fontFamily: 'Roboto', color: walletTxt),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: width * 1,
                            margin: EdgeInsets.fromLTRB(width * 0.02, height * 0.05, width * 0.02, 0),
                            child: MaterialButton(
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(70))),
                                color: const Color(0xFF128383),
                                onPressed: () {
                                  setPaymentMethod();
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.confirmPay, //"Confirm & Pay",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Roboto',
                                  ),
                                )),
                          ),
                        ],
                      )),
          ],
        ),
      ),
    ));
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

showAlertDialog(BuildContext context) {
  // Create button

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Align(
      alignment: Alignment.topCenter,
      child: Text(
        AppLocalizations.of(context)!.messages,
        style: const TextStyle(
            fontFamily: 'Roboto', fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF383838)),
      ),
    ),
    content: SizedBox(
      height: 80,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context)!.description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Color(0xFF969696)),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context)!.invoice34,
            style: const TextStyle(fontFamily: 'Roboto', fontSize: 16, color: Color(0xFF1BA9E4)),
          ),
        ],
      ),
    ),
    actions: [
      Container(
        width: 400,
        margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(70))),
              primary: const Color(0xFF128383),
            ),
            onPressed: () {
              Share.share('Something to share');
            },
            child: const Text(
              'Share Invoice Number',
              style: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.bold),
            )),
      ),
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
