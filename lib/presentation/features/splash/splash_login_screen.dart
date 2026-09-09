import 'dart:async';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../config/storage.dart';
// import '../webview/webview_deeplink.dart';

Timer? timerDialog;

class SplashTimerDialog extends StatelessWidget {
  const SplashTimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: colorWhite, systemNavigationBarColor: colorWhite
          //  TempData.currentPage == 'voucherPage'
          //     ? colorWhite
          //     : colorYellowLogo,
          ),
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: Storage().welcomeSplash!.isNotEmpty
            ? Scaffold(
                body: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(Storage().welcomeSplash!),
                      ),
                    ),
                  ),
                ),
              )
            : Scaffold(
                body: Center(
                  child: Container(
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(splashLogin),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  static Future showSplashLoginDialog(
      BuildContext context, VoidCallback navigation) {
    return showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) {
        timerDialog = Timer(Duration(seconds: 3), navigation);
        // and later, before the timer goes off...
        timerDialog;

        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorYellowLogo,
          content: SplashTimerDialog(),
        );
      },
    ).then((value) {});
  }
}
