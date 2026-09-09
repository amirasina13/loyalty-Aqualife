import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../config/global_setup.dart';
import '../../../data/model/model.dart';
import '../independent/independent.dart';

/* Extension class for voucher list(based on outlet). Will use in features/outlet/view/outlets_details.dart  */
extension View on VoucherOutlet {
  Widget getOutletVoucherTile({
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: !isSoldOut! ? onTap : () {},
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        child: Column(
          children: [
            Container(
              height: height / 7.2,
              decoration: BoxDecoration(
                color: colorBackground,
                border: Border.all(color: colorLightGray, width: 0),
                borderRadius: BorderRadius.all(
                  Radius.circular(5),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(66, 46, 45, 45),
                    blurRadius: 3.0,
                    offset: Offset(0.0, 5.0),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5),
                            bottomLeft: Radius.circular(5),
                          ),
                          child: !isSoldOut!
                              ? Image.network(image!)
                              : Image.network(
                                  image!,
                                  color: colorUsedGray,
                                  colorBlendMode: BlendMode.color,
                                ),
                          // child: CachedImage(
                          //   imageUrl: image!,
                          // ),
                        ),
                      ),
                      isMuslim == true
                          ? Positioned(
                              right: 3,
                              top: 3,
                              child: !isSoldOut!
                                  ? HalalWidget(
                                      muslimCategory: muslimCategory!,
                                      width: width * 0.06)
                                  : HalalWidget(
                                      muslimCategory: muslimCategory!,
                                      width: width * 0.06,
                                      color: colorUsedGray,
                                      colorBlendMode: BlendMode.color))
                          : SizedBox(),
                    ],
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                      decoration: BoxDecoration(
                        color: colorTransparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              name!,
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: fontFamilyInter,
                                fontWeight: FontWeight.w700,
                                color: colorBlack,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            // height: height * 0.062,
                            padding: EdgeInsets.symmetric(vertical: 2),
                            alignment: Alignment.topLeft,
                            color: colorTransparent,
                            child: Text(
                              desc!,
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                color: colorTextGrey,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 5),
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    purchaseText!,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: fontFamilyInter,
                                      fontWeight: FontWeight.w600,
                                      color: !isSoldOut!
                                          ? colorBlack
                                          : colorUsedGray,
                                    ),
                                  ),
                                ),
                                Container(
                                  // padding: EdgeInsets.only(top: 3),
                                  alignment: Alignment.topLeft,
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
                                      decoration: TextDecoration.lineThrough,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
