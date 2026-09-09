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
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../security_pin.dart';

class SecurityOtpView extends StatefulWidget {
  final Function changeView;
  final Map otpData;

  const SecurityOtpView(
      {super.key, required this.changeView, required this.otpData});

  @override
  State<SecurityOtpView> createState() => _SecurityOtpViewState();
}

class _SecurityOtpViewState extends State<SecurityOtpView> {
  bool error = false;
  bool isProcessing = false;
  int secondsRemaining = 60;
  bool enableResend = true;
  String errorfield = '';
  String reqEmail = '', resendvToken = '', tokenVerify = '';

  /// Create Controller
  // final otpController = TextEditingController();
  OtpFieldController otpController = OtpFieldController();

  String? otpCode = '';
  late double sizeBetween;

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
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

    // final errorPinTheme = defaultPinTheme.copyDecorationWith(
    //   border: Border(
    //     bottom: BorderSide(
    //       color: colorRed,
    //       width: 2,
    //     ),
    //   ),
    //   // borderRadius: BorderRadius.circular(8),
    // );

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: error == false ? colorBlack : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorWhite,
          body: BlocConsumer<SecurityBloc, SecurityState>(
            listener: (context, state) {
              // on success delete navigator stack and push to home
              if (state is SecurityOtpVerified) {
                setProcessingStatus(false);

                showSuccessToast(state.data['message'], context);
                Navigator.of(context).pushNamed(AqualifeRoutes.securitySet);
              }
              if (state is SecurityOtpSent) {
                setProcessingStatus(false);
                showSuccessToast(state.data['message'], context);

                resendvToken = state.data['data']['vToken'];
                tokenVerify = state.data['data']['otp_token'];
              }
              // on failure show a snackbar
              if (state is SecurityError) {
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);
                otpController.clear();
                showErrorToast(state.error, context);
                // ErrorIconDialog.showErrorDialog(context, state.error);
              }
              /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
              if (state is SecurityMaintenanceError) {
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
              if (state is SecurityProcessing) {
                // return Center(
                //   child: CircularProgressIndicator(color: colorDisableGrey,),
                // );
              }

              if (state is SecurityInitial) {
                reqEmail = widget.otpData['data']['send_to'];
                resendvToken = widget.otpData['data']['vToken'];
                tokenVerify = widget.otpData['data']['otp_token'];
              }

              return SingleChildScrollView(
                reverse: true, // this is new
                physics: BouncingScrollPhysics(),
                child: Container(
                  color: colorBackground,
                  height: height - (height * 0.12),
                  // padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                  margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        // alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
                        // height: height / 7,
                        child: Text(
                          'Enter the OTP Code sent to',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        // alignment: Alignment.center,
                        // margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                        // height: height / 7,
                        child: Text(
                          reqEmail,
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBetween * 2),
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
                      SizedBox(height: sizeBetween * 0.8),
                      AqualifeStyleButton(
                        height: height / 14,
                        title: 'Continue',
                        iconLeading: false,
                        icon: Icons.arrow_forward,
                        backgroundColor:
                            isProcessing ? colorLightGray : mainColor,
                        textColor: isProcessing ? colorDarkGray : colorWhite,
                        onPressed: isProcessing ? () {} : _validateAndSend,
                      ),
                      Container(
                        // height: height * 0.05,
                        // width: width,
                        alignment: Alignment.center,
                        padding: EdgeInsets.only(bottom: 15, top: 70),
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
                                      // '${duration.inSeconds} seconds  ',
                                      '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                        color: colorCountGrey,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: fontFamilyMain,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                  );
                                },
                                onFinished: () {},
                              )
                            : SizedBox(),
                      ),
                      SizedBox(height: sizeBetween * 2),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height: height / 5,
            margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Didn\'t receive it?',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      AqualifeTextButton(
                        'Send again',
                        color:
                            enableResend == true ? colorBlack : colorDarkGray,
                        fontSize: 13.0,
                        underline: true,
                        fontWeight: FontWeight.w600,
                        // fontStyle: FontStyle.italic,
                        onClick: enableResend == true ? _resendOtp : null,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<SecurityBloc>(context).add(SecurityOtpResend());

    Timer(Duration(seconds: 60), () {
      if (!mounted) return;
      setState(() {
        enableResend = true;
      });
    });
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    // Navigator.of(context).pushNamed( AqualifeRoutes.securitySet);

    if (otpCode == '') {
      setProcessingStatus(false);
      errorfield = 'errorOtp';
      showErrorToast('OTP number are required!', context);

      // ErrorIconDialog.showErrorDialog(context, 'OTP number are required!');
    } else {
      errorfield == '';
      setProcessingStatus(true);
      // Storage().otp = otpController.text;
      // Navigator.of(context).pushNamed( AqualifeRoutes.securitySet);
      BlocProvider.of<SecurityBloc>(context).add(
        SecurityOtpVerify(
          otp: otpCode!,
          otpToken: tokenVerify,
        ),
      );
    }
  }
}
