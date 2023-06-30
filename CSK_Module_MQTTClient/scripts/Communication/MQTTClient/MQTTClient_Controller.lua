---@diagnostic disable: undefined-global, redundant-parameter, missing-parameter

--***************************************************************
-- Inside of this script, you will find the necessary functions,
-- variables and events to communicate with the MQTTClient_Model
--***************************************************************

--**************************************************************************
--************************ Start Global Scope ******************************
--**************************************************************************
local nameOfModule = 'CSK_MQTTClient'

-- Timer to update UI via events after page was loaded
local tmrMQTTClient = Timer.create()
tmrMQTTClient:setExpirationTime(300)
tmrMQTTClient:setPeriodic(false)

-- Reference to global handle
local mqttClient_Model

-- ************************ UI Events Start ********************************
Script.serveEvent('CSK_MQTTClient.OnReceive', 'MQTTClient_OnReceive')

Script.serveEvent('CSK_MQTTClient.OnNewStatusCurrentlyConnected', 'MQTTClient_OnNewStatusCurrentlyConnected')
Script.serveEvent('CSK_MQTTClient.OnNewStatusActivateConnection', 'MQTTClient_OnNewStatusActivateConnection')

Script.serveEvent('CSK_MQTTClient.OnNewMQTTPort', 'MQTTClient_OnNewMQTTPort')
Script.serveEvent('CSK_MQTTClient.OnNewBrokerIP', 'MQTTClient_OnNewBrokerIP')
Script.serveEvent('CSK_MQTTClient.OnNewStatusForwardReceivedMsg', 'MQTTClient_OnNewStatusForwardReceivedMsg')

Script.serveEvent('CSK_MQTTClient.OnNewStatusConnectionTimeout', 'MQTTClient_OnNewStatusConnectionTimeout')
Script.serveEvent('CSK_MQTTClient.OnNewStatusClientID', 'MQTTClient_OnNewStatusClientID')
Script.serveEvent('CSK_MQTTClient.OnNewStatusHostnameVerification', 'MQTTClient_OnNewStatusHostnameVerification')
Script.serveEvent('CSK_MQTTClient.OnNewStatusTLS', 'MQTTClient_OnNewStatusTLS')
Script.serveEvent('CSK_MQTTClient.OnNewStatusCleanSession', 'MQTTClient_OnNewStatusCleanSession')
Script.serveEvent('CSK_MQTTClient.OnNewStatusPeerVerification', 'MQTTClient_OnNewStatusPeerVerification')

Script.serveEvent('CSK_MQTTClient.OnNewStatusClientCertificateActive', 'MQTTClient_OnNewStatusClientCertificateActive')
Script.serveEvent('CSK_MQTTClient.OnNewStatusClientCertificatePath', 'MQTTClient_OnNewStatusClientCertificatePath')
Script.serveEvent('CSK_MQTTClient.OnNewstatusClientCertificateKeyPath', 'MQTTClient_OnNewstatusClientCertificateKeyPath')
Script.serveEvent('CSK_MQTTClient.OnNewStatusCABundleActive', 'MQTTClient_OnNewStatusCABundleActive')
Script.serveEvent('CSK_MQTTClient.OnNewStatusCABundlePath', 'MQTTClient_OnNewStatusCABundlePath')

Script.serveEvent('CSK_MQTTClient.OnNewStatusInterfaceList', 'MQTTClient_OnNewStatusInterfaceList')
Script.serveEvent('CSK_MQTTClient.OnNewStatusInterface', 'MQTTClient_OnNewStatusInterface')
Script.serveEvent('CSK_MQTTClient.OnNewStatusKeepAliveInterval', 'MQTTClient_OnNewStatusKeepAliveInterval')
Script.serveEvent('CSK_MQTTClient.OnNewStatusUseCredentials', 'MQTTClient_OnNewStatusUseCredentials')
Script.serveEvent('CSK_MQTTClient.OnNewStatusUsername', 'MQTTClient_OnNewStatusUsername')

Script.serveEvent('CSK_MQTTClient.OnNewLog', 'MQTTClient_OnNewLog')

Script.serveEvent('CSK_MQTTClient.OnNewStatusSubscriptionTopic', 'MQTTClient_OnNewStatusSubscriptionTopic')
Script.serveEvent('CSK_MQTTClient.OnNewStatusSubscriptionQOS', 'MQTTClient_OnNewStatusSubscriptionQOS')

Script.serveEvent('CSK_MQTTClient.OnNewStatusPublishEventName', 'MQTTClient_OnNewStatusPublishEventName')
Script.serveEvent('CSK_MQTTClient.OnNewStatusPublishTopic', 'MQTTClient_OnNewStatusPublishTopic')
Script.serveEvent('CSK_MQTTClient.OnNewStatusPublishData', 'MQTTClient_OnNewStatusPublishData')
Script.serveEvent('CSK_MQTTClient.OnNewStatusPublishQOS', 'MQTTClient_OnNewStatusPublishQOS')
Script.serveEvent('CSK_MQTTClient.OnNewStatusPublishRetain', 'MQTTClient_OnNewStatusPublishRetain')

