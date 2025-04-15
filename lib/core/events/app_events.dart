class ProgressChangedEvent {
  final String userId;
  final bool hasDueTasks;

  ProgressChangedEvent({required this.userId, this.hasDueTasks = false});
}

class TaskCompletedEvent {
  final String userId;
  final String progressId;

  TaskCompletedEvent({required this.userId, required this.progressId});
}

class ReminderSettingsChangedEvent {
  final bool enabled;

  ReminderSettingsChangedEvent({required this.enabled});
}
