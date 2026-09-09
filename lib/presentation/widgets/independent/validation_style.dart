import '../../../../config/config.dart';
import 'package:flutter/material.dart';

/// AqualifeValidationStyleWidget that represent style of each one of them and shows as list of condition that you want to the app user

class AqualifeValidationStyleWidget extends StatelessWidget {
  final Color color;
  final String text;
  final int? value;
  final String? index;

  const AqualifeValidationStyleWidget(
      {super.key,
      required this.color,
      required this.text,
      required this.value,
      this.index});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: colorBackground,
      height: height * 0.04,
      child: IntrinsicHeight(
        child: Container(
          width: width * 0.2,
          color: colorTransparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width * 0.025,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 3),
                  alignment: Alignment.center,
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 10,
                      color: colorDarkGray,
                      fontFamily: fontFamilyMain,
                    ),
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                ),
              ),
              index == 'last'
                  ? Container()
                  : const VerticalDivider(
                      width: 2,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      color: colorDarkGray,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
