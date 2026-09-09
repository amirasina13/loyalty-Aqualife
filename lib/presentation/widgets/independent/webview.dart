import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../../config/config.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
}

class WidgetWebView extends StatefulWidget {
  final Function? changeView;
  final String? widgetUrl;

  const WidgetWebView({super.key, this.changeView, this.widgetUrl});

  @override
  // ignore: no_logic_in_create_state
  State<WidgetWebView> createState() => _WidgetWebViewState(widgetUrl);
}

class _WidgetWebViewState extends State<WidgetWebView> {
  // ignore: prefer_typing_uninitialized_variables
  var url, widgetUrl;
  bool isLoading = true;
  final GlobalKey webViewKey = GlobalKey();

  _WidgetWebViewState(this.widgetUrl);

  InAppWebViewController? webViewController;
  InAppWebViewSettings settings = InAppWebViewSettings(
    isInspectable: kDebugMode,
    mediaPlaybackRequiresUserGesture: false,
    allowsInlineMediaPlayback: true,
    iframeAllow: "camera; microphone",
    iframeAllowFullscreen: true,
  );
  // InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
  //     crossPlatform: InAppWebViewOptions(
  //       supportZoom: false,
  //       disableHorizontalScroll: true,
  //       minimumFontSize: 16,
  //       mediaPlaybackRequiresUserGesture: false,
  //     ),
  //     android: AndroidInAppWebViewOptions(
  //       useHybridComposition: true,
  //     ),
  //     ios: IOSInAppWebViewOptions(
  //       allowsInlineMediaPlayback: true,
  //     ));

  PullToRefreshController? pullToRefreshController;
  late ContextMenu contextMenu;
  double progress = 0;

  // double progress = 0;
  // late Uint8List screenshotBytes;

