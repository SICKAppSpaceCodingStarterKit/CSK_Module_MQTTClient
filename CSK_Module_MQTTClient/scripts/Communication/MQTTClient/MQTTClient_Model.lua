---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter
--*****************************************************************
-- Inside of this script, you will find the module definition
-- including its parameters and functions
--*****************************************************************

--**************************************************************************
--**********************Start Global Scope *********************************
--**************************************************************************

local tmr = Timer.create()
tmr:setExpirationTime(1000)
tmr:setPeriodic(true)

local nameOfModule = 'CSK_MQTTClient'

local mqttClient_Model = {}

-- Check if CSK_UserManagement module can be used if wanted
mqttClient_Model.userManagementModuleAvailable = CSK_UserManagement ~= nil or false

-- Check if CSK_PersistentData module can be used if wanted
mqttClient_Model.persistentModuleAvailable = CSK_PersistentData ~= nil or false

-- Default values for persistent data
-- If available, following values will be updated from data of CSK_PersistentData module (check CSK_PersistentData module for this)
mqttClient_Model.parametersName = 'CSK_MQTTClient_Parameter' -- name of parameter dataset to be used for this module
mqttClient_Model.parameterLoadOnReboot = false -- Status if parameter dataset should be loaded on app/device reboot

-- Load script to communicate with the MQTTClient_Model interface and give access
-- to the MQTTClient_Model object.
-- Check / edit this script to see/edit functions which communicate with the UI
local setMQTTClient_ModelHandle = require('Communication/MQTTClient/MQTTClient_Controller')
setMQTTClient_ModelHandle(mqttClient_Model)

--Loading helper functions if needed
mqttClient_Model.helperFuncs = require('Communication/MQTTClient/helper/funcs')
mqttClient_Model.ethernetPorts = Engine.getEnumValues("EthernetInterfaces") -- Available interfaces of device running the app
mqttClient_Model.ethernetPortsList = mqttClient_Model.helperFuncs.createJsonList(mqttClient_Model.ethernetPorts)

-- Get device type
local typeName = Engine.getTypeName()
if typeName == 'AppStudioEmulator' or typeName == 'SICK AppEngine' then
  mqttClient_Model.deviceType = 'AppEngine'
else
  mqttClient_Model.deviceType = string.sub(typeName, 1, 7)
end

-- Create parameters / instances for this module
mqttClient_Model.isConnected = false

mqttClient_Model.mqttClient = MQTTClient.create()

mqttClient_Model.tempSubscriptionTopic = '' -- temporary preset topic to subscribe
mqttClient_Model.tempSubscriptionQOS = 'QOS0' -- temporary preset qos of topic to subscribe

mqttClient_Model.tempPublishEvent = '' -- temporary preset name of event to register to publish its content
mqttClient_Model.tempPublishTopic = '' -- temporary preset topic to publish
mqttClient_Model.tempPublishData = '' -- temporary preset data to publish
mqttClient_Model.tempPublishQOS = 'QOS0' -- temporary preset qos of topic to publish preset data
mqttClient_Model.tempPublishRetain = 'NO_RETAIN' -- temporary preset retain flag of topic to publish preset data

mqttClient_Model.publishEventsFunctions = {} -- Function(s) to use to publish if event was notified

mqttClient_Model.key = '1234567890123456' -- key to encrypt passwords, should be adapted!

mqttClient_Model.messageLog = {} -- keep the latest 100 received messages

-- Parameters to be saved permanently if wanted
mqttClient_Model.parameters = {}