Script.serveEvent('CSK_MQTTClient.OnNewStatusSubscriptionList', 'MQTTClient_OnNewStatusSubscriptionList')
Script.serveEvent('CSK_MQTTClient.OnNewStatusPublishEventList', 'MQTTClient_OnNewStatusPublishEventList')
Script.serveEvent('CSK_MQTTClient.OnNewStatusWillMessageActive', 'MQTTClient_OnNewStatusWillMessageActive')
Script.serveEvent('CSK_MQTTClient.OnNewStatusWillMessageConfig', 'MQTTClient_OnNewStatusWillMessageConfig')

Script.serveEvent("CSK_MQTTClient.OnNewStatusLoadParameterOnReboot", "MQTTClient_OnNewStatusLoadParameterOnReboot")
Script.serveEvent("CSK_MQTTClient.OnPersistentDataModuleAvailable", "MQTTClient_OnPersistentDataModuleAvailable")
Script.serveEvent("CSK_MQTTClient.OnNewParameterName", "MQTTClient_OnNewParameterName")
Script.serveEvent("CSK_MQTTClient.OnDataLoadedOnReboot", "MQTTClient_OnDataLoadedOnReboot")

Script.serveEvent('CSK_MQTTClient.OnUserLevelOperatorActive', 'MQTTClient_OnUserLevelOperatorActive')
Script.serveEvent('CSK_MQTTClient.OnUserLevelMaintenanceActive', 'MQTTClient_OnUserLevelMaintenanceActive')
Script.serveEvent('CSK_MQTTClient.OnUserLevelServiceActive', 'MQTTClient_OnUserLevelServiceActive')
Script.serveEvent('CSK_MQTTClient.OnUserLevelAdminActive', 'MQTTClient_OnUserLevelAdminActive')

-- ************************ UI Events End **********************************
--**************************************************************************
--********************** End Global Scope **********************************
--**************************************************************************
--**********************Start Function Scope *******************************
--**************************************************************************

-- Functions to forward logged in user roles via CSK_UserManagement module (if available)
-- ***********************************************
--- Function to react on status change of Operator user level
---@param status boolean Status if Operator level is active
local function handleOnUserLevelOperatorActive(status)
  Script.notifyEvent("MQTTClient_OnUserLevelOperatorActive", status)
end

--- Function to react on status change of Maintenance user level
---@param status boolean Status if Maintenance level is active
local function handleOnUserLevelMaintenanceActive(status)
  Script.notifyEvent("MQTTClient_OnUserLevelMaintenanceActive", status)
end

--- Function to react on status change of Service user level
---@param status boolean Status if Service level is active
local function handleOnUserLevelServiceActive(status)
  Script.notifyEvent("MQTTClient_OnUserLevelServiceActive", status)
end

--- Function to react on status change of Admin user level
---@param status boolean Status if Admin level is active
local function handleOnUserLevelAdminActive(status)
  Script.notifyEvent("MQTTClient_OnUserLevelAdminActive", status)
end

--- Function to get access to the mqttClient_Model object
---@param handle handle Handle of mqttClient_Model object
local function setMQTTClient_Model_Handle(handle)
  mqttClient_Model = handle
  if mqttClient_Model.userManagementModuleAvailable then
    -- Register on events of CSK_UserManagement module if available
    Script.register('CSK_UserManagement.OnUserLevelOperatorActive', handleOnUserLevelOperatorActive)
    Script.register('CSK_UserManagement.OnUserLevelMaintenanceActive', handleOnUserLevelMaintenanceActive)
    Script.register('CSK_UserManagement.OnUserLevelServiceActive', handleOnUserLevelServiceActive)
    Script.register('CSK_UserManagement.OnUserLevelAdminActive', handleOnUserLevelAdminActive)
  end
  Script.releaseObject(handle)
end

--- Function to update user levels
local function updateUserLevel()
  if mqttClient_Model.userManagementModuleAvailable then
    -- Trigger CSK_UserManagement module to provide events regarding user role
    CSK_UserManagement.pageCalled()
  else
    -- If CSK_UserManagement is not active, show everything
    Script.notifyEvent("MQTTClient_OnUserLevelAdminActive", true)
    Script.notifyEvent("MQTTClient_OnUserLevelMaintenanceActive", true)
    Script.notifyEvent("MQTTClient_OnUserLevelServiceActive", true)
    Script.notifyEvent("MQTTClient_OnUserLevelOperatorActive", true)
  end
end

