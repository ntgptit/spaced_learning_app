// android/app/src/main/kotlin/com/yourapp/device/DeviceOptimizationPlugin.kt

package com.example.spaced_learning_app.device

import android.app.AlarmManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class DeviceOptimizationPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "com.yourapp.device/optimization")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "requestExactAlarmPermission" -> {
                val success = requestExactAlarmPermission()
                result.success(success)
            }
            "disableSleepingApps" -> {
                val success = disableSleepingApps()
                result.success(success)
            }
            "requestBatteryOptimization" -> {
                val success = requestBatteryOptimization()
                result.success(success)
            }
            "getDeviceInfo" -> {
                val info = getDeviceInfo()
                result.success(info)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun requestExactAlarmPermission(): Boolean {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                if (!alarmManager.canScheduleExactAlarms()) {
                    val intent = Intent(Settings.ACTION_REQUEST_SCHEDULE_EXACT_ALARM).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    context.startActivity(intent)
                    return true
                }
            }
            return true
        } catch (e: Exception) {
            e.printStackTrace()
            return false
        }
    }

    private fun disableSleepingApps(): Boolean {
        try {
            val manufacturer = Build.MANUFACTURER.toLowerCase()

            when {
                manufacturer.contains("samsung") -> {
                    // Samsung specific
                    try {
                        val intent = Intent().apply {
                            component = android.content.ComponentName(
                                "com.samsung.android.lool",
                                "com.samsung.android.sm.ui.battery.BatteryActivity"
                            )
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        context.startActivity(intent)
                        return true
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
                manufacturer.contains("xiaomi") || manufacturer.contains("redmi") -> {
                    // Xiaomi/MIUI specific
                    try {
                        val intent = Intent().apply {
                            component = android.content.ComponentName(
                                "com.miui.powerkeeper",
                                "com.miui.powerkeeper.ui.HiddenAppsConfigActivity"
                            )
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        context.startActivity(intent)
                        return true
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
                manufacturer.contains("huawei") -> {
                    // Huawei specific
                    try {
                        val intent = Intent().apply {
                            component = android.content.ComponentName(
                                "com.huawei.systemmanager",
                                "com.huawei.systemmanager.optimize.process.ProtectActivity"
                            )
                            flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        }
                        context.startActivity(intent)
                        return true
                    } catch (e: Exception) {
                        e.printStackTrace()
                    }
                }
                // Add other manufacturers as needed
                else -> {
                    // Generic battery settings
                    val intent = Intent(Settings.ACTION_BATTERY_SAVER_SETTINGS).apply {
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    context.startActivity(intent)
                    return true
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return false
    }

    private fun requestBatteryOptimization(): Boolean {
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                val packageName = context.packageName
                val pm = context.getSystemService(Context.POWER_SERVICE) as PowerManager
                if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                    val intent = Intent().apply {
                        action = Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS
                        data = Uri.parse("package:$packageName")
                        flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    }
                    context.startActivity(intent)
                    return true
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
        return false
    }

    private fun getDeviceInfo(): Map<String, Any> {
        val info = HashMap<String, Any>()
        info["manufacturer"] = Build.MANUFACTURER
        info["model"] = Build.MODEL
        info["sdkVersion"] = Build.VERSION.SDK_INT
        info["brand"] = Build.BRAND
        info["device"] = Build.DEVICE

        // Check for specific features
        val pm = context.packageManager
        info["hasVibrator"] = pm.hasSystemFeature(PackageManager.FEATURE_VIBRATE)
        info["hasAlarmScheduling"] = pm.hasSystemFeature("android.software.alarm")

        return info
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
