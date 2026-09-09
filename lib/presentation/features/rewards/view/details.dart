import 'dart:async';
import 'dart:io';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../../data/model/model.dart';
import '../../../widgets/extensions/location_screen.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../security_pin/security_pin.dart';
import '../../voucher/voucher.dart';
import '../../webview/webview_deeplink.dart';
import '../reward.dart';

class DetailsView extends StatefulWidget {
  final Function? changeView;
  final String? title;
  final int? indexPage;

  const DetailsView({super.key, this.changeView, this.title, this.indexPage});

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  bool isProcessing = false;
  bool isSelected = false;
  int? selectedRewardID;
  // int selectedTabVoucher = 0;
  String passcodePin = '';
  String _result = '';
  List<RewardOutlet> rewardsOutlet = [];
  final TextEditingController pinController = TextEditingController();
  bool load = false;
  bool isFavouriteClick = false;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  late Timer durationLoading;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: Color.fromRGBO(30, 60, 87, 1),
      fontWeight: FontWeight.w600,
    ),
    margin: EdgeInsets.zero,
  );

  void setProcessingStatus(bool processing) {
    if (!mounted) return;
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);

    initializeDateFormatting();
  }

  @override
  void dispose() {
    // durationLoading.cancel();

    super.dispose();
  }

  Future _refreshData() async {
    await Future.delayed(Duration(seconds: 1));
    // ignore: use_build_context_synchronously
    BlocProvider.of<RewardBloc>(context).add(RewardOutletCheck());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<RewardBloc, RewardState>(
      listener: (context, state) {
        // fToast = FToast();
        // fToast.init(context);

        // if (Storage().globalValue!['vouchers'] == true &&
        //     Storage().globalValue!['subscriptions'] == true) {
        //   selectedTabVoucher = 0;
        // } else if (Storage().globalValue!['vouchers'] == false) {
        //   selectedTabVoucher = 3;
        // } else {
        //   selectedTabVoucher = 0;
        // }

        /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
        if (state is RewardMaintenanceError) {
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => MaintenanceScreen(
                    parameters: MaintenanceParameters(message: state.message))),
            ModalRoute.withName('/'),
          );
        }

        if (state is RewardDownloadSuccess) {
          setProcessingStatus(false);
          showSuccessToast(state.data['message'], context);

          Navigator.of(context)
              .pushNamedAndRemoveUntil(AqualifeRoutes.voucher, (route) => false,
                  arguments: VoucherParameters(
                    selectedTab: 1,
                    filterBy: 'all',
                    filterValue: '1',
                  ));
        }

        if (state is RewardPurchaseSuccess) {
          setProcessingStatus(false);
          showSuccessToast(state.data['message'], context);

          Navigator.of(context)
              .pushNamedAndRemoveUntil(AqualifeRoutes.voucher, (route) => false,
                  arguments: VoucherParameters(
                    selectedTab: 1,
                    filterBy: 'all',
                    filterValue: '1',
                  ));
        }

        if (state is RewardRedeemFailed) {
          setProcessingStatus(false);
          showErrorToast(state.redeemResponse['message'], context);
          // Navigator.pop(context);
          BlocProvider.of<RewardBloc>(context).add(
            RewardDetailsLoad(rewardId: Storage().rewardId),
          );
        }

        if (state is RewardSessionError) {
          sessionExpiredLogOut(state.error);
        }
        if (state is RewardError) {
          setProcessingStatus(false);
          showErrorToast(state.error, context);
        }
        if (state is RewardNetworkError) {
          showErrorToast('No internet connection', context);
          Navigator.of(context).pushNamedAndRemoveUntil(
              AqualifeRoutes.home, (Route<dynamic> route) => false);
        }
      },
      builder: (context, state) {
        if (state is RewardOutletStarted) {
          BlocProvider.of<RewardBloc>(context).add(
            RewardDetailsLoad(rewardId: Storage().rewardId),
          );
        }

        if (state is RewardDetailsLoaded) {
          var detail = state.details;
          var rewardId = detail.voucher?.id;
          var points = detail.member!.points;
          rewardsOutlet = state.details.outlets!;
          var formatter = DateFormat(appDateFormat);
          var dateFormateStart =
              formatter.format(DateTime.parse(detail.voucher!.start!));
          var dateFormateEnd =
              formatter.format(DateTime.parse(detail.voucher!.end!));
          isFavouriteClick = detail.voucher!.isFavourite!;

          if (points != null) {}

          if (rewardId != null) {
            return PopScope(
                canPop: false,
                onPopInvokedWithResult: (didPop, result) {
                  if (didPop) return;
                  navigateBack();
                },
                child: Platform.isIOS
                    ? GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 50) {
                            // if (canNavigateBack) {
                            //  navigateBack();
                            // } else {
                            //   //Show exit dialog, etc.
                            // }
                            navigateBack();
                          }
                        },
                        child: voucherDetail(detail, height, width, rewardId,
                            dateFormateStart, dateFormateEnd))
                    : voucherDetail(detail, height, width, rewardId,
                        dateFormateStart, dateFormateEnd));
          }

          return Container();
        }
        // return Container(color: colorBackground);
        return AqualifeScaffold(
          body: LoadingWidget(),
          bottomMenuIndex: widget.indexPage == 0 ? 0 : 3,
        );
      },
    );
  }

  Widget voucherDetail(DetailsData detail, height, width, int rewardId,
      String dateFormateStart, String dateFormateEnd) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refreshData,
      child: AqualifeScaffold(
        systemUiOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: colorBackground,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: colorWhite,
        ),
        title: Text(
          widget.title!,
          style: TextStyle(
            fontFamily: fontFamilyMain,
            color: colorBlack,
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          textScaler: TextScaler.linear(scaleFactor),
        ),
        leading: IconButton(
          icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onPressed: () {
            navigateBack();
          },
        ),
        appbarAction: [
          InkWell(
            onTap: () async {
              // _onShare method: FOR IPAD
              final box = context.findRenderObject() as RenderBox?;

              final response = await get(Uri.parse(detail.voucher!.image!));
              final directory = await getTemporaryDirectory();
              File file = await File('${directory.path}/Image.png')
                  .writeAsBytes(response.bodyBytes);

              if (Platform.isIOS) {
                await Share.share(
                  '${detail.voucher!.share}\n\n${detail.voucher!.shareLink}',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              } else {
                await Share.shareXFiles(
                  [XFile(file.path)],
                  text:
                      '${detail.voucher!.share}\n\n${detail.voucher!.shareLink}',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              }
            },
            child: Container(
              // height: 10,
              // color: colorBabyBlue,
              child: Image.asset(
                'assets/icons/share.png',
                color: colorPinGrey,
                scale: 1.7,
              ),
            ),
          ),
        ],
        bottomMenuIndex: widget.indexPage == 0 ? 0 : 3,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: colorBackground,
                // margin: EdgeInsets.fromLTRB(
                //     marginHorizontal, 0, marginHorizontal, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(
                              marginHorizontal, 0, marginHorizontal, 26),
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: colorBackground,
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorGreyBox,
                                    blurRadius: 5.0,
                                    offset: Offset(0.0, 5.0),
                                  ),
                                ],
                              ),
                              child: CachedImage(
                                imageUrl: detail.voucher!.image!,
                                // colorFilter: ColorFilter.mode(
                                //   colorWhite.withOpacity(0.35),
                                //   BlendMode.dstATop,
                                // ),
                              ),
                            ),
                          ),
                        ),
                        detail.voucher!.isMuslim == true
                            ? Positioned(
                                right: 20,
                                top: 5,
                                child: HalalWidget(
                                    muslimCategory:
                                        detail.voucher!.muslimCategory!,
                                    width: width * 0.15))
                            : SizedBox(),
                      ],
                    ),
                    Container(
                      // height: height * 0.06,
                      margin:
                          EdgeInsets.symmetric(horizontal: marginHorizontal),
                      // color: colorBabyBlue,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            child: Container(
                              // height: height * 0.07,
                              width: width * 0.35,
                              padding: EdgeInsets.all(3),
                              // margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // shape: BoxShape.circle,
                                color: secondaryColor,
                                border: Border.all(color: colorWhite, width: 2),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: colorGreyBox,
                                    blurRadius: 4.0,
                                    spreadRadius: 2,
                                    offset: Offset(0.0, 1.0),
                                  ),
                                ],
                              ),
                              child: Container(
                                margin: EdgeInsets.all(5),
                                child: Text(
                                  '${detail.outlets!.length} Outlet(s)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: colorWhite,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                AqualifeRoutes.locationOutlet,
                                arguments: LocationScreenParameters(
                                  locationDetails: rewardsOutlet,
                                ),
                              );
                            },
                          ),
                          InkWell(
                            child: Container(
                                // margin: EdgeInsets.all(2),
                                padding: EdgeInsets.all(4),
                                child: isFavouriteClick == false
                                    ? Icon(
                                        Icons.favorite_border,
                                        size: 30,
                                        color: colorCountGrey,
                                      )
                                    : Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: colorRed,
                                      )),
                            onTap: () {
                              setState(() {
                                Storage().page = 'details_wishlist';
                                BlocProvider.of<RewardBloc>(context)
                                    .add(RewardAddRemoveFavouriteLoad(
                                  voucherId: detail.voucher!.id!.toString(),
                                ));
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 20, marginHorizontal, 10),
                      child: Text(
                        detail.voucher!.name!,
                        style: TextStyle(
                          fontFamily: fontFamilyInter,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.only(bottom: 0),
                      child: Divider(
                        color: colorDarkGray,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 10),
                      // alignment: Alignment.topLeft,
                      color: colorBackground,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: height * 0.04,
                            height: height * 0.04,
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorWhiteBlue,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: secondaryColor),
                            ),
                            child: Image(
                              image: AssetImage('assets/icons/calendar.png'),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voucher Redemption Period',
                                style: TextStyle(
                                  fontFamily: fontFamilyInter,
                                  fontSize: 10,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                              Text(
                                '$dateFormateStart - $dateFormateEnd',
                                style: TextStyle(
                                  fontFamily: fontFamilyInter,
                                  fontSize: 10,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 10),
                      // alignment: Alignment.topLeft,
                      color: colorBackground,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: height * 0.04,
                            height: height * 0.04,
                            margin: EdgeInsets.only(right: 15),
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: colorWhiteBlue,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: secondaryColor),
                            ),
                            child: Image(
                              image: AssetImage('assets/icons/coupon.png'),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Voucher Redemption Limit',
                                style: TextStyle(
                                  fontFamily: fontFamilyInter,
                                  fontSize: 10,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w500,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                              Text(
                                '${detail.voucher!.redeem} Voucher',
                                style: TextStyle(
                                  fontFamily: fontFamilyInter,
                                  fontSize: 10,
                                  color: colorBlack,
                                  fontWeight: FontWeight.w600,
                                ),
                                textScaler: TextScaler.linear(scaleFactor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 10),
                      child: BlocConsumer<SecurityBloc, SecurityState>(
                        listener: (context, securityState) {
                          // setProcessingStatus(false);

                          // if (securityState is SecurityCheckVerified) {
                          //   if (securityState.verified == false) {
                          //     setProcessingStatus(false);

                          //     Storage().page = 'reward_details';
                          //     Navigator.of(context).pushNamed(
                          //         AqualifeRoutes.securityCreate);

                          //     // Navigator.of(context).pushNamed(
                          //     //      AqualifeRoutes.securityRegister);
                          //   } else {
                          //     Storage().page = 'reward_details';
                          //     Navigator.of(context)
                          //         .pushNamed(AqualifeRoutes.passcodeKey)
                          //         .then((value) {
                          //       if (value != null) {
                          //         passcodePin = value.toString();

                          //         setState(() {
                          //           if (detail.voucher!.voucherType ==
                          //               'downloadable') {
                          //             BlocProvider.of<RewardBloc>(context)
                          //                 .add(RewardDownload(
                          //               voucherId: detail.voucher!.id!,
                          //               pin: passcodePin,
                          //             ));
                          //           } else {
                          //             BlocProvider.of<RewardBloc>(context)
                          //                 .add(RewardPurchaseLoad(
                          //               voucherId: detail.voucher!.id!,
                          //               redeemVia: detail
                          //                   .voucher!.purchaseMethod!,
                          //               points:
                          //                   detail.voucher!.aftDisPoints!,
                          //               credits: detail
                          //                   .voucher!.aftDisCredits!,
                          //               pin: passcodePin,
                          //             ));
                          //           }
                          //         });
                          //       } else {
                          //         setProcessingStatus(false);
                          //       }
                          //     });
                          //   }
                          // }

                          // if (securityState is SecurityOtpSent) {
                          //   showSuccessToast(
                          //       securityState.data['message'], context);
                          //   Navigator.of(context).pushNamed(
                          //       AqualifeRoutes.securityOtp,
                          //       arguments: SecurityOtpParameters(
                          //           otpData: securityState.data));
                          // }

                          // if (securityState is SecurityPinVerified) {
                          //   // pinController.text = '';
                          //   // Storage().isShow = DateTime.now().minute;

                          //   Navigator.pop(context);
                          //   _purchaseNow();
                          // }

                          if (securityState is SecurityError) {
                            Navigator.pop(context);
                            showErrorToast(securityState.error, context);
                          }
                          /* ----------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                          if (securityState is SecurityMaintenanceError) {
                            Navigator.pushAndRemoveUntil<void>(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      MaintenanceScreen(
                                          parameters: MaintenanceParameters(
                                              message: securityState.message))),
                              ModalRoute.withName('/'),
                            );
                          }
                        },
                        builder: (context, state) {
                          return Container(
                            margin: EdgeInsets.only(top: 10),
                            child: AqualifeStyleButton(
                              title: '${detail.voucher!.purchaseText}',
                              fontFamily: fontFamilySuez,
                              textColor: detail.voucher!.isAbleRedeem == true
                                  ? isProcessing
                                      ? colorDarkGray
                                      : colorWhite
                                  : colorDarkGray,
                              height: height / 14,
                              onPressed: detail.voucher!.isAbleRedeem == true
                                  ? isProcessing
                                      ? () {}
                                      : () {
                                          setProcessingStatus(true);

                                          if (detail.voucher!.purchaseMethod ==
                                              'either') {
                                            showPaybyModal(height, width,
                                                detail, rewardId);
                                          } else {
                                            Navigator.of(context)
                                                .pushNamed(
                                                    AqualifeRoutes
                                                        .rewardConfirm,
                                                    arguments:
                                                        RewardConfirmParameters(
                                                      voucherInfo:
                                                          detail.voucher!,
                                                      indexPage: 1,
                                                      // either: '',
                                                    ))
                                                .then((value) =>
                                                    setProcessingStatus(false));
                                          }

                                          // BlocProvider.of<SecurityBloc>(
                                          //         context)
                                          //     .add(SecurityStart());
                                        }
                                  : () {},
                              backgroundColor:
                                  detail.voucher!.isAbleRedeem == true
                                      ? isProcessing
                                          ? colorLightGray
                                          : secondaryColor
                                      : colorDisableGrey,
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.only(bottom: 0),
                      child: Divider(
                        color: colorDarkGray,
                      ),
                    ),
                    /* --------------------------------------------------- Description title part */
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 10),
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w700,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    /* --------------------------------------------------- Description info part(from API) */
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 10),
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.topLeft,
                      color: colorWhite,
                      child: Text(
                        detail.voucher!.desc!,
                        style: TextStyle(
                          fontSize: 14,
                          // color: colorSoftGrey,
                          fontWeight: FontWeight.normal,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    /* --------------------------------------------------- Terms & conditions title part */
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 10, marginHorizontal, 16),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Terms & Conditions:',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorBlack,
                          fontWeight: FontWeight.w700,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    /* --------------------------------------------------- Terms & conditions info part(from API) */
                    Container(
                      color: colorTransparent,
                      margin: EdgeInsets.fromLTRB(
                          marginHorizontal, 0, marginHorizontal, 30),
                      child: HtmlWidget(
                        detail.voucher!.tnc!,
                        textStyle: TextStyle(
                          fontSize: 14,
                          color: colorSoftGrey,
                          fontWeight: FontWeight.normal,
                        ),
                        // customWidgetBuilder: (element) {
                        //   if (element.localName == 'span') {
                        //     return Text(
                        //       element.text,
                        //       style: TextStyle(
                        //         fontFamily: fontFamilyMain,
                        //         fontSize: 14,
                        //         color: colorSoftGrey,
                        //       ),
                        //     );
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showPaybyModal(height, width, DetailsData detail, int rewardId) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      backgroundColor: colorBackground,
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => Padding(
        padding: EdgeInsets.zero,
        child: IntrinsicHeight(
          child: Container(
            width: double.maxFinite,
            // height: height / 2.5,
            padding: EdgeInsets.all(10),
            clipBehavior: Clip.antiAlias,
            // padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: colorBackground,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      // margin: EdgeInsets.only(bottom: 20),
                      child: ListTile(
                        leading: InkWell(
                          child: Container(
                            height: height * 0.04,
                            width: height * 0.04,
                            alignment: Alignment.centerRight,
                            // color: colorLightGray,
                            padding: EdgeInsets.zero,
                            child: Icon(
                              Icons.close_rounded,
                              color: colorValidGray,
                              size: 27,
                            ),
                          ),
                          onTap: () {
                            setProcessingStatus(false);
                            _result = '';
                            Navigator.of(context).pop();
                          },
                        ),
                        title: Container(
                          alignment: Alignment.center,
                          // color: colorLightBlue,
                          child: Text(
                            'Pay By',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: colorBlack,
                            ),
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                        ),
                        trailing: Container(
                          height: height * 0.04,
                          width: height * 0.04,
                          color: colorTransparent,
                        ),
                      ),
                    ),
                    creditEnable == false
                        ? Container()
                        : Container(
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: _result == 'credits'
                                  ? Color(0xFFEEFBEE)
                                  : colorButtonLightGrey,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: _result == 'credits'
                                    ? Color(0xFF37D977)
                                    : colorButtonLightGrey,
                              ),
                            ),
                            child: RadioListTile<String>(
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Credit(s)',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: colorBlack,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                                  double.parse(detail.voucher!.aftDisCredits!) >
                                          0
                                      ? Text(
                                          '${detail.voucher!.aftDisCredits}',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: colorBlack,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        )
                                      : Text(
                                          'Not available',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: colorRed,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          textScaler:
                                              TextScaler.linear(scaleFactor),
                                        ),
                                ],
                              ),
                              value: 'credits',
                              groupValue: _result,
                              activeColor: Color(0xFF37D977),
                              onChanged:
                                  double.parse(detail.voucher!.aftDisCredits!) >
                                          0
                                      ? (value) {
                                          setState(() {
                                            _result = value!;
                                          });
                                        }
                                      : (value) {},
                            ),
                          ),
                    SizedBox(height: 20),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: _result == 'points'
                            ? Color(0xFFEEFBEE)
                            : colorButtonLightGrey,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: _result == 'points'
                              ? Color(0xFF37D977)
                              : colorButtonLightGrey,
                        ),
                      ),
                      child: RadioListTile<String>(
                        contentPadding: EdgeInsets.zero,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Point(s)',
                              style: TextStyle(
                                fontSize: 15,
                                color: colorBlack,
                                fontWeight: FontWeight.w500,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                            double.parse(detail.voucher!.aftDisPoints!) > 0
                                ? Container(
                                    child: Text(
                                      '${detail.voucher!.aftDisPoints} ',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: colorBlack,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                  )
                                : Text(
                                    'Not available',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colorRed,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                          ],
                        ),
                        value: 'points',
                        groupValue: _result,
                        activeColor: Color(0xFF37D977),
                        onChanged:
                            double.parse(detail.voucher!.aftDisPoints!) > 0
                                ? (value) {
                                    setState(() {
                                      _result = value!;
                                    });
                                  }
                                : (value) {},
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: width * 0.17,
                              padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: InkWell(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: colorBlack,
                                    decoration: TextDecoration.underline,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                                onTap: () {
                                  setProcessingStatus(false);
                                  _result = '';
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                            Container(
                              // width: width * 0.17,
                              padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: InkWell(
                                onTap: () {
                                  setProcessingStatus(true);

                                  selectedRewardID = rewardId;

                                  Navigator.pop(context);

                                  // _checkVerified(
                                  //   detail.voucher!,
                                  //   1,
                                  // );

                                  if (_result == '' || _result.isEmpty) {
                                    showErrorToast(
                                        'Please select a payment method',
                                        context);
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(AqualifeRoutes.rewardConfirm,
                                            arguments: RewardConfirmParameters(
                                              voucherInfo: detail.voucher!,
                                              indexPage: 1,
                                              either: _result,
                                            ))
                                        .then((value) =>
                                            setProcessingStatus(false));
                                  }
                                },
                                child: Text(
                                  'Purchase now',
                                  style: TextStyle(
                                    // fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: _result == ''
                                        ? Color(0xFF979797)
                                        : secondaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.right,
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  // void _checkVerified(dynamic voucherInfo, int indexPage) {
  //   if (_result == '' || _result.isEmpty) {
  //     showErrorToast('Please select a payment method', context);
  //   } else {
  //     Navigator.of(context)
  //         .pushNamed( AqualifeRoutes.rewardConfirm,
  //             arguments: RewardConfirmParameters(
  //               voucherInfo: voucherInfo,
  //               indexPage: 1,
  //               either: _result,
  //             ))
  //         .then((value) => setProcessingStatus(false));
  //   }
  // }

  // void modalBottomSheetSocial(DetailsData detail) {
  //   var height = MediaQuery.of(context).size.height;
  //   // var width = MediaQuery.of(context).size.width;

  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
  //     ),
  //     backgroundColor: colorBackground,
  //     builder: (builder) {
  //       return Container(
  //         height: 350.0,
  //         padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
  //         child: GridView.builder(
  //           padding: EdgeInsets.zero,
  //           itemCount: _platforms.length,
  //           shrinkWrap: true,
  //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             crossAxisCount: 3,
  //             childAspectRatio: 1,
  //             mainAxisSpacing: height * 0.02,
  //             // crossAxisSpacing: 5,
  //           ),
  //           itemBuilder: (context, index) {
  //             return InkWell(
  //               onTap: () async {
  //                 final response = await get(Uri.parse(detail.voucher!.image!));
  //                 final directory = await getTemporaryDirectory();
  //                 File file = await File('${directory.path}/Image.png')
  //                     .writeAsBytes(response.bodyBytes);

  //                 await SocialSharingPlus.shareToSocialMedia(
  //                   _platforms[index],
  //                   '${detail.voucher!.share}\n\n${detail.voucher!.shareLink}',
  //                   media: file.path,
  //                   isOpenBrowser: true,
  //                 );
  //               },
  //               child: Container(
  //                 child: Text(
  //                   _platforms[index].toString(),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  void navigateBack() {
    TempData.currentPage == 'voucherPage'
        ? Navigator.of(context).pushNamedAndRemoveUntil(
            AqualifeRoutes.home,
            (Route<dynamic> route) => false,
          )
        : Navigator.pop(context);
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
