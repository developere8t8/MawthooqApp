import 'package:flutter/material.dart';
import 'package:seller_side/widgets/loader.dart';
import 'app_button.dart';

class AlertMessage extends StatefulWidget {
  final String title;
  final String message;
  final Function dothis;
  const AlertMessage({Key? key, required this.dothis, required this.message, required this.title})
      : super(key: key);

  @override
  State<AlertMessage> createState() => _AlertMessageState();
}

class _AlertMessageState extends State<AlertMessage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      child: SizedBox(
        height: 220,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 30.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(widget.title,
                              style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Center(
                            child: Text(
                              widget.message,
                              style: const TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      isLoading
                          ? const Loading()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: AppButton(
                                    color: const Color(0xff128383),
                                    onpressed: widget.dothis as void Function(),
                                    text: 'Yes',
                                    textColor: Colors.white,
                                  ),
                                ))
                              ],
                            ),
                    ],
                  ),
                )),
            Positioned(
              top: -16,
              right: 0.0,
              left: 0.0,
              bottom: 200.0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Image.asset('assets/close.png'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
