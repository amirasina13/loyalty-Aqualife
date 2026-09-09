import 'dart:async';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../verify_email.dart';

class EmailOtpView extends StatefulWidget {
  final Function changeView;
  final dynamic registerData;

  const EmailOtpView({super.key, required this.changeView, this.registerData});

  @override
  State<EmailOtpView> createState() => _EmailOtpViewState();
}

class _EmailOtpViewState extends State<EmailOtpView> {
  String otpCode = '';
  late double sizeBetween;
  int secondsRemaining = 60;
  bool error = false;
  bool enableResend = true;
  bool isProcessing = false;
  String resendvToken = '';

  OtpFieldController otpController = OtpFieldController();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    resendvToken = widget.registerData['vToken'];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    sizeBetween = height / 20;

    // final defaultPinTheme = PinTheme(
    //   width: 56,
    //   height: height / 15,
    //   textStyle: TextStyle(
    //     fontSize: 20,
    //     color: colorBlack,
    //     fontWeight: FontWeight.w600,
    //     fontFamily: fontFamilyMain,
    //   ),
    //   decoration: BoxDecoration(
    //     border: Border(
    //       bottom: BorderSide(
    //         color: colorBlack,
    //         width: 2,
    //       ),
    //     ),
    //     // borderRadius: BorderRadius.circular(20),
    //   ),
    // );

    // final focusedPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border(
    //     bottom: BorderSide(
    //       color: colorPinGrey,
    //       width: 2,
    //     ),
    //   ),
    //   // borderRadius: BorderRadius.circular(8),
    // );

    // final submittedPinTheme = defaultPinTheme.copyWith(
    //   decoration: BoxDecoration(
    //     border: Border(
    //       bottom: BorderSide(
    //         color: colorBlack,
    //         width: 2,
    //       ),
    //     ),
    //   ),
    // );

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: error == false ? colorDarkGray : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorWhite,
          appBar: AppBar(
            leading: Container(),
            elevation: 0,
            backgroundColor: colorTransparent,
            title: Text(
              'OTP Verification',
              style: TextStyle(
                color: colorBlack,
                fontWeight: FontWeight.w400,
                fontSize: 15,
                fontFamily: fontFamilyMain,
              ),
              textScaler: TextScaler.linear(scaleFactor),
            ),
            centerTitle: true,
          ),
          body: BlocConsumer<VerifyEmailBloc, VerifyEmailState>(
            listener: (context, state) {
              if (state is VerifyEmailOtpVerified) {
                showSuccessToast(state.data['message'], context);

                if (Storage().page == 'profileReg') {
                  Storage().page = '';
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.home,
                    (Route<dynamic> route) => false,
                  );
                } else {
                  // BlocProvider.of<ProfileBloc>(context).add(ProfileLoad());
                  Storage().page = '';
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.profile,
                    (Route<dynamic> route) => false,
                  );
                }
              }
              if (state is VerifyEmailSent) {
                setProcessingStatus(false);
                resendvToken = state.data['data']['vToken'];
                // EmailDialog.showEmailDialog(context, state.data['message']);
                showSuccessToast('${state.data['message']}', context);
              }
              if (state is VerifyEmailError) {
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                otpController.clear();
                setProcessingStatus(false);
                showErrorToast(state.error, context);
              }

              if (state is VerifyNetworkError) {
                setProcessingStatus(false);
                showErrorToast(state.error, context);
              }

