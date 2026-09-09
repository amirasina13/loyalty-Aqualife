import '../../../../config/config.dart';
import 'package:flutter/material.dart';

/* Widget class for custom listTile. Will use in features/settings/view/settings_view.dart.  */
class AqualifeMenuLine extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final VoidCallback onTap;
  final double? fontTitle;
  final FontWeight? fontWeight;

  const AqualifeMenuLine({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    required this.onTap,
    this.fontTitle = 13,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Container(
      child: Material(
        color: colorWhite,
        child: InkWell(
          // borderRadius: BorderRadius.all(
          //   Radius.circular(40),
          // ),
          splashColor: secondaryColor,
          highlightColor: secondaryColor,
          onTap: onTap,
          child: Container(
            color: colorBackground,
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height / 14,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: icon != null
                  ? Container(
                      width: height * 0.05, //width * 0.09,
                      height: height * 0.05,
                      padding: EdgeInsets.all(5),
                      child: icon,
                    )
                  : null,
              title: Text(
                title,
                style: TextStyle(
                  color: colorBlack,
                  fontSize: fontTitle,
                  fontFamily: fontFamilyInter,
                  fontWeight: fontWeight,
                ),
                textScaler: TextScaler.linear(scaleFactor),
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: mainColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
