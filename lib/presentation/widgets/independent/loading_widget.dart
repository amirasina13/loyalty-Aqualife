import 'package:flutter/material.dart';

import '../../../config/config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorBackground,
      child: Center(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loading...',
                  style: TextStyle(
                      fontFamily: fontFamilyMain,
                      color: colorSoftGrey,
                      fontSize: 10)),
              SizedBox(height: 8),
              CircularProgressIndicator(
                  color: colorSoftGrey.withValues(alpha: 0.5))
            ]),
      ),
    );
  }
}
