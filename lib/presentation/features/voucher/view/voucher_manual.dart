import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../../domain/entities/validator.dart';
import '../../../widgets/independent/independent.dart';
import '../../authentication/authentication.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../rewards/reward.dart';
import '../voucher.dart';

class VoucherManualView extends StatefulWidget {
  final Function changeView;
  const VoucherManualView({
    super.key,
    required this.changeView,
  });

  @override
  State<VoucherManualView> createState() => _VoucherManualViewState();
}

class _VoucherManualViewState extends State<VoucherManualView> {
  String errorfield = '';
  bool error = false;
  bool isProcessing = false;
  late FocusNode voucherCodeFocus;
  int selectedTabVoucher = 0;

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

    voucherCodeFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();

    voucherCodeFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorBackground,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: colorBackground,
            iconTheme: IconThemeData(color: colorBlack),
            title: Text(
              'Back to Scan',
              style: TextStyle(
                fontFamily: fontFamilyMain,
                color: colorBlack,
                fontWeight: FontWeight.w400,
                fontSize: 15,
              ),
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
          body: BlocConsumer<RewardBloc, RewardState>(
            listener: (context, state) {
              fToast = FToast();
              fToast.init(context);

              if (state is RewardRedeemSuccess) {
                // if (Storage().globalValue!['vouchers'] == true &&
                //     Storage().globalValue!['subscriptions'] == true) {
                //   selectedTabVoucher = 0;
                // } else if (Storage().globalValue!['vouchers'] == false) {
                //   selectedTabVoucher = 3;
                // } else {
                //   selectedTabVoucher = 0;
                // }

                RewardSuccessDialog.showRewardSuccessDialog(
                  context,
                  state.redeemResponse,
                  // '${state.redeemResponse['message']} \n\n ${state.redeemResponse['data']['message']}',
                  () {
                    if (state.redeemResponse['data']['type'] == 'voucher') {
                      BlocProvider.of<VoucherBloc>(context)
                          .add(VoucherCategoriesLoad(
                        filterBy: 'all',
                        filterValue: 'all',
                      ));
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AqualifeRoutes.voucher,
                          (Route<dynamic> route) => false,
                          arguments: VoucherParameters(
                              selectedTab: 1,
                              filterBy: 'all',
                              filterValue: '1'));
                    } else {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AqualifeRoutes.home, (Route<dynamic> route) => false);
                    }
                  },
                );
              }

              if (state is RewardRedeemFailed) {
                Storage().rewardReload = 'yes';
                setProcessingStatus(false);
                BlocProvider.of<RewardBloc>(context).add(RewardScannerLoad());

                // Navigator.of(context).pushNamedAndRemoveUntil(
                //      AqualifeRoutes.voucher, (Route<dynamic> route) => false,
                //     arguments: VoucherParameters(selectedTab: 0));

                showErrorToast(state.redeemResponse['message'], context);
              }

              if (state is RewardError) {
                setProcessingStatus(false);
              }

              /* --------------------------------------------------------------- Listen to maintenance error, navigate to maintenance page */
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
            },
            builder: (context, state) {
              return SingleChildScrollView(
                reverse: true, // this is new
                physics: BouncingScrollPhysics(),
                child: Container(
                  margin: EdgeInsets.fromLTRB(
                      marginHorizontal, 30, marginHorizontal, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter voucher code to redeem',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF03053D),
                          fontWeight: FontWeight.w400,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 30),
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
                                                errorfield == 'errorCode'
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
                        title: isProcessing ? 'Processing...' : 'Redeem',
                        backgroundColor:
                            isProcessing ? colorLightGray : mainColor,
                        textColor: isProcessing ? colorDarkGray : colorWhite,
                        onPressed: _validateAndSend,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: AqualifeTextButton(
                          'Cancel',
                          color: secondaryColor,
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _validateAndSend() {
    if (voucherCodeKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorCode';
      voucherCodeFocus.requestFocus();
      showErrorToast('The voucher code is required !', context);
    } else {
      errorfield = '';

      setProcessingStatus(true);
      BlocProvider.of<RewardBloc>(context).add(
        RewardRedeemQrLoad(
          code: voucherCodeController.text.trim(),
        ),
      );
    }
  }

  void sessionExpiredLogOut(String error) {
    showErrorToast('$error\nYou will be logged out.', context);
    BlocProvider.of<AuthenticationBloc>(context).add(AuthenticationLoggedOut());
    Navigator.of(context).pushNamedAndRemoveUntil(
        AqualifeRoutes.login, (Route<dynamic> route) => false);
  }
}
