import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

// Import the RewardState

import '../../../config/routes.dart';
import '../../../config/storage.dart';
import '../../../locator.dart';
import '../../navigation_service.dart';
import '../../widgets/independent/independent.dart';
import '../authentication/authentication_bloc.dart';
import '../authentication/authentication_event.dart';
import '../register/register_screen.dart';
import '../rewards/reward_detail.dart';

class TempData {
  static String voucherId = '';
  static String voucherRefCode = '';
  static String affiliateCode = '';
  static String currentPage = '';
  static String action = '';
  // static String url = '';
  static String deeplink = '';
  // static bool deeplinkDone = false;
}

class DeeplinkParameters {
  final String initialUrl;

  const DeeplinkParameters({required this.initialUrl});
}

class RedirectWebView extends StatefulWidget {
  final DeeplinkParameters parameters;

  const RedirectWebView({super.key, required this.parameters});

  @override
  RedirectWebViewState createState() => RedirectWebViewState();
}

class RedirectWebViewState extends State<RedirectWebView> {
  bool _isProcessed = false;
  bool _shouldLoadContent = true;
  bool _isReferralActionCompleted = false;
  bool _isVoucherActionCompleted = false;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          WebViewWidget(
              controller: WebViewController()
                ..setJavaScriptMode(JavaScriptMode.unrestricted)
                ..setBackgroundColor(const Color(0x00000000))
                ..setNavigationDelegate(
                  NavigationDelegate(
                    onProgress: (int progress) {
                      // Update loading bar.
                    },
                    onPageStarted: (String url) {},
                    onPageFinished: (String url) {
                      Storage().setupDone = null;
                    },
                    onHttpError: (HttpResponseError error) {},
                    onWebResourceError: (WebResourceError error) {
                      inspect(error);
                    },
                    onNavigationRequest: (NavigationRequest request) {
                      Uri uri = Uri.parse(request.url);

                      if (!_isProcessed &&
                          uri.queryParameters.containsKey('c')) {
                        _isProcessed = true;
                        _shouldLoadContent = false; // Prevent further loading

                        try {
                          Map<String, dynamic> decodeResponse =
                              decodeArray(uri.queryParameters['c'].toString());
                          var action = decodeResponse['action'] ?? "";
                          var affiliate = decodeResponse['affiliate'] ?? "";
                          var voucherId = decodeResponse['id'] ?? "";
                          var voucherRefCode = decodeResponse['refer'] ?? "";

                          var token = Storage().token;
                          TempData.action = action;

                          if (mounted) {
                            if (action == 'referral') {
                              if (token.isNotEmpty) {
                                Storage().token = '';
                                Storage().welcomeSplash = '';

                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(AuthenticationLoggedOut());
                              }

                              sl<NavigationService>()
                                  .navigatorKey
                                  .currentState
                                  ?.pushNamedAndRemoveUntil(
                                    AqualifeRoutes.register,
                                    (Route<dynamic> route) => false,
                                    arguments: RegisterParameters(
                                        referralCode: affiliate),
                                  );

                              _isReferralActionCompleted = true;
                              if (_isReferralActionCompleted) {
                                action = '';
                              }
                            } else if (action == 'voucher') {
                              TempData.voucherId = voucherId;
                              TempData.voucherRefCode = voucherRefCode;

                              // TempData.affiliateCode = affiliate;
                              TempData.currentPage = 'voucherPage';
                              if (token.isEmpty) {
                                sl<NavigationService>()
                                    .navigatorKey
                                    .currentState
                                    ?.pushNamedAndRemoveUntil(
                                      AqualifeRoutes.login,
                                      (Route<dynamic> route) => false,
                                    );
                              } else {
                                // print('APPCYCLE SETUPDONE: ${Storage().setupDone}');
                                // if (Storage().setupDone == false) {
                                //   // sl<NavigationService>()
                                //   //     .navigatorKey
                                //   //     .currentState
                                //   //     ?.pushNamedAndRemoveUntil(
                                //   //       MakanTripRoutes.splashChecking,
                                //   //       (Route<dynamic> route) => false,
                                //   //     );

                                //   Navigator.of(context).pushNamedAndRemoveUntil(
                                //     MakanTripRoutes.splashChecking,
                                //     (Route<dynamic> route) => false,
                                //   );
                                // } else {
                                Navigator.of(context).pushNamed(
                                  AqualifeRoutes.rewardDetails,
                                  arguments: RewardDetailsParameters(
                                    rewardId: int.parse(voucherId),
                                    title: '',
                                    indexPage: 3,
                                  ),
                                );
                                // }
                              }

                              _isVoucherActionCompleted = true;
                              if (_isVoucherActionCompleted) {
                                action = '';
                              }
                            }
                          }
                        } catch (e) {
                          debugPrint('Error during decoding: $e');
                          // print('Error during decoding: $e');
                        }

                        return NavigationDecision
                            .prevent; // Prevent WebView navigation
                      }
                      return NavigationDecision.navigate;
                    },
                  ),
                )
                ..loadRequest(Uri.parse(_shouldLoadContent
                    ? widget.parameters.initialUrl
                    : 'about:blank'))),
          // WebView(
          //   initialUrl: _shouldLoadContent
          //       ? widget.parameters.initialUrl
          //       : 'about:blank',
          //   javascriptMode: JavascriptMode.unrestricted,
          //   navigationDelegate: (NavigationRequest request) {
          //     Uri uri = Uri.parse(request.url);

