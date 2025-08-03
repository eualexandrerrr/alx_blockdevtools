local RSGCore = exports['rsg-core']:GetCoreObject()

local permissions = {
    'license:xxxxxxxxxxx',
    'license:xxxxxxxxxxx'
}

local webhookUrl = 'YOUR_DISCORD_WEBHOOK_URL_HERE'

local function sendWebhook(playerData)
    local embed = {
        {
            title = "🛡️ NUI DevTools Detected",
            description = "Unauthorized use of developer tools detected",
            color = 15158332,
            fields = {
                {
                    name = "👤 Player",
                    value = playerData.firstname .. " " .. playerData.lastname,
                    inline = true
                },
                {
                    name = "🆔 CitizenID", 
                    value = playerData.citizenid,
                    inline = true
                },
                {
                    name = "📋 License",
                    value = "```" .. playerData.license .. "```",
                    inline = false
                }
            },
            thumbnail = {
                url = "YOUR_ICON_URL_HERE"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            footer = {
                text = "Anti-Cheat System",
                icon_url = "YOUR_ICON_URL_HERE"
            }
        }
    }

    PerformHttpRequest(webhookUrl, function(err, text, headers) end, 'POST', json.encode({
        username = "Anti-Cheat",
        avatar_url = "YOUR_ICON_URL_HERE",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

local function getPlayerLicense(source)
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "license:") then
            return id
        end
    end
    return nil
end

local function getPlayerData(source)
    local Player = RSGCore.Functions.GetPlayer(source)
    if Player then
        return {
            license = Player.PlayerData.license,
            firstname = Player.PlayerData.charinfo.firstname,
            lastname = Player.PlayerData.charinfo.lastname,
            citizenid = Player.PlayerData.citizenid
        }
    end
    return nil
end

RegisterServerEvent(GetCurrentResourceName())
AddEventHandler(GetCurrentResourceName(), function()
    local src = source
    local playerData = getPlayerData(src)
    
    if playerData then
        print("^3[NUIDEVTOOLS]^7 " .. playerData.citizenid)
        print("^3[NUIDEVTOOLS]^7 " .. playerData.firstname .. " " .. playerData.lastname)
        print("^3[NUIDEVTOOLS]^7 " .. playerData.license)
        
        sendWebhook(playerData)
    end
    
    local playerLicense = getPlayerLicense(src)
    local isInPermissions = false
    
    for _, v in pairs(permissions) do
        if v == playerLicense then
            isInPermissions = true
            break
        end
    end
    
    if not isInPermissions then
        DropPlayer(src, 'You have been disconnected for unauthorized use of DevTools')
    end
end)