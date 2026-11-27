local recording = false
local clipReady = false
local uploadRequestPending = false
local nuiReady = false
local startPending = false
local startAwaitingAck = false
local recorderCapabilities = nil
local saveAfterNuiReady = false
local startAttemptId = 0
local pendingReadyToken = 0
local startAckToken = 0
local recorderPhase = 'nui-not-ready'
local lastRecorderError = nil

local function notify(message)
    TriggerEvent('chat:addMessage', {
        color = { 168, 125, 255 },
        args = { 'FiveM Media', tostring(message) }
    })
end

local function sendStartMessage()
    if not nuiReady then
        if not startPending then
            startPending = true
            pendingReadyToken = pendingReadyToken + 1
            local token = pendingReadyToken
            recorderPhase = 'waiting-for-nui-ready'
            notify('FiveM Media is connecting to its recorder. Your start request is queued...')
            SendNUIMessage({ type = 'fm:record:ping' })
            SetTimeout(10000, function()
                if startPending and not nuiReady and pendingReadyToken == token then
                    startPending = false
                    saveAfterNuiReady = false
                    recorderPhase = 'nui-not-ready'
                    lastRecorderError = 'The recorder NUI did not complete its ready handshake.'
                    notify('Recorder UI never became ready. Run /fmstatus and check the NUI callback in F8.')
                end
            end)
        end
        return
    end
    if startAwaitingAck then
        notify('FiveM Media is already preparing the recorder. Please wait.')
        return
    end

    startPending = false
    startAwaitingAck = true
    startAttemptId = startAttemptId + 1
    local attempt = startAttemptId
    startAckToken = startAckToken + 1
    local ackToken = startAckToken
    recorderPhase = 'start-message-sent'
    lastRecorderError = nil

    SendNUIMessage({
        type = 'fm:record:toast',
        message = 'Starting custom recording...',
        kind = 'info',
        duration = 4500
    })
    SendNUIMessage({
        type = 'fm:record:start',
        attemptId = attempt,
        settings = {
            width = FMConfig.Width or 1280,
            height = FMConfig.Height or 720,
            fps = FMConfig.Fps or 30,
            bitrate = FMConfig.Bitrate or 4000000,
            maxSeconds = FMConfig.MaxClipSeconds or 60
        }
    })

    SetTimeout(15000, function()
        if startAwaitingAck and startAckToken == ackToken and startAttemptId == attempt then
            startAwaitingAck = false
            recording = false
            saveAfterNuiReady = false
            recorderPhase = 'start-ack-timeout'
            lastRecorderError = 'NUI did not confirm that MediaRecorder entered recording state within 15 seconds.'
            SendNUIMessage({ type = 'fm:record:cancel' })
            notify('Recorder did not confirm startup in 15 seconds. Run /fmstatus and send me its output.')
        end
    end)
end

RegisterCommand('fmclip', function()
    if recording or startAwaitingAck or startPending then
        notify('A custom recording is already running or starting. Use /save to upload it, or /fmcancel to discard it.')
        return
    end
    if clipReady then
        notify('You have a clip waiting to upload. Run /save or /fmretry first.')
        return
    end
    if uploadRequestPending then
        notify('A clip upload is already being prepared. Please wait.')
        return
    end
    sendStartMessage()
end, false)

RegisterCommand('record', function()
    ExecuteCommand('fmclip')
end, false)

local function requestUploadTicket(mode)
    if uploadRequestPending then
        notify('An upload request is already running.')
        return
    end
    uploadRequestPending = true
    TriggerServerEvent('fivem_media:server:requestUploadTicket', mode or 'save')
    notify('Preparing your secure upload to FiveM Media...')
end

RegisterCommand('save', function()
    if startPending or not nuiReady then
        if saveAfterNuiReady then
            notify('Your save request is already queued.')
            return
        end
        saveAfterNuiReady = true
        notify('Save queued. FiveM Media will finish starting the recorder, then upload your clip.')
        return
    end
    if not recording and not startAwaitingAck and not clipReady then
        notify('There is no custom recording ready. Start one with /fmclip.')
        return
    end
    requestUploadTicket('save')
end, false)

RegisterCommand('fmsave', function()
    ExecuteCommand('save')
end, false)

RegisterCommand('fmretry', function()
    if not clipReady then
        notify('There is no failed upload waiting to retry.')
        return
    end
    requestUploadTicket('retry')
end, false)

RegisterCommand('fmcancel', function()
    if not recording and not clipReady and not startPending and not startAwaitingAck then
        notify('There is no active or pending custom recording to discard.')
        return
    end
    SendNUIMessage({ type = 'fm:record:cancel' })
    recording = false
    clipReady = false
    uploadRequestPending = false
    startPending = false
    startAwaitingAck = false
    saveAfterNuiReady = false
    notify('Custom recording discarded from memory. No video file was created.')
end, false)

