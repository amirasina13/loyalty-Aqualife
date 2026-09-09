import 'dart:async';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../config/routes.dart';
import '../independent/style_button.dart';

// Class for register timer dialog (dialog with timer). Will use in features/otp/otp_screen.dart

Timer? timerDialog;

class RegisterTimerDialog extends StatelessWidget {
  const RegisterTimerDialog({super.key});

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: height / 3,
                      // width: width,
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      decoration: BoxDecoration(
                        // color: colorBabyBlue,
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage('assets/image/register.png'),
                        ),
                      ),
                    ),
                    // SizedBox(height: height * 0.03),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        // Note: Styles for TextSpans must be explicitly defined.
                        // Child text spans will inherit styles from parent
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: colorBlack,
                          fontWeight: FontWeight.w700,
                          fontFamily: fontFamilyMain,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Welcome to ',
                          ),
                          TextSpan(
                            text: '$appName!',
                            style: TextStyle(
                              color: secondaryColor,
                              fontFamily: fontFamilyMain,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: width * 0.03),
                    Text(
                      "Your account has been successfully registered.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: colorBlack,
                        fontFamily: fontFamilyMain,
                      ),
                      textAlign: TextAlign.center,
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: height / 28),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 44),
              child: AqualifeStyleButton(
                height: height / 14,
                title: 'Continue',
                icon: Icons.arrow_forward,
                iconLeading: false,
                backgroundColor: mainColor,
                textColor: colorWhite,
                onPressed: () {
                  timerDialog!.cancel();
                  // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.login,
                    (Route<dynamic> route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Future showSuccessDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        timerDialog = Timer(Duration(seconds: 4), () {
          // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
          Navigator.of(context).pushNamedAndRemoveUntil(
            AqualifeRoutes.login,
            (Route<dynamic> route) => false,
          );
        });
        // and later, before the timer goes off...
        timerDialog;
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.zero,
          backgroundColor: colorWhite,
          content: RegisterTimerDialog(),
        );
      },
    );
  }
}