--- Function to send all relevant values to UI on resume
local function handleOnExpiredTmrMQTTClient()

  updateUserLevel()

  Script.notifyEvent("MQTTClient_OnNewStatusCurrentlyConnected", mqttClient_Model.isConnected)
  Script.notifyEvent("MQTTClient_OnNewStatusActivateConnection", mqttClient_Model.parameters.connect)

  Script.notifyEvent("MQTTClient_OnNewBrokerIP", mqttClient_Model.parameters.brokerIP)
  Script.notifyEvent("MQTTClient_OnNewMQTTPort", mqttClient_Model.parameters.brokerPort)

  Script.notifyEvent("MQTTClient_OnNewStatusConnectionTimeout", mqttClient_Model.parameters.connectionTimeout)
  Script.notifyEvent("MQTTClient_OnNewStatusClientID", mqttClient_Model.parameters.mqttClientID)
  Script.notifyEvent("MQTTClient_OnNewStatusCleanSession", mqttClient_Model.parameters.cleanSession)
  Script.notifyEvent("MQTTClient_OnNewStatusTLS", mqttClient_Model.parameters.tlsVersion)
  Script.notifyEvent("MQTTClient_OnNewStatusHostnameVerification", mqttClient_Model.parameters.hostnameVerification)
  Script.notifyEvent("MQTTClient_OnNewStatusPeerVerification", mqttClient_Model.parameters.peerVerification)

  Script.notifyEvent("MQTTClient_OnNewStatusClientCertificateActive", mqttClient_Model.parameters.clientCertificateActive)
  Script.notifyEvent("MQTTClient_OnNewStatusClientCertificatePath", mqttClient_Model.parameters.clientCertificatePath)
  Script.notifyEvent("MQTTClient_OnNewstatusClientCertificateKeyPath", mqttClient_Model.parameters.clientCertificateKeyPath)
  Script.notifyEvent("MQTTClient_OnNewStatusCABundleActive", mqttClient_Model.parameters.caBundleActive)
  Script.notifyEvent("MQTTClient_OnNewStatusCABundlePath", mqttClient_Model.parameters.caBundlePath)

  Script.notifyEvent("MQTTClient_OnNewStatusInterfaceList", mqttClient_Model.ethernetPortsList)
  Script.notifyEvent("MQTTClient_OnNewStatusInterface", mqttClient_Model.parameters.interface)
  Script.notifyEvent("MQTTClient_OnNewStatusKeepAliveInterval", mqttClient_Model.parameters.keepAliveInterval)
  Script.notifyEvent("MQTTClient_OnNewStatusUseCredentials", mqttClient_Model.parameters.useCredentials)
  Script.notifyEvent("MQTTClient_OnNewStatusUsername", mqttClient_Model.parameters.username)

  Script.notifyEvent("MQTTClient_OnNewStatusForwardReceivedMsg", mqttClient_Model.parameters.forwardReceives)

  Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionTopic", mqttClient_Model.tempSubscriptionTopic)
  Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionQOS", mqttClient_Model.tempSubscriptionQOS)
  Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionList", mqttClient_Model.helperFuncs.createJsonListSubscriptions(mqttClient_Model.parameters.subscriptions))
  Script.notifyEvent("MQTTClient_OnNewStatusPublishEventList", mqttClient_Model.helperFuncs.createJsonListPublishEvents(mqttClient_Model.parameters.publishEvents))

  Script.notifyEvent("MQTTClient_OnNewStatusPublishEventName", mqttClient_Model.tempPublishEvent)
  Script.notifyEvent("MQTTClient_OnNewStatusPublishTopic", mqttClient_Model.tempPublishTopic)
  Script.notifyEvent("MQTTClient_OnNewStatusPublishData", mqttClient_Model.tempPublishData)
  Script.notifyEvent("MQTTClient_OnNewStatusPublishQOS", mqttClient_Model.tempPublishQOS)
  Script.notifyEvent("MQTTClient_OnNewStatusPublishRetain", mqttClient_Model.tempPublishRetain)

  Script.notifyEvent("MQTTClient_OnNewStatusWillMessageActive", mqttClient_Model.parameters.useWillMessage)
  Script.notifyEvent("MQTTClient_OnNewStatusWillMessageConfig", "Topic = '" .. mqttClient_Model.parameters.willMessageTopic ..
                                                                "', Data = '" .. mqttClient_Model.parameters.willMessageData ..
                                                                "', QoS = '" .. mqttClient_Model.parameters.willMessageQOS ..
                                                                "', Retain = '" .. mqttClient_Model.parameters.willMessageRetain)

  mqttClient_Model.sendLog()

  Script.notifyEvent("MQTTClient_OnNewStatusLoadParameterOnReboot", mqttClient_Model.parameterLoadOnReboot)
  Script.notifyEvent("MQTTClient_OnPersistentDataModuleAvailable", mqttClient_Model.persistentModuleAvailable)
  Script.notifyEvent("MQTTClient_OnNewParameterName", mqttClient_Model.parametersName)
end
Timer.register(tmrMQTTClient, "OnExpired", handleOnExpiredTmrMQTTClient)

-- ********************* UI Setting / Submit Functions Start ********************

local function pageCalled()
  updateUserLevel() -- try to hide user specific content asap
  tmrMQTTClient:start()
  return ''
end
Script.serveFunction("CSK_MQTTClient.pageCalled", pageCalled)

local function getMQTTHandle()
  return mqttClient_Model.mqttClient
end
Script.serveFunction('CSK_MQTTClient.getMQTTHandle', getMQTTHandle)

