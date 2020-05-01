---------------------------
-- ccCommands 0.7.0 by Texafornian
--
-- 

-----------------
-- FUNCTIONS
-----------------

function ccCommands.bounty(pid, cmd)
    -- Changes a player's bounty value

    if not Players[pid]:IsModerator() then return false end

    local pid2 = 0
    local num = 0

    if tonumber(cmd[2]) ~= nil and tonumber(cmd[3]) ~= nil then
        pid = tonumber(cmd[2])
        num = tonumber(cmd[3])
    end

    if logicHandler.CheckPlayerValidity(pid, pid2) then
        tes3mp.SetBounty(pid2, num)
        tes3mp.SendBounty(pid2)
        Players[pid2]:SaveBounty()

        tes3mp.SendMessage(pid, color.Yellow .. "Setting player " .. pid2 .. "'s bounty to " .. num .. "." .. color.Default ..
            "\n", false)
        tes3mp.SendMessage(pid2, color.Yellow .. "Your bounty has been changed to " .. num .. "." .. color.Default .. "\n", false)
    end
end

function ccCommands.coordinates(pid)
    -- Displays player's current coordinates

    local message = "Coordinates: " .. tes3mp.GetExteriorX(pid) .. ", " .. tes3mp.GetExteriorY(pid) .. ", "
    .. tes3mp.GetPosX(pid) .. ", " .. tes3mp.GetPosY(pid) .. ", " .. tes3mp.GetPosZ(pid) .. ", "
    .. tes3mp.GetRotZ(pid) .. ", " .. "\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccCommands.customWindow1(pid)
    tes3mp.CustomMessageBox(pid, -1, ccConfig.Commands.InfoWindow1.Message .. "\n", "Ok")
end

function ccCommands.customWindow2(pid)
    tes3mp.CustomMessageBox(pid, -1, ccConfig.Commands.InfoWindow2.Message .. "\n", "Ok")
end

function ccCommands.customWindow3(pid)
    tes3mp.CustomMessageBox(pid, -1, ccConfig.Commands.InfoWindow3.Message .. "\n", "Ok")
end

function ccCommands.deleteCharacter(pid)
    local deleteText = "Are you sure you wish to delete your character?\n\
    This can't be undone! If you choose Yes, then you will be kicked and your character will be deleted from the server.\n\
    You'll be able to make a new character with your old name upon reconnecting, if you wish, but you'll lose your tokens in the process."
    tes3mp.CustomMessageBox(pid, ccWindowSettings.DeleteCharacter, deleteText, "Yes;No")
end

function ccCommands.finalizeDeleteCharacter(pid)
    -- Deletes the player's character file and hardcore ladder entry
    local playerName = string.lower(Players[pid].name)
    local playerNameLC = string.lower(Players[pid].data.login.name)

    tes3mp.LogMessage(2, "[ccCommands] " .. playerName .. " has called ccCommands.DeleteCharacter")

    -- don't delete the player entry from the token file!
 
    if Players[pid].data.hardcoreMode then -- Ensure that player is removed from HC ladder if applicable

        if ccConfig.HardcoreEnabled and ccHardcore.ladderExists() then
            local hcLadder = "ladder_" .. os.date("%y%m")

            if ccHardcore.LadderList.players[playerNameLC] then
                tes3mp.LogMessage(2, "[ccHardcore] Removing player " .. playerName .. " from the ladder file")
                ccHardcore.LadderList.players[playerNameLC] = nil
                jsonInterface.save("custom/ccsuite/" .. hcLadder .. ".json", ccHardcore.LadderList)
            end
        end
    end

    -- Thanks to mupf for this approach
    os.remove(ccConfig.PlayerPath .. Players[pid].data.login.name .. ".json")
    Players[pid]:Kick()
    tes3mp.LogMessage(2, "[ccCommands] " .. playerName .. " has been deleted")
end

