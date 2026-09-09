import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../data/model/model.dart';

/* Extension class for subscription transaction list. Will use in extensions/subs_history_view.dart  */
extension View on DeliveryLink {
  Widget getDeliveryExternalTile({
    required BuildContext context,
  }) {
    var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;

    return isAllow == true
        ? InkWell(
            onTap: () async {
              if (!await launchUrl(
                Uri.parse(
                  url!,
                ),
                mode: LaunchMode.externalApplication,
              )) {
                throw 'Could not launch this link';
              }
            },
            child: Container(
              // margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
              // padding: EdgeInsets.all(5),
              alignment: Alignment.center,
              height: height * 0.033,
              decoration: BoxDecoration(
                color: colorGrabGreen,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 1.0,
                    offset: Offset(1.0, 1.0),
                  ),
                ],
              ),
              child: Text(
                'Delivery',
                style: TextStyle(
                  fontSize: 14,
                  color: colorWhite,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          )
        : InkWell(
            onTap: () {},
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Container(
                  // margin: EdgeInsets.fromLTRB(5, 5, 5, 3),
                  // padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  height: height * 0.032,
                  decoration: BoxDecoration(
                    color: colorGrabGreen,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 1.0,
                        offset: Offset(1.0, 1.0),
                      ),
                    ],
                  ),
                  child: Text(
                    'Delivery',
                    style: TextStyle(
                      fontSize: 16,
                      color: colorWhite,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
  }
}
