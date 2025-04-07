import 'package:flutter/material.dart';

class GeneralLogoSpace extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 50),
          Image.asset("assets/MedEaseLogo.png", width: 115),
        ],
      ),
    );
  }
}
