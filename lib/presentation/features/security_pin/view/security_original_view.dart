import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../config/routes.dart';
import '../../../widgets/independent/independent.dart';
import '../security_pin.dart';

class SecurityOriginalView extends StatefulWidget {
  final Function changeView;
  const SecurityOriginalView({super.key, required this.changeView});

  @override
  State<SecurityOriginalView> createState() => _SecurityOriginalViewState();
}

class _SecurityOriginalViewState extends State<SecurityOriginalView> {
  bool isProcessing = false, isResetProcessing = false;
  String enteredPin = '';

  /// this widget will be use for each digit
  Widget numButton(int number) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        margin: EdgeInsets.symmetric(horizontal: 3),
        child: TextButton(
          onPressed: () {
            setState(() {
              if (enteredPin.length < 6) {
                enteredPin += number.toString();
              }
            });
          },
          style: TextButton.styleFrom(
            backgroundColor: colorWhite,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              number.toString(),
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w600,
                color: colorBlack,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  void setResetProcessingStatus(bool processing) {
    setState(() {
      isResetProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocConsumer<SecurityBloc, SecurityState>(
        listener: (context, state) {
          if (state is SecurityPinVerified) {
            BlocProvider.of<SecurityBloc>(context).add(
              SecurityOtpSend(),
            );
            // showSuccessToast(state.data['message'], context);
            // Navigator.of(context).pushNamed( AqualifeRoutes.securityOtp);
          }

          if (state is SecurityOtpSent) {
            setProcessingStatus(false);
            setResetProcessingStatus(false);
            showSuccessToast(state.data['message'], context);

            Navigator.of(context).pushNamed(AqualifeRoutes.securityOtp,
                arguments: SecurityOtpParameters(otpData: state.data));
          }

          if (state is SecurityError) {
            setProcessingStatus(false);
            setResetProcessingStatus(false);
            enteredPin = '';
            showErrorToast(state.error, context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: colorWhite,
            body: Container(
              color: colorTransparent,
              height: height - (height * 0.37),
              // child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(
                        marginHorizontal, 50, marginHorizontal, 0),
                    // padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
                    height: height / 7,
                    child: Text(
                      'Original Passcode',
                      style: TextStyle(
                        fontFamily: fontFamilyMain,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: height / 9),
                    padding: EdgeInsets.fromLTRB(
                        marginHorizontal, 20, marginHorizontal, 0),
                    child: Text(
                      'Enter Original Passcode',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colorBlack,
                        fontFamily: fontFamilyMain,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(
                        marginHorizontal, 20, marginHorizontal, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        6,
                        (index) {
                          return Container(
                            // padding: EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10.0),
                            // width: isPinVisible ? 50 : 16,
                            // height: isPinVisible ? 50 : 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: colorGreyBox),
                              // borderRadius: BorderRadius.circular(6.0),
                              // color: index < enteredPin.length ? colorBlack : colorWhite,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(13),
                              margin: EdgeInsets.all(1),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                // border: Border.all(color: colorGreyBox),
                                // borderRadius: BorderRadius.circular(6.0),
                                color: index < enteredPin.length
                                    ? colorBlack
                                    : colorWhite,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    // padding: EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Forgot Passcode?',
                          style: TextStyle(
                            fontFamily: fontFamilyMain,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        AqualifeTextButton(
                          'Reset',
                          color:
                              isResetProcessing ? processing : secondaryColor,
                          fontSize: 13.0,
                          underline: true,
                          fontWeight: FontWeight.w600,
                          // fontStyle: FontStyle.italic,
                          onClick: () {
                            setResetProcessingStatus(true);

                            BlocProvider.of<SecurityBloc>(context)
                                .add(SecurityOtpSend());
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    // flex: 1,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                          marginHorizontal, 20, marginHorizontal, 0),
                      margin: EdgeInsets.only(bottom: 20),
                      child: AqualifeStyleButton(
                        title: 'Continue',
                        iconLeading: false,
                        icon: Icons.arrow_forward,
                        onPressed: isProcessing
                            ? () {}
                            : () {
                                _validateAndSend();
                              },
                        backgroundColor:
                            isProcessing ? colorLightGray : mainColor,
                        textColor: isProcessing ? colorDarkGray : colorWhite,
                      ),
                    ),
                  ),
                ],
              ),
              // ),
              // ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                for (var i = 0; i < 3; i++)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    color: colorGreyBox,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        3,
                        (index) => numButton(1 + 3 * i + index),
                      ).toList(),
                    ),
                  ),

                /// 0 digit with back remove
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: colorGreyBox,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // TextButton(onPressed: null, child: SizedBox()),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                        ),
                      ),
                      numButton(0),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 3),
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          child: TextButton(
                            onPressed: () {
                              setState(
                                () {
                                  if (enteredPin.isNotEmpty) {
                                    enteredPin = enteredPin.substring(
                                        0, enteredPin.length - 1);
                                  }
                                },
                              );
                            },
                            // style: TextButton.styleFrom(
                            //   backgroundColor: colorWhite,
                            // ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Icon(
                                Icons.backspace,
                                color: Colors.black,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _validateAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    if (enteredPin.isEmpty) {
      setProcessingStatus(false);
      showErrorToast('Passcode are required!', context);
    } else if (enteredPin.length < 6) {
      setProcessingStatus(false);
      showErrorToast('Passcode must be 6 digit', context);
    } else {
      setProcessingStatus(true);
      // Storage().securityPin = enteredPin;
      // widget.changeView(changeType: ViewChangeType.Forward);
      BlocProvider.of<SecurityBloc>(context).add(
        SecurityPinVerify(
          pin: enteredPin,
        ),
      );
    }
  }
}
