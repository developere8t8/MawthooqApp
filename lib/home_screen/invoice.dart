import 'dart:io';
import 'package:intl/intl.dart' show DateFormat;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:seller_side/home_screen/agreement.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/models/searchreq.dart';
import 'package:seller_side/models/user.dart';
import 'package:seller_side/post_login/welcome.dart';
import '../widgets/app_button.dart';

import 'package:double_back_to_close_app/double_back_to_close_app.dart';

class Invoice extends StatefulWidget {
  final UserData userdata;
  final bool isMoveNext;
  final SearchReqData searchData;
  const Invoice({Key? key, required this.userdata, required this.searchData, required this.isMoveNext})
      : super(key: key);

  @override
  State<Invoice> createState() => _InvoiceState();
}

class _InvoiceState extends State<Invoice> {
  List<XFile?> img = [];
  //bool isMoveNext = true;
  // checkMoveNext() {
  //   if (widget.searchData.data!.status == 1) {
  //     setState(() {
  //       isMoveNext = false;
  //     });
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              AppLocalizations.of(context)!.invoice34 +
                  widget.searchData.data!.id.toString(), //'Invoice # 34',
              style: const TextStyle(color: Colors.black),
            ),
            leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => Welcome(userData: widget.userdata)));
              },
            ),
          ),
          body: DoubleBackToCloseApp(
            snackBar: SnackBar(
              content: Text(AppLocalizations.of(context)!.backagaintoexit),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (context) => InvoicePageSecond()));
                        },
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: widget.searchData.data!.status == 0
                                    ? const Color(0xffF4BD05)
                                    : widget.searchData.data!.status == 1
                                        ? const Color(0xff2CC91F)
                                        : const Color(0xffFF3B3B),
                                borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                                widget.searchData.data!.status == 0
                                    ? AppLocalizations.of(context)!.pending
                                    : widget.searchData.data!.status == 1
                                        ? AppLocalizations.of(context)!.completed
                                        : AppLocalizations.of(context)!.rejected, //'status',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            )),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.black, borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                                'Request Date : ${DateFormat('MMM/dd/yyyy').format(DateTime.parse(widget.searchData.data!.createdAt.toString()))}',
                                style: const TextStyle(color: Colors.white, fontSize: 10.5),
                              ),
                            )),
                      ),
                      Expanded(
                          child: Visibility(
                        visible: widget.searchData.data!.status == 1 ? true : false,
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            decoration: BoxDecoration(
                                color: Colors.black, borderRadius: BorderRadius.circular(20.0)),
                            child: Center(
                              child: Text(
                                'Accept Date : ${DateFormat('MMM/dd/yyyy').format(DateTime.parse(widget.searchData.data!.updatedAt.toString()))}',
                                style: const TextStyle(color: Colors.white, fontSize: 10.5),
                              ),
                            )),
                      )),
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
                          widget.searchData.data!.buyer!.name.toString(), //'Alert Title',
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
                          widget.searchData.data!.itemType.toString(), //'Alert Title',
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
                        padding: const EdgeInsets.fromLTRB(0, 7, 0, 7),
                        child: Text(
                          "\$ ${widget.searchData.data!.price.toString()}", //'Alert Title',
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
                          AppLocalizations.of(context)!.details, //'Alert Title',
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
                          child: Text(
                        widget.searchData.data!.details.toString(),
                        //overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.black, fontSize: 12.0, fontWeight: FontWeight.normal),
                      ))
                    ],
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width * 1,
                      margin: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.015, 0, 0),
                      child: Text(
                        AppLocalizations.of(context)!.files, //"Details",
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Roboto',
                            color: Color(0xFF969696),
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 60,
                    child: Row(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                itemCount: widget.searchData.data!.attachment!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                primary: false,
                                itemBuilder: (context, index) {
                                  return showImages(widget.searchData.data!.attachment![index].link!);
                                }))
                      ],
                    ),
                  ),
                  Visibility(
                      visible: widget.searchData.data!.status == 1 ? true : false,
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
                            child: Divider(
                              color: Colors.black.withOpacity(0.15),
                              thickness: 1,
                            ),
                          ),
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
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                      child: Text(
                                        AppLocalizations.of(context)!.deliveryMethod, //'Alert Title',
                                        style: const TextStyle(
                                            color: Color(0xFF969696),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
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
                                        widget.searchData.data!.deliveryMethod == 0
                                            ? AppLocalizations.of(context)!.byHand
                                            : AppLocalizations.of(context)!.byPost, //'Alert Title',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
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
                                        AppLocalizations.of(context)!.company, //'Alert Title',
                                        style: const TextStyle(
                                            color: Color(0xFF969696),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
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
                                        widget.searchData.data!.deliveryCompany == null
                                            ? ''
                                            : widget.searchData.data!.deliveryCompany
                                                .toString(), //'Alert Title',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
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
                                        AppLocalizations.of(context)!.number, //'Alert Title',
                                        style: const TextStyle(
                                            color: Color(0xFF969696),
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
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
                                        widget.searchData.data!.trackingNumber == null
                                            ? ''
                                            : widget.searchData.data!.trackingNumber
                                                .toString(), //'Alert Title',
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ))
                                  ],
                                ),
                                SizedBox(
                                  height: 60,
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: ListView.builder(
                                              itemCount: widget.searchData.data!.deliveryDocs!.length,
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              primary: false,
                                              itemBuilder: (context, index) {
                                                return showImages(
                                                    widget.searchData.data!.deliveryDocs![index].link!);
                                              }))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      )),
                  const SizedBox(
                    height: 2,
                  ),
                  Visibility(
                    visible: widget.isMoveNext,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: AppButton(
                            color: const Color(0xff128383),
                            onpressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Agreement(
                                            userData: widget.userdata,
                                            searchData: widget.searchData,
                                          )));
                            },
                            text: AppLocalizations.of(context)!.proceedtoAgreement,
                            textColor: Colors.white,
                          ),
                        ))
                      ],
                    ),
                  )
                ],
              )),
            ),
          )),
    );
  }
  //
  //
  //image sources

  showImageSource(BuildContext context) async {
    return await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    final image = await ImagePicker().pickImage(source: ImageSource.camera);
                    if (image == null) {
                      return;
                    } else {
                      setState(() {
                        img.add(image);
                      });
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  }),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  final List<XFile>? images = await ImagePicker().pickMultiImage();
                  if (images == null) {
                    return;
                  } else {
                    setState(() {
                      img.addAll(images);
                    });
                  }
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  //images collection

  Widget getPickedImage(String path, int index) {
    return Stack(
      children: [
        Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.file(
                File(path),
                fit: BoxFit.fill,
              )),
        ),
        Positioned(
            bottom: 0,
            left: 32,
            top: 28,
            right: 0,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    img.removeAt(index);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )))
      ],
    );
  }

  //showing images
  Widget showImages(String imageUrl) {
    return Container(
      height: 60,
      width: 60,
      margin: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
      child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          child: Image.network(
            imageUrl,
            fit: BoxFit.fill,
          )),
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
