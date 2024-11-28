-- Block namespace
local BLOCK_NAMESPACE = "MQTTClient_FC.OnReceive"
local nameOfModule = 'CSK_MQTTClient'

--*************************************************************
--*************************************************************

local function register(handle, _ , callback)

  Container.remove(handle, "CB_Function")
  Container.add(handle, "CB_Function", callback)

  local function localCallback()
    if callback ~= nil then
        Script.callFunction(callback, 'CSK_MQTTClient.OnReceiveFullString')
      else
        _G.logger:warning(nameOfModule .. ": " .. BLOCK_NAMESPACE .. ".CB_Function missing!")
      end
  end
  Script.register('CSK_FlowConfig.OnNewFlowConfig', localCallback)

  return true
end
Script.serveFunction(BLOCK_NAMESPACE ..".register", register)

--*************************************************************
--*************************************************************

local function create()
  local container = Container.create()
  Container.add(container, "CB_Function", "")
  return(container)
end
Script.serveFunction(BLOCK_NAMESPACE .. ".create", create)