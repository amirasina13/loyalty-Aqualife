import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/model/model.dart';

/* Extension class for subscription transaction list. Will use in extensions/subs_history_view.dart  */
extension View on SubsTransaction {
  Widget getSubsTransactionTile({
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
                  width: width * 0.46,
                  height: height * 0.06,
                  color: colorTransparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          color: colorTransparent,
                          // height: height * 0.03,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '$merchantName - $outletPlace',
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: fontFamilyMain,
                              color: colorBlack,
                              fontWeight: FontWeight.w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                            textScaler: TextScaler.linear(scaleFactor),
                          ),
                        ),
                      ),
                      Text(
                        '$dateFormat   $timeFormat',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: fontFamilyMain,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: width * 0.25,
                  height: height * 0.06,
                  color: colorTransparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '$subName',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorBlack,
                            fontWeight: FontWeight.w600,
                            overflow: TextOverflow.ellipsis,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      Text(
                        '',
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: fontFamilyMain,
                          color: Colors.black45,
                          fontWeight: FontWeight.w500,
                        ),
                        textScaler: TextScaler.linear(scaleFactor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
