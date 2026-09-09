import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../widgets/independent/independent.dart';
import '../../../widgets/independent/webview.dart';
import '../../authentication/authentication.dart';
import '../../profile/profile.dart';
import '../../webview/webview_dialog.dart';

class SettingView extends StatefulWidget {
  final Function changeView;
  const SettingView({super.key, required this.changeView});

  @override
  State<SettingView> createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  PackageInfo? packageInfo;
  bool load = false;
  bool? clickPasscode = false;
  String? profileImage, email;
  final TextEditingController pinController = TextEditingController();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
      fontFamily: fontFamilyMain,
    ),
    margin: EdgeInsets.zero,
  );

  // Future _fetchPackageInfo() async {
  //   packageInfo = await PackageInfo.fromPlatform();
  // }

  @override
  initState() {
    super.initState();
    // _fetchPackageInfo().then((value) {
    //   setState(() {});
    // });

    fToast = FToast();
    fToast.init(context);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AqualifeRoutes.wallet,
          (Route<dynamic> route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: colorBackground,
        body: Center(
          child: Container(
            margin:
                EdgeInsets.fromLTRB(marginHorizontal, 20, marginHorizontal, 0),
            child: ListView(
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontFamily: fontFamilyMain,
                          color: colorBlack,
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    BlocConsumer<ProfileBloc, ProfileState>(
                      listener: (context, profileState) {},
                      builder: (context, profileState) {
                        Image? image;
                        String name = 'Unknown';

                        if (profileState is ProfileLoaded) {
                          var profile = profileState.userProfile.profile;

                          // ignore: unnecessary_null_comparison
                          if (profile != null) {
                            profileImage = profile.image;
                            name = profile.name!;
                            email = profile.email!;

                            if (profileImage != null) {
                              // image = profileImage!;
                              image = Image.network(
                                profileImage!,
                                //  "https://staging-loyalty-bp.incitefood.com/storages/imgs/2022/04/123804_0_000_9.png",
                                fit: BoxFit.fill,
                              );
                            } else {
                              image = Image.asset('assets/icons/no_photo.png');
                            }
                          }
                        }

                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                height: 50,
                                width: width * 0.5,
                                // color: colorBabyBlue,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      color: colorBackground,
                                      height: width * 0.1,
                                      width: width * 0.1,
                                      margin: EdgeInsets.only(right: 10),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        child: image,
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 12.0,
                                          color: colorGrey,
                                          fontFamily: fontFamilyMain,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: 'Welcome\n',
                                          ),
                                          TextSpan(
                                            style: TextStyle(
                                              fontSize: 14.0,
                                              color: colorBlack,
                                              fontFamily: fontFamilyMain,
                                              fontWeight: FontWeight.w500,
                                            ),
                                            text: name,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: Container(
                            // margin: EdgeInsets.only(right: 20),
                            child: InkWell(
                              onTap: () async {
                                BlocProvider.of<AuthenticationBloc>(context)
                                    .add(AuthenticationLoggedOut());
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    AqualifeRoutes.login,
                                    (Route<dynamic> route) => false);
                              },
                              child: Image.asset(
                                'assets/icons/settings/logout-box-r-line.png',
                                height: 25,
                                width: 25,
                                color: mainColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: height / 26),
                    Divider(height: 1, color: colorGrey),
                    // AqualifeMenuLine(
                    //   title: 'User Profile',
                    //   icon: Image(
                    //     image: AssetImage(
                    //         'assets/icons/settings/account-circle-line.png'),
                    //   ),
                    //   onTap: (() {
                    //     Storage().page = '';
                    //     Navigator.of(context)
                    //         .pushNamed(AqualifeRoutes.profile);
                    //   }),
                    // ),
                    // Divider(height: 1, color: colorGrey),
                    // AqualifeMenuLine(
                    //   title: 'Transaction History',
                    //   icon: Image(
                    //     image: AssetImage('assets/icons/settings/txn_icon.png'),
                    //   ), //Icons.history,
                    //   onTap: (() {
                    //     Navigator.of(context)
                    //         .pushNamed(AqualifeRoutes.history,
                    //             arguments: HistoryParameters(selectedTab: 0))
                    //         .then((value) {
                    //       BlocProvider.of<ProfileBloc>(context)
                    //           .add(ProfileLoad());
                    //     });
                    //   }),
                    // ),
                    // Divider(height: 1, color: colorGrey),
                    // AqualifeMenuLine(
                    //   title: 'Refer Friends',
                    //   icon: Image(
                    //     image: AssetImage(
                    //         'assets/icons/settings/hand-heart-line.png'),
                    //   ),
                    //   onTap: (() async {
                    //     // var currentBrightness = await ScreenBrightness().current;
                    //     // var newBrightness = 1 - currentBrightness;

                    //     // BrightnessCheck()
                    //     //     .setBrightness(currentBrightness + newBrightness);

                    //     // ignore: use_build_context_synchronously
                    //     Navigator.of(context)
                    //         .pushNamed(AqualifeRoutes.refer)
                    //         .then(
                    //       (value) {
                    //         // BrightnessCheck().resetBrightness();

                    //         BlocProvider.of<ProfileBloc>(context)
                    //             .add(ProfileLoad());
                    //       },
                    //     );
                    //   }),
                    // ),
                    // Divider(height: 1, color: colorGrey),
                    // BlocConsumer<SecurityBloc, SecurityState>(
                    //   listener: (context, securityState) {
                    //     fToast = FToast();
                    //     fToast.init(context);

                    //     if (securityState is SecurityCheckVerified) {
                    //       if (securityState.verified == false) {
                    //         Storage().page = 'settings';
                    //         // Storage().email = email!;

                    //         // BlocProvider.of<SecurityBloc>(context)
                    //         //     .add(SecurityOtpSend());

                    //         Navigator.of(context)
                    //             .pushNamed(AqualifeRoutes.securityCreate)
                    //             .then((value) {
                    //           setState(() {
                    //             clickPasscode = false;
                    //           });
                    //         });
                    //       } else {
                    //         Storage().set = 'reset';
                    //         Navigator.of(context)
                    //             .pushNamed(AqualifeRoutes.securityChange)
                    //             .then((value) {
                    //           setState(() {
                    //             clickPasscode = false;
                    //           });
                    //         });
                    //       }
                    //     }
                    //     if (securityState is SecurityOtpSent) {
                    //       showSuccessToast(
                    //           securityState.data['message'], context);
                    //       Navigator.of(context)
                    //           .pushNamed(AqualifeRoutes.securityOtp,
                    //               arguments: SecurityOtpParameters(
                    //                   otpData: securityState.data))
                    //           .then((value) {
                    //         setState(() {
                    //           clickPasscode = false;
                    //         });
                    //       });
                    //     }
                    //   },
                    //   builder: (context, securityState) {
                    //     return AqualifeMenuLine(
                    //       title: 'Passcode',
                    //       icon: Image(
                    //         image: AssetImage(
                    //             'assets/icons/settings/lock-password-line.png'),
                    //       ),
                    //       onTap: clickPasscode == false
                    //           ? (() {
                    //               setState(() {
                    //                 clickPasscode = true;
                    //               });
                    //               // print('ALREADY CLICK !!!!!!');
                    //               BlocProvider.of<SecurityBloc>(context)
                    //                   .add(SecurityStart());
                    //             })
                    //           : () {},
                    //     );
                    //   },
                    // ),
                    // Divider(height: 1, color: colorGrey),
                    urlAboutUs != ''
                        ? AqualifeMenuLine(
                            title: 'About Us',
                            icon: Image(
                              image: AssetImage(
                                  'assets/icons/settings/team-line.png'),
                            ),
                            onTap: (() => {
                                  WebviewDialog.showWebview(
                                    context,
                                    Scaffold(
                                      appBar: AppBar(
                                        elevation: 1,
                                        leading: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          'About Us',
                                          style: TextStyle(
                                            color: colorBlack,
                                            fontFamily: fontFamilyMain,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                        centerTitle: true,
                                      ),
                                      // body: WebView(url: urlAboutUs),
                                      body: WidgetWebView(
                                        widgetUrl: urlAboutUs,
                                      ),
                                    ),
                                  )
                                }),
                          )
                        : SizedBox(),
                    urlAboutUs != ''
                        ? Divider(height: 1, color: colorGrey)
                        : SizedBox(),
                    urlFAQ != ''
                        ? AqualifeMenuLine(
                            title: 'Help Center',
                            icon: Image(
                              image: AssetImage(
                                  'assets/icons/settings/customer-service-line.png'),
                            ),
                            onTap: (() => {
                                  WebviewDialog.showWebview(
                                    context,
                                    Scaffold(
                                      appBar: AppBar(
                                        elevation: 1,
                                        leading: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          'FAQ',
                                          style: TextStyle(
                                            color: colorBlack,
                                            fontFamily: fontFamilyMain,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                        centerTitle: true,
                                      ),
                                      // body: WebView(url: urlFAQ),
                                      body: WidgetWebView(
                                        widgetUrl: urlFAQ,
                                      ),
                                    ),
                                  )
                                }),
                          )
                        : SizedBox(),
                    urlFAQ != ''
                        ? Divider(height: 1, color: colorGrey)
                        : SizedBox(),
                    urlTerm != ''
                        ? AqualifeMenuLine(
                            title: 'Terms of Use',
                            icon: Image(
                              image: AssetImage(
                                  'assets/icons/settings/file-list-2-line.png'),
                            ),
                            onTap: (() => {
                                  WebviewDialog.showWebview(
                                    context,
                                    Scaffold(
                                      appBar: AppBar(
                                        elevation: 1,
                                        leading: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          'Terms of Use',
                                          style: TextStyle(
                                            color: colorBlack,
                                            fontFamily: fontFamilyMain,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                        centerTitle: true,
                                      ),
                                      // body: WebView(url: urlTerm),
                                      body: WidgetWebView(
                                        widgetUrl: urlTerm,
                                      ),
                                    ),
                                  ),
                                }),
                          )
                        : SizedBox(),
                    urlTerm != ''
                        ? Divider(height: 1, color: colorGrey)
                        : SizedBox(),
                    urlPolicy != ''
                        ? AqualifeMenuLine(
                            title: 'Privacy Policy',
                            icon: Image(
                              image: AssetImage(
                                  'assets/icons/settings/shield-keyhole-line.png'),
                            ),
                            onTap: (() => {
                                  WebviewDialog.showWebview(
                                    context,
                                    Scaffold(
                                      appBar: AppBar(
                                        elevation: 1,
                                        leading: Container(
                                          child: IconButton(
                                            icon: Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ),
                                        title: Text(
                                          'Privacy Policy',
                                          style: TextStyle(
                                            color: colorBlack,
                                            fontFamily: fontFamilyMain,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                        centerTitle: true,
                                      ),
                                      // body: WebView(url: urlPolicy),
                                      body: WidgetWebView(
                                        widgetUrl: urlPolicy,
                                      ),
                                    ),
                                  ),
                                }),
                          )
                        : SizedBox(),
                    urlPolicy != ''
                        ? Divider(height: 1, color: colorGrey)
                        : SizedBox(),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 10),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //     children: [
                    //       AqualifeSocialButton(
                    //         child: Image.asset(
                    //           'assets/icons/social/facebook.png',
                    //           width: width * 0.08,
                    //         ),
                    //         onPressed: () async {
                    //           if (!await launchUrl(
                    //             Uri.parse(
                    //               Storage().globalValue!['url']['Facebook'],
                    //             ),
                    //             mode: LaunchMode.externalApplication,
                    //           )) {
                    //             throw 'Could not launch this link';
                    //           }
                    //         },
                    //       ),
                    //       AqualifeSocialButton(
                    //         child: Image.asset(
                    //           'assets/icons/social/instagram.png',
                    //           width: width * 0.08,
                    //         ),
                    //         onPressed: () async {
                    //           if (!await launchUrl(
                    //             Uri.parse(
                    //               Storage().globalValue!['url']['Instagram'],
                    //             ),
                    //             mode: LaunchMode.externalApplication,
                    //           )) {
                    //             throw 'Could not launch this link';
                    //           }
                    //         },
                    //       ),
                    //       AqualifeSocialButton(
                    //         child: Image.asset(
                    //           'assets/icons/social/website.png',
                    //           width: width * 0.08,
                    //         ),
                    //         onPressed: () async {
                    //           if (!await launchUrl(
                    //             Uri.parse(
                    //               Storage().globalValue!['url']['Website'],
                    //             ),
                    //             mode: LaunchMode.externalApplication,
                    //           )) {
                    //             throw 'Could not launch this link';
                    //           }
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    // Container(
                    //   color: colorTransparent,
                    //   child: InkWell(
                    //     child: ListTile(
                    //       contentPadding: EdgeInsets.symmetric(horizontal: 0),
                    //       title: Row(
                    //         children: [
                    //           Text(
                    //             'Log Out',
                    //             style: TextStyle(
                    //               fontSize: 12,
                    //               fontWeight: FontWeight.bold,
                    //               color: colorBlack,
                    //             ),
                    //              textScaler: TextScaler.linear(scaleFactor),
                    //           ),
                    //           Container(
                    //             width: width * 0.045,
                    //             height: width * 0.045,
                    //             color: colorBackground,
                    //             margin: EdgeInsets.only(left: 5),
                    //             child: Image(
                    //               image: AssetImage(
                    //                   'assets/icons/settings/logout.png'),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //       trailing: Text(
                    //         'v ${packageInfo?.version}+${packageInfo?.buildNumber}',
                    //         style: TextStyle(
                    //           fontSize: 10,
                    //           color: colorDarkGray,
                    //         ),
                    //          textScaler: TextScaler.linear(scaleFactor),
                    //       ),
                    //     ),
                    //     onTap: () async {
                    //       BlocProvider.of<AuthenticationBloc>(context)
                    //           .add(AuthenticationLoggedOut());
                    //       Navigator.of(context).pushNamedAndRemoveUntil(
                    //            AqualifeRoutes.login, (Route<dynamic> route) => false);
                    //     },
                    //   ),
                    // )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _validateAndSend() {
  //   if (!mounted) return;
  //   // setState(() {
  //   //   fToast = FToast();
  //   //   fToast.init(context);
  //   // });

  //   if (pinController.text == '') {
  //     showErrorToast('Security pin are required!', context);
  //   } else {
  //     Future.delayed(Duration(seconds: 1), () {
  //       load = false;
  //       BlocProvider.of<SecurityBloc>(context).add(SecurityPinVerify(
  //         pin: pinController.text,
  //       ));
  //       Navigator.pop(context);
  //     });
  //   }
  // }
}
