--[[
Copyright (c) 2015 深圳市辉游科技有限公司.
--]]

--require "ClassBase"

local utils = require('utils.utils')

local user_plugin = nil
local iap_plugin_maps = nil

local function onUserResult(pluginChannel, plugin, code, msg )
    print("on user action listener.")
    print("code:"..code..",msg:"..msg)
    if code == UserActionResultCode.kInitSuccess then
        --do
    elseif code == UserActionResultCode.kInitFail then
        --do
    elseif code == UserActionResultCode.kLoginSuccess then
        --do
        utils.invokeCallback(pluginChannel.loginCallback, true, plugin, code, msg)
    elseif code == UserActionResultCode.kLoginNetworkError then
        --do
    elseif code == UserActionResultCode.kLoginNoNeed then
        --do
    elseif code == UserActionResultCode.kLoginFail then
        --do
        utils.invokeCallback(pluginChannel.loginCallback, false, plugin, code, msg)
    elseif code == UserActionResultCode.kLoginCancel then
        --do
        utils.invokeCallback(pluginChannel.loginCallback, false, plugin, code, msg)
    elseif code == UserActionResultCode.kLogoutSuccess then
        --do
    elseif code == UserActionResultCode.kLogoutFail then
        --do
    elseif code == UserActionResultCode.kPlatformEnter then
        --do
    elseif code == UserActionResultCode.kPlatformBack then
        --do
    elseif code == UserActionResultCode.kPausePage then
        --do
    elseif code == UserActionResultCode.kExitPage then
        --do
    elseif code == UserActionResultCode.kAntiAddictionQuery then
        --do
    elseif code == UserActionResultCode.kRealNameRegister then
        --do
    elseif code == UserActionResultCode.kAccountSwitchSuccess then
        --do
    elseif code == UserActionResultCode.kAccountSwitchFail then
        --do
    elseif code == UserActionResultCode.kOpenShop then
        --do
    end

    utils.invokeCallback(pluginChannel.onUserResultCallback, plugin, code, msg)
end

local function onPayResult( code, msg, info )
    print("on iap result listener.")
    print("code:"..code..",msg:"..msg)
    if code == PayResultCode.kPaySuccess then
        --do
    elseif code == PayResultCode.kPayFail then
        --do
    elseif code == PayResultCode.kPayCancel then
        --do
    elseif code == PayResultCode.kPayNetworkError then
        --do
    elseif code == PayResultCode.kPayProductionInforIncomplete then
        --do
    elseif code == PayResultCode.kPayInitSuccess then
        --do
    elseif code == PayResultCode.kPayInitFail then
        --do
    elseif code == PayResultCode.kPayNowPaying then
        --do
    elseif code == PayResultCode.kPayRechargeSuccess then
        --do
    end
end

PluginChannel = class()
function PluginChannel:ctor(cbUserResult)
    --for anysdk
    local this = self
    local agent = AgentManager:getInstance()
    --init
    --anysdk
    local appKey = "3AA2ECC2-8215-2D4E-F28B-672DF927EB65";
    local appSecret = "4f6d3197bf1b615e89c696e873e17ef2";
    local privateKey = "33E89023E2E2F36C664A499A327E6A4A";


    this.onUserResultCallback = cbUserResult

    local oauthLoginServer = "http://login.ucdev.lordgame.cn:4001/anysdk";
    agent:init(appKey,appSecret,privateKey,oauthLoginServer)
    --load
    agent:loadAllPlugins()

    -- get user plugin
    user_plugin = agent:getUserPlugin()
    if user_plugin ~= nil then
        user_plugin:setActionListener(function(plugin, code, msg)
                onUserResult(this, plugin, code, msg)
            end )
    end

    iap_plugin_maps = agent:getIAPPlugin()
    for key, value in pairs(iap_plugin_maps) do
        print("key:" .. key)
        print("value: " .. type(value))
        value:setResultListener(onPayResult)
    end

    agent:setIsAnaylticsEnabled(true)
end

function PluginChannel:login(cb)
    local this = self
    this.loginCallback = cb
    if user_plugin ~= nil then
        user_plugin:login()
    end
end

function PluginChannel:logout()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("logout") then
            user_plugin:callFuncWithParam("logout")
        end
	end
end

function PluginChannel:enterPlatform()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("enterPlatform") then
            user_plugin:callFuncWithParam("enterPlatform")
        end
	end
end

function PluginChannel:showToolBar()
	if user_plugin ~= nil then
	    if user_plugin:isFunctionSupported("showToolBar") then
	        local param1 = PluginParam:create(ToolBarPlace.kToolBarTopLeft)
	        user_plugin:callFuncWithParam("showToolBar", param1)
	    end
	end
end

function PluginChannel:hideToolBar()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("hideToolBar") then
            user_plugin:callFuncWithParam("hideToolBar")
        end
	end
end

function PluginChannel:accountSwitch()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("accountSwitch") then
            user_plugin:callFuncWithParam("accountSwitch")
        end
	end
end

function PluginChannel:realNameRegister()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("realNameRegister") then
            user_plugin:callFuncWithParam("realNameRegister")
        end
	end
end

function PluginChannel:antiAddictionQuery()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("antiAddictionQuery") then
            user_plugin:callFuncWithParam("antiAddictionQuery")
        end
	end
end

function PluginChannel:submitLoginGameRole()
	if user_plugin ~= nil then
        if user_plugin:isFunctionSupported("submitLoginGameRole") then
            local data = PluginParam:create({roleId="123456",roleName="test",roleLevel="10",zoneId="123",zoneName="test",dataType="1",ext="login"})
            user_plugin:callFuncWithParam("submitLoginGameRole", data)
        end
	end
end

function PluginChannel:pay()
	if iap_plugin_maps ~= nil then
        local info = {
                Product_Price="0.1", 
                Product_Id="monthly",  
                Product_Name="gold",  
                Server_Id="13",  
                Product_Count="1",  
                Role_Id="1001",  
                Role_Name="asd"
            }
        -- analytics_plugin:logEvent("pay", info)
        for key, value in pairs(iap_plugin_maps) do
            print("key:" .. key)
            print("value: " .. type(value))
            value:payForProduct(info)
        end
	end
end