          //     if (!_isProcessed && uri.queryParameters.containsKey('c')) {
          //       _isProcessed = true;
          //       _shouldLoadContent = false; // Prevent further loading

          //       try {
          //         Map<String, dynamic> decodeResponse =
          //             decodeArray(uri.queryParameters['c'].toString());
          //         var action = decodeResponse['action'] ?? "";
          //         var affiliate = decodeResponse['affiliate'] ?? "";
          //         var voucherId = decodeResponse['id'] ?? "";
          //         var voucherRefCode = decodeResponse['refer'] ?? "";

          //         print('TEMPDATA DEEPLINK: $decodeResponse');

          //         var token = Storage().token;
          //         TempData.action = action;

          //         if (mounted) {
          //           if (action == 'referral') {
          //             if (token.isNotEmpty) {
          //               Storage().token = '';
          //               Storage().welcomeSplash = '';

          //               BlocProvider.of<AuthenticationBloc>(context)
          //                   .add(AuthenticationLoggedOut());
          //             }

          //             sl<NavigationService>()
          //                 .navigatorKey
          //                 .currentState
          //                 ?.pushNamedAndRemoveUntil(
          //                   MakanTripRoutes.register,
          //                   (Route<dynamic> route) => false,
          //                   arguments:
          //                       RegisterParameters(referralCode: affiliate),
          //                 );

          //             _isReferralActionCompleted = true;
          //             if (_isReferralActionCompleted) {
          //               action = '';
          //             }
          //           } else if (action == 'voucher') {
          //             TempData.voucherId = voucherId;
          //             TempData.voucherRefCode = voucherRefCode;

          //             print('TEMPDATA WEBVIEW: ${TempData.voucherRefCode}');
          //             // TempData.affiliateCode = affiliate;
          //             TempData.currentPage = 'voucherPage';
          //             if (token.isEmpty) {
          //               sl<NavigationService>()
          //                   .navigatorKey
          //                   .currentState
          //                   ?.pushNamedAndRemoveUntil(
          //                     MakanTripRoutes.login,
          //                     (Route<dynamic> route) => false,
          //                   );
          //             } else {
          //               // print('APPCYCLE SETUPDONE: ${Storage().setupDone}');
          //               // if (Storage().setupDone == false) {
          //               //   // sl<NavigationService>()
          //               //   //     .navigatorKey
          //               //   //     .currentState
          //               //   //     ?.pushNamedAndRemoveUntil(
          //               //   //       MakanTripRoutes.splashChecking,
          //               //   //       (Route<dynamic> route) => false,
          //               //   //     );

          //               //   Navigator.of(context).pushNamedAndRemoveUntil(
          //               //     MakanTripRoutes.splashChecking,
          //               //     (Route<dynamic> route) => false,
          //               //   );
          //               // } else {
          //               Navigator.of(context).pushNamed(
          //                 MakanTripRoutes.rewardDetails,
          //                 arguments: RewardDetailsParameters(
          //                   rewardId: int.parse(voucherId),
          //                   title: '',
          //                   indexPage: 3,
          //                 ),
          //               );
          //               // }
          //             }

          //             _isVoucherActionCompleted = true;
          //             if (_isVoucherActionCompleted) {
          //               action = '';
          //             }
          //           }
          //         }
          //       } catch (e) {
          //         debugPrint('Error during decoding: $e');
          //         // print('Error during decoding: $e');
          //       }

          //       return NavigationDecision.prevent; // Prevent WebView navigation
          //     }

