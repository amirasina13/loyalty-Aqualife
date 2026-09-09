import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:timer_count_down/timer_count_down.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../util/ios_deeplink_listener.dart';
import '../../../widgets/independent/style_button.dart';
import '../../../widgets/independent/text_button.dart';
import '../../../widgets/independent/toast_dialog.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../otp/otp.dart';
import '../../webview/webview_deeplink.dart';
import '../setup.dart';

class EvalidOtpView extends StatefulWidget {
  final Function? changeView;
  final dynamic loginData;
  final Map otpData;

  const EvalidOtpView(
      {super.key, this.changeView, this.loginData, required this.otpData});

  @override
  State<EvalidOtpView> createState() => _EvalidOtpViewState();
}

class _EvalidOtpViewState extends State<EvalidOtpView> {
  OtpFieldController otpController = OtpFieldController();

  String otpCode = '';
  late double sizeBetween;
  int secondsRemaining = 60;
  bool error = false;
  bool enableResend = true;
  bool isProcessing = false;
  String profileCvalid = '';
  String reqEmail = '', resendvToken = '', tokenVerify = '';

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      TempData.deeplink = uri.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    reqEmail = widget.loginData['profile']['email'];
    resendvToken = widget.otpData['data']['vToken'];
    tokenVerify = widget.otpData['data']['token'];

