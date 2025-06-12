# device_settings_statuses

Very small flutter package to get live status information on a device's internet connection, airplane mode and DND mode stautsΩ

## Getting Started

Create an instance of ```DeviceSettingsStatuses()``` to begin listening to changes.

```DeviceSettingsStatuses.onSettingsChange()``` will stream any change and return a status which will be of type ```DeviceSettingsStatusesType```.

To listen to specific changes, call the methods ```listenAirplaneMode()```, ```listenInternetConnectivity()``` or ```listenDNDMode()```.