  @override
  void initState() {
    super.initState();

    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              id: 1,
              title: "Special",
              action: () async {
                // print("Menu item Special clicked!");
                // print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        settings: ContextMenuSettings(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {},
        onHideContextMenu: () {
          // print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          // var id = contextMenuItemClicked.id;
          // print("onContextMenuActionItemClicked: " +
          //     id.toString() +
          //     " " +
          //     contextMenuItemClicked.title);
        });

    pullToRefreshController = kIsWeb ||
            ![TargetPlatform.iOS, TargetPlatform.android]
                .contains(defaultTargetPlatform)
        ? null
        : PullToRefreshController(
            settings: PullToRefreshSettings(
              color: Colors.blue,
            ),
            onRefresh: () async {
              if (defaultTargetPlatform == TargetPlatform.android) {
                webViewController?.reload();
              } else if (defaultTargetPlatform == TargetPlatform.iOS) {
                webViewController?.loadUrl(
                    urlRequest:
                        URLRequest(url: await webViewController?.getUrl()));
              }
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InAppWebView(
          key: webViewKey,
          initialUrlRequest: URLRequest(url: WebUri(widgetUrl)),
          // initialUrlRequest:
          // URLRequest(url: WebUri(Uri.base.toString().replaceFirst("/#/", "/") + 'page.html')),
          // initialFile: "assets/index.html",
          // initialUserScripts: UnmodifiableListView<UserScript>([]),
          initialSettings: settings,
          contextMenu: contextMenu,
          pullToRefreshController: pullToRefreshController,
          onWebViewCreated: (controller) async {
            webViewController = controller;
          },
          onLoadStart: (controller, url) {
            setState(() {
              this.url = url.toString();
            });
          },
          onPermissionRequest: (controller, request) async {
            return PermissionResponse(
                resources: request.resources,
                action: PermissionResponseAction.GRANT);
          },
          shouldOverrideUrlLoading: (controller, navigationAction) async {
            var uri = navigationAction.request.url!;

            if (![
              "http",
              "https",
              "file",
              "chrome",
              "data",
              "javascript",
              "about"
            ].contains(uri.scheme)) {
              // if (await canLaunchUrl(uri)) {
              //   // Launch the App
              //   await launchUrl(
              //     uri,
              //   );
              //   // and cancel the request
              //   return NavigationActionPolicy.CANCEL;
              // }
            }

            return NavigationActionPolicy.ALLOW;
          },
          onLoadStop: (controller, url) {
            pullToRefreshController?.endRefreshing();
            setState(() {
              this.url = url.toString();
              isLoading = false;
            });
          },
          onReceivedError: (controller, request, error) {
            pullToRefreshController?.endRefreshing();
          },
          onProgressChanged: (controller, progress) {
            if (progress == 100) {
              pullToRefreshController?.endRefreshing();
            }
            setState(() {
              this.progress = progress / 100;
            });
          },
          onUpdateVisitedHistory: (controller, url, isReload) {
            setState(() {
              this.url = url.toString();
            });
          },
          onConsoleMessage: (controller, consoleMessage) {
            // print(consoleMessage);
          },
        ),
        // InAppWebView(
        //   key: webViewKey,
        //   initialUrlRequest: URLRequest(url: WebUri(widgetUrl)),
        //   initialSettings: options,
        //   pullToRefreshController: pullToRefreshController,
        //   onWebViewCreated: (controller) {
        //     webViewController = controller;
        //   },
        //   onLoadStart: (controller, url) {
        //     setState(() {
        //       this.url = url.toString();
        //     });
        //   },
        //   androidOnPermissionRequest: (controller, origin, resources) async {
        //     return PermissionRequestResponse(
        //         resources: resources,
        //         action: PermissionRequestResponseAction.GRANT);
        //   },
        //   shouldOverrideUrlLoading: (controller, navigationAction) async {
        //     var uri = navigationAction.request.url;

        //     if (![
        //       "http",
        //       "https",
        //       "file",
        //       "chrome",
        //       "data",
        //       "javascript",
        //       "about"
        //     ].contains(uri!.scheme)) {
        //       // if (await canLaunch(url)) {
        //       //   // Launch the App
        //       //   await launch(
        //       //     url,
        //       //   );
        //       //   // and cancel the request
        //       //   return NavigationActionPolicy.CANCEL;
        //       // }
        //     }

        //     return NavigationActionPolicy.ALLOW;
        //   },
        //   onLoadStop: (controller, url) async {
        //     pullToRefreshController.endRefreshing();
        //     setState(() {
        //       this.url = url.toString();
        //       isLoading = false;
        //     });

        //     // ignore: unused_local_variable
        //     var result = await controller.evaluateJavascript(
        //         source: "function print(key, params){};");
        //   },
        //   onLoadError: (controller, url, code, message) {
        //     pullToRefreshController.endRefreshing();
        //   },
        //   onProgressChanged: (controller, progress) {
        //     if (progress == 100) {
        //       pullToRefreshController.endRefreshing();
        //     }
        //     setState(() {
        //       this.progress = progress / 100;
        //     });
        //   },
        //   onUpdateVisitedHistory: (controller, url, androidIsReload) {
        //     setState(() {
        //       this.url = url.toString();
        //     });
        //   },
        //   onConsoleMessage: (controller, consoleMessage) {},
        //   onCreateWindow: (controller, createWindowAction) async {
        //     // create a headless WebView using the createWindowAction.windowId to get the correct URL
        //     HeadlessInAppWebView? headlessWebView;
        //     headlessWebView = HeadlessInAppWebView(
        //       windowId: createWindowAction.windowId,
        //       onLoadStart: (controller, url) async {
        //         if (url != null) {
        //           InAppBrowser.openWithSystemBrowser(
        //               url: url); // to open with the system browser
        //           // or use the https://pub.dev/packages/url_launcher plugin
        //         }
        //         // dispose it immediately
        //         await headlessWebView?.dispose();
        //         headlessWebView = null;
        //       },
        //     );
        //     headlessWebView?.run();

        //     // return true to tell that we are handling the new window creation action
        //     return true;
        //   },
        // ),
        Container(
          // height: MediaQuery.of(context).size.height,
          color: colorBackground,
          child: isLoading
              ? Center(
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Loading...',
                        style: TextStyle(
                            fontFamily: fontFamilyMain,
                            color: colorSoftGrey,
                            fontSize: 10)),
                    SizedBox(height: 8),
                    CircularProgressIndicator(
                      color: colorDisableGrey,
                    ),
                  ],
                ))
              : const SizedBox(),
        ),
      ],
    );
  }
}

// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';

// import '../../../config/config.dart';

// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   if (Platform.isAndroid) {
//     await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
//   }
// }

// class WidgetWebView extends StatefulWidget {
//   final Function? changeView;
//   final String? widgetUrl;

//   const WidgetWebView({Key? key, this.changeView, this.widgetUrl})
//       : super(key: key);

//   @override
//   // ignore: no_logic_in_create_state
//   State<WidgetWebView> createState() => _WidgetWebViewState(widgetUrl);
// }

// class _WidgetWebViewState extends State<WidgetWebView> {
//   // ignore: prefer_typing_uninitialized_variables
//   var url, widgetUrl;
//   bool isLoading = true;
//   final GlobalKey webViewKey = GlobalKey();

//   _WidgetWebViewState(this.widgetUrl);