    if (Platform.isIOS) {
      DeepLinkHandler.listenForDeepLinkIOS();
    } else {
      _initDeepLinkListener();
    }
  }

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
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
        child: BlocConsumer<SetupBloc, SetupState>(
          listener: (context, state) {
            fToast = FToast();
            fToast.init(context);

            if (state is SetupFinished) {
              showSuccessToast(state.data['message'], context);

              // Check isContactRequired
              if (isContactRequired && !widget.loginData['cValid']) {
                Storage().setupDone == false;
                // need to fill and get OTP
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.setupCValid,
                      (Route<dynamic> route) => false,
                      arguments: CValidParameters(profile: widget.loginData));
                }
              } else if (!isContactRequired && !widget.loginData['cValid']) {
                Storage().setupDone == false;
                // need to fill only. No need OTP
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.setupCValid,
                      (Route<dynamic> route) => false,
                      arguments: CValidParameters(profile: widget.loginData));
                }
              } else if (widget.loginData['vProfile'] == false) {
                Storage().setupDone == false;
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.setupVProfile,
                      (Route<dynamic> route) => false,
                      arguments: VProfileParameters(profile: widget.loginData));
                }
              } else if (isMuslimFriendly == true &&
                  widget.loginData['vMuslim'] == false) {
                Storage().setupDone == false;
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.setupVMuslim,
                      (Route<dynamic> route) => false,
                      arguments: VMuslimParameters(profile: widget.loginData));
                }
              } else if (TempData.deeplink.isNotEmpty) {
                Storage().setupDone = true;
                // Navigate to webview to intercept the url - convert from short url to long url
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RedirectWebView(
                        parameters:
                            DeeplinkParameters(initialUrl: TempData.deeplink)),
                  ),
                );
              } else {
                if (mounted) {
                  Storage().setupDone = true;
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.home, (Route<dynamic> route) => false);
                }
              }
            }

            if (state is SetupSent) {
              setProcessingStatus(false);

              resendvToken = state.data['data']['vToken'];
              tokenVerify = state.data['data']['token'];

              showSuccessToast(state.data['message'], context);
            }

            if (state is SetupError) {
              // ignore: unnecessary_null_comparison
              state.error != null ? error = true : error = false;
              setProcessingStatus(false);
              otpController.clear();
              // ErrorIconDialog.showErrorDialog(context, state.error);
              showErrorToast(state.error, context);
            }
            if (state is SetupMaintenanceError) {
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
            return Container(
              color: colorBackground,
              margin: EdgeInsets.fromLTRB(
                  marginHorizontal, 20, marginHorizontal, 0),
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: colorBackground,
                    title: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: width * 0.11,
                              height: height * 0.007,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: colorBlack,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              width: width * 0.11,
                              height: height * 0.007,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: colorPermissionGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            Container(
                              width: width * 0.11,
                              height: height * 0.007,
                              decoration: BoxDecoration(
                                color: colorPermissionGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            'Step 1',
                            style: TextStyle(
                              fontFamily: fontFamilyInter,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: colorCountGrey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: height * 0.05,
                          margin: EdgeInsets.only(top: 30),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/icons/security/confirm.png'),
                                alignment: Alignment.centerLeft),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 15),
                          child: Text(
                            'Verify your email address',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: colorBlackTab,
                              // fontFamily: fontFamilyBarlow,
                            ),
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                        ),
                        Container(
                          child: RichText(
                            text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: const TextStyle(
                                fontSize: 11.0,
                                color: colorBlack,
                                fontFamily: fontFamilyMain,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      'Please enter the 6 digits code sent to ',
                                ),
                                TextSpan(
                                  text: reqEmail,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
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
                              borderColor: colorGreyBox,
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
                            if (state is OtpFinished) {
                              showSuccessToast(state.message, context);

                              // Check isContactRequired
                              if (isContactRequired &&
                                  !widget.loginData['cValid']) {
                                Storage().setupDone == false;
                                // need to fill and get OTP
                                if (mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AqualifeRoutes.setupCValid,
                                      (Route<dynamic> route) => false,
                                      arguments: CValidParameters(
                                          profile: widget.loginData));
                                }
                              } else if (!isContactRequired &&
                                  !widget.loginData['cValid']) {
                                Storage().setupDone == false;
                                // need to fill only. No need OTP
                                if (mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AqualifeRoutes.setupCValid,
                                      (Route<dynamic> route) => false,
                                      arguments: CValidParameters(
                                          profile: widget.loginData));
                                }
                              } else if (widget.loginData['vProfile'] ==
                                  false) {
                                Storage().setupDone == false;
                                if (mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AqualifeRoutes.setupVProfile,
                                      (Route<dynamic> route) => false,
                                      arguments: VProfileParameters(
                                          profile: widget.loginData));
                                }
                              } else if (isMuslimFriendly == true &&
                                  widget.loginData['vMuslim'] == false) {
                                Storage().setupDone == false;
                                if (mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AqualifeRoutes.setupVMuslim,
                                      (Route<dynamic> route) => false,
                                      arguments: VMuslimParameters(
                                          profile: widget.loginData));
                                }
                              } else if (TempData.deeplink.isNotEmpty) {
                                Storage().setupDone = true;
                                // Navigate to webview to intercept the url - convert from short url to long url
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RedirectWebView(
                                        parameters: DeeplinkParameters(
                                            initialUrl: TempData.deeplink)),
                                  ),
                                );
                              } else {
                                if (mounted) {
                                  Storage().setupDone = true;
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      AqualifeRoutes.home,
                                      (Route<dynamic> route) => false);
                                }
                              }
                            }

                            if (state is OtpResent) {
                              setProcessingStatus(false);

                              resendvToken = state.data['data']['vToken'];
                              tokenVerify = state.data['data']['token'];

                              showSuccessToast(state.data['message'], context);
                            }

                            if (state is OtpError) {
                              // ignore: unnecessary_null_comparison
                              state.error != null
                                  ? error = true
                                  : error = false;
                              setProcessingStatus(false);
                              otpController.clear();
                              // ErrorIconDialog.showErrorDialog(context, state.error);
                              showErrorToast(state.error, context);
                            }
                          },
                          builder: (context, state) {
                            return Container(
                              // height: height * 0.09,
                              // width: width,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(top: 20),
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
                                      color: enableResend == true
                                          ? mainColor
                                          : colorDarkGray,
                                      onClick: enableResend == true
                                          ? _resendOtp
                                          : null,
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AqualifeStyleButton(
                            height: height / 14,
                            title: isProcessing ? 'Processing...' : 'Confirm',
                            backgroundColor:
                                isProcessing ? colorLightGray : mainColor,
                            textColor:
                                isProcessing ? colorDarkGray : colorWhite,
                            onPressed: isProcessing ? () {} : _verifyOtp,
                          ),
                          Container(
                            //   alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 14, bottom: 15),
                            child: InkWell(
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorBlack,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                              // child: Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   children: [
                              //     Text(
                              //       'Cancel',
                              //       style: TextStyle(
                              //         fontSize: 16,
                              //         fontWeight: FontWeight.w500,
                              //         color: colorBlack,
                              //       ),
                              //       textScaler: TextScaler.linear(scaleFactor),
                              //     ),
                              //     // Container(
                              //     //   width: width * 0.045,
                              //     //   height: width * 0.045,
                              //     //   color: colorBackground,
                              //     //   margin: EdgeInsets.only(left: 5),
                              //     //   child: Image(
                              //     //     image: AssetImage(
                              //     //         'assets/icons/settings/logout.png'),
                              //     //   ),
                              //     // ),
                              //   ],
                              // ),
                              onTap: () {
                                Navigator.pop(context);
                                // BlocProvider.of<AuthenticationBloc>(context)
                                //     .add(AuthenticationLoggedOut());
                                // Storage().token = '';
                                // Navigator.of(context).pushNamedAndRemoveUntil(
                                //     AqualifeRoutes.login,
                                //     (Route<dynamic> route) => false);
                              },
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
        ),
      ),
    );
  }

  void _resendOtp() {
    enableResend = false;
    BlocProvider.of<OtpBloc>(context).add(OtpResend(
      email: reqEmail,
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

  void _verifyOtp() {
    // Navigator.of(context).pushNamedAndRemoveUntil(
    //     AqualifeRoutes.profileExtra, (Route<dynamic> route) => false,
    //     arguments: ProfileExtraParameters(profile: widget.loginData));
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(context)
        .add(OtpVerify(otpCode: otpCode, token: tokenVerify));
  }

  // void _phoneConfirmPage() {
  //   // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
  //   Navigator.of(context).pushNamedAndRemoveUntil(
  //       AqualifeRoutes.otpCValid, (Route<dynamic> route) => false,
  //       arguments: CValidOtpParameters(loginData: widget.loginData));
  // }
}
