import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on RewardFavourite {
  Widget getRewardFavouriteListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onTapFavourite,
    // required bool past,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Slidable(
        key: Key(id.toString()),
        endActionPane: ActionPane(
          motion: ScrollMotion(),
          extentRatio: 0.2,
          children: [
            InkWell(
              onTap: onTapFavourite,
              child: Container(
                height: height,
                width: width * 0.2,
                color: colorBlack.withValues(alpha: 0.1),
                alignment: Alignment.center,
                child: Image(
                  height: height * 0.023,
                  image: AssetImage('assets/icons/bin.png'),
                ),
              ),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              height: height / 8,
              margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
              child: Row(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5),
                            ),
                            child: CachedImage(
                              imageUrl: image!,
                              // colorFilter: ColorFilter.mode(
                              //   colorUsedGray,
                              //   BlendMode.color,
                              // ),
                            ),
                          ),
                        ),
                      ),
                      isMuslim == 1
                          ? Positioned(
                              right: 5,
                              top: 5,
                              child: HalalWidget(
                                  muslimCategory: muslimCategory!,
                                  width: width * 0.06))
                          : SizedBox(),
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
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   width: width * 0.18,
                  //   //   padding: EdgeInsets.symmetric(vertical: 5),
                  //   // color: colorBabyBlue,
                  //   child: InkWell(
                  //     highlightColor: colorWhite,
                  //     onTap: onTapFavourite,
                  //     child: Container(
                  //       // height: height * 0.07,
                  //       // width: width * 0.35,
                  //       padding: EdgeInsets.all(4),
                  //       // margin: EdgeInsets.all(10),
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: colorBackground,
                  //         border: Border.all(color: secondaryColor, width: 2),
                  //         boxShadow: const [
                  //           BoxShadow(
                  //             color: colorGreyBox,
                  //             blurRadius: 4.0,
                  //             spreadRadius: 2,
                  //             offset: Offset(0.0, 1.0),
                  //           ),
                  //         ],
                  //       ),
                  //       child: Container(
                  //         margin: EdgeInsets.all(2),
                  //         child: Icon(
                  //           Icons.favorite,
                  //           size: 30,
                  //           color: secondaryColor,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
