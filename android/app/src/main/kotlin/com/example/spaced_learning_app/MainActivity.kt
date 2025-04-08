package com.example.spaced_learning_app

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Đăng ký plugin
        flutterEngine.plugins.add(DeviceOptimizationPlugin())
    }
}
