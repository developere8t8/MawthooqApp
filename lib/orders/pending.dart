import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/home_screen/invoice.dart';

class PendingScreen extends StatefulWidget {
  const PendingScreen({Key? key}) : super(key: key);

  @override
  State<PendingScreen> createState() => _PendingScreenState();
}

class _PendingScreenState extends State<PendingScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Padding(
      padding: const EdgeInsets.all(18.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.pending, //'Alerts',
                    style: const TextStyle(
                        color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Container(
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
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                  color: Color(0xFFF2CC59), borderRadius: BorderRadius.circular(20.0)),
                              child: Center(
                                child: Text(
                                  AppLocalizations.of(context)!.pending, //'Unread',
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: Text(
                              AppLocalizations.of(context)!.itemtype1, //'Alert Title',
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              AppLocalizations.of(context)!.price, //'Alert Title',
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
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: Text(
                              "\$0.00", //'Alert Title',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis risus mi. ',
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 15.0),
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
                          InkWell(
                            onTap: () {},
                            child: Container(
                                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                decoration: BoxDecoration(
                                    color: Color(0xFF148788), borderRadius: BorderRadius.circular(20.0)),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.accepted, //'Unread',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: Text(
                              AppLocalizations.of(context)!.itemtype1, //'Alert Title',
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
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Text(
                              AppLocalizations.of(context)!.price, //'Alert Title',
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
                            padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                            child: Text(
                              "\$0.00", //'Alert Title',
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold),
                            ),
                          ))
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Expanded(
                              child: Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc quis risus mi. ',
                              //overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    )));
  }
}
