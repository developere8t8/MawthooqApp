import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

//import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seller_side/models/acceptrequest.dart';
import 'package:seller_side/models/user.dart';
import 'package:seller_side/post_login/welcome.dart';
import 'package:seller_side/widgets/alert.dart';
import 'package:flutter_gen/gen_l10n/app_localization.dart';
import 'package:seller_side/widgets/loader.dart';
import 'package:share_plus/share_plus.dart';
import '../constants.dart';
import '../models/searchreq.dart';
import '../widgets/app_button.dart';
import '../widgets/app_textfield.dart';
import 'package:http/http.dart' as http;
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
//import 'package:image_picker_web/image_picker_web.dart';

class Confirmation extends StatefulWidget {
  final UserData userData;
  final SearchReqData searchData;
  const Confirmation({Key? key, required this.searchData, required this.userData}) : super(key: key);

  @override
  State<Confirmation> createState() => _ConfirmationState();
}

class _ConfirmationState extends State<Confirmation> {
  List<Uint8List> webimg = [];
  TextEditingController companyName = TextEditingController();
  TextEditingController trackingNumber = TextEditingController();
  Color? byHand = Colors.black;
  Color byHandTxt = Colors.white;
  Color? byPost = Colors.grey[300];
  Color byPostTxt = Colors.grey;
  bool visible = false;
  List<XFile?> img = [];
  bool isLoading = false;
  int deliveryMethos = 0; //0->by_hand, 1->by_post

  // update payment method

