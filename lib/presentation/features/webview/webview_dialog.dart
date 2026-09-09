import '../../../../config/config.dart';
import 'package:flutter/material.dart';

class WebviewDialog {
  static Future showWebview(BuildContext context, Widget content) {
    var heightAppbar = AppBar().preferredSize.height - 10;

    return showGeneralDialog(
      transitionDuration: const Duration(milliseconds: 400),
      context: context,
      pageBuilder: (context, _, __) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: IntrinsicHeight(
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height - heightAppbar,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: colorWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Stack(
                children: [
                  content,
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, animation1, __, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(animation1),
          child: child,
        );
      },
    );
  }
}
