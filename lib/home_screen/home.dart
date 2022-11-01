import 'dart:convert';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:seller_side/buyer/new_request.dart';
import 'package:seller_side/home_screen/invoice.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/models/request_status.dart';
import 'package:seller_side/models/searchreq.dart';
import 'package:seller_side/models/user.dart';
import 'package:seller_side/orders/requestStatus.dart';
import 'package:seller_side/widgets/loader.dart';
import '../constants.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  final UserData? userData;
  const HomeScreen({Key? key, this.userData}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController invoiceID = TextEditingController();
  Color? buyerContainerColor = Colors.black;
  Color? sellerContainerColor = Colors.grey[300];
  Color? buyerTextColor = Colors.white;
  Color? sellerTextColor = Colors.grey;
  bool seller = false;
  String completed = '0';
  String pending = '0';
  String rejected = '0';
  bool isLoading = false;
  bool blockTouch = false; //to block tap of any

//request status
  Future requestStatus() async {
    setState(() => isLoading = true);
    var token = widget.userData!.token;
    final response = await http.get(
      Uri.parse('$baseUrl/requests'),
      headers: {
        //'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    setState(() => isLoading = false);
    if (response.statusCode == 200) {
      RequestStatus reqstatus = RequestStatus.fromjson(jsonDecode(response.body));
      setState(() {
        completed = reqstatus.data.completed.toString();
        rejected = reqstatus.data.rejected.toString();
        pending = reqstatus.data.pending.toString();
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

  //search request api
  Future searchRequest(String requestid) async {
    setState(() {
      isLoading = true;
      blockTouch = true;
    });
    var token = widget.userData!.token;
    final http.Response response = await http.post(
      Uri.parse('$baseUrl/search-request'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'request_id': requestid,
      }),
    );
    setState(() {
      isLoading = false;
      blockTouch = false;
    });
    if (response.statusCode == 200) {
      SearchReqData requestData = SearchReqData.fromJson(json.decode(response.body));
      if (requestData.data != null) {
        if (requestData.data!.status == 1) {
          _showMsg(
              // ignore: use_build_context_synchronously
              AppLocalizations.of(context)!.reqcompleted,
              const Icon(
                Icons.check,
                color: Colors.green,
              ));
        } else {
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Invoice(
                        userdata: widget.userData!,
                        searchData: requestData,
                        isMoveNext: true,
                      )));
        }
      } else {
        _showMsg(
            // ignore: use_build_context_synchronously
            AppLocalizations.of(context)!.nodatainvoice,
            const Icon(
              Icons.close,
              color: Colors.red,
            ));
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

  @override
  void initState() {
    super.initState();
    requestStatus();
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
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(children: [
            Row(
              children: const [Image(image: AssetImage('assets/hand.png'))],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    AppLocalizations.of(context)!.hello, //'Hello',
                    style: const TextStyle(color: Colors.grey, fontSize: 20.0),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    widget.userData!.user!.name.toString(),
                    //AppLocalizations.of(context)!.aamirHussain, //'Aamir Hussain !',
                    style: const TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                  ),
                ))
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
                height: 70,
                decoration:
                    BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: buyerContainerColor),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.buyer, //'Buyer',
                              style: TextStyle(color: buyerTextColor, fontSize: 18.0),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            buyerContainerColor = Colors.black;
                            buyerTextColor = Colors.white;
                            sellerContainerColor = Colors.grey[300];
                            sellerTextColor = Colors.grey;
                            seller = false;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {});
                          _showMsg(
                              AppLocalizations.of(context)!.buyertype,
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ));
                        },
                      )),
                      Expanded(
                          child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0), color: sellerContainerColor),
                          height: 50,
                          width: MediaQuery.of(context).size.width / 2,
                          child: Center(
                            child: Text(
                              AppLocalizations.of(context)!.seller, //'Seller',
                              style: TextStyle(color: sellerTextColor, fontSize: 18.0),
                            ),
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            buyerContainerColor = Colors.grey[300];
                            buyerTextColor = Colors.grey;
                            sellerContainerColor = Colors.black;
                            sellerTextColor = Colors.white;
                            seller = true;
                          });
                          Future.delayed(const Duration(milliseconds: 100), () {});
                          _showMsg(
                              AppLocalizations.of(context)!.sellertype,
                              const Icon(
                                Icons.check,
                                color: Colors.green,
                              ));
                        },
                      )),
                    ],
                  ),
                )),
            const SizedBox(
              height: 10.0,
            ),
            isLoading
                ? const SizedBox(
                    height: 270,
                    child: Loading(),
                  )
                : Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: blockTouch
                                ? null
                                : () {
                                    if (pending != '0') {
                                      setState(() => blockTouch = true);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RequestStatusDetail(
                                                    status: '0',
                                                    title: AppLocalizations.of(context)!.pending,
                                                    userdata: widget.userData!,
                                                  )));
                                    } else {
                                      setState(() => blockTouch = false);
                                      _showMsg(
                                          AppLocalizations.of(context)!.norequest,
                                          const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ));
                                    }
                                  },
                            child: Container(
                                margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xffF4BD05), style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(10.0)),
                                height: MediaQuery.of(context).size.height / 5,
                                //width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Image(image: AssetImage('assets/again.png')),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      pending,
                                      style: const TextStyle(
                                          color: Color(0xffF4BD05),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.pending, //'Pending',
                                      style: const TextStyle(
                                          color: Color(0xffF4BD05),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          )),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Expanded(
                              child: InkWell(
                            onTap: blockTouch
                                ? null
                                : () {
                                    if (rejected != '0') {
                                      setState(() => blockTouch = true);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RequestStatusDetail(
                                                    status: '2',
                                                    title: AppLocalizations.of(context)!.rejected,
                                                    userdata: widget.userData!,
                                                  )));
                                    } else {
                                      setState(() => blockTouch = false);
                                      _showMsg(
                                          AppLocalizations.of(context)!.norequest,
                                          const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ));
                                    }
                                  },
                            child: Container(
                                margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xffFF3B3B), style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(10.0)),
                                height: MediaQuery.of(context).size.height / 5,
                                //width: MediaQuery.of(context).size.width / 2,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Image(image: AssetImage('assets/rejected.png')),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      rejected,
                                      style: const TextStyle(
                                          color: Color(0xffF4BD05),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.rejected, //'Rejected',
                                      style: const TextStyle(
                                          color: Color(0xffFF3B3B),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          )),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: InkWell(
                            onTap: blockTouch
                                ? null
                                : () {
                                    if (completed != '0') {
                                      setState(() => blockTouch = true);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => RequestStatusDetail(
                                                    status: '1',
                                                    title: AppLocalizations.of(context)!.completed,
                                                    userdata: widget.userData!,
                                                  )));
                                    } else {
                                      setState(() => blockTouch = false);
                                      _showMsg(
                                          AppLocalizations.of(context)!.norequest,
                                          const Icon(
                                            Icons.close,
                                            color: Colors.red,
                                          ));
                                    }
                                  },
                            child: Container(
                                margin: const EdgeInsets.only(right: 5.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xff2CC91F), style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(10.0)),
                                height: MediaQuery.of(context).size.height / 7.5,
                                //width: MediaQuery.of(context).size.width / 2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Image(image: AssetImage('assets/accepted.png')),
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      completed, //'Completed',
                                      style: const TextStyle(
                                          color: Color(0xff2CC91F),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(
                                      width: 20.0,
                                    ),
                                    Text(
                                      AppLocalizations.of(context)!.completed, //'Completed',
                                      style: const TextStyle(
                                          color: Color(0xff2CC91F),
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )),
                          )),
                        ],
                      ),
                    ],
                  ),
            const SizedBox(
              height: 10.0,
            ),
            Visibility(
              visible: seller,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 15),
                    child: Text(AppLocalizations.of(context)!.enterInvoice), //Text('Enter Invoice #'),
                  )
                ],
              ),
            ),
            (seller)
                ? Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 1.8,
                            child: ApptextField(controller: invoiceID),
                          )),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AppButton(
                                text: AppLocalizations.of(context)!.search, //'Search',
                                textColor: Colors.white,
                                color: const Color(0xff128383),
                                onpressed: blockTouch
                                    ? null
                                    : () {
                                        if (invoiceID.text.isNotEmpty) {
                                          searchRequest(invoiceID.text);
                                        } else {
                                          _showMsg(
                                              AppLocalizations.of(context)!.enterinvoicenumber,
                                              const Icon(
                                                Icons.close,
                                                color: Colors.red,
                                              ));
                                        }
                                      },
                              ))),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AppButton(
                                text: AppLocalizations.of(context)!.newRequest, //'Search',
                                textColor: Colors.white,
                                color: const Color(0xff128383),
                                onpressed: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NewRequest(
                                                userData: widget.userData!,
                                              )));
                                },
                              )))
                    ],
                  )
          ]),
        ),
      ),
    )));
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