function ccCommands.punishCell(pid, cmd)
    -- Used to send a player into a cell with no doors
    local targetPid = tonumber(cmd[3])

    if #ccCommands.Punish.IntTable == 0 then
        local message = color.Red .. "You must enter at least one cell in ccConfig.lua's ccConfig.Commands.Punish.Vanilla.Interiors table.\n"
        tes3mp.SendMessage(pid, message, false)
        return false
    end

    if logicHandler.CheckPlayerValidity(pid, targetPid) then
        local targetPlayerName = Players[targetPid].name

        -- Try to improve RNG
        math.randomseed(os.time())
        math.random(); math.random()

        local rando = math.random(1, #ccCommands.Punish.IntTable)

        tes3mp.SetCell(targetPid, ccCommands.Punish.IntTable[rando][1])
        tes3mp.SendCell(targetPid)

        local message = color.Orange .. "SERVER: " .. targetPlayerName .. " has been sent to an alternate dimension.\n"
        tes3mp.SendMessage(pid, message, true)
    end
end


function ccCommands.punishOcean(pid, cmd)
    -- Used to send a player into the ocean
    local targetPid = tonumber(cmd[3])

    if #ccCommands.Punish.ExtTable == 0 then
        local message = color.Red .. "You must enter at least one cell in ccConfig.lua's ccConfig.Commands.Punish.Vanilla.Exteriors table.\n"
        tes3mp.SendMessage(pid, message, false)
        return false
    end
    
    if logicHandler.CheckPlayerValidity(pid, targetPid) then
        local targetPlayerName = Players[tonumber(targetPid)].name

        -- Try to improve RNG
        math.randomseed(os.time())
        math.random(); math.random()

        local rando = math.random(1, #ccCommands.Punish.ExtTable)

        tes3mp.SetCell(targetPid, ccCommands.Punish.ExtTable[rando][1])
        tes3mp.SendCell(targetPid)

        tes3mp.SetPos(targetPid, ccCommands.Punish.ExtTable[rando][2], ccCommands.Punish.ExtTable[rando][3], ccCommands.Punish.ExtTable[rando][4])
        tes3mp.SetRot(targetPid, 0, ccCommands.Punish.ExtTable[rando][5])
        tes3mp.SendPos(targetPid)

        local message = color.Orange .. "SERVER: " .. targetPlayerName .. " is going for a swim.\n"
        tes3mp.SendMessage(pid, message, true)
    end
end

function ccCommands.punishHandler(pid, cmd)

    if not Players[pid]:IsModerator() then return false end

    if cmd[2] == "cell" and tonumber(cmd[3]) ~= nil then ccCommands.punishCell(pid, cmd)
    elseif cmd[2] == "ocean" and tonumber(cmd[3]) ~= nil then ccCommands.punishOcean(pid, cmd)
    else
        local message = color.Red .. "The correct format is: /punish <cell/ocean> <target pid>.\n"
        tes3mp.SendMessage(pid, message, false)
    end
end

function ccCommands.roll(pid)
    -- Used to roll the dice
    local cellDescription = Players[pid].data.location.cell

    -- Try to improve RNG
    math.randomseed(os.time())
    math.random(); math.random()

    local rando = math.random(0, 100)

    if logicHandler.IsCellLoaded(cellDescription) then

        for _, visitorPid in pairs(LoadedCells[cellDescription].visitors) do

            local playerName = tes3mp.GetName(pid)
            local message = color.LightPink .. playerName .. " (" .. pid .. ") rolls " .. rando .. ".\n"
            tes3mp.SendMessage(visitorPid, message, false)
        end
    end
end

function ccCommands.sMsg(pid, cmd)
    -- Sends a uniquely-colored server-wide message
    if not Players[pid]:IsModerator() then return false end

    local message = color.Orange .. "SERVER: " .. tableHelper.concatenateFromIndex(cmd, 2) .. "\n"
    tes3mp.SendMessage(pid, message, true)
end

customCommandHooks.registerCommand("bounty", ccCommands.bounty)
customCommandHooks.registerCommand("deletecharacter", ccCommands.deleteCharacter)
customCommandHooks.registerCommand("loc", ccCommands.coordinates)
customCommandHooks.registerCommand("punish", ccCommands.punishHandler)
customCommandHooks.registerCommand("roll", ccCommands.roll)
customCommandHooks.registerCommand("s", ccCommands.sMsg)

if ccConfig.Commands.InfoWindow1.Command ~= nil then
    customCommandHooks.registerCommand(ccConfig.Commands.InfoWindow1.Command, ccCommands.customWindow1)
end

if ccConfig.Commands.InfoWindow2.Command ~= nil then
    customCommandHooks.registerCommand(ccConfig.Commands.InfoWindow2.Command, ccCommands.customWindow2)
end

if ccConfig.Commands.InfoWindow3.Command ~= nil then
    customCommandHooks.registerCommand(ccConfig.Commands.InfoWindow3.Command, ccCommands.customWindow3)
end

return ccCommands