local function connectMQTT(status)
  _G.logger:info(nameOfModule .. ": Set connection status to " .. tostring(status))

  mqttClient_Model.parameters.connect = status

  if status == true then
    mqttClient_Model.recreateMQTTClient()
    MQTTClient.setIPAddress(mqttClient_Model.mqttClient, mqttClient_Model.parameters.brokerIP)
    MQTTClient.setPort(mqttClient_Model.mqttClient, mqttClient_Model.parameters.brokerPort)
    MQTTClient.setClientID(mqttClient_Model.mqttClient, mqttClient_Model.parameters.mqttClientID)
    MQTTClient.setCleanSession(mqttClient_Model.mqttClient, mqttClient_Model.parameters.cleanSession)

    if mqttClient_Model.deviceType ~= 'AppEngine' then
      MQTTClient.setInterface(mqttClient_Model.mqttClient, mqttClient_Model.parameters.interface)
    end
    MQTTClient.setKeepAliveInterval(mqttClient_Model.mqttClient, mqttClient_Model.parameters.keepAliveInterval)
    if mqttClient_Model.parameters.useCredentials then
      MQTTClient.setUserCredentials(mqttClient_Model.mqttClient, mqttClient_Model.parameters.username, Cipher.AES.decrypt(mqttClient_Model.parameters.passwords, mqttClient_Model.key))
    end
    if mqttClient_Model.parameters.useWillMessage then
      MQTTClient.setWillMessage(mqttClient_Model.mqttClient, mqttClient_Model.parameters.willMessageTopic, mqttClient_Model.parameters.willMessageData, mqttClient_Model.parameters.willMessageQOS, mqttClient_Model.parameters.willMessageRetain)
    end

    if mqttClient_Model.parameters.tlsVersion == 'NO_TLS' then
      MQTTClient.setTLSEnabled(mqttClient_Model.mqttClient, false)
      _G.logger:info(nameOfModule .. ": TLS and related features not enabled.")
    else
      MQTTClient.setTLSEnabled(mqttClient_Model.mqttClient, true)
      MQTTClient.setTLSVersion(mqttClient_Model.mqttClient, mqttClient_Model.parameters.tlsVersion)
      MQTTClient.setHostnameVerification(mqttClient_Model.mqttClient, mqttClient_Model.parameters.hostnameVerification)
      MQTTClient.setPeerVerification(mqttClient_Model.mqttClient, mqttClient_Model.parameters.peerVerification)

      if mqttClient_Model.parameters.clientCertificateActive == true then
        if mqttClient_Model.parameters.clientCertificateKeyPassword ~= '' then
          MQTTClient.setClientCertificate(mqttClient_Model.mqttClient, mqttClient_Model.parameters.clientCertificatePath, mqttClient_Model.parameters.clientCertificateKeyPath)
        else
          MQTTClient.setClientCertificate(mqttClient_Model.mqttClient, mqttClient_Model.parameters.clientCertificatePath, mqttClient_Model.parameters.clientCertificateKeyPath, Cipher.AES.decrypt(mqttClient_Model.parameters.clientCertificateKeyPassword, mqttClient_Model.key))
        end
      end

      if mqttClient_Model.parameters.caBundleActive == true then
        MQTTClient.setCABundle(mqttClient_Model.mqttClient, mqttClient_Model.parameters.caBundlePath)
      end
    end

    MQTTClient.connect(mqttClient_Model.mqttClient, mqttClient_Model.parameters.connectionTimeout)
  else
    MQTTClient.disconnect(mqttClient_Model.mqttClient)
  end
end
Script.serveFunction('CSK_MQTTClient.connectMQTT', connectMQTT)

local function setBrokerIP(ip)
  _G.logger:info(nameOfModule .. ": Set IP to " .. ip)
  mqttClient_Model.parameters.brokerIP = ip
end
Script.serveFunction('CSK_MQTTClient.setBrokerIP', setBrokerIP)

local function setMQTTPort(port)
  _G.logger:info(nameOfModule .. ": Set port to " .. tostring(port))
  mqttClient_Model.parameters.brokerPort = port
end
Script.serveFunction('CSK_MQTTClient.setMQTTPort', setMQTTPort)

local function setForwardReceivedMessages(status)
  _G.logger:info(nameOfModule .. ": Set status to forward received messages to " .. tostring(status))
  mqttClient_Model.parameters.forwardReceives = status
end
Script.serveFunction('CSK_MQTTClient.setForwardReceivedMessages', setForwardReceivedMessages)

local function setConnectionTimeout(time)
  _G.logger:info(nameOfModule .. ": Set connection timeout to " .. tostring(time) .. "ms.")
  mqttClient_Model.parameters.connectionTimeout = time
end
Script.serveFunction('CSK_MQTTClient.setConnectionTimeout', setConnectionTimeout)

local function setClientID(id)
  _G.logger:info(nameOfModule .. ": Set client ID to '" .. id .. "'")
  mqttClient_Model.parameters.mqttClientID = id
end
Script.serveFunction('CSK_MQTTClient.setClientID', setClientID)

local function setTLSVersion(version)
  _G.logger:info(nameOfModule .. ": Set TLS version to '" .. version .. "'")
  mqttClient_Model.parameters.tlsVersion = version
end
Script.serveFunction('CSK_MQTTClient.setTLSVersion', setTLSVersion)

