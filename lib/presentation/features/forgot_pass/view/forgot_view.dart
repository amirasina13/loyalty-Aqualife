import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/routes.dart';
import '../../../../config/storage.dart';
import '../../../../domain/entities/validator.dart';
import '../../../widgets/data_driven/datadriven.dart';
import '../../../widgets/independent/independent.dart';
import '../../maintenance/maintenance_screen.dart';
import '../../register/register_screen.dart';
import '../forgot_pass.dart';

class ForgetView extends StatefulWidget {
  final Function changeView;

  // ignore: use_key_in_widget_constructors
  const ForgetView({
    Key? key,
    required this.changeView,
  }) : super();

  @override
  State<ForgetView> createState() => _ForgetViewState();
}

class _ForgetViewState extends State<ForgetView> {
  String selectedCode = '60';
  bool error = false;
  bool isProcessing = false;
  String errorfield = '';
  String errorTextEmail = '';
  List<String> getCode = [];

  final TextEditingController emailController = TextEditingController();
  // final GlobalKey<AqualifeSelectValueState> codeKey = GlobalKey();
  final GlobalKey<AqualifeInputFieldState> emailKey = GlobalKey();

  late FocusNode phoneFocus, emailFocus;
  final MyConnectivity _connectivity = MyConnectivity.instance;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    Storage().token = '';

    emailFocus = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    emailFocus.dispose();

    _connectivity.disposeStream();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var sizeBetween = height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? Colors.blueAccent : colorRed,
        ),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: colorBackground,
          body: BlocConsumer<ForgotPassBloc, ForgotPassState>(
            listener: (context, state) {
              if (state is ForgotPassSent) {
                Navigator.pushNamed(context, AqualifeRoutes.resetPassword,
                    arguments: ResetPassParameters(
                      email: state.data['data']['email'],
                      vToken: state.data['data']['vToken'],
                    ));
                // showSuccessToast(state.data['message'], context);
                // widget.changeView(
                //     changeType: ViewChangeType.Forward, data: state.data);
              }
              // on failure show a snackbar
              if (state is ForgotPassError) {
                // ignore: unnecessary_null_comparison
                state.error != null ? error = true : error = false;
                setProcessingStatus(false);

                showErrorToast(state.error, context);
                // ErrorIconDialog.showErrorDialog(context, state.error);
              }
              // maintenance mode on
              if (state is ForgotPassMaintenanceError) {
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
              // show loading screen while processing
              if (state is ForgotPassProcessing) {
                // return LoadingWidget();
              }
              return SingleChildScrollView(
                reverse: true, // this is new
                physics: BouncingScrollPhysics(),
                child: Container(
                  // height: height * 0.84,
                  color: colorWhite,
                  margin: EdgeInsets.fromLTRB(
                      marginHorizontal, 0, marginHorizontal, 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 50),
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
                        height: height / 7,
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: sizeBetween / 3),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 50, 0, 10),
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
                          // hint: 'Example: 123456789',
                          validator: Validator.valueExists,
                          keyboard: TextInputType.emailAddress,
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
                      SizedBox(height: sizeBetween * 3),
                    ],
                  ),
                ),
              );
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            // color: colorLightGray,
            margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                AqualifeStyleButton(
                  height: height / 14,
                  title: 'Send OTP',
                  backgroundColor: isProcessing ? colorLightGray : mainColor,
                  textColor: colorWhite,
                  onPressed: isProcessing ? () {} : _validateAndSend,
                ),
                Container(
                    alignment: Alignment.center,
                    // margin: EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account yet?',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AqualifeTextButton(
                          'Register',
                          color: mainColor,
                          fontSize: 13.0,
                          underline: true,
                          fontWeight: FontWeight.w600,
                          // fontStyle: FontStyle.italic,
                          onClick: _registerNow,
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerNow() {
    Navigator.of(context).pushNamed(AqualifeRoutes.register,
        arguments: RegisterParameters(
          referralCode: '',
        ));
  }

  void _validateAndSend() {
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });
    if (emailKey.currentState?.validate() != null) {
      setProcessingStatus(false);
      errorfield = 'errorEmail';
      emailFocus.requestFocus();
      errorTextEmail = 'The email address is required!';
      // showErrorToast('Please enter valid email address!', context);
    } else {
      errorfield = '';
      setProcessingStatus(true);
      BlocProvider.of<ForgotPassBloc>(context).add(
        ForgotPassReset(email: emailController.text),
      );
    }
  }
}
