import 'dart:async';
import 'dart:io';

import 'config/config.dart';
import 'config/storage.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

import 'config/routes.dart';
import 'config/theme.dart';
import 'data/repositories/repositories.dart';
import 'life_cycle_event.dart';
import 'locator.dart' as service_locator;
import 'locator.dart';

import 'presentation/features/authentication/authentication.dart';
import 'presentation/features/bulletin/bulletin.dart';
import 'presentation/features/country/country.dart';
import 'presentation/features/credits/credits.dart';
import 'presentation/features/delete_account/delete_acc.dart';
import 'presentation/features/forgot_pass/forgot_pass.dart';
import 'presentation/features/home/home.dart';
import 'presentation/features/login/login.dart';
import 'presentation/features/maintenance/maintenance.dart';
import 'presentation/features/notification/notification.dart';
import 'presentation/features/ordering/ordering.dart';
import 'presentation/features/otp/otp.dart';
import 'presentation/features/outlet/outlet.dart';
import 'presentation/features/profile/profile.dart';
import 'presentation/features/register/register.dart';
import 'presentation/features/rewards/reward.dart';
import 'presentation/features/security_pin/security_pin.dart';
import 'presentation/features/settings/setting.dart';
import 'presentation/features/setup/setup.dart';
import 'presentation/features/splash/splash.dart';
import 'presentation/features/verify_email/verify_email.dart';
import 'presentation/features/voucher/voucher.dart';
import 'presentation/features/wallet/wallet.dart';
import 'presentation/features/webview/webview_deeplink.dart';
import 'presentation/navigation_service.dart';
import 'presentation/widgets/extensions/location_screen.dart';
import 'util/custom_page_route.dart';
import 'util/ios_deeplink_listener.dart';

class SimpleBlocDelegate extends BlocObserver {
  @override
  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // ignore: avoid_print
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // ignore: avoid_print
    print(transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // ignore: avoid_print
    print(error);
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// Define a top-level named handler which background/terminated messages will
/// call.
///
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  // debugPrint('Handling a background message ${message.messageId} ${message.data}');
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TempData.deeplink = '';
  Storage().setupDone = null;
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (Platform.isIOS) {
    DeepLinkHandler.listenForDeepLinkIOS();
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await service_locator.init();

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: [
      'en_US',
    ],
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [
      SystemUiOverlay.top, // Shows Status bar
      SystemUiOverlay.bottom, // Shows Navigation bar
    ],
  );
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: colorTransparent,
    systemStatusBarContrastEnforced: true,
    statusBarIconBrightness: Brightness.dark,
    // statusBarBrightness: Brightness.light,
    systemNavigationBarColor: colorWhite,
  ));

  if (kDebugMode) {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // // Set the background messaging handler early on, as a named top-level function
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  NotificationBloc notificationBloc = NotificationBloc();
  try {
    await notificationBloc.initialize();
  } catch (e) {
    e;
  }

  CountryBloc countryBloc = CountryBloc();
  // await countryBloc.initialize();

  ProfileBloc profileBloc = ProfileBloc(userRepository: sl());

  HomeBloc homeBloc = HomeBloc(userRepository: sl(), rewardRepository: sl());

  WalletBloc walletBloc = WalletBloc(userRepository: sl());

  Bloc.observer = SimpleBlocDelegate();

  runApp(
    LifeCycleManager(
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: notificationBloc),
          BlocProvider.value(value: profileBloc),
          BlocProvider.value(value: homeBloc),
          BlocProvider.value(value: countryBloc),
          BlocProvider.value(value: walletBloc),
          BlocProvider<AuthenticationBloc>(
            create: (context) => AuthenticationBloc(
              profileBloc: BlocProvider.of<ProfileBloc>(context),
              homeBloc: BlocProvider.of<HomeBloc>(context),
              walletBloc: BlocProvider.of<WalletBloc>(context),
              countryBloc: BlocProvider.of<CountryBloc>(context),
              userRepository: sl(),
              globalRepository: sl(),
            ),
          ),
        ],
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider<UserRepository>(
              create: (context) => sl(),
            ),
          ],
          child: LocalizedApp(
            delegate,
            BlocListener<NotificationBloc, NotificationState>(
              listener: (context, state) {
                // print('noti state: $state');
                if (state is NotificationIndexed) {
                  //   if (state.target == 'new') {
                  //     sl<NavigationService>().navigateTo(JomNGoRoutes.job);
                  //   }
                  //   if (state.target == 'completed' || state.target == 'rejected') {
                  //     sl<NavigationService>().navigateTo(JomNGoRoutes.home);
                  //   }
                }
              },
              // child: LifeCycleManager(
              child: AqualifeApp(),
            ),
            // ),
          ),
        ),
      ),
    ),
  );
}

