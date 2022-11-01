import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final bool visible;
  final String? text;
  final Function? dothis;

  const AppHeader({
    Key? key,
    required this.visible,
    this.text,
    this.dothis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 150,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Color(0xff1AA6DC), Color(0xff13888E)])),
            ),
            Positioned(
                left: 20,
                top: 20,
                child: Visibility(
                    visible: visible,
                    child: IconButton(
                      onPressed: dothis as void Function()?,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ))),
            Positioned(
              left: 30,
              top: 70,
              child: Text(
                text!,
                style: const TextStyle(fontSize: 40.0, color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
