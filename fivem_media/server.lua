local apiKey = GetResourceKvpString('fivem_media_server_key')
local apiUrl = (FMConfig.ApiUrl or ''):gsub('/+$', '')
local claiming = false
local playerCooldowns = {}

local function log(message)
    print(('^5[FiveM Media]^7 %s'):format(message))
end

local function request(method, route, body, headers, callback)
    if apiUrl == '' then
        log('Missing fivem_media_api in server.cfg.')
        if callback then callback(0, '', 'Missing API URL') end
        return
    end
    local requestHeaders = headers or { ['Content-Type'] = 'application/json' }
    PerformHttpRequest(apiUrl .. route, function(statusCode, responseBody, responseHeaders, errorData)
        if callback then callback(statusCode, responseBody or '', errorData) end
    end, method, body and json.encode(body) or '', requestHeaders)
end

local function serverHeaders()
    return {
        ['Content-Type'] = 'application/json',
        ['Authorization'] = 'Bearer ' .. (apiKey or '')
    }
end

local function getStableIdentifier(playerSource)
    local identifiers = GetPlayerIdentifiers(playerSource)
    for _, identifier in ipairs(identifiers) do
        if identifier:sub(1, 8) == 'license:' then return identifier end
    end
    for _, identifier in ipairs(identifiers) do
        if identifier:sub(1, 9) == 'license2:' then return identifier end
    end
    return nil
end

local function heartbeat()
    if not apiKey or apiKey == '' then return end
    request('POST', '/api/integrations/heartbeat', {
        players = #GetPlayers(),
        maxPlayers = GetConvarInt('sv_maxclients', 48)
    }, serverHeaders(), function(statusCode)
        if statusCode == 200 then
            if FMConfig.Debug then log('Heartbeat sent.') end
        elseif statusCode == 401 then
            log('Server key rejected. Generate a fresh claim from your dashboard and reverify.')
        else
            log(('Heartbeat failed (HTTP %s).'):format(statusCode))
        end
    end)
end

local function claimServer()
    if claiming or apiKey then return end
    local claimCode = FMConfig.ClaimCode or ''
    if claimCode == '' then
        log('No claim code configured. Generate one in your FiveM Media dashboard.')
        return
    end
    claiming = true
    request('POST', '/api/integrations/claim', {
        claimCode = claimCode,
        serverName = GetConvar('sv_hostname', 'FiveM Server'),
        maxPlayers = GetConvarInt('sv_maxclients', 48),
        joinCode = FMConfig.JoinCode
    }, nil, function(statusCode, responseBody)
        claiming = false
        local ok, data = pcall(json.decode, responseBody)
        if statusCode == 201 and ok and data and data.serverKey then
            apiKey = data.serverKey
            SetResourceKvp('fivem_media_server_key', apiKey)
            log('Server control verified. The private server key is stored in resource KVP.')
            heartbeat()
        else
            local reason = (ok and data and data.error) or ('HTTP ' .. tostring(statusCode))
            log('Verification failed: ' .. tostring(reason))
        end
    end)
end

local function cooldownOkay(playerSource)
    local now = os.time()
    local last = playerCooldowns[playerSource] or 0
    if now - last < 3 then return false end
    playerCooldowns[playerSource] = now
    return true
end

RegisterNetEvent('fivem_media:server:linkPlayer', function(code)
    local playerSource = source
    if not cooldownOkay(playerSource) then return end
    if not apiKey or apiKey == '' then
        TriggerClientEvent('fivem_media:client:linkResult', playerSource, false, 'This server has not been verified with FiveM Media.')
        return
    end
    local identifier = getStableIdentifier(playerSource)
    if not identifier then
        TriggerClientEvent('fivem_media:client:linkResult', playerSource, false, 'Could not read your FiveM license identifier.')
        return
    end
    code = tostring(code or ''):upper():gsub('%s+', '')
    if #code < 12 or #code > 24 then
        TriggerClientEvent('fivem_media:client:linkResult', playerSource, false, 'That link code does not look valid.')
        return
    end
    request('POST', '/api/integrations/player-link', { code = code, identifier = identifier }, serverHeaders(), function(statusCode, responseBody)
        local ok, data = pcall(json.decode, responseBody)
        if statusCode == 200 and ok and data and data.ok then
            TriggerClientEvent('fivem_media:client:linkResult', playerSource, true, data.message or 'Your FiveM account is linked globally.')
        else
            local reason = (ok and data and data.error) or ('HTTP ' .. tostring(statusCode))
            TriggerClientEvent('fivem_media:client:linkResult', playerSource, false, tostring(reason))
        end
    end)
end)

RegisterNetEvent('fivem_media:server:requestUploadTicket', function(mode)
    local playerSource = source
    if not cooldownOkay(playerSource) then
        TriggerClientEvent('fivem_media:client:uploadError', playerSource, 'Please wait a moment before requesting another upload ticket.')
        return
    end
    if not apiKey or apiKey == '' then
        TriggerClientEvent('fivem_media:client:uploadError', playerSource, 'This server has not been verified with FiveM Media.')
        return
    end
    local identifier = getStableIdentifier(playerSource)
    if not identifier then
        TriggerClientEvent('fivem_media:client:uploadError', playerSource, 'Could not read your FiveM license identifier.')
        return
    end
    mode = mode == 'retry' and 'retry' or 'save'
    request('POST', '/api/integrations/player-upload-ticket', { identifier = identifier }, serverHeaders(), function(statusCode, responseBody)
        local ok, data = pcall(json.decode, responseBody)
        if statusCode == 201 and ok and data and data.uploadToken and data.uploadUrl then
            TriggerClientEvent('fivem_media:client:uploadTicketReady', playerSource, mode, data.uploadUrl, data.uploadToken, data.serverName or '', data.serverLink or '')
        else
            local reason = (ok and data and data.error) or ('HTTP ' .. tostring(statusCode))
            TriggerClientEvent('fivem_media:client:uploadError', playerSource, tostring(reason))
        end
    end)
end)

AddEventHandler('playerDropped', function()
    playerCooldowns[source] = nil
end)

AddEventHandler('onResourceStart', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    CreateThread(function()
        Wait(2500)
        if apiUrl == '' then
            log('Set fivem_media_api and fivem_media_claim in server.cfg.')
            return
        end
        if not apiKey then claimServer() else heartbeat() end
        while true do
            Wait((FMConfig.HeartbeatMinutes or 5) * 60 * 1000)
            heartbeat()
        end
    end)
end)

RegisterCommand('fivem_media_reverify', function(source)
    if source ~= 0 then
        TriggerClientEvent('chat:addMessage', source, { args = { 'FiveM Media', 'This command is server-console only.' } })
        return
    end
    apiKey = nil
    DeleteResourceKvp('fivem_media_server_key')
    log('Stored key removed. A fresh, unused claim code is required on the next start.')
end, true)