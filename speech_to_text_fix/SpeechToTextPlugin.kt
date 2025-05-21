package com.csdcorp.speech_to_text

import android.Manifest
import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.speech.RecognitionListener
import android.speech.RecognizerIntent
import android.speech.SpeechRecognizer
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry

class SpeechToTextPlugin: FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.RequestPermissionsResultListener {
  private lateinit var channel : MethodChannel
  private var activity: Activity? = null
  private var speechRecognizer: SpeechRecognizer? = null
  private var recognizerIntent: Intent? = null
  private var isListening = false

  private val permissions = arrayOf(Manifest.permission.RECORD_AUDIO)

  private fun checkPermissions(): Boolean {
    var allGranted = true
    for (permission in permissions) {
      if (ContextCompat.checkSelfPermission(activity!!.applicationContext, permission) != PackageManager.PERMISSION_GRANTED) {
        allGranted = false
        break
      }
    }
    return allGranted
  }

  private fun requestPermissions() {
    ActivityCompat.requestPermissions(activity!!, permissions, 1)
  }

  private fun startListening() {
    if (checkPermissions()) {
      speechRecognizer?.setRecognitionListener(object : RecognitionListener {
        override fun onReadyForSpeech(params: Bundle?) {}

        override fun onBeginningOfSpeech() {}

        override fun onRmsChanged(rmsdB: Float) {}

        override fun onBufferReceived(buffer: ByteArray?) {}

        override fun onEndOfSpeech() {}

        override fun onError(error: Int) {
          isListening = false
        }

        override fun onResults(results: Bundle?) {
          isListening = false
          val matches = results?.getStringArrayList(SpeechRecognizer.RESULTS_RECOGNITION)
          // Handle the results here
        }

        override fun onPartialResults(partialResults: Bundle?) {}

        override fun onEvent(eventType: Int, params: Bundle?) {}
      })

      recognizerIntent = Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH).apply {
        putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL, RecognizerIntent.LANGUAGE_MODEL_FREE_FORM)
        putExtra(RecognizerIntent.EXTRA_CALLING_PACKAGE, activity!!.packageName)
      }

      speechRecognizer?.startListening(recognizerIntent)
      isListening = true
    } else {
      requestPermissions()
    }
  }

  private fun stopListening() {
    speechRecognizer?.stopListening()
    isListening = false
  }

  private fun initializeSpeechRecognizer() {
    if (SpeechRecognizer.isRecognitionAvailable(activity.applicationContext)) {
      speechRecognizer = SpeechRecognizer.createSpeechRecognizer(activity.applicationContext)
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "startListening" -> {
        startListening()
        result.success(null)
      }
      "stopListening" -> {
        stopListening()
        result.success(null)
      }
      else -> result.notImplemented()
    }
  }

  companion object {
    @JvmStatic
    fun registerWith(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
      val plugin = SpeechToTextPlugin()
      plugin.setupPlugin(flutterPluginBinding.binaryMessenger, null)
    }
  }

  private fun setupPlugin(messenger: BinaryMessenger, activity: Activity?) {
    channel = MethodChannel(messenger, "plugin.csdcorp.com/speech_to_text")
    channel.setMethodCallHandler(this)
    this.activity = activity
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    setupPlugin(binding.binaryMessenger, null)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    channel = null
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity
    binding.addRequestPermissionsResultListener(this)
  }

  override fun onDetachedFromActivity() {
    activity = null
  }

  private fun initializeIfPermitted(): Boolean {
    if (checkPermissions()) {
      initializeSpeechRecognizer()
      return true
    } else {
      requestPermissions()
    }
    return false
  }
}