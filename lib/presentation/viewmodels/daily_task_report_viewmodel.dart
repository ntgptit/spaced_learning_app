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

  // Trạng thái
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

  // Hằng số cho keys
  static const String _isActiveKey = 'daily_task_checker_active';
  static const String _logEntriesKey = 'daily_task_log_entries';

  // Events
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

  void _listenForEvents() {
    // Lắng nghe sự kiện kiểm tra task
    _taskCheckSubscription = _eventBus.on<DailyTaskCheckEvent>().listen((
      event,
    ) {
      _addLogEntry(
        message: event.hasDueTasks
            ? 'Đã tìm thấy ${event.taskCount} nhiệm vụ đến hạn'
            : 'Không có nhiệm vụ đến hạn hôm nay',
        detail: event.isSuccess ? null : event.errorMessage,
        isSuccess: event.isSuccess,
      );

      // Cập nhật trạng thái
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

  // Phương thức khởi tạo
  Future<void> loadReportData() async {
    beginLoading();
    clearError();

    try {
      // Lấy trạng thái kích hoạt
      _isCheckerActive = await _storageService.getBool(_isActiveKey) ?? false;

      // Lấy báo cáo kiểm tra gần nhất
      final report = await _taskChecker.getLastCheckReport();
      _lastCheckTime = report['lastCheckTime'] as DateTime?;
      _lastCheckResult = report['lastCheckResult'] as bool;
      _lastCheckTaskCount = report['lastCheckTaskCount'] as int;
      _lastCheckError = report['lastCheckError'] as String?;

      // Lấy nhật ký
      await _loadLogs();

      setInitialized(true);
    } catch (e) {
      handleError(e, prefix: 'Lỗi khi tải dữ liệu báo cáo');
    }

    endLoading();
  }

  // Phương thức thay đổi trạng thái kích hoạt
  Future<void> toggleChecker(bool value) async {
    beginLoading();
    clearError();

    try {
      if (value == _isCheckerActive) return;

      _isCheckerActive = value;
      await _storageService.setBool(_isActiveKey, value);

      if (value) {
        // Kích hoạt kiểm tra
        final success = await _taskChecker.initialize();
        if (success) {
          _addLogEntry(
            message: 'Đã kích hoạt kiểm tra tự động hàng ngày',
            isSuccess: true,
          );
        } else {
          _addLogEntry(
            message: 'Không thể kích hoạt kiểm tra tự động',
            isSuccess: false,
          );
          _isCheckerActive = false;
          await _storageService.setBool(_isActiveKey, false);
        }
      } else {
        // Hủy kiểm tra
        final success = await _taskChecker.cancelDailyCheck();
        _addLogEntry(
          message: 'Đã hủy kiểm tra tự động hàng ngày',
          isSuccess: success,
        );
      }
    } catch (e) {
      handleError(e, prefix: 'Lỗi khi thay đổi trạng thái kiểm tra');
      _isCheckerActive = !value; // Khôi phục trạng thái trước đó
    }

    endLoading();
  }

  // Phương thức thực hiện kiểm tra thủ công
  Future<CheckResult> performManualCheck() async {
    if (_isManualCheckInProgress) {
      return CheckResult(
        timestamp: DateTime.now(),
        isSuccess: false,
        hasDueTasks: false,
        taskCount: 0,
        errorMessage: 'Đang thực hiện kiểm tra, vui lòng đợi',
      );
    }

    _isManualCheckInProgress = true;
    notifyListeners();

    try {
      _addLogEntry(message: 'Bắt đầu kiểm tra thủ công', isSuccess: true);

      // Thực hiện kiểm tra
      final event = await _taskChecker.manualCheck();

      // Cập nhật trạng thái
      _lastCheckTime = event.checkTime;
      _lastCheckResult = event.isSuccess;
      _lastCheckTaskCount = event.taskCount;
      _lastCheckError = event.isSuccess ? null : event.errorMessage;

      // Thêm bản ghi nhật ký
      _addLogEntry(
        message: event.hasDueTasks
            ? 'Kiểm tra thủ công: Tìm thấy ${event.taskCount} nhiệm vụ đến hạn'
            : 'Kiểm tra thủ công: Không có nhiệm vụ đến hạn hôm nay',
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
      handleError(e, prefix: 'Lỗi khi thực hiện kiểm tra thủ công');

      // Thêm bản ghi nhật ký lỗi
      _addLogEntry(
        message: 'Kiểm tra thủ công thất bại',
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

  // Phương thức thêm bản ghi nhật ký
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

      _logEntries.insert(0, entry); // Thêm vào đầu danh sách

      // Giới hạn số lượng bản ghi
      if (_logEntries.length > 100) {
        _logEntries = _logEntries.sublist(0, 100);
      }

      // Lưu nhật ký
      await _saveLogs();

      notifyListeners();
    } catch (e) {
      debugPrint('Lỗi khi thêm bản ghi nhật ký: $e');
    }
  }

  // Phương thức tải nhật ký
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
      debugPrint('Lỗi khi tải nhật ký: $e');
      _logEntries = [];
    }
  }

  // Phương thức lưu nhật ký
  Future<void> _saveLogs() async {
    try {
      final logsJson = jsonEncode(_logEntries.map((e) => e.toJson()).toList());
      await _storageService.setString(_logEntriesKey, logsJson);
    } catch (e) {
      debugPrint('Lỗi khi lưu nhật ký: $e');
    }
  }

  // Phương thức xóa nhật ký
  Future<void> clearLogs() async {
    beginLoading();
    clearError();

    try {
      _logEntries = [];
      await _storageService.setString(_logEntriesKey, '[]');
      _addLogEntry(message: 'Đã xóa nhật ký kiểm tra', isSuccess: true);
    } catch (e) {
      handleError(e, prefix: 'Lỗi khi xóa nhật ký');
    }

    endLoading();
  }
}