mqttClient_Model.parameters.connect = false -- Config if connection should be active
mqttClient_Model.parameters.brokerIP = '192.168.1.100' -- IP of the MQTT broker
mqttClient_Model.parameters.brokerPort = 1883 -- Default port for MQTT. If using TLS it should be 8883
mqttClient_Model.parameters.connectionTimeout = 5000 -- The timeout to wait initially until the client gets connected
mqttClient_Model.parameters.cleanSession = true -- Clean session flag. See MQTTClient docu of AppEngine
mqttClient_Model.parameters.mqttClientID = 'CSK_MQTTClient' -- Sets the Client identifier of this MQTTClient instance.
mqttClient_Model.parameters.tlsVersion = 'NO_TLS' -- TLS version to use
mqttClient_Model.parameters.peerVerification = true -- Enables/disables peer verification
mqttClient_Model.parameters.hostnameVerification = false -- Enables/disables hostname verification
mqttClient_Model.parameters.useCredentials = false -- Enables/disables to use user credentials
mqttClient_Model.parameters.username = 'user' -- Username if using user credentials
mqttClient_Model.parameters.password = Cipher.AES.encrypt('password', mqttClient_Model.key) -- Password if using user credentials

mqttClient_Model.parameters.clientCertificateActive = false -- Enables/disables client certification
mqttClient_Model.parameters.clientCertificatePath = 'public/cert.pem' -- Path to a certificate file in PEM/DER/PKCS#12 format.
mqttClient_Model.parameters.clientCertificateKeyPath = 'public/privateKey.pem' -- Path to file containing the client’s private key in PEM/DER format.
mqttClient_Model.parameters.clientCertificateKeyPassword = '' -- Optional passphrase for the private key. If empty, it will be ignored

mqttClient_Model.parameters.caBundleActive = false -- Enables/disables to use certificate authority bundle
mqttClient_Model.parameters.caBundlePath = 'public/CA.pem' -- Path to a certificate bundle in PEM format.

mqttClient_Model.parameters.useWillMessage = false -- Enables/disables to use a will message
mqttClient_Model.parameters.willMessageTopic = '' -- Topic under which to publish the will message
mqttClient_Model.parameters.willMessageData = '' -- The message payload to publish
mqttClient_Model.parameters.willMessageQOS = 'QOS0' -- Quality of Service level
mqttClient_Model.parameters.willMessageRetain = 'NO_RETAIN' -- Retaining a message means that the server stores the message and sends it to future subscribers of this topic.

mqttClient_Model.parameters.keepAliveInterval = 60 -- The number of seconds after which a PING message should be sent if no other messages have been exchanged in that time. Disable keep alive mechanism with 0.
mqttClient_Model.parameters.forwardReceives = false -- Enables/disables if module should forward incoming receives via event 'CSK_MQTTClient.OnReceive'

mqttClient_Model.parameters.publishEvents = {} -- Register to these events to publish their content, see "addPublishEvent"
mqttClient_Model.parameters.publishEvents.topic = {} -- Topic to publish to if event was notified
mqttClient_Model.parameters.publishEvents.qos = {} -- QoS to publish if event was notified
mqttClient_Model.parameters.publishEvents.retain = {} -- Retain option of publish if event was notified
-- mqttClient_Model.parameters.publishEvents.topic[eventname] = 'topic/test' -- example
-- mqttClient_Model.parameters.publishEvents.qos[eventname] = 'QOS0' -- example
-- mqttClient_Model.parameters.publishEvents.retain[eventname] = 'NO_REATAIN' -- example

mqttClient_Model.parameters.interface = mqttClient_Model.ethernetPorts[1] -- Select first of available ethernet interfaces

mqttClient_Model.parameters.subscriptions = {} -- Topics to subscribe incl. QoS
-- mqttClient_Model.parameters.subscriptions[topic] = QoS -- example for entries

--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

--- Function to create and notify internal MQTT log messages
local function sendLog()
  local tempLog2Send = ''
  for i=#mqttClient_Model.messageLog, 1, -1 do
    tempLog2Send = tempLog2Send .. mqttClient_Model.messageLog[i] .. '\n'
  end
  Script.notifyEvent('MQTTClient_OnNewLog', tempLog2Send)
end
mqttClient_Model.sendLog = sendLog

--- Function to add new message to internal MQTT log messages
---@param msg string Message
local function addMessageLog(msg)
  table.insert(mqttClient_Model.messageLog, 1, DateTime.getTime() .. ': ' .. msg)
  if #mqttClient_Model.messageLog == 200 then
    table.remove(mqttClient_Model.messageLog, 200)
  end
  sendLog()
