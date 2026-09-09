import 'dart:convert';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../config/global_setup.dart';
import '../../../widgets/independent/independent.dart';
import '../../refer/refer.dart';

class ReferView extends StatefulWidget {
  final Function? changeView;

  const ReferView({super.key, this.changeView});

  @override
  State<ReferView> createState() => _ReferViewState();
}

class _ReferViewState extends State<ReferView> {
  final GlobalKey<AqualifeInputFieldState> codeKey = GlobalKey();
  final TextEditingController codeController = TextEditingController();
  late FocusNode codeFocus;

  String selectedCode = '60';
  String errorfield = '';

  bool isProcessing = false;
  bool error = false;

  void setProcessingStatus(bool processing) {
    setState(() {
      isProcessing = processing;
    });
  }

  @override
  void initState() {
    super.initState();

    codeFocus = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocConsumer<ReferBloc, ReferState>(
      listener: (context, state) {},
      builder: (context, state) {
        // var image = Image.asset('assets/image/refer-friends.png');

        var textMessage = '', code = '', link = '';

        if (state is ReferLoaded) {
          var refer = state.userRefer;
          textMessage = refer.text!;
          code = refer.code!;
          link = refer.link!;

          String qrcode = refer.qr!;
          String barcode = refer.barcode!;

          return Container(
            height: height,
            color: colorWhite,
            margin: EdgeInsets.symmetric(
                horizontal: marginHorizontal, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  color: colorTransparent,
                  alignment: Alignment.center,
                  height: height / 14,
                  width: width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.camera_alt,
                          color: colorValidGray,
                        ),
                      ),
                      Text(
                        scanning == 'qr' ? 'Scan QR Code' : 'Scan Barcode',
                        style: TextStyle(
                          fontSize: 18,
                          color: colorBlack,
                          fontFamily: fontFamilyMain,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ],
                  ),
                ),
                qrcode != ''
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        // height: height / 2.8,
                        // width: height / 2.8,
                        child: Image(
                          height: height / 3.3,
                          width: height / 3.3,
                          image: Image.memory(base64.decode(qrcode.replaceAll(
                                  RegExp(r'^data:image\/[a-z]+;base64,'), '')))
                              .image,
                          fit: BoxFit.contain,
                        ),
                      )
                    : SizedBox(),
                barcode != ''
                    ? Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(5),
                        // height: height / 2.8,
                        // width: height / 2.8,
                        child: Image(
                          height: height / 3.3,
                          width: height / 3.3,
                          image: Image.memory(base64.decode(barcode.replaceAll(
                                  RegExp(r'^data:image\/[a-z]+;base64,'), '')))
                              .image,
                          fit: BoxFit.contain,
                        ),
                      )
                    : SizedBox(),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Share this link with your friends and have them sign up using this code. They\'ll be first in line to unlock delicious rewards!',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorDarkGray,
                      fontFamily: fontFamilyMain,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                    textScaler: TextScaler.linear(scaleFactor),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(top: 20, bottom: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: colorGreyBox),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20),
                          child: Text(
                            code,
                            style: TextStyle(
                              fontSize: 15,
                              color: colorReferGrey,
                              fontFamily: fontFamilyMain,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                        ),
                        AqualifeStyleButton(
                          title: 'SHARE CODE',
                          fontSize: 15,
                          height: height / 16,
                          fontWeight: FontWeight.w700,
                          textColor: colorWhite,
                          backgroundColor: secondaryColor,
                          borderColor: colorTransparent,
                          onPressed: () {
                            // _onShare method: FOR IPAD
                            final box =
                                context.findRenderObject() as RenderBox?;
                            Share.share(
                              '$textMessage\n\n$link',
                              sharePositionOrigin:
                                  box!.localToGlobal(Offset.zero) & box.size,
                            );
                          },
                        ),
                      ],
                    )),
              ],
            ),
          );
        }

        return LoadingWidget();
      },
    );
  }
}
