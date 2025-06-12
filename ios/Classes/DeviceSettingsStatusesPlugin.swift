import Flutter
import Network
import UIKit
import CoreTelephony

public class DeviceSettingsStatusesPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
 private var eventSink: FlutterEventSink?
      private var monitor: NWPathMonitor?
      private var timer: Timer?
      private var airplaneState: Bool = false


  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterEventChannel(name: "pt.mbcsalmeida/device_settings_statuses_stream", binaryMessenger: registrar.messenger())
    let instance = DeviceSettingsStatusesPlugin()
    channel.setStreamHandler(instance)
  }

      func isAirplaneModeOn() -> Bool {
            let networkInfo = CTTelephonyNetworkInfo()
               guard let radioAccessTechnology = networkInfo.serviceCurrentRadioAccessTechnology else {
               return false
           }
           return radioAccessTechnology.isEmpty
        }

      public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        self.startMonitoring()
        return nil
      }

      public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        self.stopMonitoring()
        return nil
      }

      private func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
          guard let self = self else { return }
          if let eventSink = self.eventSink {
              let currentAirplaneState = self.isAirplaneModeOn()
              if(currentAirplaneState != airplaneState){
                  let msg = self.isAirplaneModeOn() ? "AIRPLANE_ON" : "AIRPLANE_OFF"
                  eventSink(msg)
              }
          }
        }

          checkInitialAirplaneMode()

          monitor = NWPathMonitor()
          monitor?.pathUpdateHandler = { path in
              if path.status == .satisfied {
                  print("Internet connection is available.")
                  if let eventSink = self.eventSink{
                      eventSink("CONNECTED")
                  }
              }
              else if path.status == .requiresConnection{
                  if let eventSink = self.eventSink{
                      eventSink("AIRPLANE_ON")
                  }
              }
              else {
                  print("Internet connection is not available.")
                  if let eventSink = self.eventSink{
                      eventSink("DISCONNECTED")
                  }
              }
          }
          let queue = DispatchQueue(label: "NetworkMonitor")
          monitor?.start(queue: queue)
      }

      private func stopMonitoring() {
        timer?.invalidate()

          monitor?.cancel()
        timer = nil
      }

        public func checkInitialAirplaneMode() {
            airplaneState = self.isAirplaneModeOn()
        let msg = airplaneState ? "AIRPLANE_ON" : "AIRPLANE_OFF"
        self.eventSink?(msg)
      }
}
