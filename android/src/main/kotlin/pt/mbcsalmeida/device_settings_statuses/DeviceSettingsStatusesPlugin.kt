package pt.mbcsalmeida.device_settings_statuses

import android.annotation.SuppressLint
import android.annotation.TargetApi
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import android.util.Log
import android.provider.Settings
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

/** DeviceSettingsStatusesPlugin */
class DeviceSettingsStatusesPlugin: EventChannel.StreamHandler, FlutterPlugin {
  private val deviceStatusChannel = "pt.mbcsalmeida/device_settings_statuses_stream"

  private var eventSink: EventChannel.EventSink? = null
  private lateinit var connectivityManager: ConnectivityManager
  private var networkCallback: ConnectivityManager.NetworkCallback? = null
  private lateinit var eventChannel: EventChannel
  private lateinit var context: Context

  private val airplaneModeReceiver = object : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
      val isAirplaneModeOn = isAirModeOn()
      notifyNetworkStatus(if (isAirplaneModeOn) "AIRPLANE_ON" else "AIRPLANE_OFF")
    }
  }

  private val dndModeReceiver = object : BroadcastReceiver() {
    @RequiresApi(Build.VERSION_CODES.M)
    override fun onReceive(context: Context?, intent: Intent?) {
      val isDNDModeOn = isDNDModeOn()
      notifyNetworkStatus(if (isDNDModeOn) "DND_ON" else "DND_OFF")
    }
  }

  @TargetApi(Build.VERSION_CODES.M)
  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
    registerNetworkCallback()

    val airplaneFilter = IntentFilter(Intent.ACTION_AIRPLANE_MODE_CHANGED)
    context.registerReceiver(airplaneModeReceiver, airplaneFilter)

    val dndFilter = IntentFilter(NotificationManager.ACTION_INTERRUPTION_FILTER_CHANGED)
    context.registerReceiver(dndModeReceiver, dndFilter)

    checkInitialDNDStatus()
    checkInitialAirplaneMode()

    Log.d("DeviceSettingsSH", "LISTENING FOR EVENTS")
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
    unregisterNetworkCallback()
  }

  private fun registerNetworkCallback() {
    val networkRequest = NetworkRequest.Builder()
      .addCapability(NetworkCapabilities.NET_CAPABILITY_INTERNET)
      .build()

    networkCallback = object : ConnectivityManager.NetworkCallback() {
      override fun onAvailable(network: Network) {
        super.onAvailable(network)
        notifyNetworkStatus("CONNECTED")
      }

      override fun onLost(network: Network) {
        super.onLost(network)
        if (!isAirModeOn() && !isDNDModeOn()) {
          notifyNetworkStatus("DISCONNECTED")
        }
      }
    }

    connectivityManager.registerNetworkCallback(networkRequest, networkCallback!!)
  }

  private fun unregisterNetworkCallback() {
    networkCallback?.let { connectivityManager.unregisterNetworkCallback(it) }
  }

  private fun notifyNetworkStatus(status: String) {
    CoroutineScope(Dispatchers.Main).launch {
      eventSink?.success(status)
    }
  }

  private fun isDNDModeOn(): Boolean {
    val notificationManager =
      context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
    return notificationManager.currentInterruptionFilter != NotificationManager.INTERRUPTION_FILTER_ALL
  }

  private fun checkInitialDNDStatus() {
    val isDNDModeOn = isDNDModeOn()
    notifyNetworkStatus(if (isDNDModeOn) "DND_ON" else "DND_OFF")
  }

  private fun isAirModeOn(): Boolean {
    return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(context.contentResolver, Settings.Global.AIRPLANE_MODE_ON, 0) == 1
    } else {
      Settings.System.getInt(context.contentResolver, Settings.System.AIRPLANE_MODE_ON, 0) == 1
    }
  }

  private fun checkInitialAirplaneMode() {
    val isAirplaneModeOn = isAirModeOn()
    notifyNetworkStatus(if (isAirplaneModeOn) "AIRPLANE_ON" else "AIRPLANE_OFF")
  }

  override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel = EventChannel(binding.binaryMessenger, deviceStatusChannel)
    eventChannel.setStreamHandler(this)
    context = binding.applicationContext

    connectivityManager =
      context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    eventChannel.setStreamHandler(null)
  }
}

