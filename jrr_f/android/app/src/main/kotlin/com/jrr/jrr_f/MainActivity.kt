package com.jrr.jrr_f

import androidx.annotation.NonNull
import androidx.car.app.connection.CarConnection
import com.ryanheise.audioservice.AudioServiceActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : AudioServiceActivity() {
    private val CHANNEL = "com.jrr.jrr_f/android_auto"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Monitor Android Auto / Automotive connection status
        try {
            CarConnection(this).type.observe(this) { type ->
                val isConnected = type == CarConnection.CONNECTION_TYPE_PROJECTION ||
                        type == CarConnection.CONNECTION_TYPE_NATIVE
                
                // Use a handler to ensure we don't call this too early during engine setup
                android.os.Handler(android.os.Looper.getMainLooper()).post {
                    channel.invokeMethod("onConnectionChanged", isConnected)
                }
            }
        } catch (e: Exception) {
            // Log error or ignore if car library fails
        }

        channel.setMethodCallHandler { call, result ->
            if (call.method == "isAndroidAutoConnected") {
                try {
                    val type = CarConnection(this).type.value
                    val isConnected = type == CarConnection.CONNECTION_TYPE_PROJECTION ||
                            type == CarConnection.CONNECTION_TYPE_NATIVE
                    result.success(isConnected)
                } catch (e: Exception) {
                    result.error("ERROR", e.message, null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
