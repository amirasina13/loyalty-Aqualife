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
import '../../../locator.dart';
import '../../../util/ios_deeplink_listener.dart';
import '../../widgets/independent/independent.dart';
import '../authentication/authentication.dart';
import '../country/country.dart';
import '../forgot_pass/reset_pass_screen.dart';
import '../home/home.dart';
import '../maintenance/maintenance_screen.dart';
import '../profile/profile.dart';
import '../setup/setup.dart';
import '../wallet/wallet.dart';
import '../webview/webview_deeplink.dart';
import '../wrapper.dart';

class SplashCheckingScreen extends StatefulWidget {
  const SplashCheckingScreen({super.key});

  @override
  State<SplashCheckingScreen> createState() => _SplashCheckingScreenState();
}

class _SplashCheckingScreenState extends State<SplashCheckingScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: colorYellowLogo,
        systemNavigationBarColor: colorYellowLogo,
      ),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, profileState) {
          if (profileState is ProfileProcessing) {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: colorWhite,
              child: Center(
                child: CircularProgressIndicator(
                  color: colorDisableGrey,
                ),
              ),
            );
          }
          return SplashCheckingWrapper();
        },
      ),
    );
  }
}

class SplashCheckingWrapper extends StatefulWidget {
  const SplashCheckingWrapper({super.key});

  @override
  AqualifeWrapperState<SplashCheckingWrapper> createState() =>
      _SplashCheckingWrapperState();
}

