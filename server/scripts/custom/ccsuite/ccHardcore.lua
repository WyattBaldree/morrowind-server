---------------------------
-- ccHardcore 0.7.0 by Texafornian
--
-- Many thanks to:
-- * Mupf

-----------------
-- FUNCTIONS
-----------------

function ccHardcore.checkPlayerFileEntry(pid)
    -- Check whether player file has new "hardcore" data tables
    local changeMade = false

    if not Players[pid].data.hardcoreMode then
        local hcInfo = {}
        hcInfo.enabled = tonumber(0)
        hcInfo.ladder = os.date("%y%m")
        Players[pid].data.hardcoreMode = hcInfo
        changeMade = true
    end

    if changeMade then Players[pid]:QuicksaveToDrive() end
end

function ccHardcore.isSafeCell(pid, script)
    -- Returns true if a player died in a designated safe cell (ccConfig.lua)
    local deathCell = tes3mp.GetCell(pid)

    for index, _ in pairs(ccHardcore.SafeCellsTable) do

        if deathCell == string.lower(ccHardcore.SafeCellsTable[index][1]) then
            return true
        end
    end
    return false
end

function ccHardcore.deathDropGold(pid)
    -- Drops a dead Hardcore player's gold on the ground
    tes3mp.LogMessage(2, "[ccHardcore] Running ccHardcore's deathDrop function")

    -- First drop mandatory "otherDrops" from ccHardcoreConfig (if any)
    if #ccHardcore.DeathDropTable > 0 then
        tes3mp.LogMessage(2, "[ccHardcore] deathDrop: ccHardcore.DeathDropTable has entries")

        for index, value in pairs(ccHardcore.DeathDropTable) do
            ccHardcore.deathDropItem(pid, ccHardcore.DeathDropTable[index][1], ccHardcore.DeathDropTable[index][2])
        end
    end

    -- Then look for any gold in player's inventory
    tes3mp.LogMessage(2, "[ccHardcore] deathDrop: Looking for gold in player inventory")

    for index, value in pairs(Players[pid].data.inventory) do

        if string.lower(Players[pid].data.inventory[index].refId) == "gold_001" then
            tes3mp.LogMessage(2, "[ccHardcore] deathDrop: Dropping gold")
            ccHardcore.deathDropItem(pid, "gold_001", Players[pid].data.inventory[index].count)
            break
        end
    end
end

function ccHardcore.deathDropItem(pid, refId, count)
    -- Drops a ead Hardcore player's item on the ground and sends a packet to everyone else
    local mpNum = WorldInstance:GetCurrentMpNum() + 1
    local cell = tes3mp.GetCell(pid)
    local location = {
        posX = tes3mp.GetPosX(pid), 
        posY = tes3mp.GetPosY(pid), 
        posZ = tes3mp.GetPosZ(pid)
    }
    local refIndex =  0 .. "-" .. mpNum

    WorldInstance:SetCurrentMpNum(mpNum)
    tes3mp.SetCurrentMpNum(mpNum)

    LoadedCells[cell]:InitializeObjectData(refIndex, refId)
    LoadedCells[cell].data.objectData[refIndex].location = location
    table.insert(LoadedCells[cell].data.packets.place, refIndex)
    LoadedCells[cell]:QuicksaveToDrive()

    for onlinePid, player in pairs(Players) do

        if player:IsLoggedIn() then
            tes3mp.InitializeEvent(onlinePid)
            tes3mp.SetEventCell(cell)
            tes3mp.SetObjectRefId(refId)
            tes3mp.SetObjectCount(count)
            tes3mp.SetObjectRefNumIndex(0)
            tes3mp.SetObjectMpNum(mpNum)

            tes3mp.SetObjectPosition(location.posX, location.posY, location.posZ)
            tes3mp.AddWorldObject()
            tes3mp.SendObjectPlace()
        end
    end
end

