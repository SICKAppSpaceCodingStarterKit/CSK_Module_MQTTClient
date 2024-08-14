-- Block namespace
local BLOCK_NAMESPACE = 'MQTTClient_FC.Publish'
local nameOfModule = 'CSK_MQTTClient'

--*************************************************************
--*************************************************************

-- Required to keep track of already allocated resource
local instanceTable = {}

local function publish(handle, data1, data2, data3, data4)
  local topic = Container.get(handle, 'Topic')
  local qos = Container.get(handle, 'QoS')
  local retain = Container.get(handle, 'Retain')

  if data1 then
    CSK_MQTTClient.addPublishEvent(data1, topic, qos, retain)
  end
  if data2 then
    CSK_MQTTClient.addPublishEvent(data2, topic, qos, retain)
  end
  if data3 then
    CSK_MQTTClient.addPublishEvent(data3, topic, qos, retain)
  end
  if data4 then
    CSK_MQTTClient.addPublishEvent(data4, topic, qos, retain)
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.publish', publish)

--*************************************************************
--*************************************************************

local function create(topic, qos, retain)

  if nil ~= instanceTable[topic] then
    _G.logger:warning(nameOfModule .. ": Instance already in use, please choose another one")
    return nil
  else
    -- Otherwise create handle and store the restriced resource
    local handle = Container.create()
    instanceTable[topic] = topic
    Container.add(handle, 'Topic', topic)
    Container.add(handle, 'QoS', qos)
    Container.add(handle, 'Retain', retain)
    return handle
  end
end
Script.serveFunction(BLOCK_NAMESPACE .. '.create', create)

--- Function to reset instances if FlowConfig was cleared
local function handleOnClearOldFlow()
  Script.releaseObject(instanceTable)
  instanceTable = {}
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)