import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../config/routes.dart';
import '../../../widgets/independent/independent.dart';
import '../security_pin.dart';

class SecurityCreateView extends StatefulWidget {
  final Function changeView;
  final int? voucherId;
  final String? title;

  const SecurityCreateView({
    super.key,
    required this.changeView,
    this.voucherId,
    this.title,
  });

  @override
  State<SecurityCreateView> createState() => _SecurityCreateViewState();
}

class _SecurityCreateViewState extends State<SecurityCreateView> {
  bool isProcessing = false;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return BlocConsumer<SecurityBloc, SecurityState>(
      listener: (context, securityState) {
        if (securityState is SecurityOtpSent) {
          setProcessingStatus(false);

          showSuccessToast(securityState.data['message'], context);
          Navigator.of(context).pushNamed(AqualifeRoutes.securityOtp,
              arguments: SecurityOtpParameters(otpData: securityState.data));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: colorWhite,
          body: SingleChildScrollView(
            child: Container(
              color: colorBackground,
              height: height -
                  kToolbarHeight - // top AppBar height
                  MediaQuery.of(context).padding.top - // top padding
                  kBottomNavigationBarHeight, // BottomNavigationBar height
              margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: height * 0.18,
                    margin: EdgeInsets.symmetric(vertical: 50),
                    child: Image(
                      image: AssetImage('assets/icons/security/passcode.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
                    child: Text(
                      'Generate a passcode for your end-to-end encrypted payment.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: colorBlack,
                        fontFamily: fontFamilyInter,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'This passcode helps us validate your transaction securely',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: colorTextGrey,
                        fontFamily: fontFamilyInter,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: AqualifeStyleButton(
                        title: 'Next',
                        textColor: isProcessing ? processingText : colorWhite,
                        backgroundColor: isProcessing ? processing : mainColor,
                        onPressed: () {
                          setProcessingStatus(true);

                          BlocProvider.of<SecurityBloc>(context)
                              .add(SecurityOtpSend());
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
