import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import '../../../data/model/model.dart';
// import '../../features/ordering/ordering.dart';
import '../independent/cache_network_image.dart';

/* Extension class for merchant(brand) list. Will use in features/ordering/view/ordering_view.dart  */
extension View on MerchantList {
  Widget getListBrandTile({
    required BuildContext context,
    required VoidCallback onTap,
    // required OrderingState state,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(top: 15, left: 5, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Container for the image with fixed height
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: colorBackground,
                border: Border.all(width: 1, color: colorLightGray),
                borderRadius: BorderRadius.circular(8), // Rounded corners
              ),
              child: Container(
                height: height * 0.08,
                width: width * 0.7,
                padding: EdgeInsets.all(8),
                child: Center(
                  child: CachedImage(
                    imageUrl: image!,
                    boxFit:
                        BoxFit.contain, // Adjust how the image fits in the box
                  ),
                ),
              ),
            ),
            // Container for the text and other information
            SizedBox(
              width: width * 0.65,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Text(
                      name!,
                      style: TextStyle(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        color: colorBlack,
                        fontFamily: fontFamilyInter,
                      ),
                      textScaler: TextScaler.linear(scaleFactor),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.only(right: 3),
                          height: height * 0.015,
                          color: colorTransparent,
                          child: Image(
                            image: AssetImage(
                              'assets/icons/outlet/outlet_black.png',
                            ),
                            color: colorBlackTab,
                          ),
                        ),
                        Text(
                          '$total outlet(s)',
                          style: TextStyle(
                            fontSize: 7,
                            fontWeight: FontWeight.w500,
                            color: colorBlackTab,
                            fontFamily: fontFamilyInter,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}
