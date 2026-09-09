import 'dart:io';

import '../../../../config/config.dart';
import 'package:flutter/material.dart';

import '../../../data/model/model.dart';
import '../../features/ordering/ordering.dart';
import '../independent/cache_network_image.dart';

// Extension class for credit records list. Will use in features/settings/view/history_view.dart
extension View on NearbyOutletList {
  Widget getNearbyListTile({
    required BuildContext context,
    required VoidCallback onTap,
    required OrderingState state,
  }) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                  padding: Platform.isIOS
                      ? EdgeInsets.symmetric(
                          vertical: 16, horizontal: marginHorizontal)
                      : EdgeInsets.symmetric(
                          vertical: 10, horizontal: marginHorizontal),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          place!,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorBlackTab,
                            fontFamily: fontFamilyInter,
                          ),
                          textScaler: TextScaler.linear(scaleFactor),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(right: 5),
                                    height: height * 0.02,
                                    color: colorTransparent,
                                    child: Image(
                                      image: AssetImage(
                                        'assets/icons/outlet/map_pin.png',
                                      ),
                                      color: secondaryColor,
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      'Address:',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: colorOutletAddressLabelGrey,
                                        fontFamily: fontFamilyInter,
                                      ),
                                      textScaler:
                                          TextScaler.linear(scaleFactor),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                width: width * 0.6,
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  address!,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: colorTextGrey,
                                    fontFamily: fontFamilyInter,
                                  ),
                                  textScaler: TextScaler.linear(scaleFactor),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Container(
                            alignment: Alignment.center,
                            //padding: EdgeInsets.all(8),
                            width: width * 0.2,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Container(
                                child: CachedImage(imageUrl: image!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          ],
        ),
        Divider(
          thickness: 1,
          color: colorLightGray,
        )
      ],
    );
  }
}
