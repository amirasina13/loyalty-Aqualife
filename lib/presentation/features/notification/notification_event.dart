import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationEvent {
  final RemoteMessage? remoteMessage;

  const NotificationEvent(this.remoteMessage);
}

class NotificationException extends NotificationEvent {
  final String error;

  const NotificationException({required this.error}) : super(null);
}
