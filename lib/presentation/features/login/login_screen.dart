import 'dart:convert';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/global_setup.dart';
import '../../../config/routes.dart';
import '../../../config/storage.dart';

import '../../../domain/entities/validator.dart';
import '../../widgets/data_driven/datadriven.dart';
import '../../widgets/independent/independent.dart';
import '../authentication/authentication.dart';
import '../forgot_pass/forgot_pass.dart';
import '../maintenance/maintenance_screen.dart';
import '../register/register.dart';
import '../rewards/reward_detail.dart';
import '../setup/setup.dart';
import '../splash/splash.dart';
import '../webview/webview_deeplink.dart';
import 'login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  bool checkValue = false;
  bool error = false;
  bool isforgotclick = false;
  String errorfield = '';
  // String selectedCode = '60';
  String errorTextEmail = '', errorTextPwd = '';
  // List<String> getCode = [];
  late String passwordValid = '';
  late double sizeBetween;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final GlobalKey<AqualifeSelectValueState> codeKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> emailKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> passwordKey = GlobalKey();

  bool isProcessing = false;
  late FocusNode emailFocus, pwFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;
  // bool isAppInactive = false; // if the app is Inactive then show
  // final dynamicLink = FirebaseDynamicLinks.instance;
  Codec<String, String> infoToBase64 = utf8.fuse(base64);
  FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  String voucherId = '';
  String initialDeeplink = '';
  // AppLinks? _appLinks;
  // StreamSubscription<Uri>? _sub;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    // _initDeepLinkListener();
    Storage().token = '';
    voucherId = TempData.voucherId;
    _loadUserLogin();

    fToast = FToast();
    fToast.init(context);
    emailFocus = FocusNode();
    pwFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    voucherId = '';
    emailFocus.dispose();
    pwFocus.dispose();
    _connectivity.disposeStream();
    // _sub!.cancel();

    super.dispose();
  }

  click(bool isforgotclick) {
    setState(() {
      isforgotclick = isforgotclick;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    sizeBetween = height / 20;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorBackground,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorWhite,
      ),
      child: Theme(
        data: ThemeData(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: errorfield == '' ? colorDarkGray : colorRed,
          ),
        ),
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            // resizeToAvoidBottomInset: false, // this is new
            backgroundColor: colorBackground,
            body: BlocConsumer<LoginBloc, LoginState>(
              listener: (context, state) async {
                if (state is LoginMaintenanceError) {
                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => MaintenanceScreen(
                            parameters:
                                MaintenanceParameters(message: state.message))),
                    ModalRoute.withName('/'),
                  );
                }

                if (state is LoginFinished) {
                  setProcessingStatus(false);

                  if (checkValue == true) {
                    secureStorage.write(
                        key: 'remember', value: checkValue.toString());
                    String mobileEncode =
                        infoToBase64.encode(emailController.text);
                    String passwordEncode =
                        infoToBase64.encode(passwordController.text);

                    secureStorage.write(key: 'email', value: mobileEncode);
                    secureStorage.write(key: 'password', value: passwordEncode);
                  } else {
                    secureStorage.write(
                        key: 'remember', value: checkValue.toString());
                    secureStorage.write(key: 'email', value: '');
                    secureStorage.write(key: 'password', value: '');
                  }

                  if (state.loginData['token'] != null) {
                    if (state.loginData['isResetPassword'] == true) {
                      Storage().setupDone = false;
                      if (mounted) {
                        SplashTimerDialog.showSplashLoginDialog(
                          context,
                          () {
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(AuthenticationLoggedOut());
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.login,
                                (Route<dynamic> route) => false);

                            Navigator.pushNamed(
                                context, AqualifeRoutes.resetPassword,
                                arguments: ResetPassParameters(
                                  email: state.loginData['profile']['email'],
                                  vToken: state.loginData['vToken'],
                                ));
                          },
                        );
                      }
                    } else if (isEmailRequired && !state.loginData['eValid']) {
                      Storage().setupDone = false;
                      // need to fill and get OTP
                      if (mounted) {
                        SplashTimerDialog.showSplashLoginDialog(
                          context,
                          () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.setupEValid,
                                (Route<dynamic> route) => false,
                                arguments: EValidParameters(
                                    loginData: state.loginData));
                          },
                        );
                      }
                    } else if (!isEmailRequired && !state.loginData['eValid']) {
                      Storage().setupDone = false;
                      // need to fill only. No need OTP
                      if (mounted) {
                        SplashTimerDialog.showSplashLoginDialog(
                          context,
                          () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.setupEValid,
                                (Route<dynamic> route) => false,
                                arguments: EValidParameters(
                                    loginData: state.loginData));
                          },
                        );
                      }
                    } else if (isContactRequired &&
                        !state.loginData['cValid']) {
                      Storage().setupDone = false;
                      // need to fill and get OTP
                      SplashTimerDialog.showSplashLoginDialog(
                        context,
                        () {
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.setupCValid,
                                (Route<dynamic> route) => false,
                                arguments:
                                    CValidParameters(profile: state.loginData));
                          }
                        },
                      );
                    } else if (!isContactRequired &&
                        !state.loginData['cValid']) {
                      Storage().setupDone = false;
                      // need to fill only. No need OTP
                      SplashTimerDialog.showSplashLoginDialog(
                        context,
                        () {
                          if (mounted) {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.setupCValid,
                                (Route<dynamic> route) => false,
                                arguments:
                                    CValidParameters(profile: state.loginData));
                          }
                        },
                      );
                    } else if (state.loginData['vProfile'] == false) {
                      Storage().setupDone = false;
                      if (mounted) {
                        SplashTimerDialog.showSplashLoginDialog(
                          context,
                          () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                AqualifeRoutes.setupVProfile,
                                (Route<dynamic> route) => false,
                                arguments: VProfileParameters(
                                    profile: state.loginData));
                          },
                        );
                      }
                    } else if (isMuslimFriendly == true &&
                        state.loginData['vMuslim'] == false) {
                      Storage().setupDone = false;
                      if (mounted) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AqualifeRoutes.setupVMuslim,
                            (Route<dynamic> route) => false,
                            arguments:
                                VMuslimParameters(profile: state.loginData));
                      }
                    } else if (voucherId.isNotEmpty) {
                      // Storage().setupDone = true;
                      _redirectToVoucher();
                    } else {
                      // Storage().setupDone = true;
                      SplashTimerDialog.showSplashLoginDialog(context, () {
                        if (mounted) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AqualifeRoutes.home,
                              (Route<dynamic> route) => false);
                        }
                      });
                    }

                    // if (state.loginData['isResetPassword'] == true) {
                    //   if (mounted) {
                    //     SplashTimerDialog.showSplashLoginDialog(
                    //       context,
                    //       () {
                    //         BlocProvider.of<AuthenticationBloc>(context)
                    //             .add(AuthenticationLoggedOut());
                    //         Navigator.of(context).pushNamedAndRemoveUntil(
                    //             AqualifeRoutes.login,
                    //             (Route<dynamic> route) => false);

                    //         Navigator.pushNamed(
                    //             context, AqualifeRoutes.resetPassword,
                    //             arguments: ResetPassParameters(
                    //               email: state.loginData['profile']['email'],
                    //               vToken: state.loginData['vToken'],
                    //             ));
                    //       },
                    //     );
                    //   }
                    // } else if (state.loginData['eValid'] == false) {
                    //   if (mounted) {
                    //     SplashTimerDialog.showSplashLoginDialog(
                    //       context,
                    //       () {
                    //         Navigator.of(context).pushNamedAndRemoveUntil(
                    //             AqualifeRoutes.setupEValid,
                    //             (Route<dynamic> route) => false,
                    //             arguments: EValidParameters(
                    //                 loginData: state.loginData));
                    //       },
                    //     );
                    //   }
                    //   // } else if (state.loginData['vProfile'] == false) {
                    //   //   // Check `mounted` before accessing 'context'.
                    //   //   if (mounted) {
                    //   //     SplashTimerDialog.showSplashLoginDialog(
                    //   //       context,
                    //   //       () {
                    //   //         Navigator.of(context).pushNamedAndRemoveUntil(
                    //   //             AqualifeRoutes.profileReg,
                    //   //             (Route<dynamic> route) => false,
                    //   //             arguments: ProfileRegParameters(
                    //   //                 profile: state.loginData));
                    //   //       },
                    //   //     );
                    //   //   }
                    //   // } else if (isMuslimFriendly == true &&
                    //   //     state.loginData['vMuslim'] == false) {
                    //   //   // Check `mounted` before accessing 'context'.
                    //   //   if (mounted) {
                    //   //     Navigator.of(context).pushNamedAndRemoveUntil(
                    //   //         AqualifeRoutes.profileReg,
                    //   //         (Route<dynamic> route) => false,
                    //   //         arguments:
                    //   //             ProfileRegParameters(profile: state.loginData));
                    //   //   }
                    // } else if (state.loginData['vProfile'] == true &&
                    //     state.loginData['vExtra'] == false) {
                    //   if (mounted) {
                    //     SplashTimerDialog.showSplashLoginDialog(
                    //       context,
                    //       () {
                    //         Navigator.of(context).pushNamedAndRemoveUntil(
                    //             AqualifeRoutes.setupCValid,
                    //             (Route<dynamic> route) => false,
                    //             arguments:
                    //                 CValidParameters(profile: state.loginData));
                    //       },
                    //     );
                    //   }
                    // } else if (state.loginData['vExtra'] == true &&
                    //     state.loginData['cValid'] == false) {
                    //   SplashTimerDialog.showSplashLoginDialog(
                    //     context,
                    //     () {
                    //       Navigator.of(context).pushNamedAndRemoveUntil(
                    //           AqualifeRoutes.setupCValid,
                    //           (Route<dynamic> route) => false,
                    //           arguments:
                    //               CValidParameters(profile: state.loginData));
                    //     },
                    //   );
                    // } else if (voucherId.isNotEmpty) {
                    //   _redirectToVoucher();
                    // } else {
                    //   // var dynamicLink = Storage().dynamicLink;

                    //   // if (dynamicLink != null) {
                    //   //   var type = dynamicLink.queryParameters['type'];
                    //   //   var code = dynamicLink.queryParameters['code'];

                    //   //   if (type == 'vouchers' && code != null) {
                    //   //     if (!mounted) return;

                    //   //     // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   //     //      AqualifeRoutes.rewardDynamicDetails,
                    //   //     //     (Route<dynamic> route) => false,
                    //   //     //     arguments: RewardDetailsDynamicParameters(
                    //   //     //       code: code,
                    //   //     //     ));
                    //   //   } else if (type == 'subscriptions' && code != null) {
                    //   //     if (!mounted) return;

                    //   //     // Navigator.of(context).pushNamedAndRemoveUntil(
                    //   //     //      AqualifeRoutes.subscriptionDetailsDynamic,
                    //   //     //     (Route<dynamic> route) => false,
                    //   //     //     arguments: SubscriptionDetailsDynamicParameters(
                    //   //     //       code: code,
                    //   //     //     ));
                    //   //   }
                    //   // } else {

                    //   SplashTimerDialog.showSplashLoginDialog(context, () {
                    //     if (mounted) {
                    //       Navigator.of(context).pushNamedAndRemoveUntil(
                    //           AqualifeRoutes.home,
                    //           (Route<dynamic> route) => false);
                    //     }
                    //   });
                    // }
                  } else {
                    setProcessingStatus(false);
                  }
                }
                if (state is LoginError) {
                  // ignore: unnecessary_null_comparison
                  state.error != null ? error = true : error = false;

                  setProcessingStatus(false);
                  showErrorToast(state.error, context);
                }
                if (state is LoginNetworkError) {
                  setProcessingStatus(false);
                  showErrorToast(state.error, context);
                }
              },
              builder: (context, state) {
                // BlocProvider.of<CountryBloc>(context).add(CountryLoad());

                if (state is LoginProcessing) {}

                return SingleChildScrollView(
                  reverse: true, // this is new
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        marginHorizontal, 0, marginHorizontal, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 50),
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                          height: height / 7,
                          child: Text(
                            'Sign In',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 50, 0, 10),
                          child: Text(
                            'Email',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 15),
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
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 10),
                          child: Text(
                            'Password',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Container(
                          // padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            color: colorBackground,
                            boxShadow: [
                              BoxShadow(
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                              errorfield == 'errorPwd'
                                          ? colorRed
                                          : colorGreyBox,
                                  // blurRadius: 15.0,
                                  offset: Offset(
                                      0.0,
                                      error
                                          ? 3
                                          : errorfield == 'error' ||
                                                  errorfield == 'errorPwd'
                                              ? 3
                                              : 0))
                            ],
                            border: Border.all(color: colorGreyBox),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: AqualifeInputField(
                            key: passwordKey,
                            controller: passwordController,
                            // label: '',
                            textAlignVertical: TextAlignVertical.center,
                            // hint: 'Password',
                            validator: Validator.valueExists,
                            keyboard: TextInputType.text,
                            isPassword: true,
                            border: InputBorder.none,
                            focusNode: pwFocus,
                            onValueChanged: (value) {
                              if (value != '') {
                                setState(() {
                                  errorfield = '';
                                  error = false;
                                  passwordKey.currentState?.validate();
                                });
                              }
                            },
                          ),
                        ),
                        errorfield == 'error' || errorfield == 'errorPwd'
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  errorTextPwd,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                                  errorfield == 'errorPwd'
                                              ? colorRed
                                              : colorGreyBox),
                                ),
                              )
                            : SizedBox(),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(bottom: 20),
                                child: Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: Colors.black45,
                                  ),
                                  child: CheckboxListTile(
                                    dense: true,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 0),
                                    title: Text(
                                      'Stayed sign in?',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: checkValue == false
                                            ? FontWeight.w400
                                            : FontWeight.w500,
                                        color: checkValue == false
                                            ? Colors.black45
                                            : colorBlack,
                                        fontFamily: fontFamilyMain,
                                      ),
                                    ),
                                    value: checkValue,
                                    onChanged: _onChangedData,
                                    checkColor: colorWhite,
                                    activeColor: mainColor,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.centerRight,
                                margin: EdgeInsets.only(bottom: 20),
                                child: AqualifeTextButton(
                                  'Forgot password?',
                                  color: isforgotclick
                                      ? colorLightBlue
                                      : colorDarkGray,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  underline: true,
                                  onClick: () {
                                    setState(() {
                                      click(true);

                                      Navigator.of(context).pushNamed(
                                          AqualifeRoutes.forgotPassword);
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
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
                  AqualifeStyleButton(
                    height: height / 14,
                    title: isProcessing ? 'Processing...' : 'Sign In',
                    backgroundColor: isProcessing ? colorLightGray : mainColor,
                    textColor: isProcessing ? colorDarkGray : colorWhite,
                    onPressed: _validateAndSend,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account yet?',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          AqualifeTextButton(
                            'Register',
                            color: mainColor,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            underline: true,
                            // fontStyle: FontStyle.italic,
                            onClick: _registerNow,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onChangedData(bool? value) {
    if (value != null) {
      setState(() {
        checkValue = value;
      });
    }
  }

  void _registerNow() {
    Navigator.of(context).pushNamed(AqualifeRoutes.register,
        arguments: RegisterParameters(
          referralCode: '',
        ));
  }

  void _redirectToVoucher() {
    if (mounted) {
      SplashTimerDialog.showSplashLoginDialog(
        context,
        () {
          Navigator.of(context).pushNamedAndRemoveUntil(
              AqualifeRoutes.rewardDetails,
              arguments: RewardDetailsParameters(
                rewardId: int.parse(voucherId),
                title: '',
                indexPage: 3,
              ),
              (Route<dynamic> route) => true);
          // Navigator.of(context).pushNamed(
          //   AqualifeRoutes.rewardDetails,
          //   arguments: RewardDetailsParameters(
          //     rewardId: int.parse(voucherId),
          //     title: '',
          //     indexPage: 3,
          //   ),
          // );
        },
      );
    }

    // Navigator.of(context).pushNamed(
    //   AqualifeRoutes.rewardDetails,
    //   arguments: RewardDetailsParameters(
    //     rewardId: int.parse(voucherId),
    //     title: '',
    //     indexPage: 3,
    //   ),
    // );
  }

  void _validateAndSend() {
    if (emailKey.currentState?.validate() != null &&
        passwordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'error';
      emailFocus.requestFocus();
      errorTextEmail = 'The email address is required!';
      errorTextPwd = 'The password is required!';
    } else if (emailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'The email address is required!';
      // showErrorToast('Email address is required !', context);
    } else if (passwordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      pwFocus.requestFocus();
      errorTextPwd = 'The password is required!';
      // showErrorToast('Password is required !', context);
    } else {
      errorfield = '';

      setProcessingStatus(true);
      BlocProvider.of<LoginBloc>(context).add(
        LoginPressed(
          email: emailController.text.trim(),
          password: passwordController.text.trim(), //passwordValid.trim(),
        ),
      );
    }
  }

  void _loadUserLogin() async {
    try {
      secureStorage.read(key: 'remember').then((value) {
        if (value == 'true') {
          setState(() {
            checkValue = true;
          });
          secureStorage.read(key: 'email').then((valueEmail) {
            String emailDecoded = utf8.decode(base64Url.decode(valueEmail!));
            emailController.text = emailDecoded;
          });
          secureStorage.read(key: 'password').then((valuePw) {
            String passwordDecoded = utf8.decode(base64Url.decode(valuePw!));
            passwordController.text = passwordDecoded;
          });
        } else {
          emailController.text = '';
          passwordController.text = '';
        }
      });
    } catch (e) {
      e;
    }
  }

  // decodedString() {
  //   if (Storage().mobileNo.isNotEmpty && Storage().password.isNotEmpty) {
  //     String mobileDecoded = utf8.decode(base64Url.decode(Storage().mobileNo));
  //     String passwordDecoded =
  //         utf8.decode(base64Url.decode(Storage().password));

  //     phoneController.text = mobileDecoded;
  //     passwordController.text = passwordDecoded;
  //   } else {
  //     phoneController.text = '';
  //     passwordController.text = '';
  //   }
  // }
}
