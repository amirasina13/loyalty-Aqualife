import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../config/global_setup.dart';
import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher past list. Will use in features/voucher/view/voucher_view.dart  */
extension View on VoucherReward {
  Widget getRewardListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required VoidCallback onFavouriteTap,
    // required bool past,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: !isSoldOut! ? onTap : () {},
      child: Container(
        height: height / 7.5,
        margin: EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: CachedImage(
                        imageUrl: image!,
                      ),
                    ),
                  ),
                ),
                isMuslim == true
                    ? Positioned(
                        right: 0,
                        top: 5,
                        child: !isSoldOut!
                            ? HalalWidget(
                                muslimCategory: muslimCategory!,
                                width: width * 0.09)
                            : HalalWidget(
                                muslimCategory: muslimCategory!,
                                width: width * 0.09,
                                color: colorUsedGray,
                                colorBlendMode: BlendMode.color))
                    : SizedBox(),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                // padding: EdgeInsets.symmetric(vertical: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: height * 0.03,
                      // padding: EdgeInsets.symmetric(vertical: 5),
                      // alignment: Alignment.topLeft,
                      // color: AppColors.deepYellow,
                      child: Text(
                        name!,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w600,
                          color: colorBlack,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    isMuslim == true
                        ? Container(
                            // height: height * 0.03,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              muslimCategory == "halal"
                                  ? 'Halal'
                                  : muslimCategory == "imesra"
                                      ? 'I-Mesra'
                                      : 'Muslim Friendly',
                              style: TextStyle(
                                fontSize: 8,
                                // fontFamily: 'Inter',
                                fontWeight: FontWeight.w400,
                                color: colorBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : Container(),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            // padding: EdgeInsets.symmetric(vertical: 5),
                            child: Text(
                              purchaseText!,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: fontFamilyInter,
                                fontWeight: FontWeight.w700,
                                color: !isSoldOut! ? mainColor : colorUsedGray,
                              ),
                            ),
                          ),
                          voucherType == 'downloadable'
                              ? Container()
                              : double.parse(faceAmount!) == 0.00
                                  ? Container()
                                  : Container(
                                      padding: EdgeInsets.only(top: 5),
                                      child: Text(
                                        double.parse(faceAmount!) > 0.00
                                            ? creditLabelAlign == 'left'
                                                ? '$creditLabelText $faceAmount'
                                                : '$faceAmount $creditLabelText'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: fontFamilyInter,
                                          fontWeight: FontWeight.w500,
                                          color: colorUsedGray,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              // width: width * 0.15,
              alignment: Alignment.topCenter,
              padding: EdgeInsets.symmetric(horizontal: 5),
              margin: EdgeInsets.symmetric(vertical: 5),
              // color: colorBabyBlue,
              child: InkWell(
                // onTap: () {
                //   Storage().page = 'reward_wishlist';
                //   BlocProvider.of<RewardBloc>(context)
                //       .add(RewardAddRemoveFavouriteLoad(
                //     voucherId: id!.toString(),
                //   ));
                // },
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
    );
  }
}
