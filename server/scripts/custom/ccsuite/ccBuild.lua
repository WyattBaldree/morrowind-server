---------------------------
-- ccBuild 0.7.0 by Texafornian
--
--

-----------------
-- FUNCTIONS
-----------------

function ccBuild.buildCommand(pid)
    -- Either sends the player to build cell or opens build window
    local currentCell = tes3mp.GetCell(pid)

    if currentCell ~= ccConfig.Build.BuildCell[1] then
        ccCommon.teleportHandler(pid, ccConfig.Build.BuildCell)
    else
        local buildLabel = "Please choose an option below:"
        local buildText = ccBuild.BuildTableText
        tes3mp.ListBox(pid, ccWindowSettings.Build, buildLabel, ccBuild.BuildTableText)
    end
end

function ccBuild.choiceHandler(pid, pick)
    -- Calls appropriate function stored in BuildTable
    tes3mp.LogMessage(2, "[ccBuild] ccBuild.choiceHandler called")
    ccBuild.BuildTable[pick].storedFunc(pid)
end

function ccBuild.givePlayerPillows(pid)
    -- Gives the player a number of pillows for building
    item = { refId = "misc_uni_pillow_01", count = ccConfig.Build.NumberOfPillows, charge = -1 }
    table.insert(Players[pid].data.inventory, item)
    Players[pid]:LoadInventory()
    Players[pid]:LoadEquipment()
    tes3mp.SendMessage(pid, color.Yellow .. "You've received " .. ccConfig.Build.NumberOfPillows .. " pillows.\n", false)
end

function ccBuild.leaveBuildCell(pid)
    -- Sends the player back to the sspecified return cell (ccConfig.lua)
    ccCommon.teleportHandler(pid, ccConfig.Build.ReturnCell)
end

function ccBuild.setupBuild()
    tes3mp.LogMessage(2, "[ccBuild] Populating build table")

    for index, _ in ipairs(ccBuild.BuildTable) do

        if ccBuild.BuildTable[index].name ~= nil then
            ccBuild.BuildTableText = ccBuild.BuildTableText .. ccBuild.BuildTable[index].name .. "\n"
        end
    end
    ccBuild.BuildTableText = ccBuild.BuildTableText .. "Cancel"
end

-- ccBuild commands available to the player
-- NOTE: Don't edit anything inside the entries
-- If you want to prevent a player from using a command, then remove the entry entry from the table
ccBuild.BuildTable = {
    { name = "Receive " .. ccConfig.Build.NumberOfPillows .. " Pillows", storedFunc = ccBuild.givePlayerPillows },
    { name = "Leave Build Area", storedFunc = ccBuild.leaveBuildCell }
}

-----------------
-- EVENTS
-----------------

function ccBuild.OnDeathTimeExpiration(eventStatus, pid)
    -- Overwrites default death behavior if ccConfig.Build.SafeBuildEnabled is true
    local deathCell = tes3mp.GetCell(pid)
    tes3mp.LogMessage(2, "deathCell = " .. deathCell)

    if ccConfig.Build.SafeBuildEnabled and deathCell == ccConfig.Build.BuildCell[1] then
        tes3mp.SetCell(pid, ccConfig.Build.BuildCell[1])
        tes3mp.SendCell(pid)

        tes3mp.SetPos(pid, ccConfig.Build.BuildCell[2],
            ccConfig.Build.BuildCell[3], ccConfig.Build.BuildCell[4])
        tes3mp.SetRot(pid, 0, ccConfig.Build.BuildCell[5])
        tes3mp.SendPos(pid)

        if Players[pid].data.shapeshift.isWerewolf then
            Players[pid]:SetWerewolfState(false)
        end

        contentFixer.UnequipDeadlyItems(pid)
        tes3mp.Resurrect(pid, enumerations.resurrect.REGULAR)
        return customEventHooks.makeEventStatus(false, false)
    end
end

function ccBuild.OnPlayerDeath(eventStatus, pid)
    -- Overwrites OnPlayerDeath events from ccHardcore and others if dead in enabled safe cell
    tes3mp.LogMessage(2, "[ccBuild] OnPlayerDeath called")
    local deathCell = tes3mp.GetCell(pid)

    if ccConfig.Build.SafeBuildEnabled and deathCell == ccConfig.Build.BuildCell[1] then
        tes3mp.LogMessage(2, "[ccBuild] ccBuild.OnPlayerDeath fired and checks passed")
        return customEventHooks.makeEventStatus(true, false)
    end
end

function ccBuild.OnServerPostInit(eventStatus, pid)
    -- Performs housekeeping duties every restart
    ccBuild.setupBuild()
end

if ccConfig.BuildEnabled then
    customCommandHooks.registerCommand("build", ccBuild.buildCommand)

    customEventHooks.registerValidator("OnDeathTimeExpiration", ccBuild.OnDeathTimeExpiration)
    customEventHooks.registerValidator("OnPlayerDeath", ccBuild.OnPlayerDeath)
    customEventHooks.registerHandler("OnServerPostInit", ccBuild.OnServerPostInit)
end

return ccBuild
