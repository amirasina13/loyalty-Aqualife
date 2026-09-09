import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../config/routes.dart';

import '../../../widgets/independent/independent.dart';
import '../delete_acc.dart';

class ReasonView extends StatefulWidget {
  final Function changeView;

  const ReasonView({super.key, required this.changeView});

  @override
  State<ReasonView> createState() => _ReasonViewState();
}

class _ReasonViewState extends State<ReasonView> {
  String errorfield = '';
  bool isProcessing = false;
  String _result = '';
  late FocusNode validateFocus;
  final TextEditingController otherTextController = TextEditingController();
  final GlobalKey<AqualifeInputFieldState> otherTextKey = GlobalKey();

  List reasonDelete = [
    'No longer using the service/ platform',
    'Privacy concerns',
    'Difficulty navigating the platform',
    'Account security concerns',
    'Personal reasons',
    'Others',
  ];

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    validateFocus = FocusNode();
  }

  @override
  void dispose() {
    otherTextController.dispose();

    // Clean up the focus node when the Form is disposed.
    validateFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    // var sizeBetween = height / 20;

    return Theme(
      data: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: errorfield == '' ? colorDarkGray : colorRed,
        ),
      ),
      child: Scaffold(
        backgroundColor: colorBackground,
        body: BlocConsumer<DeleteAccBloc, DeleteAccState>(
          listener: (context, state) {
            if (state is AccReasonDeleted) {
              setProcessingStatus(false);
              Navigator.of(context).pushNamed(AqualifeRoutes.deleteMobbile);
            }
            // on failure show a snackbar
            if (state is DeleteAccError) {
              setProcessingStatus(false);
              // ErrorDialog.showErrorDialog(context, state.error);
              showErrorToast(state.error, context);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                height: height * 0.78,
                color: colorWhite,
                margin: EdgeInsets.symmetric(
                    horizontal: marginHorizontal, vertical: 10),
                // padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Reason to delete this account?',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          fontFamily: fontFamilyMain,
                          color: colorCountGrey,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          // _result = 'No longer using the service/ platform';
                          _result = reasonDelete[0];
                        });
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        title: Text(
                          reasonDelete[0],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                        leading: Container(
                          width: 22,
                          alignment: Alignment.centerLeft,
                          child: Radio<String>(
                            value: reasonDelete[0],
                            activeColor: mainColor,
                            groupValue: _result,
                            onChanged: (value) {
                              setState(() {
                                _result = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _result = reasonDelete[1];
                        });
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        title: Text(
                          reasonDelete[1],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                        leading: Container(
                          width: 22,
                          alignment: Alignment.centerLeft,
                          child: Radio<String>(
                            value: reasonDelete[1],
                            activeColor: mainColor,
                            groupValue: _result,
                            onChanged: (value) {
                              setState(() {
                                _result = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _result = reasonDelete[2];
                        });
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        title: Text(
                          reasonDelete[2],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                        leading: Container(
                          width: 22,
                          alignment: Alignment.centerLeft,
                          child: Radio<String>(
                            value: reasonDelete[2],
                            activeColor: mainColor,
                            groupValue: _result,
                            onChanged: (value) {
                              setState(() {
                                _result = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _result = reasonDelete[3];
                        });
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        title: Text(
                          reasonDelete[3],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                        leading: Container(
                          width: 22,
                          alignment: Alignment.centerLeft,
                          child: Radio<String>(
                            value: reasonDelete[3],
                            activeColor: mainColor,
                            groupValue: _result,
                            onChanged: (value) {
                              setState(() {
                                _result = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _result = reasonDelete[4];
                        });
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        title: Text(
                          reasonDelete[4],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                        leading: Container(
                          width: 22,
                          alignment: Alignment.centerLeft,
                          child: Radio<String>(
                            value: reasonDelete[4],
                            activeColor: mainColor,
                            groupValue: _result,
                            onChanged: (value) {
                              setState(() {
                                _result = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _result = reasonDelete[5];
                        });
                      },
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        horizontalTitleGap: -5,
                        title: Text(
                          reasonDelete[5],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                        leading: Container(
                          width: 22,
                          alignment: Alignment.centerLeft,
                          child: Radio<String>(
                            value: reasonDelete[5],
                            activeColor: mainColor,
                            groupValue: _result,
                            onChanged: (value) {
                              setState(() {
                                _result = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      horizontalTitleGap: -5,
                      title: Container(
                        height: height * 0.08,
                        color: colorBackground,
                        child: TextField(
                          key: otherTextKey,
                          controller: otherTextController,
                          // maxLines: null,
                          // expands: true,
                          readOnly: _result == reasonDelete[5] ? false : true,
                          // keyboardType: TextInputType.multiline,
                          textAlignVertical: TextAlignVertical.top,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: fontFamilyMain,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Reason',
                            hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFC4C4C4),
                              fontFamily: fontFamilyMain,
                            ),
                            // contentPadding: EdgeInsets.all(8),
                            // enabledBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Color(0xFFC4C4C4),
                            //     width: 1.0,
                            //   ),
                            // ),
                            // focusedBorder: OutlineInputBorder(
                            //   borderSide: BorderSide(
                            //     color: Color(0xFFC4C4C4),
                            //     width: 1.0,
                            //   ),
                            // ),
                          ),
                        ),
                      ),
                      leading: Container(
                        width: 22,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    // Expanded(
                    //   child: Container(
                    //     alignment: Alignment.bottomCenter,
                    //     child:  AqualifeStyleButton(
                    //       title: 'Continue',
                    //       height: height / 14,
                    //       iconLeading: false,
                    //       icon: Icons.arrow_forward,
                    //       backgroundColor:
                    //           isProcessing ? colorLightGray : mainColor,
                    //       textColor: isProcessing ? colorDarkGray : colorWhite,
                    //       onPressed: isProcessing ? () {} : _validateAndSend,
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
          child: AqualifeStyleButton(
            title: 'Continue',
            height: height / 14,
            iconLeading: false,
            icon: Icons.arrow_forward,
            backgroundColor: isProcessing ? colorLightGray : mainColor,
            textColor: isProcessing ? colorDarkGray : colorWhite,
            onPressed: isProcessing ? () {} : _validateAndSend,
          ),
        ),
      ),
    );
  }

  void _validateAndSend() {
    fToast = FToast();
    fToast.init(context);

    if (_result.isEmpty) {
      setProcessingStatus(false);
      // validateFocus.requestFocus();
      // ErrorIconDialog.showErrorDialog(context, 'Please select your reason');
      showErrorToast('Please select your reason', context);
    } else if (_result == 'Others' && otherTextController.text.isEmpty) {
      setProcessingStatus(false);
      validateFocus.requestFocus();
      // ErrorIconDialog.showErrorDialog(context, 'Please share us your reason');
      showErrorToast('Please share us your reason', context);
    } else {
      setProcessingStatus(true);
      BlocProvider.of<DeleteAccBloc>(context).add(
        DeleteAccReason(
          reason: _result == 'Others' ? otherTextController.text : _result,
        ),
      );
    }
  }
}