function ccHardcore.deathLog(pid)
    -- Logs death reason for HC characters
    -- Modified from player/base.lua's ProcessDeath function
    local deathReason = "committed suicide"

    if tes3mp.DoesPlayerHavePlayerKiller(pid) then
        local killerPid = tes3mp.GetPlayerKillerPid(pid)

        if pid ~= killerPid then
            deathReason = "was killed by player " .. logicHandler.GetChatName(killerPid)
            tes3mp.LogAppend(1, "[ccHardcore] " .. logicHandler.GetChatName(killerPid) .. " PKed HC player " ..
                logicHandler.GetChatName(pid) .. " in cell " .. tes3mp.GetCell(pid))
        end
    else
        local killerName = tes3mp.GetPlayerKillerName(pid)

        if killerName ~= "" then
            deathReason = "was killed by " .. killerName
        end
    end

    local message = logicHandler.GetChatName(pid) .. " " .. deathReason .. ".\n"
    tes3mp.SendMessage(pid, message, true)
end

function ccHardcore.hardcoreMode(pid)
    -- Enables hardcore mode for new players
    local newDifficulty = config.difficulty + ccConfig.Hardcore.AddedDifficulty
    local playerNameLC = string.lower(Players[pid].name)

    -- Enable hardcore mode
    local hcInfo = {}
    hcInfo.enabled = 1
    hcInfo.ladder = os.date("%y%m")
    Players[pid].data.hardcoreMode = hcInfo
    Players[pid]:QuicksaveToDrive()

    -- Increase player's difficulty
    tes3mp.SetDifficulty(pid, newDifficulty)
    tes3mp.SendSettings(pid)

    tes3mp.SendMessage(pid, color.Orange .. Players[pid].name .. " has enabled " .. color.Red .. "Hardcore Mode." ..
        color.Orange .. " Good luck!\n", true)

    -- Avoid edge case where player creates character on last day then new month starts before server restart
    if ccConfig.Hardcore.LadderEnabled and ccHardcore.ladderExists() then
        local hcLadder = "ladder_" .. os.date("%y%m")

        -- Ensure there's no residual pre-death info saved from another player
        if ccHardcore.LadderList.players[playerNameLC] then
            ccHardcore.LadderList.players[playerNameLC] = nil
            jsonInterface.save("custom/ccsuite/" .. hcLadder .. ".json", ccHardcore.LadderList)
        end

        -- Create a table entry for this player in the ladder file
        local player = {} 
        player.displayName = Players[pid].data.login.name
        player.level = 1
        ccHardcore.LadderList.players[playerNameLC] = player
        jsonInterface.save("custom/ccsuite/ladder_" .. ccHardcore.CurrentLadder .. ".json", ccHardcore.LadderList)
    else
        tes3mp.SendMessage(pid, color.Red .. "ERROR: Failed to join the ladder. Please delete your character" ..
            " and try again after the next server restart.\n", false)
    end
end

function ccHardcore.ladderCommand(pid)
    -- Called from /ladder command, ranks players in current ladder file

    -- Account for end-of-month edge case
    if not ccHardcore.ladderExists() then
        tes3mp.SendMessage(2, color.Red .. "Please wait until the next server restart for the new ladder." ..
            color.Default .. "\n", false)
        return false
    end

    local ladderChars = ccHardcore.LadderList.players
    local ladderLabel = "Hardcore Ladder Rankings (" .. os.date("%y") .. "-" .. os.date("%m") .. ")"
    local ladderRanks = ""
    local ladderRaw = {}

    -- Populate temporary table "ladderRaw" with all players in current ladder
    for pid, p in pairs(ladderChars) do 
        local name = p.displayName
        local level = p.level
        ladderRaw[name] = level
    end

    -- Sort ladderRaw by highest-to-lowest
    for k,v in ccHardcore.spairs(ladderRaw, function(t,a,b) return t[b] < t[a] end) do
        ladderRanks = ladderRanks .. k .. " (Level " .. v .. ")" .. "\n" 
    end

    -- Display the sorted players in a scrolllable box
    tes3mp.ListBox(pid, ccWindowSettings.HardcoreLadder, ladderLabel, ladderRanks)
end

function ccHardcore.ladderExists() 
    -- Ensures the correct ladder file is present for end-of-month edge case
    local hcLadder = os.date("%y%m")
    local ladderFile = io.open(ccConfig.DataPath .. "ladder_" .. hcLadder .. ".json", "r")

    if ladderFile then return true
    else return false
    end
end

