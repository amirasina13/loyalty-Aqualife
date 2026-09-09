// import '../../../../config/config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:otp_text_field/otp_field_style.dart';
// import 'package:otp_text_field/otp_field.dart';
// import 'package:otp_text_field/style.dart';

// import '../../../config/routes.dart';
// import '../../widgets/independent/independent.dart';
// import 'otp.dart';

// class OtpParameters {
//   final Map data;

//   const OtpParameters({required this.data});
// }

// class OtpScreen extends StatefulWidget {
//   final OtpParameters parameters;

//   const OtpScreen({Key? key, required this.parameters}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() {
//     return _OtpScreenState();
//   }
// }

// class _OtpScreenState extends State<OtpScreen> {
//   OtpFieldController otpController = OtpFieldController();

//   String otpCode = '', resendvToken = '', tokenVerify = '';
//   late double sizeBetween;
//   int secondsRemaining = 60;
//   bool error = false;
//   bool enableResend = true;
//   bool isProcessing = false;
//   // bool isChanging = false;

//   void setProcessingStatus(bool processing) {
//     setState(() {
//       isProcessing = processing;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     var width = MediaQuery.of(context).size.width;
//     sizeBetween = height / 20;

//     return Theme(
//       data: ThemeData(
//         textSelectionTheme: TextSelectionThemeData(
//           cursorColor: error == false ? colorDarkGray : colorRed,
//         ),
//       ),
//       child: GestureDetector(
//         onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
//         child: Scaffold(
//           backgroundColor: colorWhite,
//           // appBar: AppBar(
//           //   leading: Container(),
//           //   elevation: 0,
//           //   backgroundColor: colorTransparent,
//           //   title: Text(
//           //     'OTP Verification',
//           //     style: TextStyle(
//           //       color: colorBlack,
//           //       fontWeight: FontWeight.w400,
//           //       fontSize: 15,
//           //       fontFamily: fontFamilyMain,
//           //     ),
//           //     textScaleFactor: scaleFactor,
//           //   ),
//           //   centerTitle: true,
//           // ),
//           body: BlocConsumer<OtpBloc, OtpState>(
//             listener: (context, state) {
//               fToast = FToast();
//               fToast.init(context);

//               // // on success delete navigator stack and push to home
//               // if (state is OtpFinished) {
//               //   RegisterTimerDialog.showSuccessDialog(context);
//               // }
//               if (state is OtpRequestSuccess) {
//                 // isChanging = true;

//                 setProcessingStatus(false);
//                 // resendvToken = state.data['data']['vToken'];
//                 // tokenVerify = state.data['data']['token'];
//                 showSuccessToast(state.data['message'], context);

//                 Navigator.of(context).pushNamed(AqualifeRoutes.otpVerify,
//                     arguments: OtpVerifyParameters(data: state.data));
//               }
//               if (state is OtpResent) {
//                 setProcessingStatus(false);
//                 resendvToken = state.data['data']['vToken'];
//                 tokenVerify = state.data['data']['token'];
//                 showSuccessToast(state.data['message'], context);
//               }
//               if (state is OtpError) {
//                 // ignore: unnecessary_null_comparison
//                 state.error != null ? error = true : error = false;
//                 setProcessingStatus(false);
//                 otpController.clear();
//                 showErrorToast(state.error, context);
//               }
//             },
//             builder: (context, state) {
//               // show loading screen while processing
//               if (state is OtpProcessing) {
//                 // return Center(
//                 //   child: CircularProgressIndicator(color: colorDisableGrey,),
//                 // );
//               }
//               return SingleChildScrollView(
//                 child: Container(
//                   color: colorWhite,
//                   height: height,
//                   // padding: EdgeInsets.fromLTRB(16, 20, 16, 16),
//                   margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         alignment: Alignment.center,
//                         margin: EdgeInsets.only(top: 50, bottom: 20),
//                         padding: EdgeInsets.fromLTRB(20, 50, 20, 20),
//                         height: height / 7,
//                         child: Text(
//                           'OTP VERIFICATION',
//                           style: TextStyle(
//                             fontFamily: fontFamilyMain,
//                             fontSize: 32,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ),
//                       // SizedBox(height: sizeBetween * 2),
//                       // Text(
//                       //   'OTP Code',
//                       //   textAlign: TextAlign.center,
//                       //   style: TextStyle(
//                       //     fontSize: 16,
//                       //     fontWeight: FontWeight.bold,
//                       //     color: colorBlack,
//                       //     fontFamily: fontFamilyMain,
//                       //   ),
//                       //   textScaleFactor: scaleFactor,
//                       // ),
//                       // SizedBox(height: sizeBetween * 0.5),

