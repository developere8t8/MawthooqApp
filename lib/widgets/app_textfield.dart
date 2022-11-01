import 'package:flutter/material.dart';

class ApptextField extends StatelessWidget {
  final Onchange;
  final label;
  final obscureText;
  final controller;
  final prefix;
  final keyboardType;
  const ApptextField(
      {Key? key,
      this.Onchange,
      this.controller,
      this.keyboardType,
      this.label,
      this.obscureText,
      this.prefix})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: TextField(
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscureText ?? false,
        decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            prefixIcon: prefix,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(40.0),
            ),
            filled: true,
            labelText: label,
            fillColor: const Color(0xffF0F0F0)),
        onChanged: Onchange,
        controller: controller,
      ),
    );
  }
}
