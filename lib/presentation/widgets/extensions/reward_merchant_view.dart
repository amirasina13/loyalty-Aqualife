import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../config/global_setup.dart';
import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher list(based on outlet). Will use in features/outlet/view/outlets_details.dart  */
extension View on RewardMerchant {
  Widget getRewardMerchantTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onFavouriteTap,
  }) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: !isSoldOut! ? onTap : () {},
      child: Column(
        children: [
          Container(
            height: height / 7,
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
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
                        Expanded(
                          child: Container(
                            // padding: EdgeInsets.symmetric(vertical: 5),
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              children: [
                                Text(
                                  purchaseText!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    // fontFamily: fontFamilyInter,
                                    fontWeight: FontWeight.w700,
                                    color:
                                        !isSoldOut! ? mainColor : colorUsedGray,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Text(
                                  double.parse(faceAmount!) > 0.00
                                      ? creditLabelAlign == 'left'
                                          ? '$creditLabelText $faceAmount'
                                          : '$faceAmount $creditLabelText'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontFamily: fontFamilyInter,
                                    fontWeight: FontWeight.w500,
                                    color: colorUsedGray,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // width: width * 0.15,
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  // color: colorBabyBlue,
                  child: InkWell(
                    onTap: onFavouriteTap,
                    child: Container(
                      child: isFavourite == false
                          ? Icon(
                              Icons.favorite_border,
                              size: 30,
                              color: colorCountGrey,
                            )
                          : Icon(
                              Icons.favorite,
                              size: 30,
                              color: colorRed,
                            ),
                    ),
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
