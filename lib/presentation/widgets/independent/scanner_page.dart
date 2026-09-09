import 'dart:developer';
import 'dart:io';

// import 'package:ai_barcode/ai_barcode.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../config/global_setup.dart';
import '../../../config/routes.dart';
import '../../../config/storage.dart';

import '../../../domain/entities/validator.dart';
import '../../../locator.dart';
import '../../features/authentication/authentication.dart';
import '../../features/maintenance/maintenance_screen.dart';
import '../../features/profile/profile.dart';
import '../../features/rewards/reward.dart';
import '../../features/voucher/voucher.dart';
import 'independent.dart';

/* Widget class for barcode/ qrcode scanner.  */

/// AppBarcodeScannerWidget
class AppBarcodeScannerWidget extends StatefulWidget {
  const AppBarcodeScannerWidget.defaultStyle({
    Key? key,
  }) : super(key: key);

  @override
  State<AppBarcodeScannerWidget> createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  // ignore: unused_field
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TargetPlatform platform = Theme.of(context).platform;
      // if (!kIsWeb) {
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        _listenForPermissionStatus();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    });

    // Permission.camera.status.then((value) async {
    //   print('PERMISSION CAMERA: $value');
    //   if (value == PermissionStatus.granted) {
    //     _isGranted = true;
    //   } else if (value == PermissionStatus.denied) {
    //     _listenForPermissionStatus();
    //   }
    // });
  }

  void _listenForPermissionStatus() async {
    bool isGrated = true;
    if (await Permission.camera.status.isGranted) {
      isGrated = true;
    } else {
      if (await Permission.camera.request().isGranted) {
        isGrated = true;
      }

      if (Platform.isAndroid) {
        if (await Permission.camera.isDenied ||
            await Permission.camera.isPermanentlyDenied) {
          // The user opted to never again see the permission request dialog for this
          // app. The only way to change the permission's status now is to let the
          // user manually enable it in the system settings.
          openAppSettings().then((value) {
            if (!mounted) return;
            Navigator.pop(context);
          });
        }
      }
    }
    setState(() {
      _isGranted = isGrated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Storage().page == 'voucher'
        //     ?
        MultiBlocProvider(
          providers: [
            // BlocProvider<RegisterBloc>(
            //   create: (context) => RegisterBloc(userRepository: sl()),
            // ),
            BlocProvider<RewardBloc>(
              create: (context) =>
                  RewardBloc(context: context, rewardRepository: sl()),
            ),
            BlocProvider<VoucherBloc>(
              create: (context) => VoucherBloc(
                profileBloc: ProfileBloc(userRepository: sl()),
              ),
            ),
            // BlocProvider<TransferCreditBloc>(
            //   create: (context) => TransferCreditBloc(transferRepository: sl()),
            // ),
          ],
          child: Expanded(
            child: _isGranted == true ? _BarcodeScannerWidget() : Container(),
          ),
        )
      ],
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int selectedTabVoucher = 0;
  String errorfield = '';
  bool error = false;
  bool isProcessing = false;
  FocusNode voucherCodeFocus = FocusNode();

  final TextEditingController voucherCodeController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> voucherCodeKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    // voucherCodeFocus = FocusNode();
  }

  @override
  void dispose() {
    controller?.dispose();
    // voucherCodeFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: colorWhite,
      ),
      child: Scaffold(
        backgroundColor: colorTransparent,
        extendBodyBehindAppBar: true,
        body: BlocConsumer<RewardBloc, RewardState>(
          listener: (context, rewardState) {
            if (rewardState is RewardRedeemSuccess) {
              selectedTabVoucher = 0;
              RewardSuccessDialog.showRewardSuccessDialog(
                context,
                rewardState.redeemResponse,
                // '${rewardState.redeemResponse['message']} \n\n ${rewardState.redeemResponse['data']['message']}',
                () {
                  // if (rewardState.redeemResponse['data']['type'] ==
                  //     'voucher') {
                  BlocProvider.of<VoucherBloc>(context)
                      .add(VoucherCategoriesLoad(
                    filterBy: 'all',
                    filterValue: 'all',
                  ));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.voucher, (Route<dynamic> route) => false,
                      arguments: VoucherParameters(
                        selectedTab: 0,
                        filterBy: 'all',
                        filterValue: '0',
                      ));
                },
              );
            }
            if (rewardState is RewardRedeemFailed) {
              Storage().rewardReload = 'yes';
              setProcessingStatus(false);
              // setState(() {
              //   dispose();
              // });

              BlocProvider.of<RewardBloc>(context).add(RewardScannerLoad());

              showErrorScannerToast(
                  rewardState.redeemResponse['message'], context);
            }
            if (rewardState is RewardError) {
              setProcessingStatus(false);
              showErrorToast(rewardState.error, context);
            }
            if (rewardState is RewardNetworkError) {
              showErrorToast(rewardState.error, context);
            }
            if (rewardState is RewardSessionError) {
              sessionExpiredLogOut(rewardState.error);
            }
            /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
            if (rewardState is RewardMaintenanceError) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => MaintenanceScreen(
                        parameters: MaintenanceParameters(
                            message: rewardState.message))),
                ModalRoute.withName('/'),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: Center(
                child: Container(
                  // margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: Stack(
                    // fit: StackFit.expand,
                    clipBehavior: Clip.none,
                    alignment: Alignment.bottomCenter,
                    children: [
                      // controller.getCameraInfo
                      // LoadingWidget(),
                      _buildQrView(context),
                      Positioned(
                        bottom: height * 0.25,
                        child: SizedBox(
                          width: width - 30,
                          child: Center(
                            child: Text(
                              Storage().page == 'voucher' ||
                                      Storage().page == 'redeemVoucher'
                                  ? 'Place QR code in the scan area'
                                  : scanning == 'qr'
                                      ? 'Place QR code in the scan area'
                                      : 'Place barcode in the scan area',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: height * 0.03,
                        // right: -10,
                        child: Container(
                          height: height / 12,
                          width: width,
                          margin: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: SizedBox(
                                  width: width * 0.2,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: colorWhite,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              InkWell(
                                child: Container(
                                  width: width * 0.2,
                                  alignment: Alignment.center,
                                  child: FutureBuilder(
                                    future: controller?.getFlashStatus(),
                                    builder: (context, snapshot) {
                                      // return Text('Flash: ${snapshot.data}');

                                      return snapshot.data == false
                                          ? Icon(
                                              Icons.flash_on,
                                              color: colorWhite,
                                              size: 26,
                                            )
                                          : Icon(
                                              Icons.flash_on,
                                              color: colorYellowLogo,
                                              size: 26,
                                            );
                                    },
                                  ),
                                ),
                                onTap: () async {
                                  await controller?.toggleFlash();
                                  // controller!.resumeCamera();
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          height: height * 0.2,
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            color: colorWhite,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    // Storage().page == 'voucher'
                                    //     ?
                                    Text(
                                      ' Scan QR code to redeem voucher ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF03053D),
                                        fontWeight: FontWeight.w700,
                                        fontFamily: fontFamilyMain,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    )
                                    // : Text(
                                    //     ' Scan QR code to redeem voucher ',
                                    //     style: TextStyle(
                                    //       fontSize: 15,
                                    //       color: Color(0xFF03053D),
                                    //       fontWeight: FontWeight.w700,
                                    //       fontFamily: fontFamilyMain,
                                    //     ),
                                    //     textScaler: TextScaler.linear(scaleFactor),
                                    //   )
                                    // : Storage().page == 'wallet'
                                    //     ? Text(
                                    //         ' Scan QR code to transfer credit to your friends ',
                                    //         style: TextStyle(
                                    //           fontSize: 15,
                                    //           color: Color(0xFF03053D),
                                    //           fontWeight: FontWeight.w700,
                                    //           fontFamily: fontFamilyMain,
                                    //         ),
                                    //         textScaler: TextScaler.linear(scaleFactor),
                                    //       )
                                    //     : Text(
                                    //         ' Scan QR code to get the referral code ',
                                    //         style: TextStyle(
                                    //           fontSize: 15,
                                    //           color: Color(0xFF03053D),
                                    //           fontWeight: FontWeight.w700,
                                    //           fontFamily: fontFamilyMain,
                                    //         ),
                                    //         textScaler: TextScaler.linear(scaleFactor),
                                    //       ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                                alignment: Alignment.bottomCenter,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      splashColor: colorBackground,
                                      child: Container(
                                        height: height * 0.035,
                                        color: colorBackground,
                                        child: Text(
                                          'Cancel',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: fontFamilyMain,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                        Navigator.of(context).pushNamed(
                                            AqualifeRoutes.voucherManual);
                                      },
                                      splashColor: colorBackground,
                                      child: Container(
                                        height: height * 0.035,
                                        color: colorBackground,
                                        child: Storage().page == 'voucher'
                                            ? Text(
                                                'Having trouble scanning?',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF979797),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: fontFamilyMain,
                                                ),
                                                textScaler: TextScaler.linear(
                                                    scaleFactor),
                                              )
                                            : Container(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // (Storage().page == 'voucher')
                      //     ? Positioned(
                      //         bottom: height * 0.03,
                      //         child: InkWell(
                      //           child: Container(
                      //             height: height / 14,
                      //             width: width - 30,
                      //             clipBehavior: Clip.hardEdge,
                      //             decoration: BoxDecoration(
                      //               color: secondaryColor,
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             margin: EdgeInsets.only(top: 30),
                      //             child: Center(
                      //               child: Text(
                      //                 'Enter Promo Code',
                      //                 style: TextStyle(
                      //                   fontSize: 14,
                      //                   fontWeight: FontWeight.w500,
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //           onTap: () {
                      //             // FocusScope.of(context)
                      //             //     .requestFocus(FocusNode());
                      //             if (!mounted) return;
                      //             setState(() {
                      //               launchManual(context, height, width);
                      //               controller!.pauseCamera();
                      //               voucherCodeFocus.requestFocus();
                      //             });
                      //           },
                      //         ),
                      //       )
                      //     : SizedBox(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 280.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      // overlayMargin: EdgeInsets.only(bottom: 60),
      overlay: QrScannerOverlayShape(
          borderColor: secondaryColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      controller.resumeCamera();
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (!mounted) return;

      setState(() {
        result = scanData;

        if (result!.code!.isNotEmpty) {
          // controller.pauseCamera();
          // controller.stopCamera();

          if (Storage().page == 'voucher') {
            BlocProvider.of<RewardBloc>(context).add(
              RewardRedeemQrLoad(
                code: result!.code!,
              ),
            );
          } else if (Storage().page == 'referral') {
            controller.stopCamera();
            Future.delayed(Duration.zero, () {
              if (!mounted) return;
              Navigator.pop(context, result!.code!);
            });
          } else {
            controller.stopCamera();
            Future.delayed(Duration.zero, () {
              if (!mounted) return;
              Navigator.popAndPushNamed(context, AqualifeRoutes.voucherDesc,
                  result: result!.code!.toString());
              // Navigator.pushNamedAndRemoveUntil(
              //     context, AqualifeRoutes.voucherDesc, (route) => false);
            });
          }
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  launchManual(BuildContext context, double height, double width) async {
    // final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        ),
        backgroundColor: colorBackground,
        builder: (builder) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  height: height * 0.35,
                  padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                  child: CustomScrollView(
                    primary: false,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          // margin: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child: Text(
                                  'Enter Voucher Code',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF03053D),
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 20, 0, 30),
                                decoration: BoxDecoration(
                                  color: colorBackground,
                                  boxShadow: [
                                    BoxShadow(
                                        color: error
                                            ? colorRed
                                            : errorfield == 'error' ||
                                                    errorfield == 'errorCode'
                                                ? colorRed
                                                : colorGreyBox,
                                        // blurRadius: 15.0,
                                        offset: Offset(
                                            0.0,
                                            error
                                                ? 3
                                                : errorfield == 'error' ||
                                                        errorfield ==
                                                            'errorCode'
                                                    ? 3
                                                    : 0))
                                  ],
                                  border: Border.all(color: colorGreyBox),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                ),
                                // child: Padding(
                                // padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                                child: AqualifeInputField(
                                  key: voucherCodeKey,
                                  controller: voucherCodeController,
                                  textAlign: TextAlign.start,
                                  textAlignVertical: TextAlignVertical.center,
                                  hint: '',
                                  validator: Validator.valueExists,
                                  keyboard: TextInputType.text,
                                  border: InputBorder.none,
                                  focusNode: voucherCodeFocus,
                                  onValueChanged: (value) {
                                    if (value != '') {
                                      if (mounted) return;
                                      setState(() {
                                        errorfield = '';
                                        error = false;
                                        voucherCodeKey.currentState?.validate();
                                      });
                                    }
                                  },
                                ),
                                // ),
                              ),
                              AqualifeStyleButton(
                                height: height / 14,
                                title:
                                    isProcessing ? 'Processing...' : 'Redeem',
                                backgroundColor:
                                    isProcessing ? colorLightGray : mainColor,
                                textColor:
                                    isProcessing ? colorDarkGray : colorWhite,
                                onPressed:
                                    isProcessing ? () {} : _validateAndSend,
                              ),
                              Align(
                                alignment: Alignment.center,
                                child: AqualifeTextButton(
                                  'Cancel',
                                  color: colorBlack,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.w600,
                                  underline: true,
                                  onClick: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).whenComplete(() {
      controller!.resumeCamera();
      voucherCodeController.text = '';
      // voucherCodeFocus.unfocus();
      voucherCodeFocus.hasFocus;
    });
  }

  void _validateAndSend() {
    if (voucherCodeKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorCode';
      voucherCodeFocus.requestFocus();
      showErrorToast('The voucher code is required !', context);
    } else {
      errorfield = '';

      // setState(() {
      setProcessingStatus(true);
      BlocProvider.of<RewardBloc>(context).add(
        RewardRedeemQrLoad(
          code: voucherCodeController.text.trim(),
        ),
      );
      // });
    }
  }

  void sessionExpiredLogOut(String error) {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
        AqualifeRoutes.login, (Route<dynamic> route) => false);
  }
}

// import 'dart:io';

// import 'package:ai_barcode/ai_barcode.dart';
// import '../../../../config/config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:permission_handler/permission_handler.dart';

// import '../../../config/routes.dart';
// import '../../../config/storage.dart';

// import '../../../locator.dart';
// import '../../features/authentication/authentication.dart';
// import '../../features/maintenance/maintenance_screen.dart';
// import '../../features/profile/profile.dart';
// import '../../features/rewards/reward.dart';
// import '../../features/voucher/voucher.dart';
// import 'independent.dart';

// /* Widget class for barcode/ qrcode scanner.  */

// /// AppBarcodeScannerWidget
// class AppBarcodeScannerWidget extends StatefulWidget {
//   const AppBarcodeScannerWidget.defaultStyle({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<AppBarcodeScannerWidget> createState() => _AppBarcodeState();
// }

// class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
//   // ignore: unused_field
//   bool _isGranted = false;

//   @override
//   void initState() {
//     super.initState();

//     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
//       TargetPlatform platform = Theme.of(context).platform;
//       // if (!kIsWeb) {
//       if (platform == TargetPlatform.android ||
//           platform == TargetPlatform.iOS) {
//         _listenForPermissionStatus();
//       } else {
//         setState(() {
//           _isGranted = true;
//         });
//       }
//     });

//     // Permission.camera.status.then((value) async {
//     //   print('PERMISSION CAMERA: $value');
//     //   if (value == PermissionStatus.granted) {
//     //     _isGranted = true;
//     //   } else if (value == PermissionStatus.denied) {
//     //     _listenForPermissionStatus();
//     //   }
//     // });
//   }

//   void _listenForPermissionStatus() async {
//     bool isGrated = true;
//     if (await Permission.camera.status.isGranted) {
//       isGrated = true;
//     } else {
//       if (await Permission.camera.request().isGranted) {
//         isGrated = true;
//       }

//       if (Platform.isAndroid) {
//         if (await Permission.camera.isDenied ||
//             await Permission.camera.isPermanentlyDenied) {
//           // The user opted to never again see the permission request dialog for this
//           // app. The only way to change the permission's status now is to let the
//           // user manually enable it in the system settings.
//           openAppSettings().then((value) {
//             if (!mounted) return;
//             Navigator.pop(context);
//           });
//         }
//       }
//     }
//     setState(() {
//       _isGranted = isGrated;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         // Storage().page == 'voucher'
//         //     ?
//         MultiBlocProvider(
//           providers: [
//             // BlocProvider<RegisterBloc>(
//             //   create: (context) => RegisterBloc(userRepository: sl()),
//             // ),
//             BlocProvider<RewardBloc>(
//               create: (context) =>
//                   RewardBloc(context: context, rewardRepository: sl()),
//             ),
//             BlocProvider<VoucherBloc>(
//               create: (context) => VoucherBloc(
//                 profileBloc: ProfileBloc(userRepository: sl()),
//               ),
//             ),
//             // BlocProvider<TransferCreditBloc>(
//             //   create: (context) => TransferCreditBloc(transferRepository: sl()),
//             // ),
//           ],
//           child: Expanded(
//             child: _isGranted == true ? _BarcodeScannerWidget() : Container(),
//           ),
//         )
//       ],
//     );
//   }
// }

// ///ScannerWidget
// class _BarcodeScannerWidget extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return _AppBarcodeScannerWidgetState();
//   }
// }

// class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
//   late ScannerController _scannerController;

//   String resultScan = '';
//   String passcodePin = '';
//   int selectedTabVoucher = 0;

//   @override
//   void initState() {
//     super.initState();

//     scannerScreen();
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     _scannerController;

//     _scannerController.stopCameraPreview();
//     _scannerController.stopCamera();
//   }

//   scannerScreen() {
//     _scannerController = ScannerController(scannerResult: (result) {
//       resultScan = result;
//       // _scannerController.startCameraPreview();
//       _resultCallback(resultScan);
//     }, scannerViewCreated: () {
//       TargetPlatform platform = Theme.of(context).platform;
//       if (TargetPlatform.iOS == platform) {
//         Future.delayed(Duration(seconds: 1), () {
//           _scannerController.startCamera();
//           _scannerController.startCameraPreview();
//         });
//       } else {
//         _scannerController.startCamera();
//         _scannerController.startCameraPreview();
//       }
//     });
//   }

//   _resultCallback(resultScan) {
//     if (Storage().page == 'voucher') {
//       BlocProvider.of<RewardBloc>(context).add(
//         RewardRedeemQrLoad(
//           code: resultScan,
//         ),
//       );
//     } else {
//       Future.delayed(Duration.zero, () {
//         // Navigator.pop(context, resultScan);
//         if (!mounted) return;
//         Navigator.popAndPushNamed(context, AqualifeRoutes.voucherDesc,
//             result: resultScan);
//         // Navigator.pushNamedAndRemoveUntil(
//         //     context, AqualifeRoutes.voucherDesc, (route) => false);
//       });
//       _scannerController.stopCameraPreview();
//       _scannerController.stopCamera();

//       // Navigator.of(context).pushNamed( AqualifeRoutes.passcodeKey).then((value) {
//       //   passcodePin = value.toString();

//       //   setState(() {
//       //     BlocProvider.of<VoucherBloc>(context).add(VoucherRedeem(
//       //       qrCode: '',
//       //       pin: passcodePin,
//       //     ));
//       //   });
//       // });
//     }
//     // else if (Storage().page == 'wallet') {
//     //   BlocProvider.of<TransferCreditBloc>(context)
//     //       .add(VerifyTransferLoad(qrCode: resultScan));
//     // } else if (Storage().page == 'referral') {
//     //   BlocProvider.of<RegisterBloc>(context).add(
//     //     RegisterReferDecrypt(
//     //       referCode: resultScan,
//     //     ),
//     //   );
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;

//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: SystemUiOverlayStyle(
//         systemNavigationBarColor: colorWhite,
//       ),
//       child: Scaffold(
//         backgroundColor: colorTransparent,
//         extendBodyBehindAppBar: true,
//         appBar: AppBar(
//           systemOverlayStyle: SystemUiOverlayStyle(
//             statusBarColor: colorTransparent,
//             statusBarIconBrightness: Brightness.light,
//           ),
//           elevation: 0,
//           backgroundColor: colorTransparent,
//           shadowColor: colorTransparent,
//           automaticallyImplyLeading: false,
//           actions: [
//             InkWell(
//               child: Container(
//                 width: width * 0.2,
//                 alignment: Alignment.center,
//                 margin: EdgeInsets.only(top: 20),
//                 padding: EdgeInsets.all(3),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: colorBlack,
//                 ),
//                 child: Icon(
//                   Icons.flash_on,
//                   color: colorWhite,
//                   // size: 20,
//                 ),
//               ),
//               onTap: () {
//                 _scannerController.toggleFlash();
//                 setState(() {});
//               },
//             ),
//           ],
//         ),
//         body: MultiBlocListener(
//           listeners: [
//             BlocListener<RewardBloc, RewardState>(
//               listener: (context, rewardState) {
//                 if (rewardState is RewardRedeemSuccess) {
//                   selectedTabVoucher = 0;
//                   // if (Storage().globalValue!['vouchers'] == true &&
//                   //     Storage().globalValue!['subscriptions'] == true) {
//                   //   selectedTabVoucher = 0;
//                   // } else if (Storage().globalValue!['vouchers'] == false) {
//                   //   selectedTabVoucher = 3;
//                   // } else {
//                   //   selectedTabVoucher = 0;
//                   // }

//                   _scannerController.stopCameraPreview();
//                   _scannerController.stopCamera();

//                   RewardSuccessDialog.showRewardSuccessDialog(
//                     context,
//                     rewardState.redeemResponse,
//                     // '${rewardState.redeemResponse['message']} \n\n ${rewardState.redeemResponse['data']['message']}',
//                     () {
//                       // if (rewardState.redeemResponse['data']['type'] ==
//                       //     'voucher') {
//                       BlocProvider.of<VoucherBloc>(context)
//                           .add(VoucherCategoriesLoad(
//                         filterBy: 'all',
//                         filterValue: 'all',
//                       ));
//                       Navigator.of(context).pushNamedAndRemoveUntil(
//                           AqualifeRoutes.voucher,
//                           (Route<dynamic> route) => false,
//                           arguments: VoucherParameters(
//                             selectedTab: 1,
//                             filterBy: 'all',
//                             filterValue: '1',
//                           ));
//                       // } else {
//                       //   Navigator.of(context).pushNamedAndRemoveUntil(
//                       //        AqualifeRoutes.home, (Route<dynamic> route) => false);
//                       // }
//                     },
//                   );
//                 }
//                 if (rewardState is RewardRedeemFailed) {
//                   Storage().rewardReload = 'yes';
//                   setState(() {
//                     dispose();
//                   });

//                   BlocProvider.of<RewardBloc>(context).add(RewardScannerLoad());

//                   showErrorScannerToast(
//                       rewardState.redeemResponse['message'], context);
//                 }
//                 if (rewardState is RewardRefresh) {
//                   setState(() {
//                     scannerScreen();
//                     // AppBarcodeScannerWidget.defaultStyle();
//                     _scannerController.startCamera();
//                     _scannerController.startCameraPreview();
//                   });
//                 }
//                 if (rewardState is RewardError) {
//                   showErrorToast(rewardState.error, context);
//                 }
//                 if (rewardState is RewardNetworkError) {
//                   showErrorToast(rewardState.error, context);
//                 }
//                 if (rewardState is RewardSessionError) {
//                   sessionExpiredLogOut(rewardState.error);
//                 }
//                 /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
//                 if (rewardState is RewardMaintenanceError) {
//                   Navigator.pushAndRemoveUntil<void>(
//                     context,
//                     MaterialPageRoute<void>(
//                         builder: (BuildContext context) => MaintenanceScreen(
//                             parameters: MaintenanceParameters(
//                                 message: rewardState.message))),
//                     ModalRoute.withName('/'),
//                   );
//                 }
//               },
//             ),
//             // BlocListener<VoucherBloc, VoucherState>(
//             //   listener: (context, voucherState) {
//             //     if (voucherState is VoucherRedeemSuccess) {
//             //       _scannerController.stopCameraPreview();
//             //       _scannerController.stopCamera();

//             //       showSuccessToast(
//             //           voucherState.redeemResponse['message'], context);
//             //     }
//             //     if (voucherState is RewardRedeemFailed) {
//             //       Storage().rewardReload = 'yes';
//             //       setState(() {
//             //         dispose();
//             //       });

//             //       // BlocProvider.of<RewardBloc>(context).add(RewardScannerLoad());

//             //       showErrorScannerToast(
//             //           voucherState., context);
//             //     }
//             //     if (voucherState is RewardRefresh) {
//             //       setState(() {
//             //         scannerScreen();
//             //         // AppBarcodeScannerWidget.defaultStyle();
//             //         _scannerController.startCamera();
//             //         _scannerController.startCameraPreview();
//             //       });
//             //     }
//             //     if (voucherState is RewardError) {
//             //       showErrorToast(voucherState.error, context);
//             //     }
//             //     if (voucherState is RewardNetworkError) {
//             //       showErrorToast(voucherState.error, context);
//             //     }
//             //     if (voucherState is RewardSessionError) {
//             //       sessionExpiredLogOut(voucherState.error);
//             //     }
//             //     /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
//             //     if (voucherState is RewardMaintenanceError) {
//             //       Navigator.pushAndRemoveUntil<void>(
//             //         context,
//             //         MaterialPageRoute<void>(
//             //             builder: (BuildContext context) => MaintenanceScreen(
//             //                 parameters: MaintenanceParameters(
//             //                     message: voucherState.message))),
//             //         ModalRoute.withName('/'),
//             //       );
//             //     }
//             //   },
//             // ),
//             // BlocListener<TransferCreditBloc, TransferCreditState>(
//             //     listener: (context, creditState) {
//             //   if (creditState is VerifyTransferLoaded) {
//             //     Navigator.of(context).pushNamed( AqualifeRoutes.transferCredit,
//             //         arguments: TransferCreditParameters(
//             //             profileTransfer: creditState.verifyData));
//             //   }
//             //   if (creditState is TransferVerifyError) {
//             //     BlocProvider.of<TransferCreditBloc>(context)
//             //         .add(TransferCreditRefresh());

//             //     AppBarcodeScannerWidget.defaultStyle();

//             //     showErrorScannerToast(creditState.error, context);
//             //   }
//             //   if (creditState is TransferCreditError) {
//             //     showErrorToast(creditState.error, context);
//             //   }
//             //   if (creditState is TransferCreditNetworkError) {
//             //     showErrorToast(creditState.error, context);
//             //   }
//             //   if (creditState is TransferCreditSessionError) {
//             //     sessionExpiredLogOut(creditState.error);
//             //   }
//             //   /* ------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
//             //   if (creditState is TransferCreditMaintenanceError) {
//             //     Navigator.pushAndRemoveUntil<void>(
//             //       context,
//             //       MaterialPageRoute<void>(
//             //           builder: (BuildContext context) => MaintenanceScreen(
//             //               parameters: MaintenanceParameters(
//             //                   message: creditState.message))),
//             //       ModalRoute.withName('/'),
//             //     );
//             //   }
//             // }),
//             // BlocListener<RegisterBloc, RegisterState>(
//             //   listener: (context, registerState) {
//             //     if (registerState is ReferDecryptFail) {
//             //       showErrorScannerToast('Refferal code not valid.', context);
//             //     }
//             //     if (registerState is ReferDecryptSuccess) {
//             //       Navigator.of(context).pop(resultScan);
//             //     }
//             //   },
//             // )
//           ],
//           child: Stack(
//             clipBehavior: Clip.hardEdge,
//             alignment: Alignment.bottomCenter,
//             children: [
//               Positioned(
//                 child: Container(
//                   height: height * 0.12,
//                   alignment: Alignment.topCenter,
//                   decoration: BoxDecoration(
//                     color: colorDeepBlue,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                 ),
//               ),
//               Column(
//                 children: [
//                   Expanded(
//                     child: PlatformAiBarcodeScannerWidget(
//                       platformScannerController: _scannerController,
//                     ),
//                   ),
//                   Container(
//                     height: height * 0.15,
//                   ),
//                 ],
//               ),
//               Positioned(
//                 child: Container(
//                   height: height * 0.2,
//                   alignment: Alignment.bottomCenter,
//                   decoration: BoxDecoration(
//                     color: colorWhite,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30),
//                       topRight: Radius.circular(30),
//                     ),
//                   ),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Expanded(
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const [
//                             // Storage().page == 'voucher'
//                             //     ?
//                             Text(
//                               ' Scan QR code to redeem voucher ',
//                               style: TextStyle(
//                                 fontSize: 15,
//                                 color: Color(0xFF03053D),
//                                 fontWeight: FontWeight.w700,
//                                 fontFamily: fontFamilyMain,
//                               ),
//                               textScaler: TextScaler.linear(scaleFactor),
//                             )
//                             // : Text(
//                             //     ' Scan QR code to redeem voucher ',
//                             //     style: TextStyle(
//                             //       fontSize: 15,
//                             //       color: Color(0xFF03053D),
//                             //       fontWeight: FontWeight.w700,
//                             //       fontFamily: fontFamilyMain,
//                             //     ),
//                             //     textScaler: TextScaler.linear(scaleFactor),
//                             //   )
//                             // : Storage().page == 'wallet'
//                             //     ? Text(
//                             //         ' Scan QR code to transfer credit to your friends ',
//                             //         style: TextStyle(
//                             //           fontSize: 15,
//                             //           color: Color(0xFF03053D),
//                             //           fontWeight: FontWeight.w700,
//                             //           fontFamily: fontFamilyMain,
//                             //         ),
//                             //         textScaler: TextScaler.linear(scaleFactor),
//                             //       )
//                             //     : Text(
//                             //         ' Scan QR code to get the referral code ',
//                             //         style: TextStyle(
//                             //           fontSize: 15,
//                             //           color: Color(0xFF03053D),
//                             //           fontWeight: FontWeight.w700,
//                             //           fontFamily: fontFamilyMain,
//                             //         ),
//                             //         textScaler: TextScaler.linear(scaleFactor),
//                             //       ),
//                           ],
//                         ),
//                       ),
//                       Container(
//                         margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
//                         alignment: Alignment.bottomCenter,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                               },
//                               splashColor: colorBackground,
//                               child: Container(
//                                 height: height * 0.035,
//                                 color: colorBackground,
//                                 child: Text(
//                                   'Cancel',
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: colorBlack,
//                                     fontWeight: FontWeight.w500,
//                                     fontFamily: fontFamilyMain,
//                                   ),
//                                   textScaler: TextScaler.linear(scaleFactor),
//                                 ),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () {
//                                 Navigator.pop(context);
//                                 Navigator.of(context)
//                                     .pushNamed(AqualifeRoutes.voucherManual);
//                               },
//                               splashColor: colorBackground,
//                               child: Container(
//                                 height: height * 0.035,
//                                 color: colorBackground,
//                                 child: Storage().page == 'voucher'
//                                     ? Text(
//                                         'Having trouble scanning?',
//                                         style: TextStyle(
//                                           fontSize: 12,
//                                           color: Color(0xFF979797),
//                                           fontWeight: FontWeight.w500,
//                                           fontFamily: fontFamilyMain,
//                                         ),
//                                         textScaler:
//                                             TextScaler.linear(scaleFactor),
//                                       )
//                                     : Container(),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void sessionExpiredLogOut(String error) {
//     setState(() {
//       fToast = FToast();
//       fToast.init(context);
//     });

//     showErrorToast('$error\nYou will be logged out.', context);
//     BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
//     Navigator.of(context).pushNamedAndRemoveUntil(
//         AqualifeRoutes.login, (Route<dynamic> route) => false);
//   }
// }
