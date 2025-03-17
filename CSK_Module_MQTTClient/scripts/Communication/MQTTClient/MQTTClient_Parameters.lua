---@diagnostic disable: redundant-parameter, undefined-global

--***************************************************************
-- Inside of this script, you will find the relevant parameters
-- for this module and its default values
--***************************************************************

local functions = {}

local function getParameters()

  local mqttClientParameters = {}
  mqttClientParameters.flowConfigPriority = CSK_FlowConfig ~= nil or false -- Status if FlowConfig should have priority for FlowConfig relevant configurations

  mqttClientParameters.logAllMessages = true -- Status if all messages of send/received data should be logged on UI
  mqttClientParameters.connect = false -- Config if connection should be active
  mqttClientParameters.brokerIP = '192.168.1.100' -- IP of the MQTT broker
  mqttClientParameters.brokerPort = 1883 -- Default port for MQTT. If using TLS it should be 8883
  mqttClientParameters.connectionTimeout = 5000 -- The timeout to wait initially until the client gets connected
  mqttClientParameters.cleanSession = true -- Clean session flag. See MQTTClient docu of AppEngine
  mqttClientParameters.mqttClientID = 'CSK_MQTTClient' -- Sets the Client identifier of this MQTTClient instance.
  mqttClientParameters.tlsVersion = 'NO_TLS' -- TLS version to use
  mqttClientParameters.peerVerification = true -- Enables/disables peer verification
  mqttClientParameters.hostnameVerification = false -- Enables/disables hostname verification
  mqttClientParameters.useCredentials = false -- Enables/disables to use user credentials
  mqttClientParameters.username = 'user' -- Username if using user credentials

  mqttClientParameters.clientCertificateActive = false -- Enables/disables client certification
  mqttClientParameters.clientCertificatePath = 'public/cert.pem' -- Path to a certificate file in PEM/DER/PKCS#12 format.
  mqttClientParameters.clientCertificateKeyPath = 'public/privateKey.pem' -- Path to file containing the client’s private key in PEM/DER format.
  mqttClientParameters.clientCertificateKeyPassword = '' -- Optional passphrase for the private key. If empty, it will be ignored

  mqttClientParameters.caBundleActive = false -- Enables/disables to use certificate authority bundle
  mqttClientParameters.caBundlePath = 'public/CA.pem' -- Path to a certificate bundle in PEM format.

  mqttClientParameters.useWillMessage = false -- Enables/disables to use a will message
  mqttClientParameters.disconnectWithWillMessage = false -- Enables/disables sending a will message before intentionally disconnecting
  mqttClientParameters.willMessageTopic = '' -- Topic under which to publish the will message
  mqttClientParameters.willMessageData = '' -- The message payload to publish
  mqttClientParameters.willMessageQOS = 'QOS0' -- Quality of Service level
  mqttClientParameters.willMessageRetain = 'NO_RETAIN' -- Retaining a message means that the server stores the message and sends it to future subscribers of this topic.

  mqttClientParameters.keepAliveInterval = 60 -- The number of seconds after which a PING message should be sent if no other messages have been exchanged in that time. Disable keep alive mechanism with 0.
  mqttClientParameters.forwardReceives = false -- Enables/disables if module should forward incoming receives via event 'CSK_MQTTClient.OnReceive'

  mqttClientParameters.topicPrefix = '' -- Optional prefix for all topics

  mqttClientParameters.publishEvents = {} -- Register to these events to publish their content, see "addPublishEvent"
  mqttClientParameters.publishEvents.topic = {} -- Topic to publish to if event was notified
  mqttClientParameters.publishEvents.qos = {} -- QoS to publish if event was notified
  mqttClientParameters.publishEvents.retain = {} -- Retain option of publish if event was notified
  -- mqttClientParameters.publishEvents.topic[eventname] = 'topic/test' -- example
  -- mqttClientParameters.publishEvents.qos[eventname] = 'QOS0' -- example
  -- mqttClientParameters.publishEvents.retain[eventname] = 'NO_REATAIN' -- example

  mqttClientParameters.subscriptions = {} -- Topics to subscribe incl. QoS
  -- mqttClientParameters.subscriptions[topic] = QoS -- example for entries

  mqttClientParameters.interface = '' -- Interface to use
  mqttClientParameters.password = '' -- Password if using user credentials

  return mqttClientParameters
end
functions.getParameters = getParameters

return functions