// ignore: use_key_in_widget_constructors
class AqualifeApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('en_US');

    return MaterialApp(
      navigatorKey: sl<NavigationService>().navigatorKey,
      navigatorObservers: [NavigationHistoryObserver()],
      onGenerateRoute: _registerRoutesWithParameters,
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: AqualifeTheme.of(context),
    );
  }

  Route _registerRoutesWithParameters(RouteSettings settings) {
    var route = settings.name;
    // ignore: prefer_typing_uninitialized_variables
    var parameters;

    if (settings.name == AqualifeRoutes.splash) {
      return NoAnimationPageRoute(
          builder: (context) {
            return _buildSplashBloc(context, route);
          },
          settings: settings);
    }
    if (settings.name == AqualifeRoutes.register) {
      parameters = settings.arguments as RegisterParameters;
      return NoAnimationPageRoute(
        builder: (context) {
          return _buildRegisterBloc(parameters: parameters);
        },
        settings: settings,
      );
    }
    // if (settings.name == AqualifeRoutes.otp) {
    //   parameters = settings.arguments as OtpParameters;
    //   return NoAnimationPageRoute(
    //       builder: (context) {
    //         return _buildOtpBloc(parameters: parameters);
    //       },
    //       settings: settings);
    // }
    if (settings.name == AqualifeRoutes.otpVerify) {
      parameters = settings.arguments as OtpVerifyParameters;
      return NoAnimationPageRoute(
          builder: (context) {
            return _buildOtpVerifyBloc(parameters: parameters);
          },
          settings: settings);
    }
    if (settings.name == AqualifeRoutes.login) {
      return NoAnimationPageRoute(
          builder: (context) {
            return _buildLoginBloc();
          },
          settings: settings);
    }
    if (settings.name == AqualifeRoutes.forgotPassword) {
      return NoAnimationPageRoute(
          builder: (context) {
            return _buildForgotPassBloc();
          },
          settings: settings);
    }

    if (settings.name == AqualifeRoutes.resetPassword) {
      parameters = settings.arguments as ResetPassParameters;
      return NoAnimationPageRoute(
          builder: (context) {
            return _buildForcePassBloc(parameters: parameters);
          },
          settings: settings);
    }

    if (route != null) {
      if (settings.name == AqualifeRoutes.deeplinkWebview) {
        parameters = settings.arguments as DeeplinkParameters;
      } else if (settings.name == AqualifeRoutes.resetPassword) {
        parameters = settings.arguments as ResetPassParameters;
      } else if (settings.name == AqualifeRoutes.setupEValid) {
        parameters = settings.arguments as EValidParameters;
      } else if (settings.name == AqualifeRoutes.setupEValidOtp) {
        parameters = settings.arguments as EValidOtpParameters;
      } else if (settings.name == AqualifeRoutes.setupCValid) {
        parameters = settings.arguments as CValidParameters;
      } else if (settings.name == AqualifeRoutes.setupCValidOtp) {
        parameters = settings.arguments as CValidOtpParameters;
      } else if (settings.name == AqualifeRoutes.setupVProfile) {
        parameters = settings.arguments as VProfileParameters;
      } else if (settings.name == AqualifeRoutes.setupVMuslim) {
        parameters = settings.arguments as VMuslimParameters;
      } else if (settings.name == AqualifeRoutes.verifyEmail) {
        parameters = settings.arguments as VerifyEmailParameters;
      } else if (settings.name == AqualifeRoutes.verifyEmailOtp) {
        parameters = settings.arguments as VerifyEmailOtpParameters;
      } else if (settings.name == AqualifeRoutes.rewardDetails) {
        parameters = settings.arguments as RewardDetailsParameters;
      } else if (settings.name == AqualifeRoutes.rewardConfirm) {
        parameters = settings.arguments as RewardConfirmParameters;
        // } else if (settings.name ==  AqualifeRoutes.rewardDynamicDetails) {
        //   parameters = settings.arguments as RewardDetailsDynamicParameters;
      } else if (settings.name == AqualifeRoutes.voucherDesc) {
        parameters = settings.arguments as VoucherDescParameters;
      } else if (settings.name == AqualifeRoutes.voucher) {
        parameters = settings.arguments as VoucherParameters;
      } else if (settings.name == AqualifeRoutes.voucherPastDetails) {
        parameters = settings.arguments as VoucherPastDetailsParameters;
      } else if (settings.name == AqualifeRoutes.outletDetails) {
        parameters = settings.arguments as OutletDetailsParameters;
      } else if (settings.name == AqualifeRoutes.history) {
        parameters = settings.arguments as HistoryParameters;
      } else if (settings.name == AqualifeRoutes.rewardOutletDetails) {
        parameters = settings.arguments as RewardOutletDetailsParameters;
      } else if (settings.name == AqualifeRoutes.bulletinDetails) {
        parameters = settings.arguments as BulletinDetailsParameters;
      } else if (settings.name == AqualifeRoutes.orderingMerchant) {
        parameters = settings.arguments as OrderingScreenParameters;
      } else if (settings.name == AqualifeRoutes.orderingOutlet) {
        parameters = settings.arguments as OrderingOutletParameters;
      } else if (settings.name == AqualifeRoutes.locationOutlet) {
        parameters = settings.arguments as LocationScreenParameters;
        // } else if (settings.name ==  AqualifeRoutes.transferCredit) {
        //   parameters = settings.arguments as TransferCreditParameters;
      } else if (settings.name == AqualifeRoutes.maintenanceScreen) {
        parameters = settings.arguments as MaintenanceParameters;
      } else if (settings.name == AqualifeRoutes.securityOtp) {
        parameters = settings.arguments as SecurityOtpParameters;
      }

      return NoAnimationPageRoute(
          builder: (context) {
            return _buildScreen(route, parameters: parameters);
          },
          settings: settings);
    }
    return NoAnimationPageRoute(
      builder: (context) {
        return _buildLoginBloc();
      },
      settings: settings,
    );
  }

  BlocBuilder<AuthenticationBloc, AuthenticationState> _buildScreen(
      String route,
      {Object? parameters}) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
      if (state is AuthenticationAuthenticated) {
        switch (route) {
          case AqualifeRoutes.deeplinkWebview:
            return RedirectWebView(
                parameters: parameters as DeeplinkParameters);
          case AqualifeRoutes.resetPassword:
            return ResetPassScreen(
                parameters: parameters as ResetPassParameters);
          case AqualifeRoutes.splashChecking:
            return SplashCheckingScreen();
          // case AqualifeRoutes.profileReg:
          //   return RegisterProfileScreen(
          //       parameters: parameters as ProfileRegParameters);
          // case AqualifeRoutes.profileExtra:
          //   return RegisterProfileExtraScreen(
          //       parameters: parameters as ProfileExtraParameters);
          case AqualifeRoutes.wallet:
            return WalletScreen();
          case AqualifeRoutes.favDeal:
            return FavDealScreen();
          case AqualifeRoutes.favMerchant:
            return FavMerchantScreen();
          case AqualifeRoutes.favOutlet:
            return FavOutletScreen();
          case AqualifeRoutes.setting:
            return SettingScreen();
          case AqualifeRoutes.profile:
            return ProfileScreen();
          case AqualifeRoutes.verifyEmail:
            return VerifyEmailScreen(
              parameters: parameters as VerifyEmailParameters,
            );
          case AqualifeRoutes.verifyEmailOtp:
            return VerifyEmailOtpScreen(
              parameters: parameters as VerifyEmailOtpParameters,
            );
          case AqualifeRoutes.refer:
            return ReferScreen();
          case AqualifeRoutes.rewardDetails:
            return RewardDetailsScreen(
                parameters: parameters as RewardDetailsParameters);
          case AqualifeRoutes.rewardConfirm:
            return RewardConfirmScreen(
                parameters: parameters as RewardConfirmParameters);
          // case  AqualifeRoutes.rewardDynamicDetails:
          //   return RewardDetailsDynamicScreen(
          //       parameters: parameters as RewardDetailsDynamicParameters);
          case AqualifeRoutes.rewardOutletDetails:
            return RewardOutletDetailsScreen(
                parameters: parameters as RewardOutletDetailsParameters);
          case AqualifeRoutes.voucher:
            return VoucherScreen(parameters: parameters as VoucherParameters);
          case AqualifeRoutes.voucherDesc:
            return VoucherDescScreen(
                parameters: parameters as VoucherDescParameters);
          // case AqualifeRoutes.voucherPast:
          //   return VoucherPastScreen();
          case AqualifeRoutes.voucherPastDetails:
            return VoucherPastDetailsScreen(
                parameters: parameters as VoucherPastDetailsParameters);
          case AqualifeRoutes.voucherManual:
            return VoucherManualScreen();
          case AqualifeRoutes.history:
            return HistoryScreen(parameters: parameters as HistoryParameters);
          case AqualifeRoutes.outletDetails:
            return OutletDetailsScreen(
                parameters: parameters as OutletDetailsParameters);
          case AqualifeRoutes.bulletin:
            return BulletinScreen();
          case AqualifeRoutes.upcoming:
            return UpcomingScreen();
          case AqualifeRoutes.bulletinDetails:
            return BulletinDetailsScreen(
                parameters: parameters as BulletinDetailsParameters);
          case AqualifeRoutes.deleteAccount:
            return DeleteAccScreen();
          case AqualifeRoutes.deleteMobbile:
            return DeleteAccMobileScreen();
          case AqualifeRoutes.creditOnline:
            return CreditOnlineScreen();
          case AqualifeRoutes.pointConversion:
            return PointConversionScreen();
          case AqualifeRoutes.securityCreate:
            return SecurityCreateScreen();
          // case  AqualifeRoutes.securityOriginal:
          //   return SecurityOriginalScreen();
          case AqualifeRoutes.securityChange:
            return SecurityPhoneScreen();
          case AqualifeRoutes.securityOtp:
            return SecurityOtpScreen(
                parameters: parameters as SecurityOtpParameters);
          case AqualifeRoutes.securitySet:
            return SecuritySetScreen();
          case AqualifeRoutes.securityConfirm:
            return SecurityConfirmScreen();
          case AqualifeRoutes.passcodeKey:
            return PasscodeScreen();
          // case  AqualifeRoutes.orderingMerchant:
          //   return OrderingScreen(parameters: parameters as OrderingParameters);
          case AqualifeRoutes.orderingMerchant:
            return OrderingScreen(
              parameters: parameters as OrderingScreenParameters,
            );
          case AqualifeRoutes.orderingOutlet:
            return OrderingOutletScreen(
                parameters: parameters as OrderingOutletParameters);
          case AqualifeRoutes.nearbyOutlet:
            return OrderingNearbyScreen();
          // case  AqualifeRoutes.brandsChecking:
          //   return BrandsCheckingScreen();
          // case  AqualifeRoutes.transferCredit:
          //   return TransferCreditScreen(
          //       parameters: parameters as TransferCreditParameters);
          case AqualifeRoutes.setupEValid:
            return EValidScreen(parameters: parameters as EValidParameters);
          case AqualifeRoutes.setupEValidOtp:
            return EValidOtpScreen(
                parameters: parameters as EValidOtpParameters);
          case AqualifeRoutes.setupCValid:
            return CValidScreen(parameters: parameters as CValidParameters);
          case AqualifeRoutes.setupCValidOtp:
            return CValidOtpScreen(
                parameters: parameters as CValidOtpParameters);
          case AqualifeRoutes.setupVProfile:
            return VProfileScreen(parameters: parameters as VProfileParameters);
          case AqualifeRoutes.setupVMuslim:
            return VMuslimScreen(parameters: parameters as VMuslimParameters);
          case AqualifeRoutes.locationOutlet:
            return LocationScreen(
                parameters: parameters as LocationScreenParameters);
          case AqualifeRoutes.searchResultsPage:
            return SearchView();

          case AqualifeRoutes.maintenanceScreen:
            return MaintenanceScreen(
                parameters: parameters as MaintenanceParameters);
          case AqualifeRoutes.serviceScreen:
            return ServiceErrorScreen();
        }
        return const HomeScreenNew();
      } else if (state is AuthenticationUnauthenticated) {
        return _buildLoginBloc();
      } else if (state is AuthMaintenanceError) {
        return MaintenanceScreen(
            parameters: MaintenanceParameters(message: state.message));
      } else {
        return _buildSplashBloc(context, route);
      }
    });
  }

  BlocProvider<SplashBloc> _buildSplashBloc(BuildContext context, route) {
    var splashBloc = SplashBloc(
      authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      countryBloc: BlocProvider.of<CountryBloc>(context),
    );

    // var splitString = route.split('/');

    // final Map<int, String> values = {
    //   for (int i = 0; i < splitString.length; i++) i: splitString[i]
    // };

    // if (Platform.isAndroid) {
    //   if (TempData.deeplink.isNotEmpty && values[1]!.isNotEmpty) {
    //     splashBloc.add(SplashStart());
    //   } else if (TempData.deeplink.isNotEmpty && values[1]!.isEmpty) {
    //   } else if (TempData.deeplink.isEmpty && values[1]!.isEmpty) {
    //     splashBloc.add(SplashStart());
    //   } else {
    //     splashBloc.add(SplashStart());
    //   }
    // } else {
    //   splashBloc.add(SplashStart());
    // }

    splashBloc.add(SplashStart());

    return BlocProvider<SplashBloc>(
      create: (context) => splashBloc,
      child: SplashScreen(),
    );
  }

  BlocProvider<RegisterBloc> _buildRegisterBloc({Object? parameters}) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: RegisterScreen(parameters: parameters as RegisterParameters),
    );
  }

  // BlocProvider<OtpBloc> _buildOtpBloc({Object? parameters}) {
  //   return BlocProvider<OtpBloc>(
  //     create: (context) => OtpBloc(
  //       userRepository: RepositoryProvider.of<UserRepository>(context),
  //     ),
  //     child: OtpScreen(
  //       parameters: parameters as OtpParameters,
  //     ),
  //   );
  // }

  BlocProvider<OtpBloc> _buildOtpVerifyBloc({Object? parameters}) {
    return BlocProvider<OtpBloc>(
      create: (context) => OtpBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: OtpVerifyScreen(
        parameters: parameters as OtpVerifyParameters,
      ),
    );
  }

  BlocProvider<LoginBloc> _buildLoginBloc() {
    return BlocProvider<LoginBloc>(
      create: (context) => LoginBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
        authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
      ),
      child: const LoginScreen(),
    );
  }

  BlocProvider<ForgotPassBloc> _buildForgotPassBloc() {
    return BlocProvider<ForgotPassBloc>(
      create: (context) => ForgotPassBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: ForgotPassScreen(),
    );
  }

  BlocProvider<ForgotPassBloc> _buildForcePassBloc({Object? parameters}) {
    return BlocProvider<ForgotPassBloc>(
      create: (context) => ForgotPassBloc(
        userRepository: RepositoryProvider.of<UserRepository>(context),
      ),
      child: ResetPassScreen(
        parameters: parameters as ResetPassParameters,
      ),
    );
  }
}
