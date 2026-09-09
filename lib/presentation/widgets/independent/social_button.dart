// Extended Raised button for Open Flutter E-commerce App
// Author: openflutterproject@gmail.com
// Date: 2020-02-06

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

/* Widget class for standardize all button.  */

class AqualifeSocialButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AqualifeSocialButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    var widthButton = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFFCFCFC),
          border: Border.all(
            width: widthButton * 0.002,
            color: colorTabGray,
          ),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: colorBorderGray,
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0.0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
