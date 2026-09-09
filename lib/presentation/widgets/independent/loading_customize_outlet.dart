import '../../../../config/config.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/* Widget class for custom loading (With shimmer plugin).  */
class LoadingCustomizationOutlet extends StatelessWidget {
  const LoadingCustomizationOutlet({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool enabled = true;

    return Container(
      // height: height * 0.62,
      color: colorTransparent,
      margin: EdgeInsets.symmetric(horizontal: marginHorizontal),
      child: Center(
        child: Shimmer.fromColors(
          baseColor: colorLightGray,
          highlightColor: colorDisableGrey,
          enabled: enabled,
          child: ListView.builder(
            itemBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Container(
                  width: height * 0.06, //width * 0.09,
                  height: height * 0.06,
                  padding: EdgeInsets.all(5),
                  color: colorWhite,
                ),
                title: Container(
                  height: height * 0.03,
                  padding: EdgeInsets.all(5),
                  color: colorWhite,
                  margin: EdgeInsets.symmetric(vertical: 5),
                ),
                subtitle: Container(
                  height: height * 0.03,
                  padding: EdgeInsets.all(5),
                  color: colorWhite,
                ),
                trailing: Container(
                  width: width * 0.15,
                  height: height * 0.04,
                  alignment: Alignment.centerLeft,
                  color: colorWhite,
                ),
              ),
            ),
            itemCount: 10,
          ),
        ),
      ),
    );
  }
}
