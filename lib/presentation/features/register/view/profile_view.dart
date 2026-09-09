import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/routes.dart';
import '../../../../config/storage.dart';

import '../../../../domain/entities/validator.dart';
import '../../../widgets/data_driven/datadriven.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../otp/otp.dart';
import '../../webview/webview_deeplink.dart';
import '../register.dart';

class ProfileRegView extends StatefulWidget {
  final Function changeView;
  final String referralCode;

  const ProfileRegView({
    super.key,
    required this.changeView,
    required this.referralCode,
  });

  @override
  State<ProfileRegView> createState() => _ProfileRegViewState();
}

class _ProfileRegViewState extends State<ProfileRegView> {
  bool error = false;
  String selectedCode = '60';
  String passwordValid = '';
  String errorfield = '';
  String barcodeScanRes = '';
  List<String> getCode = [];

  final TextEditingController emailController = TextEditingController();
  final TextEditingController refferelController =
      TextEditingController(); //text: "IF21ZFGMYC"
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final GlobalKey<AqualifeInputFieldState> refferelKey = GlobalKey();
  // final GlobalKey<AqualifeSelectValueState> codeKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> emailKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> passwordKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> confirmPasswordKey = GlobalKey();

  String otpCode = '', vToken = '';
  String errorTextEmail = '',
      errorTextPwd = '',
      errorTextCfmPwd = '',
      errorTextMissMatch = '',
      voucherAffilliateCode = '';
  late double sizeBetween;
  bool isProcessing = false;
  bool checkValueRead = false;
  bool checkValueData = false;
  late Map reqInfo;
  late FocusNode emailFocus, pwFocus, confirmPwFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;
  // final dynamicLink = FirebaseDynamicLinks.instance;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    Storage().token = '';
    // _getVoucherAffiliateCode();
    voucherAffilliateCode = TempData.affiliateCode;
    refferelController.text = widget.referralCode.isNotEmpty
        ? widget.referralCode
        : voucherAffilliateCode;
    emailFocus = FocusNode();
    pwFocus = FocusNode();
    confirmPwFocus = FocusNode();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();

    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();
    pwFocus.dispose();
    confirmPwFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    sizeBetween = height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
        ),
      ),
      child: Scaffold(
        backgroundColor: colorWhite,
        body: BlocConsumer<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterMaintenanceError) {
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => MaintenanceScreen(
                        parameters:
                            MaintenanceParameters(message: state.message))),
                ModalRoute.withName('/'),
              );
            }
            if (state is RegisterSuccess) {
              setProcessingStatus(false);
              // showSuccessToast(state.data['message'], context);

              reqInfo = state.data;
              var reqEmail = state.data['data']['email'];
              var reqVToken = state.data['data']['vToken'];
              // Navigator.of(context).pushNamedAndRemoveUntil(
              //      AqualifeRoutes.otp, (Route<dynamic> route) => false,
              //     arguments: OtpParameters(data: state.data));
              _requestOtp(reqEmail, reqVToken);
              // Navigator.of(context).pushNamed(AqualifeRoutes.otpVerify,
              //     arguments: OtpVerifyParameters(data: state.data));
              // Navigator.of(context).pushNamed(AqualifeRoutes.otp,
              //     arguments: OtpParameters(data: state.data));
            }
            if (state is RegisterError) {
              // ignore: unnecessary_null_comparison
              state.error != null ? error = true : error = false;

              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }
            if (state is RegisterNetworkError) {
              setProcessingStatus(false);
              showErrorToast(state.error, context);
            }
            if (state is ReferDecryptSuccess) {
              refferelController.text = state.referCode;
            }
            if (state is ReferDecryptFail) {
              // setProcessingStatus(false);
              refferelController.text = '';
              showErrorToast('Refferal code not valid.', context);
            }
          },
          builder: (context, state) {
            // show loading screen while processing
            if (state is RegisterProcessing) {
              // return Center(
              //   child: CircularProgressIndicator(color: colorDisableGrey,),
              // );
            }

            if (state is RegisterVerifySuccess) {
              emailController.text = state.data['data']['email'];
              vToken = state.data['data']['vToken'];
            }

            return BlocConsumer<OtpBloc, OtpState>(
              listener: (context, state) {
                if (state is OtpRequestSuccess) {
                  setProcessingStatus(false);
                  // resendvToken = state.data['data']['vToken'];
                  // tokenVerify = state.data['data']['token'];

                  Navigator.of(context).pushNamed(AqualifeRoutes.otpVerify,
                      arguments: OtpVerifyParameters(data: state.data));
                  showSuccessToast(state.data['message'], context);
                }
                if (state is OtpError) {
                  // ignore: unnecessary_null_comparison
                  state.error != null ? error = true : error = false;
                  setProcessingStatus(false);
                  showErrorToast(state.error, context);
                  // Navigator.of(context).pushNamed(AqualifeRoutes.otp,
                  //     arguments: OtpVerifyParameters(data: reqInfo));
                }
              },
              builder: (context, state) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: 50),
                          padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                          height: height / 7,
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: fontFamilyMain,
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        SizedBox(height: sizeBetween * 0.5),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
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
                            // boxShadow: [
                            //   BoxShadow(
                            //       color: error
                            //           ? colorRed
                            //           : errorfield == 'error' ||
                            //                   errorfield == 'errorEmail'
                            //               ? colorRed
                            //               : colorGreyBox,
                            //       // blurRadius: 15.0,
                            //       offset: Offset(
                            //           0.0,
                            //           error
                            //               ? 3
                            //               : errorfield == 'error' ||
                            //                       errorfield == 'errorEmail'
                            //                   ? 3
                            //                   : 0))
                            // ],
                            border: Border.all(color: colorGreyBox),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: AqualifeInputField(
                            key: emailKey,
                            controller: emailController,
                            validator: Validator.valueExists,
                            readOnly: true,
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
                            // errorText: errorText,
                          ),
                        ),
                        // errorfield == 'error' || errorfield == 'errorEmail'
                        //     ? Container(
                        //         margin: EdgeInsets.only(top: 5),
                        //         child: Text(
                        //           errorTextEmail,
                        //           style: TextStyle(
                        //               fontSize: 10,
                        //               fontWeight: FontWeight.w400,
                        //               color: error
                        //                   ? colorRed
                        //                   : errorfield == 'error' ||
                        //                           errorfield == 'errorEmail'
                        //                       ? colorRed
                        //                       : colorGreyBox),
                        //         ),
                        //       )
                        //     : SizedBox(),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
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
                                              errorfield == 'errorPwd' ||
                                              errorfield == 'errorMismatch'
                                          ? colorRed
                                          : colorGreyBox,
                                  // blurRadius: 15.0,
                                  offset: Offset(
                                      0.0,
                                      error
                                          ? 3
                                          : errorfield == 'error' ||
                                                  errorfield == 'errorPwd' ||
                                                  errorfield == 'errorMismatch'
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
                            // hint: 'Password *',
                            // validator: Validator.passwordCorrect,
                            keyboard: TextInputType.visiblePassword,
                            isPassword: true,
                            border: InputBorder.none,
                            focusNode: pwFocus,
                            onValueChanged: (value) {
                              if (value != '') {
                                setState(() {
                                  errorfield = '';
                                  passwordKey.currentState?.validate();

                                  // print(
                                  //     'ERRORTEXT: ${passwordKey.currentState?.validate()}');
                                });
                              }
                            },
                          ),
                        ),
                        errorfield == 'error' ||
                                errorfield == 'errorPwd' ||
                                errorfield == 'errorMismatch'
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  errorfield == 'error' ||
                                          errorfield == 'errorPwd'
                                      ? errorTextPwd
                                      : errorTextMissMatch,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                                  errorfield == 'errorPwd' ||
                                                  errorfield == 'errorMismatch'
                                              ? colorRed
                                              : colorGreyBox),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Must contain: 8-16 characters, uppercase, lowercase, number and symbol (!@#)',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 10,
                                    color: colorSoftGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: Text(
                            'Confirm Password',
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
                                              errorfield == 'errorCfmPwd' ||
                                              errorfield == 'errorMismatch'
                                          ? colorRed
                                          : colorGreyBox,
                                  // blurRadius: 15.0,
                                  offset: Offset(
                                      0.0,
                                      error
                                          ? 3
                                          : errorfield == 'error' ||
                                                  errorfield == 'errorCfmPwd' ||
                                                  errorfield == 'errorMismatch'
                                              ? 3
                                              : 0))
                            ],
                            border: Border.all(color: colorGreyBox),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: AqualifeInputField(
                            key: confirmPasswordKey,
                            controller: confirmPasswordController,
                            // hint: 'Confirm Password *',
                            validator: Validator.valueExists,
                            keyboard: TextInputType.visiblePassword,
                            isPassword: true,
                            border: InputBorder.none,
                            focusNode: confirmPwFocus,
                            textAlignVertical: TextAlignVertical.center,
                            onValueChanged: (value) {
                              if (value != '') {
                                setState(() {
                                  errorfield = '';
                                  confirmPasswordKey.currentState?.validate();
                                });
                              }
                            },
                          ),
                        ),
                        errorfield == 'error' ||
                                errorfield == 'errorCfmPwd' ||
                                errorfield == 'errorMismatch'
                            ? Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  errorfield == 'error' ||
                                          errorfield == 'errorCfmPwd'
                                      ? errorTextCfmPwd
                                      : errorTextMissMatch,
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w400,
                                      color: error
                                          ? colorRed
                                          : errorfield == 'error' ||
                                                  errorfield == 'errorCfmPwd' ||
                                                  errorfield == 'errorMismatch'
                                              ? colorRed
                                              : colorGreyBox),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.only(top: 5),
                                child: Text(
                                  'Must contain: 8-16 characters, uppercase, lowercase, number and symbol (!@#)',
                                  style: TextStyle(
                                    fontFamily: fontFamilyMain,
                                    fontSize: 10,
                                    color: colorSoftGrey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: Text(
                            'Referral Code (Optional)',
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
                                  color: error ? colorRed : colorGreyBox,
                                  // blurRadius: 15.0,
                                  offset: Offset(0.0, error ? 3 : 0))
                            ],
                            border: Border.all(color: colorGreyBox),
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                          ),
                          child: AqualifeInputField(
                            readOnly: voucherAffilliateCode.isNotEmpty ||
                                    widget.referralCode.isNotEmpty
                                ? true
                                : false,
                            key: refferelKey,
                            controller: refferelController,
                            hint: voucherAffilliateCode.isNotEmpty
                                ? voucherAffilliateCode
                                : widget.referralCode.isNotEmpty
                                    ? widget.referralCode
                                    : '',
                            validator: Validator.valueExists,
                            keyboard: TextInputType.text,
                            border: InputBorder.none,
                            textAlignVertical: TextAlignVertical.center,
                            endIcon: InkWell(
                              child: Container(
                                margin: EdgeInsets.all(12),
                                child: Image(
                                  fit: BoxFit.contain,
                                  color: colorDarkGray,
                                  image: AssetImage(registerScanner),
                                ),
                              ),
                              onTap: () {
                                Storage().page = 'referral';
                                scanBarcodeNormal();
                              },
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(top: height / 13),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: sizeBetween * 0.97,
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
                              SizedBox(height: 20),
                              AqualifeStyleButton(
                                height: height / 14,
                                title: isProcessing
                                    ? 'Processing...'
                                    : 'Create My Account',
                                backgroundColor:
                                    isProcessing ? colorLightGray : mainColor,
                                textColor:
                                    isProcessing ? colorDarkGray : colorWhite,
                                onPressed:
                                    isProcessing ? () {} : _validateAndSend,
                              ),
                              Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account?',
                                        style: TextStyle(
                                          fontFamily: fontFamilyMain,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      AqualifeTextButton(
                                        'Sign In',
                                        color: mainColor,
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        underline: true,
                                        // fontStyle: FontStyle.italic,
                                        onClick: _showLogInScreen,
                                      ),
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
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

  void _showLogInScreen() {
    // Storage().dynamicLink = null;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AqualifeRoutes.login,
      (Route<dynamic> route) => false,
    );
  }

  Future<void> scanBarcodeNormal() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              AppBarcodeScannerWidget.defaultStyle(),
        )).then((value) {
      barcodeScanRes = value.toString();

      if (value != null) {
        referDecryptValue(barcodeScanRes);
      }
    });
  }

  void referDecryptValue(String barcodeScanRes) {
    BlocProvider.of<RegisterBloc>(context).add(
      RegisterReferDecrypt(
        referCode: barcodeScanRes,
      ),
    );
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });
    if (passwordController.text.isEmpty &&
        confirmPasswordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'error';
      emailFocus.requestFocus();

      errorTextPwd = 'The password is required!';
      errorTextCfmPwd = 'The confirmation password is required!';
    } else if (passwordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorPwd';
      pwFocus.requestFocus();
      errorTextPwd = 'The password is required!';
      // showErrorToast('The password is required!', context);
    } else if (confirmPasswordKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorCfmPwd';
      confirmPwFocus.requestFocus();
      errorTextCfmPwd = 'The confirmation password is required!';
      // showErrorToast('The confirmation password is required!', context);
    } else if (Validator.passwordCorrect(passwordController.text) != null) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      pwFocus.requestFocus();
      errorTextMissMatch =
          'Must contain: 8-16 characters, uppercase, lowercase, number and symbol (!@#)';
    } else if (passwordController.text != confirmPasswordController.text) {
      setProcessingStatus(false);
      errorfield = 'errorMismatch';
      confirmPwFocus.requestFocus();
      errorTextMissMatch = 'Password mismatched';
      // showErrorToast('Password mismatched', context);
    } else if (checkValueRead == false) {
      errorfield = '';
      showErrorToast(
          'You must agree to the Terms and Conditions to proceed.', context);
    } else {
      errorfield = '';
      setProcessingStatus(true);

      BlocProvider.of<RegisterBloc>(context).add(
        RegisterPressed(
          email: emailController.text.trim(),
          referral: refferelController.text.trim(),
          password: confirmPasswordController.text.trim(),
          vToken: vToken,
        ),
      );
    }
  }

  void _requestOtp(String reqEmail, String reqVToken) {
    setProcessingStatus(true);
    BlocProvider.of<OtpBloc>(context).add(OtpRequest(
      email: reqEmail,
      purpose: 'register',
      vToken: reqVToken,
    ));
  }
}
