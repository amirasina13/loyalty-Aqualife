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
import '../../../../domain/entities/validator.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../otp/otp.dart';
import '../forgot_pass.dart';

class ForcePassView extends StatefulWidget {
  final Function changeView;
  final String email;
  final String vToken;

  // ignore: use_key_in_widget_constructors
  const ForcePassView({
    Key? key,
    required this.changeView,
    required this.email,
    required this.vToken,
  }) : super();

  @override
  State<ForcePassView> createState() => _ForcePassViewState();
}

class _ForcePassViewState extends State<ForcePassView> {
  bool error = false;
  bool isProcessing = false;
  bool enableResend = true;
  String passwordValid = '';
  String errorfield = '';
  String errorTextPwd = '', errorTextCfmPwd = '', errorTextMissMatch = '';
  String reqEmail = '', resendvToken = '', tokenVerify = '';

  // OtpFieldController otpController = OtpFieldController();
  /// Create Controller
  OtpFieldController otpController = OtpFieldController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<AqualifeInputFieldState> newPasswordKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> confirmPasswordKey = GlobalKey();

  String? otpCode = '';
  late double sizeBetween;
  late FocusNode pwFocus, confirmPwFocus;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    pwFocus = FocusNode();
    confirmPwFocus = FocusNode();

    reqEmail = widget.email;
    resendvToken = widget.vToken;
    _requestOtp();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    pwFocus.dispose();
    confirmPwFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
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
          body: BlocConsumer<ForgotPassBloc, ForgotPassState>(
            listener: (context, state) {
              // on success delete navigator stack and push to home
              if (state is ForgotPassOtpVerified) {
                SuccessTimerDialog.showSuccessTimerDialog(
                  context,
                  state.message,
                  () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.login,
                      (Route<dynamic> route) => false,
                    );
                  },
                );
                // Navigator.of(context)
                //     .pushNamed( AqualifeRoutes.login, arguments: LoginScreen());
                // showSuccessToast('Password reset successfully!', context);
              }
              if (state is ForgotPassResent) {
                setProcessingStatus(false);
                showSuccessToast(state.data['message'], context);
              }
              // on failure show a snackbar
              if (state is ForgotPassError) {
                // otpController.clear();

                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);

