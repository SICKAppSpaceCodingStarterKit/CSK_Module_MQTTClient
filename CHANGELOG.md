# Changelog
All notable changes to this project will be documented in this file.

## Release 0.4.1

### Improvements
- Updated docu and added "Known issues" in README that data of registered events to be forwarded via MQTT are always published as converted data type "string".

### Bugfix
- Did not convert data of registered events to strings before trying to publish them via MQTT

## Release 0.4.0

### Improvements
- Renamed abbreviations (Id-ID, Ip-IP, Ui-UI, Mqtt-MQTT, Tls-TLS, Qos-QOS, Ca-CA)
- Using recursive helper functions to convert Container <-> Lua table

## Release 0.3.0

### Improvements
- Update to EmmyLua annotations
- Usage of lua diagnostics
- Documentation updates

### Bugfix
- Some Enum references were missed

## Release 0.2.0

### New features
- TLS, CleanSession, PeerVerification, CA Bundle, ClientCertification
- Check if running on SAE

### Improvements
- Loading only required APIs ('LuaLoadAllEngineAPI = false') -> less time for GC needed
- Improve behaviour when loading paramters
- Recreate MQTTClient handle to reset old configuration
- Use addSubscription within addSubscriptionViaUi
- Docu update

### Bugfix
- Do not save internal functions to forward incoming events within persistent parameters

## Release 0.1.0
- Initial commit