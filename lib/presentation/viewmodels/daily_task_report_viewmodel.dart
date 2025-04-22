import 'dart:async';
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:spaced_learning_app/core/events/app_events.dart';
import 'package:spaced_learning_app/core/services/storage_service.dart';
import 'package:spaced_learning_app/presentation/viewmodels/base_viewmodel.dart';

import '../../core/services/daily_task_checker_service.dart';

class LogEntry {
  final DateTime timestamp;
  final String message;
  final String? detail;
  final bool isSuccess;

  LogEntry({
    required this.timestamp,
    required this.message,
    this.detail,
    required this.isSuccess,
  });

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toIso8601String(),
      'message': message,
      'detail': detail,
      'isSuccess': isSuccess,
    };
  }

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      timestamp: DateTime.parse(json['timestamp']),
      message: json['message'],
      detail: json['detail'],
      isSuccess: json['isSuccess'],
    );
  }
}

class CheckResult {
  final DateTime timestamp;
  final bool isSuccess;
  final bool hasDueTasks;
  final int taskCount;
  final String? errorMessage;

  CheckResult({
    required this.timestamp,
    required this.isSuccess,
    required this.hasDueTasks,
    required this.taskCount,
    this.errorMessage,
  });
}

class DailyTaskReportViewModel extends BaseViewModel {
  final StorageService _storageService;
  final EventBus _eventBus;
  final DailyTaskChecker _taskChecker;

  // State
  bool _isCheckerActive = false;
  bool _isManualCheckInProgress = false;
  DateTime? _lastCheckTime;
  bool _lastCheckResult = false;
  int _lastCheckTaskCount = 0;
  String? _lastCheckError;
  List<LogEntry> _logEntries = [];

  // Getters
  bool get isCheckerActive => _isCheckerActive;

  bool get isManualCheckInProgress => _isManualCheckInProgress;

  DateTime? get lastCheckTime => _lastCheckTime;

  bool get lastCheckResult => _lastCheckResult;

  int get lastCheckTaskCount => _lastCheckTaskCount;

  String? get lastCheckError => _lastCheckError;

  List<LogEntry> get logEntries => _logEntries;

  // Constants for keys
  static const String _isActiveKey = 'daily_task_checker_active';
  static const String _logEntriesKey = 'daily_task_log_entries';

  // Event subscription
  StreamSubscription? _taskCheckSubscription;

  DailyTaskReportViewModel({
    required StorageService storageService,
    required EventBus eventBus,
    required DailyTaskChecker taskChecker,
  }) : _storageService = storageService,
       _eventBus = eventBus,
       _taskChecker = taskChecker {
    _listenForEvents();
  }

  /// Listen for task check events
  void _listenForEvents() {
    _taskCheckSubscription = _eventBus.on<DailyTaskCheckEvent>().listen((
      event,
    ) {
      _addLogEntry(
        message: event.hasDueTasks
            ? 'Found ${event.taskCount} tasks due'
            : 'No tasks due today',
        detail: event.isSuccess ? null : event.errorMessage,
        isSuccess: event.isSuccess,
      );

      // Update state
      _lastCheckTime = event.checkTime;
      _lastCheckResult = event.isSuccess;
      _lastCheckTaskCount = event.taskCount;
      _lastCheckError = event.isSuccess ? null : event.errorMessage;

      notifyListeners();
    });
  }

  @override
  void dispose() {
    _taskCheckSubscription?.cancel();
    super.dispose();
  }

  /// Load report data
  Future<void> loadReportData() async {
    beginLoading();
    clearError();

    try {
      // Get active state
      _isCheckerActive = await _storageService.getBool(_isActiveKey) ?? false;

      // Get latest check report
      final report = await _taskChecker.getLastCheckReport();
      _lastCheckTime = report['lastCheckTime'] as DateTime?;
      _lastCheckResult = report['lastCheckResult'] as bool;
      _lastCheckTaskCount = report['lastCheckTaskCount'] as int;
      _lastCheckError = report['lastCheckError'] as String?;

      // Get logs
      await _loadLogs();

      setInitialized(true);
    } catch (e) {
      handleError(e, prefix: 'Error loading report data');
    } finally {
      endLoading();
    }
  }

