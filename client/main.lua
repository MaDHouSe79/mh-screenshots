local QBCore = exports['qb-core']:GetCoreObject()
local cooldown = false

local function CoolDown()
    cooldown = true
    SetTimeout(Config.CoolDown, function()
        cooldown = false
    end) 
end

local function ScreenshotTimer()
    Wait(math.random(1000, 60000))
    QBCore.Functions.TriggerCallback('mh-screenshots:server:isAdmin', function(_isAdmin, adminID)
        if not _isAdmin then
            QBCore.Functions.TriggerCallback('mh-screenshots:server:isWhitelisted', function(_isWhitelisted)
                if not _isWhitelisted then
                    QBCore.Functions.TriggerCallback('mh-screenshots:server:getWekhook', function(webhook)
                        if webhook ~= nil then
                            exports["screenshot-basic"]:requestScreenshotUpload(webhook, "files[]", function() end)
                            TriggerServerEvent("mh-screenshots:server:sendAutoScreenshotToDiscord")
                            SetTimeout(Config.ScreenshotTimer + math.random(15000, 60000), function()
                                ScreenshotTimer()
                            end)
                        end
                    end)
                end
            end)
        end
    end)
end

AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    ScreenshotTimer()
end)

AddEventHandler('onResourceStart', function(resource)
    ScreenshotTimer()
end)

RegisterNetEvent("mh-screenshots:client:screenshot-player", function(hook)
    if not cooldown then
        CoolDown()
        exports["screenshot-basic"]:requestScreenshotUpload(hook, "files[]", function() end)
        TriggerServerEvent("mh-screenshots:server:sendPlayerScreenshotToDiscord")
    else
        QBCore.Functions.Notify(Lang:t('notify.coolcown_message'))
    end
end)

RegisterNetEvent("mh-screenshots:client:screenshot-reguest", function(hook, adminID)
    exports["screenshot-basic"]:requestScreenshotUpload(hook, "files[]", function() end)
    TriggerServerEvent("mh-screenshots:server:reguestRendToDiscord", adminID)
end)

RegisterNetEvent('mh-screenshots:client:ShowMenu', function()
    QBCore.Functions.TriggerCallback('mh-screenshots:server:isAdmin', function(_isAdmin, adminID)
        if _isAdmin then
            TriggerServerEvent('mh-screenshots:server:screenshotall', tonumber(adminID))
        end
    end)
end)

RegisterNetEvent('mh-screenshots:client:ShowMenu', function()
    QBCore.Functions.TriggerCallback('mh-screenshots:server:isAdmin', function(_isAdmin, adminID)
        if _isAdmin then
            local playerlist = {}
            QBCore.Functions.TriggerCallback('mh-screenshots:server:GetOnlinePlayers', function(online)
                for key, v in pairs(online) do
                    playerlist[#playerlist + 1] = {value = v.source, text = "(ID:"..v.source..") "..v.fullname}
                end
                local menu = exports["qb-input"]:ShowInput({
                    header = Lang:t('menu.header'),
                    submitText = Lang:t('menu.button'),
                    inputs = {
                        {
                            text = Lang:t('menu.select_player'),
                            name = "id",
                            type = "select",
                            options = playerlist,
                            isRequired = true
                        },
                    }
                })
                if menu then
                    if not menu.id then
                        return
                    else
                        TriggerServerEvent('mh-screenshots:server:action', tonumber(menu.id))
                    end
                end
            end)
        end
    end)
end)

local adminIndex = nil
RegisterNetEvent('qb-radialmenu:client:onRadialmenuOpen', function()
    QBCore.Functions.TriggerCallback("mh-screenshots:server:isAdmin", function(_isAdmin, _adminID)
        if _isAdmin then
            local screenshotMenu = {
                id = 'admininteractions',
                title = Lang:t('menu.title'),
                icon = 'images',
                items = {}
            }
            if Config.AdminInteractions['admin'] and next(Config.AdminInteractions['admin']) then
                screenshotMenu.items = Config.AdminInteractions['admin']
            end
            if #screenshotMenu.items == 0 then
                if adminIndex then
                    exports['qb-radialmenu']:RemoveOption(adminIndex)
                    adminIndex = nil
                end
            else
                adminIndex = exports['qb-radialmenu']:AddOption(screenshotMenu, adminIndex)
            end
        end
    end)
end)

AddEventHandler('onResourceStop', function(resource)
    if adminIndex ~= nil then
        exports['qb-radialmenu']:RemoveOption(adminIndex)
        adminIndex = nil
    end
end)