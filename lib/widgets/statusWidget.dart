import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/constants.dart';
import 'package:seller_side/models/searchreq.dart';
import 'package:seller_side/models/user.dart';
import 'package:http/http.dart' as http;
import '../home_screen/invoice.dart';

class Statuswidget extends StatefulWidget {
  final String status;
  final String itemtype;
  final String price;
  final String detail;
  final UserData userData;
  final int reqID;
  final String buyer;
  const Statuswidget(
      {Key? key,
      required this.detail,
      required this.itemtype,
      required this.price,
      required this.status,
      required this.userData,
      required this.reqID,
      required this.buyer})
      : super(key: key);

  @override
  State<Statuswidget> createState() => _StatuswidgetState();
}

class _StatuswidgetState extends State<Statuswidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    decoration: BoxDecoration(
                        color: widget.status == 'Pending'
                            ? const Color(0xFFF2CC59)
                            : widget.status == 'Rejected'
                                ? const Color(0xffFF3B3B)
                                : const Color(0xff2CC91F),
                        borderRadius: BorderRadius.circular(20.0)),
                    child: Center(
                      child: Text(
                        widget.status, //'Unread',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.buyer, //'Alert Title',
                    style: const TextStyle(
                        color: Color(0xFF969696), fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text(
                    widget.buyer.toString(), //'Alert Title',
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.invoice34, //'Alert Title',
                    style: const TextStyle(
                        color: Color(0xFF969696), fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text(
                    widget.reqID.toString(), //'Alert Title',
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.itemtype, //'Alert Title',
                    style: const TextStyle(
                        color: Color(0xFF969696), fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text(
                    widget.itemtype, //'Alert Title',
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.price,
                    style: const TextStyle(
                        color: Color(0xFF969696), fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                  child: Text(
                    "\$${widget.price}",
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
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Text(
                    AppLocalizations.of(context)!.details,
                    style: const TextStyle(
                        color: Color(0xFF969696), fontSize: 15.0, fontWeight: FontWeight.bold),
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
                    widget.detail,
                    //overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
                  ),
                ))
              ],
            )
          ],
        ),
      ),
      onTap: () async {
        setState(() => isLoading = true);
        var token = widget.userData.token;
        final http.Response response = await http.post(
          Uri.parse('$baseUrl/search-request'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(<String, String>{
            'request_id': widget.reqID.toString(),
          }),
        );
        setState(() => isLoading = false);
        if (response.statusCode == 200) {
          SearchReqData requestData = SearchReqData.fromJson(json.decode(response.body));
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Invoice(
                        userdata: widget.userData,
                        searchData: requestData,
                        isMoveNext: false,
                      )));
        } else {
          _showMsg(
              'Server Error ${response.statusCode}',
              const Icon(
                Icons.close,
                color: Colors.red,
              ));
        }
      },
    );
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
