package com.jaljeevanmission.jaljeevanmissiondynamic

import android.content.Intent
import androidx.annotation.NonNull  // Import NonNull annotation
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugins.GeneratedPluginRegistrant.registerWith
class MainActivity : FlutterActivity() {
    private val CHANNEL = "AdhaarDemo"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method == "openFaceCapture") {
                    val pidOptXml: String? = call.argument("request")
                    if (pidOptXml != null && pidOptXml.isNotEmpty()) {
                        startFaceCaptureActivity(pidOptXml)
                        result.success(pidOptXml)
                    } else {
                        result.error("InvalidArgument", "Missing XML data", null)
                    }
                } else {
                    result.notImplemented()
                }
            }
    }
    private fun startFaceCaptureActivity(pidOptXml: String) {
        val intentCapture = Intent("in.gov.uidai.rdservice.face.CAPTURE")
        intentCapture.putExtra("request", pidOptXml)
        startActivityForResult(intentCapture, REQUEST_CODE)
    }
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == REQUEST_CODE) {
            val pidData = data?.getStringExtra("response") ?: ""
            // Send the pidData back to Flutter
            MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL)
                .invokeMethod("onFaceCaptureResult", pidData)
        }
    }
    companion object {
        private const val REQUEST_CODE = 1
    }
}