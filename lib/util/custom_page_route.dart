import 'package:flutter/material.dart';

class NoAnimationPageRoute extends MaterialPageRoute {
  NoAnimationPageRoute({builder, settings})
      : super(builder: builder, settings: settings);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
