import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../domain/entities/validator.dart';
import '../../../../util/ios_deeplink_listener.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../webview/webview_deeplink.dart';
import '../setup.dart';

class EvalidView extends StatefulWidget {
  final Function? changeView;
  final Map loginData;

  const EvalidView({super.key, this.changeView, required this.loginData});

  @override
  State<EvalidView> createState() => _EvalidViewState();
}

class _EvalidViewState extends State<EvalidView> {
  bool isProcessing = false;
  bool error = false;
  String errorfield = '';
  String errorTextEmail = '';
  String resendVtoken = '';

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;
  late FocusNode emailFocus;
  final TextEditingController emailController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> emailKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      TempData.deeplink = uri.toString();
    });
  }

  @override
  void initState() {
    super.initState();

    resendVtoken = widget.loginData['vToken'];
    emailFocus = FocusNode();
    emailController.text = widget.loginData['profile']['email'];

    if (Platform.isIOS) {
      DeepLinkHandler.listenForDeepLinkIOS();
    } else {
      _initDeepLinkListener();
    }
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

    return BlocConsumer<SetupBloc, SetupState>(
      listener: (context, state) async {
        fToast = FToast();
        fToast.init(context);

        if (state is SetupMaintenanceError) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MaintenanceScreen(
                    parameters: MaintenanceParameters(message: state.message))),
            ModalRoute.withName('/'),
          );
        }

        if (state is SetupEmailDone) {
          setProcessingStatus(false);
          showSuccessToast(state.data['message'], context);

          // Check isContactRequired
          if (isContactRequired && !widget.loginData['cValid']) {
            Storage().setupDone == false;
            // need to fill and get OTP
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.setupCValid, (Route<dynamic> route) => false,
                  arguments: CValidParameters(profile: widget.loginData));
            }
          } else if (!isContactRequired && !widget.loginData['cValid']) {
            Storage().setupDone == false;
            // need to fill only. No need OTP
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.setupCValid, (Route<dynamic> route) => false,
                  arguments: CValidParameters(profile: widget.loginData));
            }
          } else if (widget.loginData['vProfile'] == false) {
            Storage().setupDone == false;
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.setupVProfile, (Route<dynamic> route) => false,
                  arguments: VProfileParameters(profile: widget.loginData));
            }
          } else if (isMuslimFriendly == true &&
              widget.loginData['vMuslim'] == false) {
            Storage().setupDone == false;
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.setupVMuslim, (Route<dynamic> route) => false,
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
          // if (isContactRequired && !widget.loginData['cValid']) {
          //   Navigator.of(context)
          //       .pushNamedAndRemoveUntil(AqualifeRoutes.setupCValid,
          //           (Route<dynamic> route) => false,
          //           arguments: CValidParameters(profile: widget.loginData))
          //       .then((value) => setProcessingStatus(false));
          //   // Check vProfile
          // } else if (widget.loginData['vProfile'] == false) {
          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //       AqualifeRoutes.setupVProfile, (Route<dynamic> route) => false,
          //       arguments: VProfileParameters(profile: widget.loginData));
          //   // Check isMuslimFriendly
          // } else if (isMuslimFriendly == true &&
          //     widget.loginData['vMuslim'] == false) {
          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //       AqualifeRoutes.setupVMuslim, (Route<dynamic> route) => false,
          //       arguments: VMuslimParameters(profile: widget.loginData));
          //   // Go to homepage
          // } else {
          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //       AqualifeRoutes.home, (Route<dynamic> route) => false);
          // }
        }

        if (state is SetupEmailOtp) {
          Navigator.of(context)
              .pushNamed(AqualifeRoutes.setupEValidOtp,
                  arguments: EValidOtpParameters(
                    loginData: widget.loginData,
                    otpData: state.data,
                  ))
              .then((value) {
            resendVtoken = state.data['data']['vToken'];
            setProcessingStatus(false);
          });
        }

        if (state is SetupError) {
          setProcessingStatus(false);
          showErrorToast(state.error, context);
        }
      },
      builder: (context, state) {
        return Container(
          // color: colorBabyBlue,
          margin:
              EdgeInsets.fromLTRB(marginHorizontal, 20, marginHorizontal, 0),
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
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
                            image:
                                AssetImage('assets/icons/security/verify.png'),
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
                      // height: height * 0.05,
                      child: Text(
                        'Please enter your email address to receive a verification code.',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: colorBlackTab,
                          // fontFamily: fontFamilyBarlow,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: colorBackground,
                        boxShadow: [
                          BoxShadow(
                              color: error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                          errorfield == 'errorEmail'
                                      ? colorRed
                                      : colorGreyBox,
                              // blurRadius: 15.0,
                              offset: Offset(
                                  0.0,
                                  error
                                      ? 3
                                      : errorfield == 'error' ||
                                              errorfield == 'errorEmail'
                                          ? 3
                                          : 0))
                        ],
                        border: Border.all(color: colorGreyBox),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: AqualifeInputField(
                        key: emailKey,
                        controller: emailController,
                        // hint: 'Example: 123456789',
                        validator: Validator.valueExists,
                        keyboard: TextInputType.emailAddress,
                        border: InputBorder.none,
                        focusNode: emailFocus,
                        onValueChanged: (value) {
                          if (value != '') {
                            setState(() {
                              errorfield = '';
                              error = false;
                              emailKey.currentState?.validate();
                            });
                          }
                        },
                      ),
                    ),
                    errorfield == 'error' || errorfield == 'errorEmail'
                        ? Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              errorTextEmail,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                              errorfield == 'errorEmail'
                                          ? colorRed
                                          : colorGreyBox),
                            ),
                          )
                        : SizedBox(),
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
                        title: isProcessing ? 'Processing...' : 'Next',
                        backgroundColor:
                            isProcessing ? colorLightGray : mainColor,
                        textColor: isProcessing ? colorDarkGray : colorWhite,
                        onPressed: isProcessing ? () {} : _validateAndSend,
                      ),
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 14, bottom: 15),
                        child: InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Log Out',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: colorBlack,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                              Container(
                                width: width * 0.045,
                                height: width * 0.045,
                                color: colorBackground,
                                margin: EdgeInsets.only(left: 5),
                                child: Image(
                                  image: AssetImage(
                                      'assets/icons/settings/logout.png'),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(AuthenticationLoggedOut());
                            Storage().token = '';
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.login,
                                (Route<dynamic> route) => false);
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
    );
  }

  void _validateAndSend() {
    // Navigator.of(context).pushNamed(AqualifeRoutes.otpCValidSend,
    //     arguments: CValidSendParameters(
    //       loginData: widget.loginData,
    //       otpData: {
    //         "isMaintenance": false,
    //         "status": true,
    //         "message":
    //             "An OTP code has been sent to sina@gmail.com. Please enter the code to proceed.",
    //         "data": {
    //           "token":
    //               "00b25a87e0856213b62296e3b2903771345a33c3777f421cb2c52b010d6808e5", // use this to verify otp
    //           "send_to": "sinamira@gmail.com",
    //           "vToken":
    //               "e796145663ab8ea6e82025b4a51c576914d30f0c45834510793f04c2a9867f29" // For resend otp
    //         }
    //       },
    //     ));
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (emailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'The email address is required!';
      // showErrorToast('Please enter valid email address!', context);
    } else {
      errorfield = '';
      setProcessingStatus(true);
      BlocProvider.of<SetupBloc>(context).add(SetupEmail(
        email: emailController.text,
      ));
      // BlocProvider.of<OtpBloc>(context).add(OtpRequest(
      //   email: emailController.text,
      //   purpose: 'resend-register',
      //   vToken: resendVtoken,
      // ));
    }
  }

  // void _requestOtp() {
  //   setProcessingStatus(true);
  //   // Navigator.of(context).pushNamed( AqualifeRoutes.otpCValidSend,
  //   //     arguments: CValidSendParameters(
  //   //       loginData: widget.loginData,
  //   //       otpData: {
  //   //         "isMaintenance": false,
  //   //         "status": true,
  //   //         "message":
  //   //             "An OTP code has been sent to sina@gmail.com. Please enter the code to proceed.",
  //   //         "data": {
  //   //           "token":
  //   //               "00b25a87e0856213b62296e3b2903771345a33c3777f421cb2c52b010d6808e5", // use this to verify otp
  //   //           "send_to": "sinamira@gmail.com",
  //   //           "vToken":
  //   //               "e796145663ab8ea6e82025b4a51c576914d30f0c45834510793f04c2a9867f29" // For resend otp
  //   //         }
  //   //       },
  //   //     ));
  //   BlocProvider.of<OtpBloc>(context).add(OtpRequest(
  //     email: widget.loginData['profile']['email'],
  //     purpose: 'resend-register',
  //     vToken: resendVtoken,
  //   ));
  // }
}
