import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../../config/storage.dart';
import 'notification.dart';

const notificationChannel = "Notification channel";
const notificationChannelId = "Channel_id_1";
const notificationChannelDescription = "Notification channel description";

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  late FirebaseMessaging _firebaseMessaging;
  // late FlutterLocalNotificationsPlugin _localNotifications;
  FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  /// A notification action which triggers a App navigation event
  String navigationActionId = 'id_3';

  late Future<String> permissionStatusFuture;
  var permGranted = "granted";
  var permDenied = "denied";
  var permUnknown = "unknown";
  var permProvisional = "provisional";

  String? _fcmToken;

  // ignore: prefer_final_fields
  static int _notificationId = 1; //Id for every notification

  bool _hasLaunched = false;

  String? _payLoad;
  RemoteMessage? _message;
  // ignore: unused_field
  bool _notificationsEnabled = false;

  final StreamController<String?> selectNotificationStream =
      StreamController<String?>.broadcast();

  @pragma('vm:entry-point')
  void notificationTapBackground(NotificationResponse notificationResponse) {
    // ignore: avoid_print
    print('notification(${notificationResponse.id}) action tapped: '
        '${notificationResponse.actionId} with'
        ' payload: ${notificationResponse.payload}');
    if (notificationResponse.input?.isNotEmpty ?? false) {
      // ignore: avoid_print
      print(
          'notification action tapped with input: ${notificationResponse.input}');
    }
  }

  final AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('launcher_icon');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    // notificationCategories: darwinNotificationCategories,
  );

  NotificationBloc() : super(NotificationStartUp()) {
    _localNotifications = FlutterLocalNotificationsPlugin();
    _firebaseMessaging = FirebaseMessaging.instance;
    // permissionStatusFuture = getCheckNotificationPermStatus();

    on<NotificationEvent>((event, emit) async {
      await mapEventToState(event, emit);
    });
  }

  initialize() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('launcher_icon');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    // // _requestPermissions();
    if (Platform.isIOS) {
      var hasPermission = await _requestIOSPermissions();
      if (hasPermission) {
        await _fcmInitialization();
      } else {
        add(NotificationException(
            error: "You can provide permission by going into Settings later."));
      }
    } else {
      final bool granted = await _localNotifications
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      _notificationsEnabled = granted;

      if (_notificationsEnabled) {
        await _fcmInitialization();
      }
    }

    NotificationAppLaunchDetails? appLaunchDetails =
        await _localNotifications.getNotificationAppLaunchDetails();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            selectNotificationStream.add(notificationResponse.payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            if (notificationResponse.actionId == navigationActionId) {
              selectNotificationStream.add(notificationResponse.payload);
            }
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _createNotificationChannel();

    _hasLaunched = appLaunchDetails!.didNotificationLaunchApp;
    if (_hasLaunched) {
      if (appLaunchDetails.notificationResponse?.payload != null) {
        _payLoad = appLaunchDetails.notificationResponse?.payload;
      }
      // if (appLaunchDetails.payload != null) {
      //   _payLoad = appLaunchDetails.payload;
      // }
    }
  }

  // void onDidReceiveNotificationResponse(
  //     NotificationResponse notificationResponse) async {
  //   final String? payload = notificationResponse.payload;
  //   if (notificationResponse.payload != null) {
  //     // debugPrint('notification payload: $payload');
  //   }

  // }

  Future<String> requestCheckPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      return permGranted;
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      // // ignore: avoid_print
      // print('User granted provisional permission');
      return permProvisional;
    } else {
      // // ignore: avoid_print
      // print('User declined or has not accepted permission');
      await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return permDenied;
    }
  }

  Future<bool> _requestIOSPermissions() async {
    var platformImplementation =
        _localNotifications.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
    bool permission = false;
    if (platformImplementation != null) {
      permission = (await platformImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ))!;
    }
    return permission;
  }

  NotificationState get initialState => NotificationStartUp();

  // Function to login
  Future<void> mapEventToState(event, Emitter<NotificationState> emit) async {
    switch (event.runtimeType) {
      case const (NotificationEvent):
        var message = event.remoteMessage;
        if (message != null) {
          emit(NotificationIndexed(
            1,
            message.notification?.title ?? '',
          ));
        }
        break;
      case const (NotificationException):
        emit(NotificationError(error: (event as NotificationException).error));
        break;
    }
  }

  Future<void> _showNotification(RemoteMessage message) async {
    // // ignore: avoid_print
    // print('Handling a foreground message ${message.messageId} ${message.data}');
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 200;
    vibrationPattern[2] = 200;
    vibrationPattern[3] = 200;

    RemoteNotification? notification = message.notification;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _notificationId.toString(),
      notificationChannel,
      channelDescription: notificationChannelDescription,
      icon: 'launcher_icon',
      vibrationPattern: vibrationPattern,
      importance: Importance.max,
      priority: Priority.max,
    );
    // var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      categoryIdentifier: '',
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await _localNotifications.show(
      notification.hashCode,
      notification!.title,
      notification.body,
      platformChannelSpecifics,
      // payload: message.data.toString()
    );

    add(NotificationEvent(message));
  }

  /// Create a [AndroidNotificationChannel] for heads up notifications
  void _createNotificationChannel() async {
    var androidNotificationChannel = AndroidNotificationChannel(
      notificationChannelId,
      notificationChannel,
      description: notificationChannelDescription,
      importance: Importance.high,
    );

    /// From Android 13 (API level 33) onwards, apps now have the ability to
    /// display a prompt where users can decide if they want to grant an app permission to show notifications.
    // _localNotifications
    //     .resolvePlatformSpecificImplementation<
    //         AndroidFlutterLocalNotificationsPlugin>()
    //     ?.requestPermission();

    if (Platform.isIOS || Platform.isMacOS) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await _localNotifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }

    // Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidNotificationChannel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: true,
      sound: true,
    );
  }

  // _getPlatformSettings() {
  //   var initializationSettingsAndroid =
  //       AndroidInitializationSettings('launcher_icon');
  //   var initializationSettingsIOS = DarwinInitializationSettings(
  //     requestSoundPermission: true,
  //     requestBadgePermission: true,
  //     requestAlertPermission: true,
  //   );
  //   // var initializationSettingsIOS = IOSInitializationSettings(
  //   //     requestAlertPermission: true,
  //   //     requestBadgePermission: true,
  //   //     requestSoundPermission: true);
  //   return InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  // }

  // Future _handleNotificationTap(String? payload) async {
  //   if (payload != null) {
  //     add(NotificationEvent(_message));
  //   }
  // }

  Future _fcmInitialization() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();

      _firebaseMessaging.onTokenRefresh.listen((event) {
        //API call can be done here to update token in back-end
        _fcmToken = event;
      });

      await Storage().secureStorage.write(key: 'push_token', value: _fcmToken);

      _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          // // ignore: avoid_print
          // print(message);
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _showNotification(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // // ignore: avoid_print
        // print('A new onMessageOpenedApp event was published!');
        // // ignore: avoid_print
        // print(message);
      });
    } catch (e) {
      add(NotificationException(error: e.toString()));
    }
  }

  void checkForLaunchedNotifications() {
    if (_hasLaunched && _payLoad != null) add(NotificationEvent(_message));
  }

  String? getFcmToken() => _fcmToken;
}