RegisterCommand('fmstatus', function()
    notify(('NUI: %s | State: %s | Recording: %s | Clip ready: %s | Upload pending: %s'):format(
        nuiReady and 'READY' or 'NOT READY',
        startAwaitingAck and 'STARTING' or (recording and 'RECORDING' or (clipReady and 'CLIP READY' or 'IDLE')),
        recording and 'YES' or 'NO',
        clipReady and 'YES' or 'NO',
        uploadRequestPending and 'YES' or 'NO'
    ))
    notify('Recorder phase: ' .. tostring(recorderPhase))
    if lastRecorderError then notify('Last error: ' .. tostring(lastRecorderError)) end
    if recorderCapabilities then
        notify(('Browser support — MediaRecorder: %s | Canvas capture: %s | WebGL: %s | VP8: %s | VP9: %s'):format(
            tostring(recorderCapabilities.mediaRecorder),
            tostring(recorderCapabilities.canvasCapture),
            tostring(recorderCapabilities.webgl),
            tostring(recorderCapabilities.webmVp8),
            tostring(recorderCapabilities.webmVp9)
        ))
        if recorderCapabilities.phase then notify('Recorder phase: ' .. tostring(recorderCapabilities.phase)) end
        if recorderCapabilities.error then notify('Last recorder error: ' .. tostring(recorderCapabilities.error)) end
    else
        notify('No recorder capability report received from NUI yet.')
    end
end, false)

RegisterCommand('fmlink', function(_, args)
    local code = table.concat(args or {}, '')
    if code == '' then
        notify('Generate a link code in your FiveM Media dashboard, then use /fmlink FM-LINK-XXXXXXXX.')
        return
    end
    TriggerServerEvent('fivem_media:server:linkPlayer', code)
    notify('Sending your one-time account-link code to FiveM Media...')
end, false)

RegisterNetEvent('fivem_media:client:linkResult', function(success, message)
    notify(message or (success and 'Account linked.' or 'Account linking failed.'))
end)

RegisterNetEvent('fivem_media:client:uploadError', function(message)
    uploadRequestPending = false
    notify('Upload unavailable: ' .. tostring(message))
end)

RegisterNetEvent('fivem_media:client:uploadTicketReady', function(mode, uploadUrl, uploadToken, serverName, serverLink)
    uploadRequestPending = false
    if type(uploadUrl) ~= 'string' or uploadUrl == '' or type(uploadToken) ~= 'string' or uploadToken == '' then
        notify('The upload ticket response was incomplete. Try /save again.')
        return
    end
    SendNUIMessage({
        type = 'fm:record:upload',
        mode = mode == 'retry' and 'retry' or 'save',
        uploadUrl = uploadUrl,
        uploadToken = uploadToken,
        serverName = serverName or '',
        serverLink = serverLink or ''
    })
end)

RegisterNUICallback('fmNuiReady', function(data, cb)
    nuiReady = true
    recorderPhase = 'nui-ready'
    recorderCapabilities = data or {}
    cb({ ok = true })
    if FMConfig.Debug then
        notify('Recorder NUI is ready.')
    end
    if startPending then
        sendStartMessage()
    end
end)

RegisterNUICallback('fmRecorderDiagnostics', function(data, cb)
    recorderCapabilities = recorderCapabilities or {}
    recorderCapabilities.phase = data and data.phase or recorderCapabilities.phase
    recorderCapabilities.error = data and data.error or nil
    recorderPhase = recorderCapabilities.phase or recorderPhase
    if data and data.error then lastRecorderError = tostring(data.error) end
    cb({ ok = true })
end)

RegisterNUICallback('fmRecordingStarted', function(data, cb)
    if data and data.attemptId and tonumber(data.attemptId) ~= startAttemptId then
        cb({ ok = true, ignored = true })
        return
    end
    startAwaitingAck = false
    recording = true
    recorderPhase = 'recording'
    lastRecorderError = nil
    clipReady = false
    cb({ ok = true })
    SendNUIMessage({
        type = 'fm:record:toast',
        message = '● Recording started · /fmsave when you are done',
        kind = 'success',
        duration = 5500
    })
    if saveAfterNuiReady then
        saveAfterNuiReady = false
        SetTimeout(300, function()
            requestUploadTicket('save')
        end)
    end
end)

RegisterNUICallback('fmRecordingReady', function(data, cb)
    recording = false
    clipReady = true
    cb({ ok = true })
    if data and data.reason == 'max-duration' then
        notify('Maximum clip length reached. Use /save to upload it to FiveM Media.')
    end
end)

RegisterNUICallback('fmRecordingError', function(data, cb)
    recording = false
    recorderPhase = 'failed'
    clipReady = false
    startPending = false
    startAwaitingAck = false
    saveAfterNuiReady = false
    uploadRequestPending = false
    cb({ ok = true })
    local message = tostring(data and data.message or 'Could not capture the game view.')
    lastRecorderError = message
    SendNUIMessage({ type = 'fm:record:toast', message = 'Recorder error: ' .. message, kind = 'error', duration = 9000 })
    notify('Recorder error: ' .. message)
end)

RegisterNUICallback('fmUploadComplete', function(data, cb)
    recording = false
    clipReady = false
    uploadRequestPending = false
    cb({ ok = true })
    notify('Clip uploaded directly to FiveM Media! Open Creator Dashboard → My Clips to Post, Save private or Delete it.')
end)

RegisterNUICallback('fmUploadFailed', function(data, cb)
    recording = false
    clipReady = data and data.hasClip == true or false
    uploadRequestPending = false
    cb({ ok = true })
    notify('Upload failed: ' .. tostring(data and data.message or 'Unknown error') .. ' Your clip is still in memory. Run /fmretry to try again.')
end)

RegisterNUICallback('fmRecorderStopped', function(_, cb)
    recording = false
    cb({ ok = true })
end)

RegisterKeyMapping('fmclip', 'FiveM Media: start custom recording', 'keyboard', 'F6')
RegisterKeyMapping('save', 'FiveM Media: upload custom recording', 'keyboard', 'F7')
RegisterKeyMapping('fmcancel', 'FiveM Media: discard custom recording', 'keyboard', 'F9')