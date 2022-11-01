import 'package:flutter/material.dart';

//this widget is created for buttons to use in whole app
class AppButton extends StatelessWidget {
  final Function? onpressed;
  final String? text;
  final Color? color;
  final Color? textColor;
  const AppButton({Key? key, this.color, this.onpressed, this.text, this.textColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: MaterialButton(
          onPressed: onpressed as void Function()?,
          color: color,
          textColor: textColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Text(text!)),
    );
  }
}
