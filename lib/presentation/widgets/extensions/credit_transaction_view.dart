import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../config/global_setup.dart';
import '../../../data/model/model.dart';

// Extension class for credit transaction list. Will use in extensions/credit_history_view.dart
extension View on CreditTransaction {
  Widget getCreditTransactionTile({
    required BuildContext context,
    // required VoidCallback onTap,,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var dateFormat =
        DateFormat(appDateFormat).format(DateTime.parse('$date $time'));
    var timeFormat =
        DateFormat(appTimeFormat).format(DateTime.parse('$date $time'));

    return Container(
      height: height / 12,
      color: colorTransparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: width * 0.08,
                  color: colorBackground,
                  child: Image(
                    image: AssetImage(type == 'debit'
                        ? 'assets/icons/settings/txn-in.png'
                        : 'assets/icons/settings/txn-out.png'),
                  ),
                ),
                Container(
                  width: width * 0.45,
                  height: height * 0.06,
                  color: colorTransparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        color: colorTransparent,
                        height: height * 0.03,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '$method',
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: fontFamilyMain,
                            color: colorBlack,
                            fontWeight: FontWeight.bold,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      Text(
                        '$dateFormat   $timeFormat',
                        // timeformat,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: fontFamilyMain,
                          color: colorBlack,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.35,
                  height: height * 0.06,
                  color: colorTransparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        color: colorTransparent,
                        height: height * 0.03,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            type == 'debit'
                                ? Text(
                                    '+ ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: thirdColor,
                                      fontFamily: fontFamilyInter,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  )
                                : Text(
                                    '- ',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colorRed,
                                      fontFamily: fontFamilyInter,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textScaler: TextScaler.linear(scaleFactor),
                                  ),
                            Text(
                              creditLabelAlign == 'left'
                                  ? '$creditLabelText $amount '
                                  : '$amount $creditLabelText ',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: fontFamilyInter,
                                color: type == 'debit' ? thirdColor : colorRed,
                                fontWeight: FontWeight.w700,
                              ),
                              textScaler: TextScaler.linear(scaleFactor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Container(
                //   color: colorTransparent,
                //   height: height * 0.03,
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     // crossAxisAlignment: CrossAxisAlignment.center,
                //     children: [
                //       type == 'debit'
                //           ? Text(
                //               '+ ',
                //               style: TextStyle(
                //                 fontSize: 13,
                //                 color: thirdColor,
                //                 fontFamily: fontFamilyInter,
                //                 fontWeight: FontWeight.w700,
                //               ),
                //              textScaler: TextScaler.linear(scaleFactor),
                //             )
                //           : Text(
                //               '- ',
                //               style: TextStyle(
                //                 fontSize: 13,
                //                 color: colorRed,
                //                 fontFamily: fontFamilyInter,
                //                 fontWeight: FontWeight.w700,
                //               ),
                //              textScaler: TextScaler.linear(scaleFactor),
                //             ),
                //       Text(
                //         creditLabelAlign == 'left'
                //             ? '$creditLabelText $amount '
                //             : '$amount $creditLabelText ',
                //         style: TextStyle(
                //           fontSize: 13,
                //           fontFamily: fontFamilyInter,
                //           color: type == 'debit' ? thirdColor : colorRed,
                //           fontWeight: FontWeight.w700,
                //         ),
                //        textScaler: TextScaler.linear(scaleFactor),
                //       ),
                //     ],
                //   ),
                // ),
                // Container(
                //   width: width * 0.35,
                //   height: height * 0.06,
                //   alignment: Alignment.centerRight,
                //   color: colorTransparent,
                //   child: Text(
                //     type == 'debit'
                //         ? creditLabelAlign == 'left'
                //             ? '+ $creditLabelText$amount '
                //             : '+ $amount$creditLabelText '
                //         : creditLabelAlign == 'left'
                //             ? '- $creditLabelText$amount '
                //             : '- $amount$creditLabelText ',
                //     style: TextStyle(
                //       fontSize: 14,
                //       color: type == 'debit' ? thirdColor : colorRed,
                //       fontWeight: FontWeight.bold,
                //     ),
                //    textScaler: TextScaler.linear(scaleFactor),
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
