import 'package:intl/intl.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on VoucherPast {
  Widget getVoucherPastTile({
    required BuildContext context,
    required VoidCallback onTap,
    required bool past,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var formatter = DateFormat(appDateFormat);
    var dateExpired = formatter.format(DateTime.parse(expiredAt!));

    return Column(
      children: [
        Container(
          height: height / 7.5,
          margin: EdgeInsets.symmetric(vertical: 7),
          // padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: isExpired!
                ? colorBlack.withValues(alpha: 0.05)
                : colorBackground,
            border: Border.all(
              color: colorLightGray,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
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
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      isExpired!
                          ? Expanded(
                              child: Container(
                                // height: height * 0.062,
                                padding: EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.bottomLeft,
                                color: colorTransparent,
                                child: Text(
                                  isExpired! ? 'Expired at: $dateExpired' : '',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.w500,
                                      color: colorTextGrey),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
              ),
              isExpired!
                  ? Container(
                      margin: EdgeInsets.only(top: 10, right: 10),
                      child: AqualifeStyleButton(
                        height: width * 0.08,
                        title: 'Expired',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Inter',
                        textColor: colorTextGrey,
                        onPressed: () {},
                        borderColor: colorTransparent,
                        backgroundColor: isExpired!
                            ? colorBlack.withValues(alpha: 0.1)
                            : secondaryColor,
                      ),
                    )
                  : rating != 0 && comment!.isNotEmpty
                      ? Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          child: AqualifeStyleButton(
                            height: width * 0.08,
                            title: 'Rated',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            textColor: colorCountGrey,
                            onPressed: () {},
                            // borderColor: colorTransparent,
                            backgroundColor: colorBackground,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 10, right: 10),
                          child: AqualifeStyleButton(
                            height: width * 0.08,
                            title: 'Rate',
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Inter',
                            textColor: colorWhite,
                            onPressed: onTap,
                            borderColor: colorTransparent,
                            backgroundColor: secondaryColor,
                          ),
                        ),
              // Container(
              //   width: width * 0.18,
              //   padding: EdgeInsets.symmetric(horizontal: 10),
              //   // color: colorBabyBlue,
              //   alignment: Alignment.centerRight,
              //   child: Container(
              //     // margin: EdgeInsets.only(top: 15),
              //     child: Text(
              //       isUsed!
              //           ? 'Used'
              //           : isExpired!
              //               ? 'Expired'
              //               : '',
              //       style: TextStyle(
              //         fontSize: 13,
              //         fontFamily: 'Inter',
              //         fontWeight: FontWeight.w700,
              //         color: colorSocialGrey,
              //       ),
              //       // overflow: TextOverflow.ellipsis,
              //       // textAlign: TextAlign.right,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
