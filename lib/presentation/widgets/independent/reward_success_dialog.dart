import '../../../../config/config.dart';
import 'package:flutter/material.dart';

// import 'cache_network_image.dart';

/* Widget class for promotional reward success dialog. Will use in scanner_page.dart and view/voucher_manual.dart.  */

// Content of promotional reward success dialog. Can change design here
class RewardSuccessDialog extends StatelessWidget {
  // final String mainText;
  final Map data;
  final VoidCallback onTap;

  const RewardSuccessDialog({
    super.key,
    // required this.mainText,
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return Container(
      // color: colorBackground,
      alignment: Alignment.center,
      // height: height * 0.4,
      padding: EdgeInsets.symmetric(horizontal: marginHorizontal),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Show image icon on top
          Container(
            // height: height / 2.5,
            // color: colorYellowCard,
            // margin: EdgeInsets.only(top: 20),
            child: Image(
              image: AssetImage('assets/image/ribbon.png'),
              fit: BoxFit.fill,
            ),
          ),
          // Show title
          // Storage().page == 'voucher'
          //     ?
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              // Storage().page == 'voucher' ? 'Congratulations!' : ' Success!',
              'Congratulations!',
              style: TextStyle(
                color: colorPink,
                fontFamily: fontFamilySuez,
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
            ),
          ),
          // : Container(),
          Container(
            alignment: Alignment.topCenter,
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Text(
              '${data['message']} \n\n ${data['data']['message']}',
              // Storage().page == 'voucher'
              //     ? '${data['message']} \n\n ${data['data']['message']}'
              //     : '${data['message']}',
              // ?${data['message']}
              // : '${data['message']} \n\n ${data['data']['message']}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: colorTextGrey,
                fontFamily: fontFamilyInter,
              ),
              textAlign: TextAlign.center,
              textScaler: TextScaler.linear(scaleFactor),
            ),
          ),
          // // Show main text that you passed here
          // Storage().page == 'voucher'
          // ?
          // Expanded(
          //   flex: 3,
          //   child: Container(
          //     alignment: Alignment.topCenter,
          //     padding: EdgeInsets.symmetric(horizontal: 20),
          //     child: Text(
          //       '${data['message']} \n\n ${data['data']['message']}',
          //       // ?${data['message']}
          //       // : '${data['message']} \n\n ${data['data']['message']}',
          //       style: TextStyle(
          //         fontSize: 16,
          //         fontWeight: FontWeight.w400,
          //         color: colorTextGrey,
          //         fontFamily: fontFamilyInter,
          //       ),
          //       textAlign: TextAlign.center,
          //        textScaler: TextScaler.linear(scaleFactor),
          //     ),
          //   ),
          // ),
          //     : Expanded(
          //         child:
          // Storage().page == 'voucher'
          //     ? Container()
          //     :
          // Container(
          //   height: height / 7,
          //   // margin: EdgeInsets.symmetric(vertical: 20),
          //   // padding: EdgeInsets.all(10),
          //   decoration: BoxDecoration(
          //     border: Border.all(
          //       color: colorLightGray,
          //     ),
          //     borderRadius: BorderRadius.all(
          //       Radius.circular(5),
          //     ),
          //   ),
          //   child: Row(
          //     children: [
          //       AspectRatio(
          //         aspectRatio: 1 / 1,
          //         child: Container(
          //           // margin: EdgeInsets.all(5),
          //           // height: width * 0.2,
          //           // width: width * 0.2,
          //           // color: colorBabyBlue,
          //           // decoration: BoxDecoration(
          //           //     image: DecorationImage(
          //           //   fit: BoxFit.cover,
          //           // ),)
          //           child: CachedImage(
          //             imageUrl: data['data']['voucher']['image'],
          //             colorFilter: ColorFilter.mode(
          //               colorUsedGray,
          //               BlendMode.color,
          //             ),
          //           ),
          //         ),
          //       ),
          //       Flexible(
          //         child: Container(
          //           margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
          //           // padding: EdgeInsets.symmetric(vertical: 5),
          //           // decoration: BoxDecoration(
          //           //   color: colorTransparent,
          //           //   borderRadius: BorderRadius.only(
          //           //     topRight: Radius.circular(20),
          //           //     bottomRight: Radius.circular(20),
          //           //   ),
          //           // ),
          //           child: Column(
          //             mainAxisAlignment: MainAxisAlignment.center,
          //             // crossAxisAlignment: CrossAxisAlignment.start,
          //             children: [
          //               Container(
          //                 // height: height * 0.03,
          //                 padding: EdgeInsets.only(top: 5),
          //                 alignment: Alignment.topLeft,
          //                 // color: AppColors.deepYellow,
          //                 child: Text(
          //                   data['data']['voucher']['name'],
          //                   style: TextStyle(
          //                     fontSize: 12,
          //                     fontFamily: 'Inter',
          //                     fontWeight: FontWeight.w600,
          //                     color: colorBlack,
          //                   ),
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //               Container(
          //                 // height: height * 0.062,
          //                 padding: EdgeInsets.symmetric(vertical: 5),
          //                 alignment: Alignment.topLeft,
          //                 color: colorTransparent,
          //                 child: Text(
          //                   data['data']['voucher']['desc'],
          //                   style: TextStyle(
          //                     fontSize: 10,
          //                     fontFamily: 'Inter',
          //                     fontWeight: FontWeight.w500,
          //                     color: colorTextGrey,
          //                   ),
          //                   maxLines: 3,
          //                   overflow: TextOverflow.ellipsis,
          //                 ),
          //               ),
          //               Expanded(
          //                 child: Container(
          //                   alignment: Alignment.bottomLeft,
          //                   child: Column(
          //                     mainAxisAlignment: MainAxisAlignment.end,
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     children: [
          //                       Text(
          //                         'Redeem at: ${data['data']['voucher']['redeemAt']}',
          //                         style: TextStyle(
          //                           fontSize: 10,
          //                           fontFamily: 'Inter',
          //                           fontWeight: FontWeight.w500,
          //                           color: colorTextGrey,
          //                         ),
          //                       ),
          //                       Text(
          //                         '${data['data']['voucher']['notes']}',
          //                         style: TextStyle(
          //                           fontSize: 10,
          //                           fontFamily: 'Inter',
          //                           fontWeight: FontWeight.w500,
          //                           color: colorTextGrey,
          //                         ),
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          //       ),
          // button to close the dialog
          Expanded(
            child: Container(
              alignment: Alignment.bottomCenter,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  // width: width * 0.6,
                  height: height * 0.07,
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: 70),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Text(
                    'CONTINUE',
                    style: TextStyle(
                      color: colorWhite,
                      fontSize: 16,
                      fontFamily: fontFamilyInter,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Call this future with text and context. Then will pass to AlertDialog
  static Future showRewardSuccessDialog(
      BuildContext context, Map data, VoidCallback onTap) {
    //String text,
    return showGeneralDialog(
      context: context,
      barrierColor: Colors.black38,
      barrierLabel: 'Label',
      barrierDismissible: true,
      pageBuilder: (_, __, ___) => Center(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            // color: colorWhite,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: const [
                  Color(0xFFD4FFDB),
                  Color(0xFFF0FEF2),
                  Color(0xFFFFFFFF),
                ],
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                // end: Alignment(0.8, 1),
                // stops: const [0.0, 0.9],
                tileMode: TileMode.clamp,
              ),
            ),
            child: RewardSuccessDialog(
              // mainText: text,
              data: data,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
    // return showDialog(
    //   context: context,
    //   builder: (context) {
    //     return Container(
    //       color: colorBackground,
    //       height: MediaQuery.of(context).size.height,
    //       width: MediaQuery.of(context).size.width,
    //       child: RewardSuccessDialog(
    //         mainText: text,
    //         onTap: onTap,
    //       ),
    //     );
    //     // return AlertDialog(
    //     //   contentPadding: EdgeInsets.all(10.0),
    //     //   backgroundColor: colorWhite,
    //     //   shape: RoundedRectangleBorder(
    //     //     borderRadius: BorderRadius.all(
    //     //       Radius.circular(20),
    //     //     ),
    //     //   ),
    //     //   content: RewardSuccessDialog(
    //     //     mainText: text,
    //     //     onTap: onTap,
    //     //   ),
    //     // );
    //   },
    // );
  }
}
