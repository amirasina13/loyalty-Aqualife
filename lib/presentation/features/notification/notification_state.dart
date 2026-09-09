import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationStartUp extends NotificationState {}

class NotificationIndexed extends NotificationState {
  final int index;
  final String message;

  const NotificationIndexed(
    this.index,
    this.message,
  );

  @override
  List<Object> get props => [
        index,
      ];

  @override
  bool operator ==(Object other) => false;

  @override
  // ignore: unnecessary_overrides
  int get hashCode => super.hashCode;
}

class NotificationError extends NotificationState {
  final String error;

  const NotificationError({required this.error});

  @override
  List<Object> get props => [
        error,
      ];
}
