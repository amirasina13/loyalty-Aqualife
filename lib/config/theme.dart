import 'package:flutter/material.dart';
import 'config.dart';

// FOR CUSTOM THEME

// Ref: Font Weights: https://api.flutter.dev/flutter/dart-ui/FontWeight-class.html
// Ref: Font Weights for TextTheme: https://api.flutter.dev/flutter/material/TextTheme-class.html
class AqualifeTheme {
  static ThemeData of(context) {
    var theme = Theme.of(context);
    return ThemeData(
      useMaterial3: false,
      fontFamily: fontFamilyMain,
      primaryColor: mainColor,
      primaryColorLight: colorDarkGray,
      // bottomAppBarColor: colorDarkGray,
      // backgroundColor: colorBackground,
      // dialogBackgroundColor: colorBackgroundLight,
      // errorColor: colorRed,
      dividerColor: colorTransparent,
      appBarTheme: theme.appBarTheme.copyWith(
        color: colorWhite,
        iconTheme: const IconThemeData(color: colorBlack),
        // toolbarTextStyle: theme.textTheme
        //     .copyWith(
        //       caption: const TextStyle(
        //         color: colorDarkYellow,
        //         fontSize: 18,
        //         fontFamily: fontFamilyMain,
        //         fontWeight: FontWeight.w400,
        //       ),
        //     )
        //     .bodyText2,
        titleTextStyle: TextStyle(
          fontFamily: fontFamilyMain,
        ),
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        minWidth: 50,
        buttonColor: mainColor,
      ),
      colorScheme:
          ColorScheme.fromSwatch().copyWith(secondary: colorDeepSkyBlue),
      primaryTextTheme: TextTheme().apply(fontFamily: fontFamilyMain),
      textTheme: TextTheme().apply(fontFamily: fontFamilyMain),
    );
  }
}