          //     return NavigationDecision
          //         .navigate; // Allow navigation if not processed
          //   },
          //   onPageFinished: (url) {
          //     Storage().setupDone = null;
          //   },
          //   onWebResourceError: (error) {
          //     inspect(error);
          //     // print('WebView error: $error');
          //   },
          // ),
          isLoading ? LoadingWidget() : Stack(),
        ],
      ),
    );
    // return Scaffold(
    //   body: Stack(
    //     children: [
    //       WebView(
    //         initialUrl: _shouldLoadContent
    //             ? widget.parameters.initialUrl
    //             : 'about:blank',
    //         javascriptMode: JavascriptMode.unrestricted,
    //         navigationDelegate: (NavigationRequest request) {
    //           Uri uri = Uri.parse(request.url);

    //           if (!_isProcessed && uri.queryParameters.containsKey('c')) {
    //             _isProcessed = true;
    //             _shouldLoadContent = false; // Prevent further loading

    //             try {
    //               Map<String, dynamic> decodeResponse =
    //                   decodeArray(uri.queryParameters['c'].toString());
    //               var action = decodeResponse['action'] ?? "";
    //               var affiliate = decodeResponse['affiliate'] ?? "";
    //               var voucherId = decodeResponse['id'] ?? "";
    //               var voucherRefCode = decodeResponse['refer'] ?? "";

    //               var token = Storage().token;
    //               TempData.action = action;

    //               if (mounted) {
    //                 if (action == 'referral') {
    //                   if (token.isNotEmpty) {
    //                     Storage().token = '';
    //                     Storage().welcomeSplash = '';

    //                     BlocProvider.of<AuthenticationBloc>(context)
    //                         .add(AuthenticationLoggedOut());
    //                   }

    //                   sl<NavigationService>()
    //                       .navigatorKey
    //                       .currentState
    //                       ?.pushNamedAndRemoveUntil(
    //                         AqualifeRoutes.register,
    //                         (Route<dynamic> route) => false,
    //                         arguments:
    //                             RegisterParameters(referralCode: affiliate),
    //                       );

    //                   _isReferralActionCompleted = true;
    //                   if (_isReferralActionCompleted) {
    //                     action = '';
    //                   }
    //                 } else if (action == 'voucher') {
    //                   TempData.voucherId = voucherId;
    //                   TempData.voucherRefCode = voucherRefCode;
    //                   // TempData.affiliateCode = affiliate;
    //                   TempData.currentPage = 'voucherPage';
    //                   if (token.isEmpty) {
    //                     sl<NavigationService>()
    //                         .navigatorKey
    //                         .currentState
    //                         ?.pushNamedAndRemoveUntil(
    //                           AqualifeRoutes.login,
    //                           (Route<dynamic> route) => false,
    //                         );
    //                   } else {
    //                     // print('APPCYCLE SETUPDONE: ${Storage().setupDone}');
    //                     // if (Storage().setupDone == false) {
    //                     //   // sl<NavigationService>()
    //                     //   //     .navigatorKey
    //                     //   //     .currentState
    //                     //   //     ?.pushNamedAndRemoveUntil(
    //                     //   //       AqualifeRoutes.splashChecking,
    //                     //   //       (Route<dynamic> route) => false,
    //                     //   //     );

    //                     //   Navigator.of(context).pushNamedAndRemoveUntil(
    //                     //     AqualifeRoutes.splashChecking,
    //                     //     (Route<dynamic> route) => false,
    //                     //   );
    //                     // } else {
    //                     Navigator.of(context).pushNamed(
    //                       AqualifeRoutes.rewardDetails,
    //                       arguments: RewardDetailsParameters(
    //                         rewardId: int.parse(voucherId),
    //                         title: '',
    //                         indexPage: 3,
    //                       ),
    //                     );
    //                     // }
    //                   }

    //                   _isVoucherActionCompleted = true;
    //                   if (_isVoucherActionCompleted) {
    //                     action = '';
    //                   }
    //                 }
    //               }
    //             } catch (e) {
    //               debugPrint('Error during decoding: $e');
    //               // print('Error during decoding: $e');
    //             }

    //             return NavigationDecision.prevent; // Prevent WebView navigation
    //           }

    //           return NavigationDecision
    //               .navigate; // Allow navigation if not processed
    //         },
    //         onPageFinished: (url) {
    //           Storage().setupDone = null;
    //         },
    //         onWebResourceError: (error) {
    //           inspect(error);
    //           // print('WebView error: $error');
    //         },
    //       ),
    //       isLoading ? LoadingWidget() : Stack(),
    //     ],
    //   ),
    // );
  }

  Map<String, dynamic> decodeArray(String hexData) {
    try {
      Uint8List bytes = hexToBytes(hexData);
      String base64String = utf8.decode(bytes);
      Uint8List decodedBytes = base64.decode(base64String);
      String jsonString = utf8.decode(decodedBytes);
      return jsonDecode(jsonString);
    } catch (e) {
      // print('Error during decoding: $e');
      debugPrint('Error during decoding: $e');
      rethrow;
    }
  }

  Uint8List hexToBytes(String hex) {
    if (hex.length % 2 != 0) {
      throw FormatException('Hex string must have an even length');
    }

    final length = hex.length;
    final bytes = Uint8List(length ~/ 2);

    for (int i = 0; i < length; i += 2) {
      bytes[i ~/ 2] = int.parse(hex.substring(i, i + 2), radix: 16);
    }

    return bytes;
  }
}