--- Function to check if TLS is activated
local function checkTLS()
  if mqttClient_Model.parameters.tlsVersion == 'NO_TLS' then
    -- TLS needs to be activated if hostname verification should be active
    setTLSVersion('TLS_V12')
    Script.notifyEvent("MQTTClient_OnNewStatusTLS", mqttClient_Model.parameters.tlsVersion)
  end
end

local function setHostnameVerification(status)
  _G.logger:info(nameOfModule .. ": Set hostname verification to " .. tostring(status))
  mqttClient_Model.parameters.hostnameVerification = status
  if status == true then
    checkTLS()
  end
end
Script.serveFunction('CSK_MQTTClient.setHostnameVerification', setHostnameVerification)

local function setInterface(interface)
  _G.logger:info(nameOfModule .. ": Set interface to " .. interface)
  mqttClient_Model.parameters.interface = interface
end
Script.serveFunction('CSK_MQTTClient.setInterface', setInterface)

local function setKeepAliveInterval(time)
  _G.logger:info(nameOfModule .. ": Set keep alive interval to " .. tostring(time))
  mqttClient_Model.parameters.keepAliveInterval = time
end
Script.serveFunction('CSK_MQTTClient.setKeepAliveInterval', setKeepAliveInterval)

local function setUsername(username)
  _G.logger:info(nameOfModule .. ": Set username to '" .. username .. "'")
  mqttClient_Model.parameters.username = username
end
Script.serveFunction('CSK_MQTTClient.setUsername', setUsername)

local function setPassword(password)
  _G.logger:info(nameOfModule .. ": Set password.")
  mqttClient_Model.parameters.passwords = Cipher.AES.encrypt(password, mqttClient_Model.key)
end
Script.serveFunction('CSK_MQTTClient.setPassword', setPassword)

local function setUseCredentials(status)
  _G.logger:info(nameOfModule .. ": Set usage of credentials to " .. tostring(status))
  mqttClient_Model.parameters.useCredentials = status
  if status then
    MQTTClient.setUserCredentials(mqttClient_Model.mqttClient, mqttClient_Model.parameters.username, Cipher.AES.decrypt(mqttClient_Model.parameters.passwords, mqttClient_Model.key))
  end
end
Script.serveFunction('CSK_MQTTClient.setUseCredentials', setUseCredentials)

local function setCleanSession(status)
  _G.logger:info(nameOfModule .. ": Set status of Clean Session to " .. tostring(status))
  mqttClient_Model.parameters.cleanSession = status
end
Script.serveFunction('CSK_MQTTClient.setCleanSession', setCleanSession)

local function setPeerVerification(status)
  _G.logger:info(nameOfModule .. ": Set peer verification to " .. tostring(status))
  mqttClient_Model.parameters.peerVerification = status
  if status == true then
    checkTLS()
  end
end
Script.serveFunction('CSK_MQTTClient.setPeerVerification', setPeerVerification)

local function setUseClientCertificate(status)
  _G.logger:info(nameOfModule .. ": Set status to use client certificate to " .. tostring(status))
  mqttClient_Model.parameters.clientCertificateActive = status
  if status == true then
    checkTLS()
  end
end
Script.serveFunction('CSK_MQTTClient.setUseClientCertificate', setUseClientCertificate)

local function setClientCertificatePath(path)
  _G.logger:info(nameOfModule .. ": Set path to client certificate to '" .. path .. "'")
  mqttClient_Model.parameters.clientCertificatePath = path
end
Script.serveFunction('CSK_MQTTClient.setClientCertificatePath', setClientCertificatePath)

local function setClientCertificateKeyPath(path)
  _G.logger:info(nameOfModule .. ": Set path to client certificate key to '" .. path .. "'")
  mqttClient_Model.parameters.clientCertificatePath = path
end
Script.serveFunction('CSK_MQTTClient.setClientCertificateKeyPath', setClientCertificateKeyPath)

local function setClientCertificateKeyPassword(password)
  _G.logger:info(nameOfModule .. ": Set password for client certificate key.")
  if password == '' then
    mqttClient_Model.parameters.clientCertificateKeyPassword = ''
  else
    mqttClient_Model.parameters.clientCertificateKeyPassword = Cipher.AES.encrypt(password, mqttClient_Model.key)
  end
end
Script.serveFunction('CSK_MQTTClient.setClientCertificateKeyPassword', setClientCertificateKeyPassword)

local function setUseCABundle(status)
  _G.logger:info(nameOfModule .. ": Set status to use CA bundle to " .. tostring(status))
  mqttClient_Model.parameters.caBundleActive = status
  if status == true then
    checkTLS()
  end
end
Script.serveFunction('CSK_MQTTClient.setUseCABundle', setUseCABundle)

local function setCABundlePath(path)
  _G.logger:info(nameOfModule .. ": Set path to CA bundle to '" .. path .. "'")
  mqttClient_Model.parameters.caBundlePath = path
end
Script.serveFunction('CSK_MQTTClient.setCABundlePath', setCABundlePath)

---------------------------------------------------
------------------ Subscriptions ------------------
---------------------------------------------------

local function presetSubscriptionTopic(topic)
  mqttClient_Model.tempSubscriptionTopic = topic
