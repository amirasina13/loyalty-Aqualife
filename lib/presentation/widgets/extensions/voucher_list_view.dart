import 'package:intl/intl.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on Voucher {
  Widget getVoucherListTile({
    required BuildContext context,
    required VoidCallback onTap,
    // required bool past,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var formatter = DateFormat(appDateFormat);
    var dateExpired = formatter.format(DateTime.parse(expired!));

    return Column(
      children: [
        Container(
          height: height / 7.5,
          margin:
              EdgeInsets.symmetric(vertical: 5, horizontal: marginHorizontal),
          decoration: BoxDecoration(
            color: colorBackground,
            border: Border.all(
              color: colorLightGray,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.black.withOpacity(0.2),
            //     offset: Offset(0, 2),
            //     blurRadius: 5,
            //   ),
            // ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 1 / 1,
                    child: Container(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                        child: CachedImage(
                          imageUrl: image!,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  // padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: colorTransparent,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // height: height * 0.03,
                        // padding: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.topLeft,
                        // color: AppColors.deepYellow,
                        child: Text(
                          name!,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w600,
                            color: colorBlack,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        // height: height * 0.062,
                        padding: EdgeInsets.symmetric(vertical: 5),
                        alignment: Alignment.topLeft,
                        color: colorTransparent,
                        child: Text(
                          desc!,
                          style: TextStyle(
                              fontSize: 11,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                              color: colorTextGrey),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          // height: height * 0.062,
                          padding: EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.bottomLeft,
                          color: colorTransparent,
                          child: Text(
                            dateExpired,
                            style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: colorTextGrey),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: width * 0.18,
                padding: EdgeInsets.only(right: 10),
                // color: colorBabyBlue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'x$quantity',
                      // textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: AqualifeStyleButton(
                        height: width * 0.08,
                        title: 'Use',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        textColor: colorWhite,
                        onPressed: onTap,
                        // () {
                        //   Navigator.of(context).pushNamed(
                        //        AqualifeRoutes.voucherDesc,
                        //       arguments: VoucherDescParameters(
                        //           voucherId: voucher.voucherId!,
                        //           title: voucher.name!));
                        // },
                        backgroundColor: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