  Future setDeliveryMethod() async {
    setState(() => isLoading = true);
    var token = widget.userData.token;
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/update-request'));
    request.fields['request_id'] = widget.searchData.data!.id.toString();
    request.fields['delivery_method'] = deliveryMethos.toString();
    request.fields['delivery_company_name'] = companyName.text;
    request.fields['delivery_tracking_no'] = trackingNumber.text;
    if (kIsWeb) {
      for (var image in webimg) {
        List<int> imgList = image.cast();
        request.files.add(http.MultipartFile.fromBytes(
            'delivery_docs[${webimg.indexOf(image)}]', imgList,
            filename: 'photo${webimg.indexOf(image)}.png'));
      }
    } else {
      for (var image in img) {
        request.files
            .add(await http.MultipartFile.fromPath('delivery_docs[${img.indexOf(image)}]', image!.path));
      }
    }
    request.headers.addAll(headers);
    final response = await request.send();
    if (response.statusCode == 200) {
      //final resMultipart = jsonDecode(String.fromCharCodes(await response.stream.toBytes()));
      final res = await http.post(
          Uri.parse(
              '$baseUrl/update-request?request_id=${widget.searchData.data!.id}&seller_id=${widget.userData.user!.userid.toString()}'),
          headers: {
            'content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          });
      setState(() => isLoading = false);
      if (res.statusCode == 200) {
        AcceptRequest acceptRequest = AcceptRequest.fromjson(jsonDecode(res.body));
        if (acceptRequest.success == true) {
          _showMsg(
              // ignore: use_build_context_synchronously
              AppLocalizations.of(context)!.requestaccepted,
              const Icon(
                Icons.check,
                color: Colors.green,
              ));
          // ignore: use_build_context_synchronously
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Welcome(userData: widget.userData)));
        } else {
          _showMsg(
              // ignore: use_build_context_synchronously
              AppLocalizations.of(context)!.failtoacceptrequest,
              const Icon(
                Icons.check,
                color: Colors.green,
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
    } else {
      setState(() => isLoading = false);
      _showMsg(
          'Server Error ${response.statusCode}',
          const Icon(
            Icons.close,
            color: Colors.red,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context)!.confirmation, //'Confirmation',
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Welcome(userData: widget.userData)));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
      ),
      body: DoubleBackToCloseApp(
          snackBar: SnackBar(
            content: Text(AppLocalizations.of(context)!.backagaintoexit),
          ),
          child: isLoading
              ? const Loading()
              : Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.deliveryMethod, //'Delivery Method',
                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: InkWell(
                              child: Container(
                                margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0), color: byHand),
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.byHand, //'By Hand',
                                    style: TextStyle(color: byHandTxt, fontSize: 18.0),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  byHand = Colors.black;
                                  byHandTxt = Colors.white;
                                  byPost = Colors.grey[300];
                                  byPostTxt = Colors.grey;
                                  visible = false;
                                  deliveryMethos = 0;
                                });
                              },
                            )),
                            Expanded(
                                child: InkWell(
                              child: Container(
                                margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0), color: byPost),
                                height: 50,
                                width: MediaQuery.of(context).size.width / 2,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.byPost, //'By Post',
                                    style: TextStyle(color: byPostTxt, fontSize: 18.0),
                                  ),
                                ),
                              ),
                              onTap: () {
                                setState(() {
                                  byHand = Colors.grey[300];
                                  byHandTxt = Colors.grey;
                                  byPost = Colors.black;
                                  byPostTxt = Colors.white;
                                  visible = true;
                                  deliveryMethos = 1;
                                });
                              },
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        Visibility(
                            visible: visible,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(left: 30.0),
                                        child: Text(AppLocalizations.of(context)!
                                            .companyName) //Text('Company Name'),
                                        )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ApptextField(
                                          controller: companyName,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30.0),
                                      child:
                                          Text(AppLocalizations.of(context)!.number), //Text('Number'),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: ApptextField(
                                          controller: trackingNumber,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Row(children: [
                          SizedBox(
                            width: width * 0.05,
                          ),
                        ]),
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  margin: EdgeInsets.fromLTRB(0, height * 0.015, 0, 0),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(const Radius.circular(12)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border:
                                              Border.all(style: BorderStyle.solid, color: Colors.blue),
                                          borderRadius: BorderRadius.circular(12)),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: IconButton(
                                                icon: const Icon(Icons.attach_file),
                                                color: const Color(0xFF128383),
                                                onPressed: () async {
                                                  if (kIsWeb) {
                                                    pickImageWeb();
                                                  } else {
                                                    await showImageSource(context);
                                                  }
                                                  // await Permission.photos.request();
                                                  // var permissionStatus = await Permission.photos.status;
                                                  // if (permissionStatus.isGranted) {
                                                  //   // ignore: use_build_context_synchronously
                                                  //   await showImageSource(context);
                                                  // } else {
                                                  //   _showMsg(
                                                  //       'cant access your gallery',
                                                  //       const Icon(
                                                  //         Icons.close,
                                                  //         color: Colors.red,
                                                  //       ));
                                                  // }
                                                },
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                                child: Text(
                                              AppLocalizations.of(context)!.attach,
                                              style: const TextStyle(color: const Color(0xFF128383)),
                                            )),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(2.0, 10.0, 5.0, 10.0),
                                child: Container(
                                  height: 60,
                                  width: 60,
                                  margin: EdgeInsets.fromLTRB(0, height * 0.015, 0, 0),
                                  child: (kIsWeb)
                                      ? ListView.builder(
                                          itemCount: webimg.length,
                                          shrinkWrap: true,
                                          primary: false,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return getPickedImageWeb(webimg[index], index);
                                          })
                                      : ListView.builder(
                                          itemCount: img.length,
                                          shrinkWrap: true,
                                          primary: false,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return getPickedImage(img[index]!.path, index);
                                          }),
                                ),
                              ),
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: AppButton(
                                color: const Color(0xff128383),
                                onpressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AlertMessage(
                                          dothis: () {
                                            setDeliveryMethod();
                                            Navigator.pop(context);
                                          },
                                          message: AppLocalizations.of(context)!
                                              .areyousureyouwantToproceed, //'Are you sure you want To proceed',
                                          title: AppLocalizations.of(context)!.messages));
                                },
                                text: AppLocalizations.of(context)!.confirm, //'Confirm',
                                textColor: Colors.white,
                              ),
                            ))
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
    ));
  }
  //

  // pick image
  pickImageWeb() async {
    // final imageweb = await ImagePickerWeb.getMultiImagesAsBytes();
    // setState(() {
    //   webimg.addAll(imageweb!);
    // });
  }
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

  Widget getPickedImageWeb(Uint8List imageBytes, int index) {
    return Stack(
      children: [
        Container(
          height: 60,
          width: 60,
          margin: const EdgeInsets.fromLTRB(3.0, 0, 3.0, 0),
          child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.memory(
                imageBytes,
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
                    webimg.removeAt(index);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                )))
      ],
    );
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
