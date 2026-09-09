import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/global_setup.dart';
import '../../../config/routes.dart';
import '../../../config/storage.dart';
import '../../../util/ios_deeplink_listener.dart';
import '../../widgets/independent/independent.dart';
import '../authentication/authentication.dart';
import '../forgot_pass/reset_pass_screen.dart';
import '../maintenance/maintenance_screen.dart';
import '../setup/setup.dart';
import '../webview/webview_deeplink.dart';
import 'splash.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String initialDeeplink = '';
  String referralCode = '';
  String voucherId = '';

  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  // void _initDeepLinkListener() {
  //   _appLinks = AppLinks();
  //   _sub = _appLinks!.allUriLinkStream.listen((uri) async {
  //     setState(() {
  //       initialDeeplink = uri.toString();
  //     });
  //   });
  // }

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      if (uri.host == 'loyalty.aqualifecambodia.com') {
        // setState(() {
        //   initialDeeplink = uri.toString();
        // });
        TempData.deeplink = uri.toString();
      } else {
        // Optionally handle cases where the host does not match
        debugPrint('Deep link from a different host: ${uri.host}');
        // setState(() {
        //   initialDeeplink = '';
        // });
        TempData.deeplink = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // _initDeepLinkListener();
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
    // var width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorWhite,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: colorWhite,
      ),
      child: Scaffold(
        backgroundColor: colorWhite,
        body: BlocConsumer<SplashBloc, SplashState>(
          listener: (context, state) {},
          builder: (context, state) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) async {
                fToast = FToast();
                fToast.init(context);

                if (state is AuthenticationAuthenticated) {
                  Storage().dataCheck = state.loginData;

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
                    // need to fill and get OTP
                    Storage().setupDone = false;
                    if (mounted) {
                      SplashTimerDialog.showSplashLoginDialog(
                        context,
                        () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AqualifeRoutes.setupEValid,
                              (Route<dynamic> route) => false,
                              arguments:
                                  EValidParameters(loginData: state.loginData));
                        },
                      );
                    }
                  } else if (!isEmailRequired && !state.loginData['eValid']) {
                    // need to fill only. No need OTP
                    Storage().setupDone = false;
                    if (mounted) {
                      SplashTimerDialog.showSplashLoginDialog(
                        context,
                        () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AqualifeRoutes.setupEValid,
                              (Route<dynamic> route) => false,
                              arguments:
                                  EValidParameters(loginData: state.loginData));
                        },
                      );
                    }
                  } else if (isContactRequired && !state.loginData['cValid']) {
                    // need to fill and get OTP
                    Storage().setupDone = false;
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
                  } else if (!isContactRequired && !state.loginData['cValid']) {
                    // need to fill only. No need OTP
                    Storage().setupDone = false;
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
                              arguments:
                                  VProfileParameters(profile: state.loginData));
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
                  } else if (TempData.deeplink.isNotEmpty) {
                    // Storage().setupDone = true;
                    // Navigate to webview to intercept the url - convert from short url to long url
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RedirectWebView(
                              parameters: DeeplinkParameters(
                                  initialUrl: TempData.deeplink)),
                        ),
                      );
                    }
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
                } else if (state is AuthenticationUnauthenticated) {
                  if (TempData.deeplink.isNotEmpty) {
                    // Storage().setupDone = true;
                    // Navigate to webview to intercept the URL - convert from short URL to long URL
                    if (mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RedirectWebView(
                              parameters: DeeplinkParameters(
                                  initialUrl: TempData.deeplink)),
                        ),
                      );
                    }
                  } else {
                    // Storage().setupDone = true;
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AqualifeRoutes.login,
                          (Route<dynamic> route) => false);
                    }
                  }
                } else if (state is NetworkError) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.login, (Route<dynamic> route) => false);
                  showErrorToast('No internet connection.', context);
                  // ErrorIconDialog.showErrorDialog(
                  //     context, 'No internet connection.');
                } else if (state is AuthenticationError) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.login, (Route<dynamic> route) => false);
                  showErrorToast(state.error, context);
                } else if (state is AuthMaintenanceError) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.maintenanceScreen,
                      (Route<dynamic> route) => false,
                      arguments: MaintenanceParameters(message: state.message));
                }
              },
              child: Center(
                child: Container(
                  height: height * 0.25,
                  width: height * 0.25, // width * 0.8,
                  margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(appLogo),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