end
Script.serveFunction('CSK_MQTTClient.presetSubscriptionTopic', presetSubscriptionTopic)

local function presetSubscriptionQOS(qos)
  mqttClient_Model.tempSubscriptionQOS = qos
end
Script.serveFunction('CSK_MQTTClient.presetSubscriptionQOS', presetSubscriptionQOS)

local function addSubscription(topicFilter, qos)
  _G.logger:info(nameOfModule .. ": Add subcription to topic '" .. tostring(topicFilter) .. "' with QoS of '" .. tostring(qos) .. "'")
  mqttClient_Model.parameters.subscriptions[topicFilter] = qos
  Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionList", mqttClient_Model.helperFuncs.createJsonListSubscriptions(mqttClient_Model.parameters.subscriptions))
  if mqttClient_Model.isConnected then
    mqttClient_Model.subscribe(mqttClient_Model.tempSubscriptionTopic, mqttClient_Model.tempSubscriptionQOS)
  end
end
Script.serveFunction('CSK_MQTTClient.addSubscription', addSubscription)

local function addSubscriptionViaUI()
  addSubscription(mqttClient_Model.tempSubscriptionTopic, mqttClient_Model.tempSubscriptionQOS)
end
Script.serveFunction('CSK_MQTTClient.addSubscriptionViaUI', addSubscriptionViaUI)

--- Function to check if selection in UIs DynamicTable can find related pattern
---@param selection string Full text of selection
---@param pattern string Pattern to search for
local function checkSelection(selection, pattern)
  if selection ~= "" then
    local _, pos = string.find(selection, pattern)
    if pos == nil then
    else
      pos = tonumber(pos)
      local endPos = string.find(selection, '"', pos+1)
      local tempSelection = string.sub(selection, pos+1, endPos-1)
      if tempSelection ~= nil and tempSelection ~= '-' then
        return tempSelection
      end
    end
  end
  return nil
end

local function selectSubscription(selection)
  local tempSelection = checkSelection(selection, '"DTC_SubTopic":"')
  if tempSelection ~= nil and tempSelection ~= '-' then
    mqttClient_Model.tempSubscriptionTopic = tempSelection
    mqttClient_Model.tempSubscriptionQOS = mqttClient_Model.parameters.subscriptions[tempSelection]
    Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionTopic", mqttClient_Model.tempSubscriptionTopic)
    Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionQOS", mqttClient_Model.tempSubscriptionQOS)
  end
end
Script.serveFunction('CSK_MQTTClient.selectSubscriptionViaUI', selectSubscription)

local function unsubscribe(topic)
  if mqttClient_Model.parameters.subscriptions[topic] then
    _G.logger:info(nameOfModule .. ": Unsubscribe from topic '" .. topic .. "'")
    mqttClient_Model.parameters.subscriptions[topic] = nil
    Script.notifyEvent("MQTTClient_OnNewStatusSubscriptionList", mqttClient_Model.helperFuncs.createJsonListSubscriptions(mqttClient_Model.parameters.subscriptions))

    if mqttClient_Model.isConnected then
      MQTTClient.unsubscribe(mqttClient_Model.mqttClient, topic)
    end
  else
    _G.logger:info(nameOfModule .. ": Topic to unsubscribe not available: '" .. topic .. "'")
  end
end
Script.serveFunction('CSK_MQTTClient.unsubscribe', unsubscribe)

local function unsubscribeViaUI()
  if mqttClient_Model.tempSubscriptionTopic ~= '' then
    unsubscribe(mqttClient_Model.tempSubscriptionTopic)
  end
end
Script.serveFunction('CSK_MQTTClient.unsubscribeViaUI', unsubscribeViaUI)

---------------------------------------------
------------------ Publish ------------------
---------------------------------------------

local function presetPublishTopic(topic)
  mqttClient_Model.tempPublishTopic = topic
end
Script.serveFunction('CSK_MQTTClient.presetPublishTopic', presetPublishTopic)

local function presetPublishData(data)
  mqttClient_Model.tempPublishData = data
end
Script.serveFunction('CSK_MQTTClient.presetPublishData', presetPublishData)

local function presetPublishQOS(qos)
  mqttClient_Model.tempPublishQOS = qos
end
Script.serveFunction('CSK_MQTTClient.presetPublishQOS', presetPublishQOS)

local function presetPublishRetain(status)
  mqttClient_Model.tempPublishRetain = status
end
Script.serveFunction('CSK_MQTTClient.presetPublishRetain', presetPublishRetain)

local function publishViaUI()
  mqttClient_Model.publish(mqttClient_Model.tempPublishTopic, mqttClient_Model.tempPublishData, mqttClient_Model.tempPublishQOS, mqttClient_Model.tempPublishRetain)
end
Script.serveFunction('CSK_MQTTClient.publishViaUI', publishViaUI)

local function presetPublishEvent(name)
  mqttClient_Model.tempPublishEvent = name
end
Script.serveFunction('CSK_MQTTClient.presetPublishEvent', presetPublishEvent)