  /// Toggle checker active state
  Future<void> toggleChecker(bool value) async {
    if (value == _isCheckerActive) return;

    return safeCall(
      action: () async {
        _isCheckerActive = value;
        await _storageService.setBool(_isActiveKey, value);

        if (value) {
          // Activate checker
          final success = await _taskChecker.initialize();
          if (success) {
            _addLogEntry(
              message: 'Daily automated check activated',
              isSuccess: true,
            );
          } else {
            _addLogEntry(
              message: 'Failed to activate automated check',
              isSuccess: false,
            );
            _isCheckerActive = false;
            await _storageService.setBool(_isActiveKey, false);
          }
        } else {
          // Deactivate checker
          final success = await _taskChecker.cancelDailyCheck();
          _addLogEntry(
            message: 'Daily automated check deactivated',
            isSuccess: success,
          );
        }
      },
      errorPrefix: 'Error changing checker state',
    );
  }

  /// Perform manual check
  Future<CheckResult> performManualCheck() async {
    if (_isManualCheckInProgress) {
      return CheckResult(
        timestamp: DateTime.now(),
        isSuccess: false,
        hasDueTasks: false,
        taskCount: 0,
        errorMessage: 'Check in progress, please wait',
      );
    }

    _isManualCheckInProgress = true;
    notifyListeners();

    try {
      _addLogEntry(message: 'Starting manual check', isSuccess: true);

      // Perform check
      final event = await _taskChecker.manualCheck();

      // Update state
      _lastCheckTime = event.checkTime;
      _lastCheckResult = event.isSuccess;
      _lastCheckTaskCount = event.taskCount;
      _lastCheckError = event.isSuccess ? null : event.errorMessage;

      // Add log entry
      _addLogEntry(
        message: event.hasDueTasks
            ? 'Manual check: Found ${event.taskCount} due tasks'
            : 'Manual check: No tasks due today',
        detail: event.isSuccess ? null : event.errorMessage,
        isSuccess: event.isSuccess,
      );

      return CheckResult(
        timestamp: event.checkTime,
        isSuccess: event.isSuccess,
        hasDueTasks: event.hasDueTasks,
        taskCount: event.taskCount,
        errorMessage: event.errorMessage,
      );
    } catch (e) {
      handleError(e, prefix: 'Error performing manual check');

      // Add error log entry
      _addLogEntry(
        message: 'Manual check failed',
        detail: e.toString(),
        isSuccess: false,
      );

      return CheckResult(
        timestamp: DateTime.now(),
        isSuccess: false,
        hasDueTasks: false,
        taskCount: 0,
        errorMessage: e.toString(),
      );
    } finally {
      _isManualCheckInProgress = false;
      notifyListeners();
    }
  }

  /// Add log entry
  Future<void> _addLogEntry({
    required String message,
    String? detail,
    required bool isSuccess,
  }) async {
    try {
      final entry = LogEntry(
        timestamp: DateTime.now(),
        message: message,
        detail: detail,
        isSuccess: isSuccess,
      );

      _logEntries.insert(0, entry); // Add to start of list

      // Limit number of entries
      if (_logEntries.length > 100) {
        _logEntries = _logEntries.sublist(0, 100);
      }

      // Save logs
      await _saveLogs();

      notifyListeners();
    } catch (e) {
      debugPrint('Error adding log entry: $e');
    }
  }

  /// Load logs from storage
  Future<void> _loadLogs() async {
    try {
      final logsJson = await _storageService.getString(_logEntriesKey);
      if (logsJson == null) {
        _logEntries = [];
        return;
      }

      // Parse JSON
      final List<dynamic> logsData = jsonDecode(logsJson);
      _logEntries = logsData.map((json) => LogEntry.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error loading logs: $e');
      _logEntries = [];
    }
  }

  /// Save logs to storage
  Future<void> _saveLogs() async {
    try {
      final logsJson = jsonEncode(_logEntries.map((e) => e.toJson()).toList());
      await _storageService.setString(_logEntriesKey, logsJson);
    } catch (e) {
      debugPrint('Error saving logs: $e');
    }
  }

  /// Clear all logs
  Future<void> clearLogs() async {
    return safeCall(
      action: () async {
        _logEntries = [];
        await _storageService.setString(_logEntriesKey, '[]');
        _addLogEntry(message: 'Logs cleared', isSuccess: true);
      },
      errorPrefix: 'Error clearing logs',
    );
  }
}
