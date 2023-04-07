local QBCore = exports['qb-core']:GetCoreObject()

local DiscordWebhook = {
    Reguests = "", -- for requested screenshots
    Logs     = "", -- for auto screenshots
}

local function isAdmin(id)
    if IsPlayerAceAllowed(id, 'admin') or IsPlayerAceAllowed(id, 'god') or IsPlayerAceAllowed(id, 'command') then
        return true
    end
    return false
end

local function isWhitelisted(id)
    local isWhitelisted = false
    local license = QBCore.Functions.GetIdentifier(id, 'license')
    local result = MySQL.Sync.fetchAll('SELECT * FROM underattack_ignore_players WHERE license = ?', {license})
    if result[1] ~= nil and result[1].license == license then isWhitelisted = true end
    return isWhitelisted
end

local function GetPlayerInfo(id)
    local Player = QBCore.Functions.GetPlayer(id)
    local info = {}
    if Player then
        local fullname  = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname
        local citizenid = Player.PlayerData.citizenid
        info = {
            source    = Player.PlayerData.source,
            citizenid = Player.PlayerData.citizenid,
            fullname  = Player.PlayerData.charinfo.firstname .. ' ' .. Player.PlayerData.charinfo.lastname,
            fivem     = GetPlayerName(id),
            license   = QBCore.Functions.GetIdentifier(id, 'license'),
            discord   = QBCore.Functions.GetIdentifier(id, 'discord'),
            steam     = QBCore.Functions.GetIdentifier(id, 'steam'),
            ip        = QBCore.Functions.GetIdentifier(id, 'ip'),
        }
    end
    return info
end

local function CreateMessage(event, player, admin)
    local txt
    if admin ~= nil then
        if Config.ShowIpInMessage then
            txt = Lang:t(event, {id = player.source, citizenid = player.citizenid, fullname = player.fullname, fivem = player.fivem, steam = player.steam, license = player.license, discord = player.discord, ip = player.ip, admin_name = admin.fullname})
        else
            txt = Lang:t(event, {id = player.source, citizenid = player.citizenid, fullname = player.fullname, fivem = player.fivem, steam = player.steam, license = player.license, discord = player.discord, ip = 'ip:hidden', admin_name = admin.fullname})
        end
    else
        if Config.ShowIpInMessage then
            txt = Lang:t(event, {id = player.source, citizenid = player.citizenid, fullname = player.fullname, fivem = player.fivem, steam = player.steam, license = player.license, discord = player.discord, ip = player.ip})
        else
            txt = Lang:t(event, {id = player.source, citizenid = player.citizenid, fullname = player.fullname, fivem = player.fivem, steam = player.steam, license = player.license, discord = player.discord, ip = 'ip:hidden'})
        end
    end
    return txt
end

local function GetOnlinePlayers()
    local sources = {}	
    for k, id in pairs(QBCore.Functions.GetPlayers()) do
		local target = QBCore.Functions.GetPlayer(id)
		local info = {
			source = target.PlayerData.source,
			fullname = target.PlayerData.charinfo.firstname.." "..target.PlayerData.charinfo.lastname,
		}
        sources[#sources+1] = info
    end
    return sources
end

local function SendToDiscoord(hook, message)
    PerformHttpRequest(hook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
end

QBCore.Commands.Add("makescreenshot", "", {}, true, function(source)
    local src = source
    TriggerClientEvent('mh-screenshots:client:screenshot-player', src, DiscordWebhook.Reguests)
end, 'user')

QBCore.Commands.Add("screenshot", "(Admin Only)", {}, true, function(source, args)
    local src = source
    if args[1] and tonumber(args[1]) > 0 then
        local id = tonumber(args[1])
        TriggerClientEvent('mh-screenshots:client:screenshot-reguest', id, DiscordWebhook.Reguests, src)
    end
end, 'admin')

QBCore.Commands.Add("screenshotmenu", "", {}, true, function(source)
    local src = source
    TriggerClientEvent('mh-screenshots:client:ShowMenu', src)
end, 'admin')

QBCore.Functions.CreateCallback("mh-screenshots:server:getWekhook", function(source, cb)
	cb(DiscordWebhook.Logs)
end)

QBCore.Functions.CreateCallback("mh-screenshots:server:isAdmin", function(source, cb)
    local src = source
	cb(isAdmin(src), scr)
end)

QBCore.Functions.CreateCallback("mh-screenshots:server:isWhitelisted", function(source, cb)
    local src = source
	cb(isWhitelisted(src))
end)

QBCore.Functions.CreateCallback("mh-screenshots:server:GetOnlinePlayers", function(source, cb)
	cb(GetOnlinePlayers())
end)

RegisterServerEvent('mh-screenshots:server:screenshot', function()
    local src = source
    if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'god') or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('mh-screenshots:client:screenshot-player', src, DiscordWebhook.Reguests)
    end
end)

RegisterServerEvent('mh-screenshots:server:screenshotall', function()
    local src = source
    if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'god') or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('mh-screenshots:client:screenshot-reguest', -1, DiscordWebhook.Reguests, src)
    end
end)

RegisterServerEvent('mh-screenshots:server:action', function(targetID)
    local src = source
    if IsPlayerAceAllowed(src, 'admin') or IsPlayerAceAllowed(src, 'god') or IsPlayerAceAllowed(src, 'command') then
        TriggerClientEvent('mh-screenshots:client:screenshot-reguest', targetID, DiscordWebhook.Reguests, src)
    end
end)

RegisterServerEvent('mh-screenshots:server:sendPlayerScreenshotToDiscord', function()
    local src = source
    if DiscordWebhook.Reguests ~= nil and DiscordWebhook.Reguests ~= "" then
        SendToDiscoord(DiscordWebhook.Reguests, CreateMessage('discord.message_user', GetPlayerInfo(src), nil))
    end
end)

RegisterServerEvent('mh-screenshots:server:sendAutoScreenshotToDiscord', function()
    local src = source
    if not isAdmin(src) and not isWhitelisted(src) then
        if DiscordWebhook.Logs ~= nil and DiscordWebhook.Logs ~= "" then
           SendToDiscoord(DiscordWebhook.Logs, CreateMessage('discord.auto_message', GetPlayerInfo(src), nil))
        end
    end
end)

RegisterServerEvent('mh-screenshots:server:reguestRendToDiscord', function(adminID)
    local src = source
    if DiscordWebhook.Reguests ~= nil and DiscordWebhook.Reguests ~= "" then
        SendToDiscoord(DiscordWebhook.Reguests, CreateMessage('discord.message_admin', GetPlayerInfo(src), GetPlayerInfo(adminID)))
    end
end)