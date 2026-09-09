import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/routes.dart';

import '../../../../domain/entities/validator.dart';
import '../../../widgets/data_driven/datadriven.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../wrapper.dart';
import '../register.dart';

class RegisterView extends StatefulWidget {
  final Function changeView;
  final String referralCode;

  const RegisterView({
    super.key,
    required this.changeView,
    required this.referralCode,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  bool error = false;
  String errorfield = '';

  final TextEditingController emailController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> emailKey = GlobalKey();

  String otpCode = '';
  String errorTextEmail = '';
  late double sizeBetween;
  bool isProcessing = false;
  late FocusNode emailFocus;
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

    fToast = FToast();
    fToast.init(context);

    emailFocus = FocusNode();
  }

  @override
  void dispose() {
    _connectivity.disposeStream();

    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();

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
            if (state is RegisterVerifySuccess) {
              setProcessingStatus(false);
              showSuccessToast(state.data['message'], context);
              widget.changeView(changeType: ViewChangeType.Forward);
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
          },
          builder: (context, state) {
            // show loading screen while processing
            if (state is RegisterProcessing) {
              // return Center(
              //   child: CircularProgressIndicator(color: colorDisableGrey,),
              // );
            }
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
                        boxShadow: [
                          BoxShadow(
                              color: error
                                  ? colorRed
                                  : errorfield == 'error' ||
                                          errorfield == 'errorEmail'
                                      ? colorRed
                                      : colorGreyBox,
                              // blurRadius: 15.0,
                              offset: Offset(
                                  0.0,
                                  error
                                      ? 3
                                      : errorfield == 'error' ||
                                              errorfield == 'errorEmail'
                                          ? 3
                                          : 0))
                        ],
                        border: Border.all(color: colorGreyBox),
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      child: AqualifeInputField(
                        key: emailKey,
                        controller: emailController,
                        validator: Validator.valueExists,
                        border: InputBorder.none,
                        focusNode: emailFocus,
                        keyboard: TextInputType.emailAddress,
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
                    errorfield == 'error' || errorfield == 'errorEmail'
                        ? Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Text(
                              errorTextEmail,
                              style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  color: error
                                      ? colorRed
                                      : errorfield == 'error' ||
                                              errorfield == 'errorEmail'
                                          ? colorRed
                                          : colorGreyBox),
                            ),
                          )
                        : SizedBox(),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: EdgeInsets.only(top: height / 13),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AqualifeStyleButton(
                            height: height / 14,
                            title: isProcessing
                                ? 'Processing...'
                                : 'Create My Account',
                            backgroundColor:
                                isProcessing ? colorLightGray : mainColor,
                            textColor:
                                isProcessing ? colorDarkGray : colorWhite,
                            onPressed: isProcessing ? () {} : _validateAndSend,
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
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showLogInScreen() {
    // Storage().dynamicLink = null;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AqualifeRoutes.login,
      (Route<dynamic> route) => false,
    );
  }

  void _validateAndSend() {
    if (emailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'The email address is required!';
      // showErrorToast('Please enter valid email address!', context);
    } else {
      errorfield = '';
      setProcessingStatus(true);

      BlocProvider.of<RegisterBloc>(context).add(
        RegisterVerify(
          email: emailController.text.trim(),
        ),
      );
    }
  }
}
