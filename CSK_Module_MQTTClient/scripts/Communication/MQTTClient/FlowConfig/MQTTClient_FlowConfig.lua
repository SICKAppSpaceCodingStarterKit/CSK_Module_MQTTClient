--*****************************************************************
-- Here you will find all the required content to provide specific
-- features of this module via the 'CSK FlowConfig'.
--*****************************************************************

require('Communication.MQTTClient.FlowConfig.MQTTClient_Publish')
require('Communication.MQTTClient.FlowConfig.MQTTClient_OnReceive')

--- Function to react if FlowConfig was updated
local function handleOnClearOldFlow()
  if _G.availableAPIs.default and _G.availableAPIs.specific then
    if mqttClient_Model.parameters.flowConfigPriority then
      CSK_MQTTClient.clearFlowConfigRelevantConfiguration()
    end
  end
end
Script.register('CSK_FlowConfig.OnClearOldFlow', handleOnClearOldFlow)