--- Function to create internal publish functions
---@param event string Name of event to register (event with one parameter expected)
---@param topic string Data content of the event will be publsihed to this MQTT topic
---@param qos string QoS of publish message
---@param retain string Retain option of the publish
local function createInternalPublishFunctions(event, topic, qos, retain)

  local function triggerPublish(event, data)
    if mqttClient_Model.isConnected then
      mqttClient_Model.publish(mqttClient_Model.parameters.publishEvents.topic[event], data, mqttClient_Model.parameters.publishEvents.qos[event], mqttClient_Model.parameters.publishEvents.retain[event])
    else
      _G.logger:info(nameOfModule .. ": Publish not possible because not connected")
    end
  end

  local function forwardContent(data)
    triggerPublish(event, data)
  end
  mqttClient_Model.publishEventsFunctions[event] = forwardContent

  if Script.isServedAsEvent(event) then
    _G.logger:info(nameOfModule .. ": Register to event '" .. event .. "' to forward its content via MQTT publish on topic '" .. topic .. "'")
    Script.register(event, mqttClient_Model.publishEventsFunctions[event])
  else
    _G.logger:info(nameOfModule .. ": Not possible to register to event '" .. event .. "' as it seems not to be available.")
  end
end

local function addPublishEvent(event, topic, qos, retain)
  mqttClient_Model.parameters.publishEvents.topic[event] = topic
  mqttClient_Model.parameters.publishEvents.qos[event] = qos
  mqttClient_Model.parameters.publishEvents.retain[event] = retain

  Script.notifyEvent("MQTTClient_OnNewStatusPublishEventList", mqttClient_Model.helperFuncs.createJsonListPublishEvents(mqttClient_Model.parameters.publishEvents))

  createInternalPublishFunctions(event, topic, qos, retain)

end
Script.serveFunction('CSK_MQTTClient.addPublishEvent', addPublishEvent)

local function addPublishEventViaUI()
  if mqttClient_Model.tempPublishEvent ~= '' then
    addPublishEvent(mqttClient_Model.tempPublishEvent, mqttClient_Model.tempPublishTopic, mqttClient_Model.tempPublishQOS, mqttClient_Model.tempPublishRetain)
  end
end
Script.serveFunction('CSK_MQTTClient.addPublishEventViaUI', addPublishEventViaUI)

local function removePublishEvent(event)
  if mqttClient_Model.parameters.publishEvents.topic[event] then

    _G.logger:info(nameOfModule .. ": Deregister from event '" .. event .. "' and remove this from the list.")
    mqttClient_Model.parameters.publishEvents.topic[event] = nil
    mqttClient_Model.parameters.publishEvents.qos[event] = nil
    mqttClient_Model.parameters.publishEvents.retain[event] = nil

    Script.deregister(event, mqttClient_Model.publishEventsFunctions[event])
    mqttClient_Model.publishEventsFunctions[event] = nil

    Script.notifyEvent("MQTTClient_OnNewStatusPublishEventList", mqttClient_Model.helperFuncs.createJsonListPublishEvents(mqttClient_Model.parameters.publishEvents))
  else

    _G.logger:info(nameOfModule .. ": Not possible to deregister from event '" .. event .. "'.")
  end
end
Script.serveFunction('CSK_MQTTClient.removePublishEvent', removePublishEvent)

local function removePublishEventViaUI()
  removePublishEvent(mqttClient_Model.tempPublishEvent)
end
Script.serveFunction('CSK_MQTTClient.removePublishEventViaUI', removePublishEventViaUI)

local function selectPublishEvent(selection)
  local tempSelection = checkSelection(selection, '"DTC_Event":"')
  if tempSelection ~= nil and tempSelection ~= '-' then
    mqttClient_Model.tempPublishEvent = tempSelection
    mqttClient_Model.tempPublishTopic = mqttClient_Model.parameters.publishEvents.topic[tempSelection]
    mqttClient_Model.tempPublishQOS = mqttClient_Model.parameters.publishEvents.qos[tempSelection]
    mqttClient_Model.tempPublishRetain  = mqttClient_Model.parameters.publishEvents.retain[tempSelection]

    Script.notifyEvent("MQTTClient_OnNewStatusPublishEventName", mqttClient_Model.tempPublishEvent)
    Script.notifyEvent("MQTTClient_OnNewStatusPublishTopic", mqttClient_Model.tempPublishTopic)
    Script.notifyEvent("MQTTClient_OnNewStatusPublishQOS", mqttClient_Model.tempPublishQOS)
    Script.notifyEvent("MQTTClient_OnNewStatusPublishRetain", mqttClient_Model.tempPublishRetain)
  end
end
Script.serveFunction('CSK_MQTTClient.selectPublishEvent', selectPublishEvent)

local function setWillMessageActivation(status)
  _G.logger:info(nameOfModule .. ": Set WillMessage activation to " .. tostring(status))
  mqttClient_Model.parameters.useWillMessage = status
end
Script.serveFunction('CSK_MQTTClient.setWillMessageActivation', setWillMessageActivation)

