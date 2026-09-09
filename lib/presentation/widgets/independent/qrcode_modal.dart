import '../../../../config/config.dart';
import 'package:flutter/material.dart';

/* Widget class for bottom modal(appear from bottom to top). Mostly will use to show the Qr code  */
class QrcodeModal extends StatelessWidget {
  final Widget? content;

  const QrcodeModal({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        height: height / 1.45,
        clipBehavior: Clip.antiAlias,
        // padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: colorWhite,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: content,
        ),
      ),
    );
  }

  static Future showQrcodeModal(
    BuildContext context,
    Widget content,
  ) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16.0),
        ),
      ),
      backgroundColor: colorBackground,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.zero,
        child: QrcodeModal(
          content: content,
        ),
      ),
    );
  }
}