              if (state is VerifyEmailMaintenanceError) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => MaintenanceScreen(
                          parameters:
                              MaintenanceParameters(message: state.message))),
                  ModalRoute.withName('/'),
                );
              }
            },
            builder: (context, state) {
              // show loading screen while processing
              if (state is VerifyEmailProcessing) {}

              return SingleChildScrollView(
                child: Container(
                  color: colorWhite,
                  height: height * 0.9,
                  // padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                  margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 20),
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
                        height: height / 7,
                        child: Text(
                          'OTP VERIFICATION',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // SizedBox(height: sizeBetween * 2),
                      // Text(
                      //   'OTP Code',
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //     fontSize: 16,
                      //     fontWeight: FontWeight.bold,
                      //     color: colorBlack,
                      //     fontFamily: fontFamilyMain,
                      //   ),
                      //   textScaler: TextScaler.linear(scaleFactor),
                      // ),
                      // SizedBox(height: sizeBetween * 0.5),

                      SizedBox(height: sizeBetween * 0.5),
                      Container(
                        color: colorTransparent,
                        height: height / 15,
                        child: OTPTextField(
                          controller: otpController,
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          fieldWidth: 45,
                          style: TextStyle(fontSize: 16),
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldStyle: FieldStyle.box,
                          otpFieldStyle: OtpFieldStyle(
                            focusBorderColor: colorDarkGray,
                            disabledBorderColor: colorBlack,
                          ),
                          onChanged: (pin) {},
                          onCompleted: (pin) {
                            otpCode = pin;

                            if (error) {
                              pin = "";
                            }
                          },
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            height: height / 6,
                            width: width,
                            margin: EdgeInsets.symmetric(vertical: 30),
                            decoration: BoxDecoration(
                              color: colorLightGray,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8.0,
                                  offset: Offset(0.0, 5.0),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.all(15),
                            child: RichText(
                              text: TextSpan(
                                // Note: Styles for TextSpans must be explicitly defined.
                                // Child text spans will inherit styles from parent
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: colorBlack,
                                  fontFamily: fontFamilyMain,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        'Note: \n1. A verification code has been sent to ',
                                  ),
                                  TextSpan(
                                    text: Storage().contact,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        ' through email. \n\n2. If you have not received your code, please click on ',
                                  ),
                                  TextSpan(
                                    text: 'Resend OTP Code ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text: 'below.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: sizeBetween * 0.4),
                          Container(
                            height: height * 0.09,
                            width: width,
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 5, bottom: 15),
                            color: colorTransparent,
                            child: enableResend == false
                                ? Countdown(
                                    seconds: 60,
                                    build: (_, double time) {
                                      var duration =
                                          Duration(seconds: time.toInt());
                                      return Container(
                                        alignment: Alignment.center,
                                        // padding:
                                        //     EdgeInsets.only(left: 16.0, top: 0.0),
                                        child: Text(
                                          // 'Remaining Time: ${duration.inMinutes}:${duration.inSeconds.remainder(60)}',
                                          '${duration.inSeconds} seconds left before enabling resend',
                                          style: TextStyle(
                                            color: mainColor,
                                            fontSize: 14,
                                            fontFamily: fontFamilyMain,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                      );
                                    },
                                    onFinished: () {},
                                  )
                                : AqualifeTextButton(
                                    'Resend OTP',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: enableResend == true
                                        ? colorLightBlue
                                        : colorDarkGray,
                                    onClick: enableResend == true
                                        ? _resendOtp
                                        : null,
                                  ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            // margin: EdgeInsets.only(bottom: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                AqualifeStyleButton(
                                  height: height / 14,
                                  title: 'Continue',
                                  iconLeading: false,
                                  icon: Icons.arrow_forward,
                                  backgroundColor:
                                      isProcessing ? colorLightGray : mainColor,
                                  textColor:
                                      isProcessing ? colorDarkGray : colorWhite,
                                  onPressed:
                                      isProcessing ? () {} : _validateAndSend,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: 14, bottom: 15),
                                    alignment: Alignment.center,

                                    //_phoneConfirmPage,
                                    child: Text(
                                      'Cancel',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: colorBlack,
                                        fontWeight: FontWeight.w400,
                                        decoration: TextDecoration.underline,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              );
              // return SingleChildScrollView(
              //   reverse: true, // this is new
              //   physics: BouncingScrollPhysics(),
              //   child: Container(
              //     // height: height * 0.6,
              //     color: colorWhite,
              //     margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       children: <Widget>[
              //         Container(
              //           margin: EdgeInsets.only(top: 20),
              //           child: Text(
              //             'Please enter the OTP code sent to your email.',
              //             textAlign: TextAlign.center,
              //             style: TextStyle(
              //               fontSize: 16,
              //               // fontWeight: FontWeight.bold,
              //               color: colorBlack,
              //               fontFamily: fontFamilyMain,
              //             ),
              //             textScaler: TextScaler.linear(scaleFactor),
              //           ),
              //         ),
              //         SizedBox(height: sizeBetween * 0.5),
              //         Container(
              //           color: colorTransparent,
              //           height: height / 15,
              //           child: Pinput(
              //             length: 6,
              //             controller: otpController,
              //             defaultPinTheme: defaultPinTheme,
              //             focusedPinTheme: focusedPinTheme,
              //             submittedPinTheme: submittedPinTheme,
              //             cursor: Text(
              //               '|',
              //               style: TextStyle(
              //                 color: colorPinGrey,
              //                 fontSize: 30,
              //               ),
              //               textScaler: TextScaler.linear(scaleFactor),
              //             ),
              //             pinputAutovalidateMode:
              //                 PinputAutovalidateMode.onSubmit,
              //             showCursor: true,
              //             onCompleted: (pin) {
              //               otpCode = pin;

              //               if (error) {
              //                 pin = "";
              //               }
              //             },
              //           ),
              //         ),
              //         SizedBox(height: sizeBetween * 0.5),
              //         Container(
              //           height: height / 5,
              //           width: width,
              //           margin: EdgeInsets.symmetric(vertical: 15),
              //           decoration: BoxDecoration(
              //             color: colorLightGray,
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(5),
              //             ),
              //             boxShadow: const [
              //               BoxShadow(
              //                 color: Colors.black26,
              //                 blurRadius: 8.0,
              //                 offset: Offset(0.0, 5.0),
              //               ),
              //             ],
              //           ),
              //           padding: EdgeInsets.all(15),
              //           child: RichText(
              //             text: TextSpan(
              //               // Note: Styles for TextSpans must be explicitly defined.
              //               // Child text spans will inherit styles from parent
              //               style: const TextStyle(
              //                 fontSize: 12.0,
              //                 color: Colors.black,
              //                 fontFamily: fontFamilyMain,
              //               ),
              //               children: [
              //                 TextSpan(
              //                   text:
              //                       'Note: \n1. A verification code has been sent to ',
              //                 ),
              //                 TextSpan(
              //                   text: Storage().email,
              //                   style: TextStyle(fontWeight: FontWeight.bold),
              //                 ),
              //                 TextSpan(
              //                   text:
              //                       ' through email. \n\n2. If you have not received your code, please click on ',
              //                 ),
              //                 TextSpan(
              //                   text: 'Resend OTP Code ',
              //                   style: TextStyle(fontWeight: FontWeight.bold),
              //                 ),
              //                 TextSpan(
              //                   text: 'below.',
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //         Container(
              //           height: height * 0.09,
              //           width: width,
              //           alignment: Alignment.center,
              //           margin: EdgeInsets.only(top: 5, bottom: 25),
              //           color: colorTransparent,
              //           child: enableResend == false
              //               ? Countdown(
              //                   seconds: 60,
              //                   build: (_, double time) {
              //                     var duration =
              //                         Duration(seconds: time.toInt());
              //                     return Container(
              //                       alignment: Alignment.center,
              //                       // padding:
              //                       //     EdgeInsets.only(left: 16.0, top: 0.0),
              //                       child: Text(
              //                         // 'Remaining Time: ${duration.inMinutes}:${duration.inSeconds.remainder(60)}',
              //                         '${duration.inSeconds} seconds left before enabling resend',
              //                         style: TextStyle(
              //                           color: colorDeepBlue,
              //                           fontSize: 14,
              //                           fontFamily: fontFamilyMain,
              //                         ),
              //                         textScaler: TextScaler.linear(scaleFactor),
              //                       ),
              //                     );
              //                   },
              //                   onFinished: () {},
              //                 )
              //               : AqualifeTextButton(
              //                   'Resend OTP',
              //                   color: enableResend == true
              //                       ? colorLightBlue
              //                       : colorDarkGray,
              //                   onClick:
              //                       enableResend == true ? _resendOtp : null,
              //                 ),
              //         ),
              //       ],
              //     ),
              //   ),
              // );
            },
          ),
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.centerFloat,
          // floatingActionButton: Container(
          //   margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          //   alignment: Alignment.bottomCenter,
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //        AqualifeStyleButton(
          //         title: 'Verify',
          //         backgroundColor:
          //             isProcessing ? colorLightGray : colorDeepBlue,
          //         onPressed: isProcessing ? () {} : _validateAndSend,
          //       ),
          //       Container(
          //         margin: EdgeInsets.only(bottom: 5, top: 10),
          //         child: InkWell(
          //           onTap: Storage().page != 'profileReg'
          //               ? () {
          //                   Storage().page = '';
          //                   Navigator.of(context).pushNamedAndRemoveUntil(
          //                      AqualifeRoutes.profile,
          //                     (route) => false,
          //                   );
          //                 }
          //               : () {
          //                   Storage().page = '';
          //                   Navigator.of(context).pop();
          //                 },
          //           child: Text(
          //             'Cancel',
          //             style: TextStyle(
          //               fontSize: 14,
          //               fontWeight: FontWeight.w400,
          //               decoration: TextDecoration.underline,
          //               fontFamily: fontFamilyMain,
          //             ),
          //             textScaler: TextScaler.linear(scaleFactor),
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<VerifyEmailBloc>(context).add(VerifyEmailOtpResend(
      purpose: 'resend-contact',
      contactNo: Storage().contact,
      vToken: resendvToken,
    ));
    Timer(Duration(seconds: 60), () {
      if (!mounted) return;
      setState(() {
        enableResend = true;
      });
    });
  }

  void _validateAndSend() {
    // if (otpController.text.isEmpty) {
    //   setProcessingStatus(false);
    //   showErrorToast('OTP number are required!', context);
    // } else {
    setProcessingStatus(true);
    BlocProvider.of<VerifyEmailBloc>(context).add(
      VerifyEmailOtpSend(
        otpCode: otpCode,
      ),
    );
    // }
  }
}
