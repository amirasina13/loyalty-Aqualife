import 'dart:async';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

// Class for register timer dialog (dialog with timer). Will use in features/otp/otp_screen.dart

Timer? timerDialog;

class SuccessTimerDialog extends StatelessWidget {
  final String message;

  const SuccessTimerDialog({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Container(
      color: colorBackground,
      // alignment: Alignment.center,
      height: height,
      width: width,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal, vertical: 20),
      child: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.fromLTRB(
                          marginHorizontal, 50, marginHorizontal, height * 0.2),
                      // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                      // height: height / 7,
                      child: Text(
                        'Success',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: colorTextGreen,
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.15,
                      margin: EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/icons/success_circle.png'),
                        ),
                      ),
                    ),
                    Container(
                      child: Text(
                        message,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future showSuccessTimerDialog(
      BuildContext context, String message, final VoidCallback routes) {
    return showDialog(
      context: context,
      builder: (context) {
        timerDialog = Timer(
          Duration(seconds: 3),
          routes,
        );
        // and later, before the timer goes off...
        timerDialog;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorWhite,
          content: SuccessTimerDialog(
            message: message,
          ),
        );
      },
    );
  }
}
