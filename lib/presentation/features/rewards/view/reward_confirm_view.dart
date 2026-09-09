import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../data/model/model.dart';
import '../../../widgets/data_driven/datadriven.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../security_pin/security_pin.dart';
import '../../voucher/voucher.dart';
import '../../webview/webview_deeplink.dart';
import '../reward.dart';

class RewardConfirm extends StatefulWidget {
  final Function changeView;
  final Details voucherInfo;
  final String? either;

  const RewardConfirm({
    super.key,
    required this.changeView,
    required this.voucherInfo,
    this.either,
  });

  @override
  State<RewardConfirm> createState() => _RewardConfirmState();
}

class _RewardConfirmState extends State<RewardConfirm> {
  int _itemCount = 1;
  bool isMax = false, isMin = false;
  bool isProcessing = false;
  bool checkValueRead = false;
  String passcodePin = '',
      creditsAmount = '',
      pointsAmount = '',
      totalText = '',
      redeemVia = '',
      refCode = '';
  late FocusNode referralFocus;
  TextEditingController referralController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> referralKey = GlobalKey();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    referralFocus = FocusNode();
    totalPayment();
    refCode = TempData.voucherRefCode;
  }

  @override
  void dispose() {
    // // Clean up the focus node when the Form is disposed.
    referralFocus.dispose();

    super.dispose();
  }

  totalPayment() {
    if (widget.voucherInfo.voucherType! == 'downloadable') {
      creditsAmount = '0.00';
      pointsAmount = '0.00';
      totalText = '0.00';
    } else if (widget.voucherInfo.purchaseMethod! == 'credits') {
      creditsAmount = widget.voucherInfo.aftDisCredits!;
      pointsAmount = '0.00';
      redeemVia = 'credits';
      totalText = creditLabelAlign == 'left'
          ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)}'
          : '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText ';
    } else if (widget.voucherInfo.purchaseMethod! == 'points') {
      creditsAmount = '0.00';
      pointsAmount = widget.voucherInfo.aftDisPoints!;
      redeemVia = 'points';
      totalText = pointLabelAlign == 'left'
          ? '$pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)}'
          : '${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText ';
    } else if (widget.voucherInfo.purchaseMethod! == 'both') {
      creditsAmount = widget.voucherInfo.aftDisCredits!;
      pointsAmount = widget.voucherInfo.aftDisPoints!;
      redeemVia = 'credits';
      totalText = creditLabelAlign == 'left' && pointLabelAlign == 'left'
          ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} + $pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)}'
          : creditLabelAlign == 'right' && pointLabelAlign == 'right'
              ? '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText + ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText '
              : creditLabelAlign == 'left' && pointLabelAlign == 'right'
                  ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} + ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText '
                  : '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText + $pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} ';
    } else if (widget.either == 'credits') {
      creditsAmount = widget.voucherInfo.aftDisCredits!;
      pointsAmount = '0.00';
      redeemVia = 'credits';
      totalText = creditLabelAlign == 'left'
          ? '$creditLabelText ${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)}'
          : '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} $creditLabelText ';
    } else if (widget.either == 'points') {
      creditsAmount = '0.00';
      pointsAmount = widget.voucherInfo.aftDisPoints!;
      redeemVia = 'points';
      totalText = pointLabelAlign == 'left'
          ? '$pointLabelText ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)}'
          : '${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} $pointLabelText ';
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // var sizeBetween = height / 20;

    return Scaffold(
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Container(
            height: height * 0.78,
            margin:
                EdgeInsets.fromLTRB(marginHorizontal, 10, marginHorizontal, 10),
            child: BlocConsumer<RewardBloc, RewardState>(
              listener: (context, state) {
                /* --------------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
                if (state is RewardMaintenanceError) {
                  Navigator.pushAndRemoveUntil<void>(
                    context,
                    MaterialPageRoute<void>(
                        builder: (BuildContext context) => MaintenanceScreen(
                            parameters:
                                MaintenanceParameters(message: state.message))),
                    ModalRoute.withName('/'),
                  );
                }

                if (state is RewardDownloadSuccess) {
                  setProcessingStatus(false);
                  showSuccessToast(state.data['message'], context);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.voucher, (route) => false,
                      arguments: VoucherParameters(
                        selectedTab: 1,
                        filterBy: 'all',
                        filterValue: '1',
                      ));
                }

                if (state is RewardPurchaseSuccess) {
                  setProcessingStatus(false);
                  showSuccessToast(state.data['message'], context);

                  Navigator.of(context).pushNamedAndRemoveUntil(
                      AqualifeRoutes.voucher, (route) => false,
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Payment Details',
                        style: TextStyle(
                          fontFamily: fontFamilyInter,
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Divider(
                      color: colorUsedGray,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 18),
                      child: Row(
                        children: [
                          Container(
                            width: height * 0.04,
                            height: height * 0.04,
                            margin: EdgeInsets.only(right: 10),
                            padding: EdgeInsets.all(3),
                            // decoration: BoxDecoration(
                            //     color: colorBoxGreen,
                            //     borderRadius: BorderRadius.circular(5)),
                            child: Image(
                              image: AssetImage('assets/icons/coupon.png'),
                              color: secondaryColor,
                            ),
                          ),
                          SizedBox(
                            width: width * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    widget.voucherInfo.name!,
                                    style: TextStyle(
                                      fontFamily: fontFamilyInter,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    widget.voucherInfo.desc!,
                                    style: TextStyle(
                                      fontFamily: fontFamilyInter,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // color: colorBabyBlue,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  (widget.voucherInfo.redeem! -
                                                  int.parse(widget.voucherInfo
                                                      .totalOwned!)) ==
                                              1 ||
                                          (widget.voucherInfo.redeem! -
                                                  int.parse(widget.voucherInfo
                                                      .totalOwned!)) ==
                                              0
                                      ? SizedBox(
                                          width: width * 0.09,
                                          child: Text(
                                            _itemCount.toString(),
                                            style: TextStyle(
                                              fontFamily: fontFamilyPoppins,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _itemCount != 0
                                                ? InkWell(
                                                    child: Container(
                                                      // color: colorButtonLightGrey,
                                                      width: width * 0.075,
                                                      height: width * 0.075,
                                                      decoration: BoxDecoration(
                                                        color: _itemCount != 1
                                                            ? secondaryColor
                                                            : colorButtonLightGrey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      child: Icon(
                                                        Icons.remove,
                                                        size: width * 0.06,
                                                        color: _itemCount != 1
                                                            ? colorWhite
                                                            : colorBlack,
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        if (_itemCount > 1) {
                                                          _itemCount--;
                                                          totalPayment();
                                                        }
                                                      });
                                                      // setState(() => _itemCount--);
                                                    },
                                                  )
                                                : Container(),
                                            SizedBox(
                                              width: width * 0.09,
                                              child: Text(
                                                _itemCount.toString(),
                                                style: TextStyle(
                                                  fontFamily: fontFamilyPoppins,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            InkWell(
                                              child: Container(
                                                width: width * 0.075,
                                                height: width * 0.075,
                                                decoration: BoxDecoration(
                                                  color: _itemCount >=
                                                          widget.voucherInfo
                                                                  .redeem! -
                                                              int.parse(widget
                                                                  .voucherInfo
                                                                  .totalOwned!)
                                                      ? colorButtonLightGrey
                                                      : secondaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child: Icon(
                                                  Icons.add,
                                                  size: width * 0.06,
                                                  color: _itemCount >=
                                                          widget.voucherInfo
                                                                  .redeem! -
                                                              int.parse(widget
                                                                  .voucherInfo
                                                                  .totalOwned!)
                                                      ? colorBlack
                                                      : colorWhite,
                                                ),
                                              ),
                                              onTap: () {
                                                setState(() {
                                                  if (_itemCount <
                                                      widget.voucherInfo
                                                              .redeem! -
                                                          int.parse(widget
                                                              .voucherInfo
                                                              .totalOwned!)) {
                                                    _itemCount++;
                                                    totalPayment();
                                                  }
                                                });
                                                // setState(() => _itemCount++);
                                              },
                                            )
                                          ],
                                        ),
                                  (widget.voucherInfo.redeem! -
                                                  int.parse(widget.voucherInfo
                                                      .totalOwned!)) ==
                                              1 ||
                                          (widget.voucherInfo.redeem! -
                                                  int.parse(widget.voucherInfo
                                                      .totalOwned!)) ==
                                              0
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.only(top: 5),
                                          child: Text(
                                            '${widget.voucherInfo.redeem! - int.parse(widget.voucherInfo.totalOwned!)} left',
                                            style: TextStyle(
                                              fontFamily: fontFamilyInter,
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: colorReferGrey,
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: colorUsedGray,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              creditLabelTitle,
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              creditLabelAlign == 'left'
                                  ? '$creditLabelText $creditsAmount'
                                  : '$creditsAmount $creditLabelText',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Point(s)',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              pointLabelAlign == 'left'
                                  ? '$pointLabelText $pointsAmount'
                                  : '$pointsAmount $pointLabelText',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Quantity',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              '$_itemCount',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              'Total to pay',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: mainColor,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              totalText,
                              // widget.voucherInfo.purchaseMethod! == 'both'
                              //     ? '${(double.parse(creditsAmount) * _itemCount).toStringAsFixed(2)} Credit(s) + ${(double.parse(pointsAmount) * _itemCount).toStringAsFixed(2)} Point(s)'
                              //     : creditsAmount != '0.00'
                              //         ? (double.parse(creditsAmount) *
                              //                 _itemCount)
                              //             .toStringAsFixed(2)
                              //         : pointsAmount != '0.00'
                              //             ? (double.parse(pointsAmount) *
                              //                     _itemCount)
                              //                 .toStringAsFixed(2)
                              //             : '0.00',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: colorBlack,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 10),
                            child: Text(
                              'Referral Code',
                              style: TextStyle(
                                fontFamily: fontFamilyInter,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: colorReferGrey,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              // height: height * 0.05,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: refCode.isNotEmpty
                                    ? Colors.grey[200]
                                    : colorBackground,
                                border: Border.all(color: colorGreyBox),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: TextField(
                                readOnly: refCode.isNotEmpty ? true : false,
                                controller: referralController,
                                style: TextStyle(
                                  fontFamily: fontFamilyInter,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: colorBlack,
                                ),
                                textAlign: TextAlign.right,
                                decoration: InputDecoration(
                                  hintText: refCode.isNotEmpty ? refCode : '',
                                  hintStyle: TextStyle(
                                    color: refCode.isNotEmpty
                                        ? colorBlack
                                        : colorSoftGrey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: fontFamilyMain,
                                  ),
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              // height: sizeBetween * 0.97,
                              child: Theme(
                                data: ThemeData(
                                  // unselectedWidgetColor: Colors.black45,
                                  checkboxTheme: CheckboxThemeData(
                                    // fillColor: MaterialStateProperty.all(
                                    //     Colors.transparent),
                                    // checkColor: MaterialStateProperty.all(
                                    //     secondaryColor),

                                    // For every Material state we return the same border style
                                    side: WidgetStateBorderSide.resolveWith(
                                      (states) => BorderSide(
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ),
                                child: CheckboxListTile(
                                  controlAffinity:
                                      ListTileControlAffinity.leading,
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 0),
                                  title: AqualifeRichText(
                                    oneText:
                                        'I have read, understood and accept the ',
                                    twoText: 'Terms & Conditions ',
                                    title1: 'Terms & Conditions',
                                    url1: urlTerm,
                                    threeText: 'and ',
                                    fourText: 'Privacy Policy.',
                                    title2: 'Privacy Policy',
                                    url2: urlPolicy,
                                  ),
                                  value: checkValueRead,
                                  onChanged: _onChangedRead,
                                  checkColor: colorWhite,
                                  activeColor: mainColor,
                                ),
                              ),
                            ),
                            BlocConsumer<SecurityBloc, SecurityState>(
                              listener: (context, securityState) {
                                // setProcessingStatus(false);

                                if (securityState is SecurityCheckVerified) {
                                  if (securityState.verified == false) {
                                    setProcessingStatus(false);

                                    Storage().page = 'reward_details';
                                    Navigator.of(context).pushNamed(
                                        AqualifeRoutes.securityCreate);

                                    // Navigator.of(context).pushNamed(
                                    //      AqualifeRoutes.securityRegister);
                                  } else {
                                    Storage().page = 'reward_details';
                                    Navigator.of(context)
                                        .pushNamed(AqualifeRoutes.passcodeKey)
                                        .then((value) {
                                      if (value != null) {
                                        passcodePin = value.toString();

                                        setState(() {
                                          if (widget.voucherInfo.voucherType ==
                                              'downloadable') {
                                            BlocProvider.of<RewardBloc>(context)
                                                .add(RewardDownload(
                                              voucherId: widget.voucherInfo.id!,
                                              pin: passcodePin,
                                              referral: referralController
                                                      .text.isNotEmpty
                                                  ? referralController.text
                                                  : refCode,
                                            ));
                                          } else {
                                            BlocProvider.of<RewardBloc>(context)
                                                .add(RewardPurchaseLoad(
                                              voucherId: widget.voucherInfo.id!,
                                              redeemVia: redeemVia,
                                              points: '0.00',
                                              pin: passcodePin,
                                              referral: referralController
                                                      .text.isNotEmpty
                                                  ? referralController.text
                                                  : refCode,
                                              quantity: _itemCount.toString(),
                                            ));
                                          }
                                        });
                                      } else {
                                        setProcessingStatus(false);
                                      }
                                    });
                                  }
                                }

                                if (securityState is SecurityOtpSent) {
                                  showSuccessToast(
                                      securityState.data['message'], context);
                                  Navigator.of(context).pushNamed(
                                      AqualifeRoutes.securityOtp,
                                      arguments: SecurityOtpParameters(
                                          otpData: securityState.data));
                                }

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
                                                parameters:
                                                    MaintenanceParameters(
                                                        message: securityState
                                                            .message))),
                                    ModalRoute.withName('/'),
                                  );
                                }
                              },
                              builder: (context, state) {
                                return AqualifeStyleButton(
                                  height: height / 14,
                                  title: isProcessing
                                      ? 'Processing...'
                                      : 'Pay Now',
                                  iconLeading: false,
                                  icon: Icons.arrow_forward,
                                  backgroundColor:
                                      isProcessing ? colorLightGray : mainColor,
                                  textColor:
                                      isProcessing ? colorDarkGray : colorWhite,
                                  onPressed: _validateAndSend,
                                );
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                padding: EdgeInsets.symmetric(vertical: 5),
                                // color: colorBabyBlue,
                                alignment: Alignment.center,
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: colorBlack,
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                  ),
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
              },
            )),
      ),
    );
  }

  void _onChangedRead(bool? value) {
    if (value != null) {
      setState(() {
        checkValueRead = value;
      });
    }
  }

  void _validateAndSend() {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (checkValueRead == false) {
      // errorfield = '';
      showErrorToast(
          'To continue, kindly read and agree to the Terms & Conditions.',
          context);
    } else {
      BlocProvider.of<SecurityBloc>(context).add(SecurityStart());
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
