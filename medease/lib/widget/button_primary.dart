import 'package:flutter/material.dart';
import 'package:medease/theme.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final Function onTap;

  ButtonPrimary({this.text, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        child: Text("Get Started"),
        style: ElevatedButton.styleFrom(
          primary: lightColor,
          shape: RoundedRectangleBorder.circular(20),
        ),
      ),
    );
  }
}