//   late InAppWebViewController webViewController;
//   InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
//       crossPlatform: InAppWebViewOptions(
//         supportZoom: false,
//         disableHorizontalScroll: true,
//         minimumFontSize: 16,
//         mediaPlaybackRequiresUserGesture: false,
//       ),
//       android: AndroidInAppWebViewOptions(
//         useHybridComposition: true,
//       ),
//       ios: IOSInAppWebViewOptions(
//         allowsInlineMediaPlayback: true,
//       ));

//   late PullToRefreshController pullToRefreshController;
//   double progress = 0;
//   late Uint8List screenshotBytes;

//   @override
//   void initState() {
//     super.initState();

//     pullToRefreshController = PullToRefreshController(
//       options: PullToRefreshOptions(
//         color: Colors.blue,
//       ),
//       onRefresh: () async {
//         if (Platform.isAndroid) {
//           webViewController.reload();
//         } else if (Platform.isIOS) {
//           webViewController.loadUrl(
//               urlRequest: URLRequest(url: await webViewController.getUrl()));
//         }
//       },
//     );
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         Container(
//           /* ----------------------------------------------------------------------- Inappwebview layout */
//           child: InAppWebView(
//             key: webViewKey,
//             initialUrlRequest: URLRequest(url: Uri.parse(widgetUrl)),
//             initialOptions: options,
//             pullToRefreshController: pullToRefreshController,
//             onWebViewCreated: (controller) {
//               webViewController = controller;
//             },
//             onLoadStart: (controller, url) {
//               setState(() {
//                 this.url = url.toString();
//               });
//             },
//             androidOnPermissionRequest: (controller, origin, resources) async {
//               return PermissionRequestResponse(
//                   resources: resources,
//                   action: PermissionRequestResponseAction.GRANT);
//             },
//             shouldOverrideUrlLoading: (controller, navigationAction) async {
//               var uri = navigationAction.request.url;

//               if (![
//                 "http",
//                 "https",
//                 "file",
//                 "chrome",
//                 "data",
//                 "javascript",
//                 "about"
//               ].contains(uri!.scheme)) {
//                 // if (await canLaunch(url)) {
//                 //   // Launch the App
//                 //   await launch(
//                 //     url,
//                 //   );
//                 //   // and cancel the request
//                 //   return NavigationActionPolicy.CANCEL;
//                 // }
//               }

//               return NavigationActionPolicy.ALLOW;
//             },
//             onLoadStop: (controller, url) async {
//               pullToRefreshController.endRefreshing();
//               setState(() {
//                 this.url = url.toString();
//                 isLoading = false;
//               });

//               // ignore: unused_local_variable
//               var result = await controller.evaluateJavascript(
//                   source: "function print(key, params){};");
//             },
//             onLoadError: (controller, url, code, message) {
//               pullToRefreshController.endRefreshing();
//             },
//             onProgressChanged: (controller, progress) {
//               if (progress == 100) {
//                 pullToRefreshController.endRefreshing();
//               }
//               setState(() {
//                 this.progress = progress / 100;
//               });
//             },
//             onUpdateVisitedHistory: (controller, url, androidIsReload) {
//               setState(() {
//                 this.url = url.toString();
//               });
//             },
//             onConsoleMessage: (controller, consoleMessage) {},
//             onCreateWindow: (controller, createWindowAction) async {
//               // create a headless WebView using the createWindowAction.windowId to get the correct URL
//               HeadlessInAppWebView? headlessWebView;
//               headlessWebView = HeadlessInAppWebView(
//                 windowId: createWindowAction.windowId,
//                 onLoadStart: (controller, url) async {
//                   if (url != null) {
//                     InAppBrowser.openWithSystemBrowser(
//                         url: url); // to open with the system browser
//                     // or use the https://pub.dev/packages/url_launcher plugin
//                   }
//                   // dispose it immediately
//                   await headlessWebView?.dispose();
//                   headlessWebView = null;
//                 },
//               );
//               headlessWebView?.run();

//               // return true to tell that we are handling the new window creation action
//               return true;
//             },
//           ),
//         ),
//         Container(
//           // height: MediaQuery.of(context).size.height,
//           color: colorBackground,
//           child: isLoading
//               ? Center(
//                   child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Text('Loading...',
//                         style: TextStyle(
//                             fontFamily: fontFamilyMain,
//                             color: colorSoftGrey,
//                             fontSize: 10)),
//                     SizedBox(height: 8),
//                     CircularProgressIndicator(
//                       color: colorDisableGrey,
//                     ),
//                   ],
//                 ))
//               : const SizedBox(),
//         ),
//       ],
//     );
//   }
// }