//                       SizedBox(height: sizeBetween * 0.5),
//                       Container(
//                         color: colorTransparent,
//                         height: height / 15,
//                         child: OTPTextField(
//                           controller: otpController,
//                           length: 6,
//                           width: MediaQuery.of(context).size.width,
//                           fieldWidth: 45,
//                           style: TextStyle(fontSize: 16),
//                           textFieldAlignment: MainAxisAlignment.spaceAround,
//                           fieldStyle: FieldStyle.box,
//                           otpFieldStyle: OtpFieldStyle(
//                             focusBorderColor: colorDarkGray,
//                             disabledBorderColor: colorBlack,
//                           ),
//                           onChanged: (pin) {},
//                           onCompleted: (pin) {
//                             otpCode = pin;

//                             if (error) {
//                               pin = "";
//                             }
//                           },
//                         ),
//                       ),
//                       // isChanging == true
//                       //     ? Column(
//                       //         children: [
//                       //           Container(
//                       //             height: height / 6,
//                       //             width: width,
//                       //             margin: EdgeInsets.symmetric(vertical: 30),
//                       //             decoration: BoxDecoration(
//                       //               color: colorLightGray,
//                       //               borderRadius: BorderRadius.all(
//                       //                 Radius.circular(5),
//                       //               ),
//                       //               boxShadow: const [
//                       //                 BoxShadow(
//                       //                   color: Colors.black26,
//                       //                   blurRadius: 8.0,
//                       //                   offset: Offset(0.0, 5.0),
//                       //                 ),
//                       //               ],
//                       //             ),
//                       //             padding: EdgeInsets.all(15),
//                       //             child: RichText(
//                       //               text: TextSpan(
//                       //                 // Note: Styles for TextSpans must be explicitly defined.
//                       //                 // Child text spans will inherit styles from parent
//                       //                 style: const TextStyle(
//                       //                   fontSize: 12.0,
//                       //                   color: colorBlack,
//                       //                   fontFamily: fontFamilyMain,
//                       //                 ),
//                       //                 children: [
//                       //                   TextSpan(
//                       //                     text:
//                       //                         'Note: \n1. A verification code has been sent to ',
//                       //                   ),
//                       //                   TextSpan(
//                       //                     text: widget.parameters.data['data']
//                       //                         ['email'],
//                       //                     style: TextStyle(
//                       //                         fontWeight: FontWeight.bold),
//                       //                   ),
//                       //                   TextSpan(
//                       //                     text:
//                       //                         ' through email. \n\n2. If you did not receive the code, please check the spam filter or click on ',
//                       //                   ),
//                       //                   TextSpan(
//                       //                     text: 'Resend OTP ',
//                       //                     style: TextStyle(
//                       //                         fontWeight: FontWeight.bold),
//                       //                   ),
//                       //                   TextSpan(
//                       //                     text: 'below.',
//                       //                   ),
//                       //                 ],
//                       //               ),
//                       //             ),
//                       //           ),
//                       //           SizedBox(height: sizeBetween * 0.4),
//                       //           Container(
//                       //             height: height * 0.09,
//                       //             width: width,
//                       //             alignment: Alignment.center,
//                       //             margin: EdgeInsets.only(top: 5, bottom: 15),
//                       //             color: colorTransparent,
//                       //             child: enableResend == false
//                       //                 ? Countdown(
//                       //                     seconds: 60,
//                       //                     build: (_, double time) {
//                       //                       var duration =
//                       //                           Duration(seconds: time.toInt());
//                       //                       return Container(
//                       //                         alignment: Alignment.center,
//                       //                         // padding:
//                       //                         //     EdgeInsets.only(left: 16.0, top: 0.0),
//                       //                         child: Text(
//                       //                           // 'Remaining Time: ${duration.inMinutes}:${duration.inSeconds.remainder(60)}',
//                       //                           '${duration.inSeconds} seconds left before enabling resend',
//                       //                           style: TextStyle(
//                       //                             color: mainColor,
//                       //                             fontSize: 14,
//                       //                             fontFamily: fontFamilyMain,
//                       //                           ),
//                       //                           textScaleFactor: scaleFactor,
//                       //                         ),
//                       //                       );
//                       //                     },
//                       //                     onFinished: () {},
//                       //                   )
//                       //                 : AqualifeTextButton(
//                       //                     'Resend OTP',
//                       //                     fontSize: 16,
//                       //                     fontWeight: FontWeight.w600,
//                       //                     color: enableResend == true
//                       //                         ? colorLightBlue
//                       //                         : colorDarkGray,
//                       //                     onClick: enableResend == true
//                       //                         ? _resendOtp
//                       //                         : null,
//                       //                   ),
//                       //           ),
//                       //         ],
//                       //       )
//                       //     : Container(),
//                       // isChanging == true
//                       //     ? Expanded(
//                       //         child: Container(
//                       //             alignment: Alignment.bottomCenter,
//                       //             // margin: EdgeInsets.only(bottom: 20),
//                       //             child: Column(
//                       //               mainAxisAlignment: MainAxisAlignment.end,
//                       //               children: [
//                       //                 AqualifeStyleButton(
//                       //                   height: height / 14,
//                       //                   title: 'Continue',
//                       //                   iconLeading: false,
//                       //                   icon: Icons.arrow_forward,
//                       //                   backgroundColor: isProcessing
//                       //                       ? colorLightGray
//                       //                       : mainColor,
//                       //                   textColor: isProcessing
//                       //                       ? colorDarkGray
//                       //                       : colorWhite,
//                       //                   onPressed:
//                       //                       isProcessing ? () {} : _verifyOtp,
//                       //                 ),
//                       //                 InkWell(
//                       //                   onTap: () {
//                       //                     Navigator.pop(context);
//                       //                   },
//                       //                   child: Container(
//                       //                     margin: EdgeInsets.only(
//                       //                         top: 14, bottom: 15),
//                       //                     padding:
//                       //                         EdgeInsets.symmetric(vertical: 5),
//                       //                     // color: colorBabyBlue,
//                       //                     alignment: Alignment.center,
//                       //                     child: Text(
//                       //                       'Cancel',
//                       //                       style: TextStyle(
//                       //                         fontSize: 16,
//                       //                         color: colorBlack,
//                       //                         fontWeight: FontWeight.w400,
//                       //                         decoration:
//                       //                             TextDecoration.underline,
//                       //                       ),
//                       //                       textScaleFactor: scaleFactor,
//                       //                     ),
//                       //                   ),
//                       //                 ),
//                       //               ],
//                       //             )),
//                       //       )
//                       Expanded(
//                         child: Container(
//                           alignment: Alignment.topCenter,
//                           // margin: EdgeInsets.only(top: 30),
//                           child: Column(
//                             children: [
//                               Container(
//                                 // height: height / 6,
//                                 width: width,
//                                 margin: EdgeInsets.symmetric(vertical: 30),
//                                 decoration: BoxDecoration(
//                                   color: colorLightGray,
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(5),
//                                   ),
//                                   boxShadow: const [
//                                     BoxShadow(
//                                       color: Colors.black26,
//                                       blurRadius: 8.0,
//                                       offset: Offset(0.0, 5.0),
//                                     ),
//                                   ],
//                                 ),
//                                 padding: EdgeInsets.all(15),
//                                 child: RichText(
//                                   text: TextSpan(
//                                     // Note: Styles for TextSpans must be explicitly defined.
//                                     // Child text spans will inherit styles from parent
//                                     style: const TextStyle(
//                                       fontSize: 12.0,
//                                       color: colorBlack,
//                                       fontFamily: fontFamilyMain,
//                                     ),
//                                     children: [
//                                       TextSpan(
//                                         text: 'Click ',
//                                       ),
//                                       TextSpan(
//                                         text: 'Request OTP',
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       TextSpan(
//                                         text:
//                                             ' below to get an otp code that will be sent to your email ',
//                                       ),
//                                       TextSpan(
//                                         text: widget.parameters.data['data']
//                                             ['email'],
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                               AqualifeStyleButton(
//                                 height: height / 14,
//                                 title: 'Request OTP',
//                                 // iconLeading: false,
//                                 // icon: Icons.arrow_forward,
//                                 backgroundColor:
//                                     isProcessing ? colorLightGray : mainColor,
//                                 textColor:
//                                     isProcessing ? colorDarkGray : colorWhite,
//                                 onPressed: isProcessing ? () {} : _requestOtp,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   // void _resendOtp() {
//   //   // print('OTP VTOKEN RESEND: $resendvToken');
//   //   enableResend = false;
//   //   BlocProvider.of<OtpBloc>(context).add(OtpResend(
//   //     email: widget.parameters.data['data']['email'],
//   //     purpose: 'resend-register',
//   //     vToken: resendvToken,
//   //   ));
//   //   Timer(Duration(seconds: 60), () {
//   //     if (!mounted) return;
//   //     setState(() {
//   //       enableResend = true;
//   //     });
//   //   });
//   // }

//   // void _phoneConfirmPage() {
//   //   // BlocProvider.of<CountryBloc>(context).add(CountryLoad());
//   //   Navigator.of(context).pushNamedAndRemoveUntil(
//   //        AqualifeRoutes.otpCValid, (Route<dynamic> route) => false,
//   //       arguments: CValidOtpParameters(loginData: widget.loginData));
//   // }

//   // void _verifyOtp() {
//   //   setProcessingStatus(true);
//   //   BlocProvider.of<OtpBloc>(context)
//   //       .add(OtpVerify(otpCode: otpCode, token: tokenVerify));
//   // }

//   void _requestOtp() {
//     // print('OTP VTOKEN REQUEST: ${widget.parameters.data['data']['vToken']}');
//     setProcessingStatus(true);
//     // isChanging == true;
//     BlocProvider.of<OtpBloc>(context).add(OtpRequest(
//       email: widget.parameters.data['data']['email'],
//       purpose: 'register',
//       vToken: widget.parameters.data['data']['vToken'],
//     ));
//   }
// }