function ccHardcore.spairs(t, order) 
    -- Sorts a given table by highest-to-lowest values
    -- Credit to https://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    local keys = {}

    for k in pairs(t) do keys[#keys+1] = k end

    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    local i = 0
    return function()
        i = i + 1

        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end

-----------------
-- EVENTS
-----------------

function ccHardcore.OnPlayerDeath(eventStatus, pid)
    -- Controls death mechanics for hardcore players
    tes3mp.LogMessage(2, "[ccHardcore] OnPlayerDeath called")
    local isSafe = true

    -- Check if this event is blocked by another script like ccBuild
    if eventStatus.validCustomHandlers then

        if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then

            -- Check if player has the hardcoreMode table in their json file
            if ccConfig.HardcoreEnabled and Players[pid].data.hardcoreMode and Players[pid].data.hardcoreMode.enabled == 1 then
                isSafe = false

                -- Player died in a safe cell so we follow vanilla death mechanics
                if ccConfig.Hardcore.SafeCells.enabled and ccConfig.Hardcore.UseSafeCells and ccHardcore.isSafeCell(pid) then
                    isSafe = true
                    return customEventHooks.makeEventStatus(true, false)
                end
            -- Player was created after the hardcore mode update or doesn't have hardcore mode enabled
            else
                isSafe = true
                return customEventHooks.makeEventStatus(true, false)
            end
        else
            return false -- Something's wrong with this player
        end
    end

    if not isSafe then
        tes3mp.LogMessage(2, "[ccHardcore] ccHardcore.OnPlayerDeath fired and checks passed")
        ccHardcore.deathLog(pid)

        local playerName = Players[pid].name
        local playerNameLC = string.lower(Players[pid].name)
        local timePlayed = Players[pid].data.timeKeeping.timePlayed

        local diffDays, diffHours, diffMinutes = ccStats.parseTime(timePlayed, nil, 2)

        tes3mp.SendMessage(pid, color.Red .. "RIP: " .. playerName .. " died after surviving for " .. diffDays ..
            " day(s), " .. diffHours .. " hour(s), " .. diffMinutes .. " minute(s).\n", true)

        if ccConfig.Hardcore.DeathDrop.Enabled then
            ccHardcore.deathDropGold(pid)
        end

        if ccConfig.Hardcore.LadderEnabled and ccHardcore.ladderExists() then
            local hcLadder = "ladder_" .. os.date("%y%m")

            if ccHardcore.LadderList.players[playerNameLC] then
                tes3mp.LogMessage(2, "[ccHardcore] Removing player " .. playerName .. " from the ladder file")
                ccHardcore.LadderList.players[playerNameLC] = nil
                jsonInterface.save("custom/ccsuite/" .. hcLadder .. ".json", ccHardcore.LadderList)
            end
        end

        if ccConfig.FactionsEnabled then
            -- Remove player from their faction if applicable
            local factionNameLC = ""

            if Players[pid].data.factions.id ~= nil and Players[pid].data.factions.id ~= "" then
                tes3mp.LogMessage(2, "[ccHardcore] Attempting to remove " .. playerName .. " from faction " .. factionNameLC)
                factionNameLC = Players[pid].data.factions.id
                ccFactions.leaveFaction(pid)
            end
        end

        -- Thanks to mupf for this approach
        os.remove(ccConfig.PlayerPath .. Players[pid].data.login.name .. ".json")
        Players[pid]:Kick()
    end
end

function ccHardcore.OnPlayerFinishLogin(eventStatus, pid)
    -- Give new players the ccHardcore data entries
    tes3mp.LogMessage(1, "[ccHardcore] OnPlayerFinishLogin: " .. Players[pid].name .. " called")
    ccHardcore.checkPlayerFileEntry(pid)
end

function ccHardcore.OnPlayerLevel(eventStatus, pid)
    -- Update monthly player ladder with new level

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local playerName = Players[pid].name
        local playerNameLC = string.lower(playerName)

        if ccConfig.HardcoreEnabled and ccHardcore.ladderExists() then
            local hcLadder = "ladder_" .. os.date("%y%m")

            if ccHardcore.LadderList.players[playerNameLC] then
                tes3mp.LogMessage(2, "[ccHardcore] Updating ladder level of player " .. playerName)
                ccHardcore.LadderList.players[playerNameLC].level = Players[pid].data.stats.level
                jsonInterface.save("custom/ccsuite/" .. hcLadder .. ".json", ccHardcore.LadderList)
            end
        end
    end
end

function ccHardcore.OnPlayerSendMessage(eventStatus, pid, message)
    -- Appends the prefix [HC] to any chat messages sent by hardcore players
    -- If not a hardcore player, then call the default OnPlayerSendMessage function

    if message:sub(1, 1) ~= '/' then
        local message = color.White .. logicHandler.GetChatName(pid) .. ": " .. message .. "\n"

        if Players[pid]:IsServerStaff() then
            return customEventHooks.makeEventStatus(true, false)
        else

            if Players[pid].data.hardcoreMode and Players[pid].data.hardcoreMode.enabled == 1 then
                message = color.Crimson .. "[HC] " .. message
                tes3mp.SendMessage(pid, message, true)
                return customEventHooks.makeEventStatus(false, false)
            end
        end
    end
end

function ccHardcore.OnServerPostInit(eventStatus)
    -- Performs housekeeping duties every restart

    -- Automatically generates monthly player ladders
    -- https://stackoverflow.com/questions/16367524/copy-csv-file-to-new-file-in-lua
    if ccConfig.Hardcore.LadderEnabled then
        ccHardcore.CurrentLadder = os.date("%y%m")
        local ladderFile = io.open(ccConfig.DataPath .. "ladder_" .. ccHardcore.CurrentLadder .. ".json", "r")

        -- Ladder file is present so do nothing
        if ccHardcore.ladderExists() then
            tes3mp.LogMessage(1, "[ccHardcore] File for ladder " .. ccHardcore.CurrentLadder .. " is present")
        -- Ladder file is not present, so copy template file and write to new file using current month as title
        else
            tes3mp.LogMessage(1, "[ccHardcore] File for ladder " .. ccHardcore.CurrentLadder .. " is not present. Copying" ..
                " template file")

            local templateFile = io.open(ccConfig.DataPath .. "ladderTemplate.json", "r")
            local copyTemplate = templateFile:read("*a")
            templateFile:close()

            tes3mp.LogMessage(1, "[ccHardcore] Template file copied. Writing JSON table")

            ladderFile = io.open(ccConfig.DataPath .. "ladder_" .. ccHardcore.CurrentLadder .. ".json", "w")
            ladderFile:write(copyTemplate)
            ladderFile:close()
            tes3mp.LogMessage(1, "[ccHardcore] File for ladder " .. ccHardcore.CurrentLadder .. " created")
        end

        -- Initializes monthly player ladder table
        tes3mp.LogMessage(2, "[ccHardcore] Loading ladder_" .. os.date("%y%m") .. ".json")
        ccHardcore.LadderList = jsonInterface.load("custom/ccsuite/ladder_" .. os.date("%y%m") .. ".json")
    end
 
    -- If enabled, players drop items on death
    if ccConfig.Hardcore.DeathDrop.Enabled then
        tes3mp.LogMessage(2, "[ccHardcore] Populating death drop table with vanilla entries")

        for index, entryData in ipairs(ccConfig.Hardcore.DeathDrop.Vanilla) do
            table.insert(ccHardcore.DeathDropTable, entryData)
        end

        if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
            tes3mp.LogMessage(2, "[ccHardcore] Populating death drop table with Tamriel entries")

            for index, entryData in ipairs(ccConfig.Hardcore.DeathDrop.Tamriel) do
                table.insert(ccHardcore.DeathDropTable, entryData)
            end
        end
    end
end

if ccConfig.HardcoreEnabled then

    if ccConfig.Hardcore.LadderEnabled then
        customCommandHooks.registerCommand("ladder", ccHardcore.ladderCommand)
    end

    customEventHooks.registerValidator("OnPlayerDeath", ccHardcore.OnPlayerDeath)
    customEventHooks.registerValidator("OnPlayerSendMessage", ccHardcore.OnPlayerSendMessage)
    customEventHooks.registerHandler("OnPlayerFinishLogin", ccHardcore.OnPlayerFinishLogin)
    customEventHooks.registerHandler("OnPlayerLevel", ccHardcore.OnPlayerLevel)
    customEventHooks.registerHandler("OnServerPostInit", ccHardcore.OnServerPostInit)
end

return ccHardcore
