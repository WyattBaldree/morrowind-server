---------------------------
-- ccStats 0.7.0 by Texafornian
--
-- 

-----------------
-- FUNCTIONS
-----------------

function ccStats.checkPlayerFileEntry(pid)
    -- Check whether player file has new "timeKeeping" data tables
    local changeMade = false

    if not Players[pid].data.timeKeeping then
        local timeInfo = {}
        timeInfo.timeCreated = os.time()
        timeInfo.timeStored = os.time()
        timeInfo.timePlayed = tonumber(0)
        Players[pid].data.timeKeeping = timeInfo
        changeMade = true
    end

    if changeMade then Players[pid]:QuicksaveToDrive() end
end

function ccStats.parseTime(timeCurrent, timeOriginal, ident)
    -- Used to report days, hours, minutes since some given timestamp
    -- Thanks to jsmorley at https://forum.rainmeter.net/viewtopic.php?t=23486
    local diff = 0

    if ident == 1 then
        diff = (timeCurrent - timeOriginal)
    elseif ident == 2 then
        diff = timeCurrent
    end

    local diffDays = math.floor(diff / 86400)
    local remainder = diff % 86400
    local diffHours = math.floor(remainder / 3600)
    local remainder = remainder % 3600
    local diffMinutes = math.floor(remainder / 60)

    return diffDays, diffHours, diffMinutes
end

function ccStats.timeOnServer(pid)
    -- Calculates how long a player has been on the server + playtime

    if not Players[pid].data.timeKeeping then
        tes3mp.SendMessage(pid, color.Yellow .. "Your character was created before this feature was implemented.\n", false)
        return false
    end

    local timeCurrent = os.time()
    local timeCreated = Players[pid].data.timeKeeping.timeCreated
    local timePlayed = Players[pid].data.timeKeeping.timePlayed

    local diffDays, diffHours, diffMinutes = ccStats.parseTime(timeCurrent, timeCreated, 1)
    tes3mp.SendMessage(pid, color.Yellow .. "Your character was created " .. diffDays .. " day(s), " .. diffHours ..
        " hour(s), " .. diffMinutes .. " minute(s) ago.\n", false)

    diffDays, diffHours, diffMinutes = ccStats.parseTime(timePlayed, nil, 2)
    tes3mp.SendMessage(pid, color.Yellow .. "You've played for " .. diffDays .. " day(s), " .. diffHours .. " hour(s), " ..
        diffMinutes .. " minute(s).\n", false)
end

-----------------
-- EVENTS
-----------------

function ccStats.OnPlayerCellChange(eventStatus, pid)
    -- Update time played on server

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        -- Players[pid]:SaveCell()
        -- Players[pid]:SaveStatsDynamic()

        if Players[pid].data.timeKeeping then
            local played = Players[pid].data.timeKeeping.timePlayed
            local stored = Players[pid].data.timeKeeping.timeStored

            Players[pid].data.timeKeeping.timePlayed = played + (os.time() - stored)
            Players[pid].data.timeKeeping.timeStored = os.time()
            Players[pid]:QuicksaveToDrive()
        end
    end
end

function ccStats.OnPlayerEndCharGen(eventStatus, pid)
    ccStats.checkPlayerFileEntry(pid)
end

function ccStats.OnPlayerFinishLogin(eventStatus, pid)
    ccStats.checkPlayerFileEntry(pid)
end

if ccConfig.StatsEnabled then
    customCommandHooks.registerCommand("stats", ccStats.timeOnServer)
    customCommandHooks.registerCommand("time", ccStats.timeOnServer)

    customEventHooks.registerHandler("OnPlayerCellChange", ccStats.OnPlayerCellChange)
    customEventHooks.registerHandler("OnPlayerEndCharGen", ccStats.OnPlayerEndCharGen)
    customEventHooks.registerHandler("OnPlayerFinishLogin", ccStats.OnPlayerFinishLogin)
end

return ccStats
