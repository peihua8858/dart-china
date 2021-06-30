part of 'notification_bloc.dart';

enum NotificationStatus { initial, loading, success, paging, failure }

extension NotificationStatusX on NotificationStatus {
  bool get isInitial => this == NotificationStatus.initial;
  bool get isLoading => this == NotificationStatus.loading;
  bool get isSuccess => this == NotificationStatus.success;
  bool get isPaging => this == NotificationStatus.paging;
  bool get isFailure => this == NotificationStatus.failure;
}

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<models.Notification> notifications;
  final int page;
  final bool more;

  NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.page = -1,
    this.more = true,
  });

  NotificationState copyWith({
    NotificationStatus? status,
    List<models.Notification>? notifications,
    int? page,
    bool? more,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      more: more ?? this.more,
    );
  }

  @override
  List<Object?> get props => [status, notifications, page, more];
}
