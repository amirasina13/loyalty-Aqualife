import 'package:flutter/material.dart';

class HalalWidget extends StatelessWidget {
  final String muslimCategory;
  final bool? isCircle;
  final double? width;
  final double? height;
  final Color? color;
  final BlendMode? colorBlendMode;

  const HalalWidget(
      {super.key,
      required this.muslimCategory,
      this.isCircle = false,
      this.width,
      this.height,
      this.color,
      this.colorBlendMode});

  @override
  Widget build(BuildContext context) {
    return _getHalalLogo(context, muslimCategory);
  }

  Widget _getHalalLogo(BuildContext context, String muslimCategory) {
    if (muslimCategory == "halal") {
      return Image(
        color: color,
        colorBlendMode: colorBlendMode,
        width: width,
        image: AssetImage(!isCircle!
            ? 'assets/icons/icon_halal.png'
            : 'assets/icons/halal_circle.png'),
      );
    } else if (muslimCategory == "imesra") {
      return Image(
        color: color,
        colorBlendMode: colorBlendMode,
        width: width,
        image: AssetImage(!isCircle!
            ? 'assets/icons/icon_imesra.png'
            : 'assets/icons/imesra_circle.png'),
      );
    } else if (muslimCategory == "mFriendly") {
      return Image(
        color: color,
        colorBlendMode: colorBlendMode,
        width: width,
        image: AssetImage('assets/icons/icon_muslim_friendly.png'),
      );
    } else {
      return SizedBox();
    }
  }
}
