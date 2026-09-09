import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/global_setup.dart';
import '../../../../config/storage.dart';
import '../../../widgets/independent/independent.dart';
import '../../security_pin/security_pin.dart';
import '../credits.dart';

class PointConversionView extends StatefulWidget {
  final Function? changeView;

  const PointConversionView({super.key, this.changeView});

  @override
  State<PointConversionView> createState() => _PointConversionViewState();
}

class _PointConversionViewState extends State<PointConversionView> {
  FocusNode focusNode = FocusNode();
  FocusNode pinNode = FocusNode();
  String errorfield = '';
  String inputValue = '0';
  double totalConvert = 0;
  double convertRate = 0;
  bool isProcessing = false;
  bool load = false;
  final TextEditingController pinController = TextEditingController();

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    focusNode.dispose();

    // _connectivity.disposeStream();

    super.dispose();
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
      child: Scaffold(
        backgroundColor: colorBackground,
        body: BlocListener<CreditBloc, CreditState>(
          listener: (context, state) {
            if (state is ConvertSuccess) {
              Navigator.pop(context);
              showSuccessToast(state.message, context);
            }

            if (state is CreditError) {
              setProcessingStatus(false);
              // Navigator.pop(context);
            }
          },
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      'Enter points',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: fontFamilyRedhat,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
                    child: Center(
                      child: TextField(
                        // controller: pointController,
                        decoration: InputDecoration(
                          hintText: '0',
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 64.0,
                          fontFamily: fontFamilyRedhat,
                          fontWeight: FontWeight.w500,
                          color: colorLocationGrey,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        autocorrect: false,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        // inputFormatters: [
                        //   DecimalTextInputFormatter(decimalRange: 2)
                        // ],
                        showCursor: false,
                        focusNode: focusNode,
                        enableInteractiveSelection: false,
                        onChanged: (value) {
                          convertRate = 1 / double.parse(pointConvertRate);

                          if (value.isEmpty || value == '') {
                            setState(() {
                              inputValue = '0';
                              totalConvert =
                                  double.parse(inputValue) * convertRate;
                            });
                          } else {
                            setState(() {
                              inputValue = value;
                              totalConvert =
                                  double.parse(inputValue) * convertRate;
                            });
                          }
                        },
                        // onEditingComplete: _submit,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          // height: height / 5,
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child: BlocListener<SecurityBloc, SecurityState>(
            listener: (context, securityState) {
              if (securityState is SecurityCheckVerified) {
                // securityPinDialog();
                // SecurityPinDialog.showSecurityPinDialog(
                //   context,
                //   () {
                //     pinController.text = '';
                //     Navigator.pop(context);
                //   },
                //   StatefulBuilder(
                //     builder: (BuildContext context, StateSetter setState) {
                //       return Stack(
                //         children: [
                //           Container(
                //             height: height / 18,
                //             clipBehavior: Clip.antiAlias,
                //             decoration: BoxDecoration(
                //               color: colorBackground,
                //               border: Border.all(color: colorPinGrey),
                //               borderRadius: BorderRadius.circular(8),
                //             ),
                //             child: Pinput(
                //               length: 6,
                //               controller: pinController,
                //               autofocus: true,
                //               focusNode: pinNode,
                //               separator: Container(
                //                 height: 64,
                //                 width: 1,
                //                 color: colorPinGrey,
                //               ),
                //               separatorPositions: const [1, 2, 3, 4, 5],
                //               defaultPinTheme: defaultPinTheme,
                //               showCursor: true,
                //               obscureText: true,
                //               onCompleted: (setPin) async {
                //                 pinController.text = setPin;

                //                 if (pinController.text != '') {
                //                   setState(() {
                //                     load = true;
                //                   });

                //                   _validateAndSend();
                //                 }
                //               },
                //             ),
                //           ),
                //           Align(
                //             alignment: FractionalOffset.center,
                //             child: load == true
                //                 ? Container(
                //                     color: Colors.grey[300]!.withOpacity(0.8),
                //                     width: 70.0,
                //                     height: 70.0,
                //                     child: Padding(
                //                       padding: const EdgeInsets.all(5.0),
                //                       child: Center(
                //                         child: CircularProgressIndicator(
                //                           color: colorDisableGrey,
                //                         ),
                //                       ),
                //                     ),
                //                   )
                //                 : Container(),
                //           ),
                //         ],
                //       );
                //     },
                //   ),
                // ).then((value) => pinController.text = '');
              }

              if (securityState is SecurityPinVerified) {
                _pointConvertAndSend();
              }

              if (securityState is SecurityError) {
                setProcessingStatus(false);
                showErrorToast(securityState.error, context);
              }
            },
            child: AqualifeStyleButton(
              height: height / 13,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: fontFamilyRedhat,
              title: isProcessing
                  ? 'Processing...'
                  : '$inputValue points = RM ${totalConvert.toStringAsFixed(2)}', //'$inputValue points = RM ${int.parse(inputValue) * 0.01}',
              backgroundColor: isProcessing ? colorLightGray : mainColor,
              textColor: isProcessing ? colorDarkGray : colorBlack,
              borderRadius: 0,
              onPressed: () {
                if (inputValue == '0') {
                  showErrorToast('Points cannot be 0!', context);
                } else {
                  BlocProvider.of<SecurityBloc>(context).add(SecurityStart());
                }
              }, // _validateAndSend,
            ),
          ),
        ),
      ),
    );
  }

  // // Security pin check API
  // void _validateAndSend() {
  //   if (!mounted) return;
  //   setState(() {
  //     fToast = FToast();
  //     fToast.init(context);
  //   });

  //   if (pinController.text == '') {
  //     showErrorToast('Security pin are required!', context);
  //   } else {
  //     setProcessingStatus(true);
  //     Future.delayed(Duration(seconds: 1), () {
  //       load = false;
  //       BlocProvider.of<SecurityBloc>(context).add(SecurityPinVerify(
  //         pin: pinController.text,
  //       ));

  //       Navigator.pop(context);
  //     });
  //   }
  // }

  // Security pin check API
  void _pointConvertAndSend() {
    if (!mounted) return;
    setState(() {
      fToast = FToast();
      fToast.init(context);
    });

    BlocProvider.of<CreditBloc>(context).add(PointConvertLoad(
      pin: Storage().securityPin,
      pointConvert: inputValue,
    ));
  }
}