class _SplashCheckingWrapperState
    extends AqualifeWrapperState<SplashCheckingWrapper> {
  String initialDeeplink = '';
  String referralCode = '';
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;

  void _initDeepLinkListener() {
    _appLinks = AppLinks();
    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      if (uri.host == 'loyalty.aqualifecambodia.com') {
        TempData.deeplink = uri.toString();
      } else {
        // Optionally handle cases where the host does not match
        debugPrint('Deep link from a different host: ${uri.host}');
        TempData.deeplink = '';
      }
    });
  }

  @override
  void initState() {
    super.initState();

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
    return BlocProvider<AuthenticationBloc>(
      create: (context) {
        // ProfileBloc profileBloc = ProfileBloc(userRepository: sl());
        return AuthenticationBloc(
          profileBloc: BlocProvider.of<ProfileBloc>(context),
          homeBloc: BlocProvider.of<HomeBloc>(context),
          walletBloc: BlocProvider.of<WalletBloc>(context),
          countryBloc: BlocProvider.of<CountryBloc>(context),
          userRepository: sl(),
          globalRepository: sl(),
        )..add(AuthenticationChecking());
      },
      child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          fToast = FToast();
          fToast.init(context);

          if (state is AuthenticationChecked) {
            if (state.loginData['isResetPassword'] == true) {
              Storage().setupDone = false;
              if (mounted) {
                // SplashTimerDialog.showSplashLoginDialog(
                //   context,
                //   () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(AuthenticationLoggedOut());
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.login, (Route<dynamic> route) => false);

                Navigator.pushNamed(context, AqualifeRoutes.resetPassword,
                    arguments: ResetPassParameters(
                      email: state.loginData['profile']['email'],
                      vToken: state.loginData['vToken'],
                    ));
                //   },
                // );
              }
            } else if (isEmailRequired && !state.loginData['eValid']) {
              Storage().setupDone = false;
              // need to fill and get OTP
              if (mounted) {
                // SplashTimerDialog.showSplashLoginDialog(
                //   context,
                //   () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.setupEValid, (Route<dynamic> route) => false,
                    arguments: EValidParameters(loginData: state.loginData));
                //   },
                // );
              }
            } else if (!isEmailRequired && !state.loginData['eValid']) {
              Storage().setupDone = false;
              // need to fill only. No need OTP
              if (mounted) {
                // SplashTimerDialog.showSplashLoginDialog(
                //   context,
                //   () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.setupEValid, (Route<dynamic> route) => false,
                    arguments: EValidParameters(loginData: state.loginData));
                //   },
                // );
              }
            } else if (isContactRequired && !state.loginData['cValid']) {
              Storage().setupDone = false;
              // need to fill and get OTP
              // SplashTimerDialog.showSplashLoginDialog(
              //   context,
              //   () {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.setupCValid, (Route<dynamic> route) => false,
                    arguments: CValidParameters(profile: state.loginData));
              }
              //   },
              // );
            } else if (!isContactRequired && !state.loginData['cValid']) {
              Storage().setupDone = false;
              // need to fill only. No need OTP
              // SplashTimerDialog.showSplashLoginDialog(
              //   context,
              //   () {
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.setupCValid, (Route<dynamic> route) => false,
                    arguments: CValidParameters(profile: state.loginData));
              }
              //   },
              // );
            } else if (state.loginData['vProfile'] == false) {
              Storage().setupDone = false;
              if (mounted) {
                // SplashTimerDialog.showSplashLoginDialog(
                //   context,
                //   () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.setupVProfile,
                    (Route<dynamic> route) => false,
                    arguments: VProfileParameters(profile: state.loginData));
                // },
                // );
              }
            } else if (isMuslimFriendly == true &&
                state.loginData['vMuslim'] == false) {
              Storage().setupDone = false;
              if (mounted) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.setupVMuslim,
                    (Route<dynamic> route) => false,
                    arguments: VMuslimParameters(profile: state.loginData));
              }
            } else if (TempData.deeplink.isNotEmpty) {
              // Storage().setupDone = true;
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
              // SplashTimerDialog.showSplashLoginDialog(context, () {
              if (mounted) {
                // Storage().setupDone = true;
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AqualifeRoutes.home, (Route<dynamic> route) => false);
              }
              // });
            }
          } else if (state is AuthenticationUnauthenticated) {
            if (TempData.deeplink.isNotEmpty) {
              // Storage().setupDone = true;
              // Navigate to webview to intercept the URL - convert from short URL to long URL
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RedirectWebView(
                      parameters:
                          DeeplinkParameters(initialUrl: TempData.deeplink)),
                ),
              );
            } else {
              // Storage().setupDone = true;
              Navigator.of(context).pushNamedAndRemoveUntil(
                  AqualifeRoutes.login, (Route<dynamic> route) => false);
            }
          } else if (state is NetworkError) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AqualifeRoutes.login, (Route<dynamic> route) => false);
            showErrorToast('No internet connection.', context);
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
        builder: (context, state) {
          return AqualifeScaffold(
            systemUiOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: colorWhite,
              systemNavigationBarColor: colorWhite,
            ),
            extendBodyBehindAppBar: true,
            appBarColor: colorTransparent,
            body: Container(),
            bottomMenuIndex: 0,
            isShow: false,
          );
        },
      ),
    );
  }

  // checkDynamicLink(Future<Object?> navigate) async {
  //   var dynamicLink = Storage().dynamicLink;

  //   if (dynamicLink != null) {
  //     var type = dynamicLink.queryParameters['type'];
  //     var code = dynamicLink.queryParameters['code'];

  //     if (type == 'vouchers' && code != null) {
  //       if (!mounted) return;

  //       // Navigator.of(context).pushNamedAndRemoveUntil(
  //       //      AqualifeRoutes.rewardDynamicDetails, (Route<dynamic> route) => false,
  //       //     arguments: RewardDetailsDynamicParameters(code: code));
  //     } else if (type == 'subscriptions' && code != null) {
  //       if (!mounted) return;

  //       // Navigator.of(context).pushNamedAndRemoveUntil(
  //       //      AqualifeRoutes.subscriptionDetailsDynamic,
  //       //     (Route<dynamic> route) => false,
  //       //     arguments: SubscriptionDetailsDynamicParameters(code: code));
  //     }
  //   } else {
  //     navigate;
  //   }
  // }
}
