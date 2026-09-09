import 'package:flutter/material.dart';

class ChupNotification extends ScrollNotification {
  ChupNotification(
      {required this.id,
      required ScrollMetrics metrics,
      required BuildContext? context})
      : super(metrics: metrics, context: context);
  final String id;
}
