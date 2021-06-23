package com.bluebird.prowords

import android.content.Intent
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var text:String? = null
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        text = intent.getStringExtra(Intent.EXTRA_TEXT)
        MethodChannel(this.flutterEngine!!.dartExecutor, "com.bluebird.prowords.intent").setMethodCallHandler { call, result ->
            when (call.method) {
                "getWord" -> result.success(text)
            }
        }
    }
}