local function setWillMessageConfig(topic, data, qos, retain)
  _G.logger:info(nameOfModule .. ": Set WillMessage config with data '" .. data .. "' to topic '" .. topic .. "' with QoS '" .. qos .. "' and '" .. retain .. "'")
  mqttClient_Model.parameters.willMessageTopic = topic
  mqttClient_Model.parameters.willMessageData = data
  mqttClient_Model.parameters.willMessageQOS = qos
  mqttClient_Model.parameters.willMessageRetain = retain

  Script.notifyEvent("MQTTClient_OnNewStatusWillMessageConfig", "Topic = '" .. mqttClient_Model.parameters.willMessageTopic ..
                                                             "', Data = '" .. mqttClient_Model.parameters.willMessageData ..
                                                             "', QoS = '" .. mqttClient_Model.parameters.willMessageQOS ..
                                                             "', Retain = '" .. mqttClient_Model.parameters.willMessageRetain)

end
Script.serveFunction('CSK_MQTTClient.setWillMessageConfig', setWillMessageConfig)

local function setWillMessageConfigViaUI()
  setWillMessageConfig(mqttClient_Model.tempPublishTopic, mqttClient_Model.tempPublishData, mqttClient_Model.tempPublishQOS, mqttClient_Model.tempPublishRetain)
end
Script.serveFunction('CSK_MQTTClient.setWillMessageConfigViaUI', setWillMessageConfigViaUI)

------------------------------------------------------

-- *****************************************************************
-- Following functions can be adapted for CSK_PersistentData module usage
-- *****************************************************************

local function setParameterName(name)
  _G.logger:info(nameOfModule .. ": Set parameter name: " .. tostring(name))
  mqttClient_Model.parametersName = name
end
Script.serveFunction("CSK_MQTTClient.setParameterName", setParameterName)

local function sendParameters()
  if mqttClient_Model.persistentModuleAvailable then
    CSK_PersistentData.addParameter(mqttClient_Model.helperFuncs.convertTable2Container(mqttClient_Model.parameters), mqttClient_Model.parametersName)
    CSK_PersistentData.setModuleParameterName(nameOfModule, mqttClient_Model.parametersName, mqttClient_Model.parameterLoadOnReboot)
    _G.logger:info(nameOfModule .. ": Send MQTTClient parameters with name '" .. mqttClient_Model.parametersName .. "' to CSK_PersistentData module.")
    CSK_PersistentData.saveData()
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_MQTTClient.sendParameters", sendParameters)

local function loadParameters()
  if mqttClient_Model.persistentModuleAvailable then
    local data = CSK_PersistentData.getParameter(mqttClient_Model.parametersName)
    if data then
      _G.logger:info(nameOfModule .. ": Loaded parameters from CSK_PersistentData module.")

      for key in pairs(mqttClient_Model.parameters.publishEvents.topic) do
        Script.deregister(key, mqttClient_Model.publishEventsFunctions[key])
      end

      mqttClient_Model.parameters = mqttClient_Model.helperFuncs.convertContainer2Table(data)
      mqttClient_Model.publishEventsFunctions = {}

      -- Configured/activated with new loaded data
      for key in pairs(mqttClient_Model.parameters.publishEvents.topic) do
        createInternalPublishFunctions(key, mqttClient_Model.parameters.publishEvents.topic[key], mqttClient_Model.parameters.publishEvents.qos[key], mqttClient_Model.parameters.publishEvents.retain[key])
      end
      connectMQTT(mqttClient_Model.parameters.connect)

      CSK_MQTTClient.pageCalled()
    else
      _G.logger:warning(nameOfModule .. ": Loading parameters from CSK_PersistentData module did not work.")
    end
  else
    _G.logger:warning(nameOfModule .. ": CSK_PersistentData module not available.")
  end
end
Script.serveFunction("CSK_MQTTClient.loadParameters", loadParameters)

local function setLoadOnReboot(status)
  mqttClient_Model.parameterLoadOnReboot = status
  _G.logger:info(nameOfModule .. ": Set new status to load setting on reboot: " .. tostring(status))
end
Script.serveFunction("CSK_MQTTClient.setLoadOnReboot", setLoadOnReboot)

--- Function to react on initial load of persistent parameters
local function handleOnInitialDataLoaded()

  if string.sub(CSK_PersistentData.getVersion(), 1, 1) == '1' then

    _G.logger:warning(nameOfModule .. ': CSK_PersistentData module is too old and will not work. Please update CSK_PersistentData module.')

    mqttClient_Model.persistentModuleAvailable = false
  else

    local parameterName, loadOnReboot = CSK_PersistentData.getModuleParameterName(nameOfModule)

    if parameterName then
      mqttClient_Model.parametersName = parameterName
      mqttClient_Model.parameterLoadOnReboot = loadOnReboot
    end

    if mqttClient_Model.parameterLoadOnReboot then
      loadParameters()
    end
    Script.notifyEvent('MQTTClient_OnDataLoadedOnReboot')
  end
end
Script.register("CSK_PersistentData.OnInitialDataLoaded", handleOnInitialDataLoaded)

-- *************************************************
-- END of functions for CSK_PersistentData module usage
-- *************************************************

return setMQTTClient_Model_Handle

--**************************************************************************
--**********************End Function Scope *********************************
--**************************************************************************