                showErrorToast(state.error, context);
                // ErrorIconDialog.showErrorDialog(context, state.error);
              }
              // maintenance mode on
              if (state is ForgotPassMaintenanceError) {
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
              if (state is ForgotPassProcessing) {
                // return LoadingWidget();
              }

              if (state is ForgotPassSent) {
                reqEmail = state.data['data']['email'];
                resendvToken = state.data['data']['vToken'];
              }

              return SingleChildScrollView(
                child: Container(
                  height: height - 15,
                  color: colorTransparent,
                  padding: EdgeInsets.fromLTRB(
                      marginHorizontal, 10, marginHorizontal, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        height: height / 7,
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: colorBlack,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Enter the OTP code sent to\n\n ',
                              ),
                              TextSpan(
                                text: reqEmail,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: colorBlack,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: sizeBetween * 0.2),
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
                      BlocConsumer<OtpBloc, OtpState>(
                        listener: (context, state) {
                          if (state is OtpRequestSuccess) {
                            // isChanging = true;

                            setProcessingStatus(false);
                            resendvToken = state.data['data']['vToken'];
                            tokenVerify = state.data['data']['token'];
                            showSuccessToast(state.data['message'], context);
                          }
                          if (state is OtpResent) {
                            setProcessingStatus(false);
                            resendvToken = state.data['data']['vToken'];
                            tokenVerify = state.data['data']['token'];
                            showSuccessToast(state.data['message'], context);
                          }
                        },
                        builder: (context, state) {
                          return Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  // margin: EdgeInsets.only(top: 50),
                                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                                  height: height / 7,
                                  child: Text(
                                    'Change Password',
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 32,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                                  child: Text(
                                    'Change New Password',
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: colorBackground,
                                    boxShadow: [
                                      BoxShadow(
                                          color: error
                                              ? colorRed
                                              : errorfield == 'error' ||
                                                      errorfield ==
                                                          'errorPwd' ||
                                                      errorfield ==
                                                          'errorMismatch'
                                                  ? colorRed
                                                  : colorGreyBox,
                                          // blurRadius: 15.0,
                                          offset: Offset(
                                              0.0,
                                              error
                                                  ? 3
                                                  : errorfield == 'error' ||
                                                          errorfield ==
                                                              'errorPwd' ||
                                                          errorfield ==
                                                              'errorMismatch'
                                                      ? 3
                                                      : 0))
                                    ],
                                    border: Border.all(color: colorGreyBox),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: AqualifeInputField(
                                    key: newPasswordKey,
                                    controller: newPasswordController,
                                    // label: '',
                                    textAlignVertical: TextAlignVertical.center,
                                    // hint: 'Password *',
                                    // validator: Validator.passwordCorrect,
                                    keyboard: TextInputType.visiblePassword,
                                    isPassword: true,
                                    border: InputBorder.none,
                                    focusNode: pwFocus,
                                    onValueChanged: (value) {
                                      if (value != '') {
                                        setState(() {
                                          errorfield = '';
                                          newPasswordKey.currentState
                                              ?.validate();

                                          // print(
                                          //     'ERRORTEXT: ${passwordKey.currentState?.validate()}');
                                        });
                                      }
                                    },
                                  ),
                                ),
                                errorfield == 'error' ||
                                        errorfield == 'errorPwd' ||
                                        errorfield == 'errorMismatch'
                                    ? Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          errorfield == 'error' ||
                                                  errorfield == 'errorPwd'
                                              ? errorTextPwd
                                              : errorTextMissMatch,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: error
                                                  ? colorRed
                                                  : errorfield == 'error' ||
                                                          errorfield ==
                                                              'errorPwd' ||
                                                          errorfield ==
                                                              'errorMismatch'
                                                      ? colorRed
                                                      : colorGreyBox),
                                        ),
                                      )
                                    : SizedBox(),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                                  child: Text(
                                    'Confirm New Password',
                                    style: TextStyle(
                                      fontFamily: fontFamilyMain,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Container(
                                  // padding: EdgeInsets.symmetric(
                                  //     horizontal: 15),
                                  decoration: BoxDecoration(
                                    color: colorBackground,
                                    boxShadow: [
                                      BoxShadow(
                                          color: error
                                              ? colorRed
                                              : errorfield == 'error' ||
                                                      errorfield ==
                                                          'errorCfmPwd' ||
                                                      errorfield ==
                                                          'errorMismatch'
                                                  ? colorRed
                                                  : colorGreyBox,
                                          // blurRadius: 15.0,
                                          offset: Offset(
                                              0.0,
                                              error
                                                  ? 3
                                                  : errorfield == 'error' ||
                                                          errorfield ==
                                                              'errorCfmPwd' ||
                                                          errorfield ==
                                                              'errorMismatch'
                                                      ? 3
                                                      : 0))
                                    ],
                                    border: Border.all(color: colorGreyBox),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: AqualifeInputField(
                                    key: confirmPasswordKey,
                                    controller: confirmPasswordController,
                                    // hint: 'Confirm Password *',
                                    validator: Validator.valueExists,
                                    keyboard: TextInputType.visiblePassword,
                                    isPassword: true,
                                    border: InputBorder.none,
                                    focusNode: confirmPwFocus,
                                    textAlignVertical: TextAlignVertical.center,
                                    onValueChanged: (value) {
                                      if (value != '') {
                                        setState(() {
                                          errorfield = '';
                                          confirmPasswordKey.currentState
                                              ?.validate();
                                        });
                                      }
                                    },
                                  ),
                                ),
                                errorfield == 'error' ||
                                        errorfield == 'errorCfmPwd' ||
                                        errorfield == 'errorMismatch'
                                    ? Container(
                                        margin: EdgeInsets.only(top: 5),
                                        child: Text(
                                          errorfield == 'error' ||
                                                  errorfield == 'errorCfmPwd'
                                              ? errorTextCfmPwd
                                              : errorTextMissMatch,
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w400,
                                              color: error
                                                  ? colorRed
                                                  : errorfield == 'error' ||
                                                          errorfield ==
                                                              'errorCfmPwd' ||
                                                          errorfield ==
                                                              'errorMismatch'
                                                      ? colorRed
                                                      : colorGreyBox),
                                        ),
                                      )
                                    : SizedBox(),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(top: 15),
                                    alignment: Alignment.bottomCenter,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                            // height: height * 0.05,
                                            // width: width,
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(bottom: 15),
                                            color: colorTransparent,
                                            child: enableResend == false
                                                ? Countdown(
                                                    seconds: 60,
                                                    build: (_, double time) {
                                                      var duration = Duration(
                                                          seconds:
                                                              time.toInt());
                                                      return Container(
                                                        alignment:
                                                            Alignment.center,
                                                        // padding:
                                                        //     EdgeInsets.only(left: 16.0, top: 0.0),
                                                        child: Text(
                                                          // 'Remaining Time: ${duration.inMinutes}:${duration.inSeconds.remainder(60)}',
                                                          // '${duration.inSeconds} seconds  ',
                                                          '${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                          style: TextStyle(
                                                            color:
                                                                colorCountGrey,
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily:
                                                                fontFamilyMain,
                                                          ),
                                                          textScaler:
                                                              TextScaler.linear(
                                                                  scaleFactor),
                                                        ),
                                                      );
                                                    },
                                                    onFinished: () {},
                                                  )
                                                : SizedBox()
                                            // Text('Time left before enabling resend', style: TextStyle(),),
                                            ),
                                        Container(
                                          padding: EdgeInsets.only(bottom: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                                color: enableResend == true
                                                    ? mainColor
                                                    : colorDarkGray,
                                                fontSize: 13.0,
                                                underline: true,
                                                fontWeight: FontWeight.w600,
                                                // fontStyle: FontStyle.italic,
                                                onClick: enableResend == true
                                                    ? _resendOtp
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                        AqualifeStyleButton(
                                          height: height / 14,
                                          title: 'Continue',
                                          iconLeading: false,
                                          icon: Icons.arrow_forward,
                                          backgroundColor: isProcessing
                                              ? colorLightGray
                                              : colorBlack,
                                          onPressed: isProcessing
                                              ? () {}
                                              : _validateAndSend,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                            FocusScope.of(context).unfocus();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                top: 20, bottom: 5),
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5),
                                            // color: colorBabyBlue,
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Cancel',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: colorBlack,
                                                fontWeight: FontWeight.w400,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                              textScaler: TextScaler.linear(
                                                  scaleFactor),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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

  void _requestOtp() {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(context).add(OtpRequest(
      email: reqEmail,
      purpose: 'forgot',
      vToken: resendvToken,
    ));
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<OtpBloc>(context).add(OtpResend(
      email: reqEmail,
      purpose: 'resend-forgot',
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
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });
    if (otpCode == '') {
      setProcessingStatus(false);
      errorfield = 'errorOtp';
      showErrorToast('Otp No are required!', context);
    } else if (newPasswordController.text == '') {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      errorTextPwd = 'The new password is required!';
      // showErrorToast('New password is required!', context);
    } else if (confirmPasswordController.text == '') {
      setProcessingStatus(false);
      errorfield = 'errorCfmPwd';
      errorTextCfmPwd = 'The confirmation password is required!';
      // showErrorToast('Password confirmation is required!', context);
    } else if (Validator.passwordCorrect(newPasswordController.text) != null) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      pwFocus.requestFocus();
      errorTextMissMatch =
          'Must contain: 8-16 characters, uppercase, lowercase, number and symbol (!@#)';
    } else if (newPasswordController.text != confirmPasswordController.text) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      confirmPwFocus.requestFocus();
      errorTextMissMatch = 'Password mismatched';
      // showErrorToast('Password mismatched', context);
    } else {
      errorfield == '';
      setProcessingStatus(true);
      BlocProvider.of<ForgotPassBloc>(context).add(
        ForgotPassOtpSend(
          password: confirmPasswordController.text,
          otpCode: otpCode!,
          verifyToken: tokenVerify,
        ),
      );
    }
  }
}
