// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'config/storage.dart';
import 'locator.dart';
import 'presentation/features/webview/webview_deeplink.dart';
import 'presentation/navigation_service.dart';
import 'util/ios_deeplink_listener.dart';

class LifeCycleManager extends StatefulWidget {
  const LifeCycleManager({super.key, required this.child});

  final Widget child;

  @override
  State<LifeCycleManager> createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  AppLinks? _appLinks;
  StreamSubscription<Uri>? _sub;
  bool isDeeplinkPressed = false;

  void _initDeepLinkListener() {
    _appLinks = AppLinks();

    _sub = _appLinks!.uriLinkStream.listen((uri) async {
      if ((uri != null || uri.toString().isNotEmpty) &&
          uri.host == 'loyalty.aqualifecambodia.com') {
        isDeeplinkPressed = true;

        TempData.deeplink = uri.toString();
        sl<NavigationService>()
            .navigatorKey
            .currentState
            ?.push(MaterialPageRoute(
              builder: (context) => RedirectWebView(
                parameters: DeeplinkParameters(initialUrl: uri.toString()),
              ),
            ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // print('STATE APPCYCLE: $state');

    switch (state) {
      case AppLifecycleState.resumed:
        if (Platform.isAndroid) {
          if (Storage().setupDone == false) {
            sl<NavigationService>()
                .navigatorKey
                .currentState
                ?.pushNamedAndRemoveUntil(
                  AqualifeRoutes.splashChecking,
                  (Route<dynamic> route) => false,
                );
          } else {
            _initDeepLinkListener();
            if (isDeeplinkPressed) {
              _sub?.cancel();
            }
          }
        } else {
          DeepLinkHandler.listenForDeepLinkIOS();
        }

        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        // print("app in detached");

        break;
      case AppLifecycleState.hidden:
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
