import 'dart:async';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../widgets/data_driven/datadriven.dart';
import '../../widgets/independent/independent.dart';
import 'otp.dart';

class OtpVerifyParameters {
  final Map data;

  const OtpVerifyParameters({required this.data});
}

class OtpVerifyScreen extends StatefulWidget {
  final OtpVerifyParameters parameters;

  const OtpVerifyScreen({super.key, required this.parameters});

  @override
  State<StatefulWidget> createState() {
    return _OtpVerifyScreenState();
  }
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  OtpFieldController otpController = OtpFieldController();

  String otpCode = '', resendvToken = '', tokenVerify = '';
  late double sizeBetween;
  int secondsRemaining = 60;
  bool error = false;
  bool enableResend = true;
  bool isProcessing = false;
  // bool isChanging = false;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    resendvToken = widget.parameters.data['data']['vToken'];
    tokenVerify = widget.parameters.data['data']['token'];
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    sizeBetween = height / 20;

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
          body: BlocConsumer<OtpBloc, OtpState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              // on success delete navigator stack and push to home
              if (state is OtpFinished) {
                RegisterTimerDialog.showSuccessDialog(context);
              }
              // if (state is OtpRequestSuccess) {
              //   // isChanging = true;

              //   setProcessingStatus(false);
              //   resendvToken = state.data['data']['vToken'];
              //   tokenVerify = state.data['data']['token'];
              //   showSuccessToast(state.data['message'], context);

              //   // Navigator.of(context).pushNamed( AqualifeRoutes.otpVerify,
              //   //     arguments: OtpVerifyParameters(data: state.data));
              // }
              if (state is OtpResent) {
                setProcessingStatus(false);
                resendvToken = state.data['data']['vToken'];
                tokenVerify = state.data['data']['token'];
                showSuccessToast(state.data['message'], context);
              }
              if (state is OtpError) {
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);
                otpController.clear();
                showErrorToast(state.error, context);
              }
            },
            builder: (context, state) {
              // show loading screen while processing
              if (state is OtpProcessing) {
                // return Center(
                //   child: CircularProgressIndicator(color: colorDisableGrey,),
                // );
              }

              return SingleChildScrollView(
                child: Container(
                  color: colorWhite,
                  height: height,
                  // padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
                  margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50, bottom: 20),
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
                                    text: widget.parameters.data['data']
                                        ['send_to'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  TextSpan(
                                    text:
                                        ' through email. \n\n2. If you did not receive the code, please check the spam filter or click on ',
                                  ),
                                  TextSpan(
                                    text: 'Resend OTP ',
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
                                  onPressed: isProcessing ? () {} : _verifyOtp,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin:
                                        EdgeInsets.only(top: 14, bottom: 15),
                                    padding: EdgeInsets.symmetric(vertical: 5),
                                    // color: colorBabyBlue,
                                    alignment: Alignment.center,
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
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _resendOtp() {
    // print('OTP VTOKEN RESEND: $resendvToken');
    enableResend = false;
    BlocProvider.of<OtpBloc>(context).add(OtpResend(
      email: widget.parameters.data['data']['send_to'],
      purpose: 'resend-register',
      vToken: resendvToken,
    ));
    Timer(Duration(seconds: 60), () {
      if (!mounted) return;
      setState(() {
        enableResend = true;
      });
    });
  }

  // void _phoneConfirmPage() {
  //   // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
  //   Navigator.of(context).pushNamedAndRemoveUntil(
  //        AqualifeRoutes.otpCValid, (Route<dynamic> route) => false,
  //       arguments: CValidOtpParameters(loginData: widget.loginData));
  // }

  void _verifyOtp() {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(context)
        .add(OtpVerify(otpCode: otpCode, token: tokenVerify));
  }

  // void _requestOtp() {
  //   // print('OTP VTOKEN REQUEST: ${widget.parameters.data['data']['vToken']}');
  //   setProcessingStatus(true);
  //   // isChanging == true;
  //   BlocProvider.of<OtpBloc>(context).add(OtpRequest(
  //     email: widget.parameters.data['data']['email'],
  //     purpose: 'register',
  //     vToken: widget.parameters.data['data']['vToken'],
  //   ));
  // }
}