end
mqttClient_Model.addMessageLog = addMessageLog

--- Function to react on "OnReceive" event of MQTT client
---@param topic string The topic the message was posted to
---@param data binary The payload data that was received
---@param qos MQTTClient.QOS The Quality of Service level
---@param retain MQTTClient.Retain The message retain flag
local function handleOnReceive(topic, data, qos, retain)

  addMessageLog('[Topic]: ' .. topic .. ', [Data]: ' .. tostring(data) .. ', [QoS]: ' .. qos .. ', [Retain]: ' .. retain)

  if mqttClient_Model.parameters.forwardReceives then
    Script.notifyEvent('MQTTClient_OnReceive', topic, data, qos, retain)
  end
end
MQTTClient.register(mqttClient_Model.mqttClient, 'OnReceive', handleOnReceive)

local function publish(topic, data, qos, retain)
  _G.logger:info(nameOfModule .. ": Publish data '" .. tostring(data) .. "' to topic '" .. topic .. "' with QoS '" .. qos .. "' and '" .. retain .. "'")
  addMessageLog("Publish data '" .. tostring(data) .. "' to topic '" .. topic .. "' with QoS '" .. qos .. "' and '" .. retain .. "'")
  MQTTClient.publish(mqttClient_Model.mqttClient, topic, tostring(data), qos, retain)
end
Script.serveFunction('CSK_MQTTClient.publish', publish)
mqttClient_Model.publish = publish

--- Function to subscribe to a topic on a MQTT broker
---@param topicFilter string The topic which to subscribe to.
---@param qos string Quality of Service level. Default is QOS0
local function subscribe(topicFilter, qos)
  _G.logger:info(nameOfModule .. ": Subscribe to topic '" .. topicFilter .. "' with QOS '" .. tostring(qos) .. "'")
  MQTTClient.subscribe(mqttClient_Model.mqttClient, topicFilter, qos)
end
mqttClient_Model.subscribe = subscribe

--- Function to subscribe to all configured topics
local function subscripeToAllTopics()
  for key, value in pairs(mqttClient_Model.parameters.subscriptions) do
    subscribe(key, value)
  end
end
mqttClient_Model.subscripeToAllTopics = subscripeToAllTopics

--- Function to react on "OnConnected" event of MQTT client
local function handleOnConnected()
  _G.logger:info(nameOfModule .. ": Connected to MQQT broker.")

  addMessageLog('Connected to MQQT broker.')

  mqttClient_Model.isConnected = true
  Script.notifyEvent("MQTTClient_OnNewStatusCurrentlyConnected", mqttClient_Model.isConnected)
  subscripeToAllTopics()
end
MQTTClient.register(mqttClient_Model.mqttClient, 'OnConnected', handleOnConnected)

--- Function to react on "OnDisconnected" event of MQTT client
local function handleOnDisconnected()
  _G.logger:info(nameOfModule .. ": Disconnected from MQQT broker.")
  addMessageLog('Disconnected from MQQT broker.')
  mqttClient_Model.isConnected = false
  Script.notifyEvent("MQTTClient_OnNewStatusCurrentlyConnected", mqttClient_Model.isConnected)
end
MQTTClient.register(mqttClient_Model.mqttClient, 'OnDisconnected', handleOnDisconnected)

--- Function to reset the MQTTClient
local function recreateMQTTClient()
  Script.releaseObject(mqttClient_Model.mqttClient)
  mqttClient_Model.mqttClient = MQTTClient.create()

  MQTTClient.register(mqttClient_Model.mqttClient, 'OnReceive', handleOnReceive)
  MQTTClient.register(mqttClient_Model.mqttClient, 'OnConnected', handleOnConnected)
  MQTTClient.register(mqttClient_Model.mqttClient, 'OnDisconnected', handleOnDisconnected)  
end
mqttClient_Model.recreateMQTTClient = recreateMQTTClient

--*************************************************************************
--********************** End Function Scope *******************************
--*************************************************************************

return mqttClient_Model
