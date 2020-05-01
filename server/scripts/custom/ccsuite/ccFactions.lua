---------------------------
-- ccFactions by Texafornian
--
-- Requires "factionlist.json" in /data/ folder!

------------------
-- FUNCTIONS
------------------

-- -- WIP
-- function ccFactions.factionStats(pid)
    -- -- Displays information about the faction

    -- -- do stuff
-- end


-- -- WIP
-- function ccFactions.windowFactionStats(pid)
    -- -- Creates window that displays stats about the faction such as age and # of members
    -- local statsLabel = "Faction Stats"
    -- local statsText = ""
    -- tes3mp.ListBox(pid, ccWindowSettings.FactionStats, statsLabel, statsText)
-- end

function ccFactions.checkPlayerFileEntry(pid)
    -- Check whether player file has new "factions" data tables
    local changeMade = false

    if not Players[pid].data.factions then
        local factionsData = {}
        factionsData.id = ""
        factionsData.rank = tonumber(0)
        Players[pid].data.factions = factionsData
        changeMade = true
    end

    if not Players[pid].data.factions.lastWarp then
        Players[pid].data.factions.lastWarp = tonumber(0)
        changeMade = true
    end

    if changeMade then Players[pid]:QuicksaveToDrive() end
end

function ccFactions.claimCell(pid)
    -- Claims the player's current cell for their faction (must be officer or leader)
    local currentCell = tes3mp.GetCell(pid)
    local factionName = Players[pid].data.factions.id
    local factionNameLC = string.lower(Players[pid].data.factions.id)

    -- Iterate through FactionList to see if another faction has claimed cell
    for _, faction in pairs(ccFactions.FactionList) do

        if faction.cells[1] == currentCell then
            tes3mp.LogMessage(2, "[ccFactions] Deleting claimed cell " .. currentCell .. " from faction " .. faction.displayName)
            faction.cells[1] = nil
            break
        end
    end

    -- Temporary: Replaced player's faction's claimed cell (if any) with new cell
    -- Future: Allow multiple cells?
    if ccFactions.FactionList[factionNameLC] then
        tes3mp.LogMessage(2, "[ccFactions] Replacing claimed cell #1 from faction " .. factionNameLC .. " with cell " .. currentCell)
        ccFactions.FactionList[factionNameLC].cells[1] = currentCell
        ccFactions.saveFactionList()
        tes3mp.SendMessage(pid, color.Orange .. factionName .. " has claimed a cell: " .. currentCell .. ".\n", true)
    end
end

function ccFactions.createFaction(pid, factionName)
    -- Add news faction to factionlist.json, calls ccFactions.joinFaction to update player data
    local playerName = string.lower(Players[pid].name)

    if not ccFactions.isFactionNameOK(pid, factionName) then return false end

    local factionNameLC = string.lower(factionName)
    local factionInfo = {}

    factionInfo.displayName = factionName
    factionInfo.leader = playerName
    factionInfo.members = {}
    factionInfo.cells = {}
    factionInfo.creationTime = os.time()
    factionInfo.lastLogin = os.time()
    ccFactions.FactionList[factionNameLC] = factionInfo
    ccFactions.saveFactionList()

    ccFactions.joinFaction(pid, factionName)
end

function ccFactions.deleteFaction(pid, factionName)
    -- Called from admin-only command: /faction delete <faction name>
    local factionNameLC = string.lower(factionName)
    local message = ""

    if ccFactions.doesFactionExist(factionNameLC) then

        if ccFactions.FactionList[factionNameLC] then
            ccFactions.FactionList[factionNameLC] = nil
            ccFactions.saveFactionList()
        end

        for _, p in pairs(Players) do -- Check connected players for this faction's entry and remove it

            if p ~= nil and p:IsLoggedIn() then
            
                if string.lower(p.data.factions.id) == factionNameLC then 
                    ccFactions.removeFactionEntry(p.pid)
                end
            end
        end

        message = color.Orange .. "A faction has been disbanded: " .. factionName .. ".\n"
        tes3mp.SendMessage(pid, message, true)
    else
        message = color.Red .. "That faction doesn't exist. Type the name exactly as it appears in the list without quotation marks.\n"
        tes3mp.SendMessage(pid, message, false)
    end
end

function ccFactions.disbandFaction(pid)
    -- Delete the faction from factionlist.json and remove entries from connected members
    tes3mp.LogMessage(1, "[ccFactions] disbandFaction: " .. Players[pid].name .. " called")
    local factionName = Players[pid].data.factions.id
    local factionNameLC = string.lower(factionName)
    local playerName = Players[pid].name

    if ccFactions.FactionList[factionNameLC] then -- Remove faction entry from factionlist.json
        tes3mp.LogMessage(1, "[ccFactions] disbandFaction: Deleting faction " .. factionName)
        ccFactions.FactionList[factionNameLC] = nil
        ccFactions.saveFactionList()
        tes3mp.LogMessage(1, "[ccFactions] disbandFaction: ...faction " .. factionName .. " was deleted")
    end

    for _, p in pairs(Players) do -- Check connected players for this faction's entry and remove it
        tes3mp.LogMessage(1, "[ccFactions] disbandFaction: Iterating through 'for' loop")

        if p ~= nil and p:IsLoggedIn() then

            if string.lower(p.data.factions.id) == factionNameLC then
                tes3mp.LogMessage(1, "[ccFactions] disbandFaction: Clearing faction entry from player file of " .. p.name)
                ccFactions.removeFactionEntry(p.pid)
            end
        end
    end

    tes3mp.LogMessage(1, "[ccFactions] disbandFaction: Reached end")

    local message = color.Green .. playerName .. " has disbanded a faction: " .. color.Yellow .. factionName .. color.Green .. ".\n"
    tes3mp.SendMessage(pid, message, true)
end

function ccFactions.doesFactionExist(factionName)
    -- Checks whether the chosen faction exists in factionlist.json

    if ccFactions.FactionList[factionName] then return true end
    return false
end

function ccFactions.factionChatCommand(pid, cmd)
    -- Sends faction chat message to faction members who are online

    if not ccFactions.isInAFaction(pid) then
        tes3mp.SendMessage(pid, color.Error .. "You must be in a faction to use faction chat.\n", false)
        return false
    end

    local factionName = Players[pid].data.factions.id
    local message = tableHelper.concatenateFromIndex(cmd, 2) .. "\n"
    message = ccConfig.Factions.ChatColor .. logicHandler.GetChatName(pid) .. ": " .. message

    -- Check connected players for faction's entry and send message
    for _, p in pairs(Players) do

        if p ~= nil and p:IsLoggedIn() and p.data.factions.id == factionName then
            tes3mp.SendMessage(p.pid, message, false)
        end
    end
end

function ccFactions.factionCommand(pid, cmd)
    -- Determines which window should be opened when /faction with arguments called

    if cmd[2] == nil then
        ccFactions.factionMenuCommand(pid)
    elseif cmd[2] == "delete" and cmd[3] ~= nil and Players[pid]:IsAdmin() then
        ccFactions.deleteFaction(pid, cmd[3])
    else
        tes3mp.SendMessage(pid, color.Red .. "Typing /faction brings up the main faction menu.\n", false)
        return false
    end
end

function ccFactions.factionMenuCommand(pid)
    -- Called from /faction with no arguments; main ccFactions GUI window
    local factionName = "None"
    local factionText = ""
    tes3mp.LogMessage(1, "[ccFactions] factionMenuCommand: " .. Players[pid].name .. " called")

    if not ccFactions.isInAFaction(pid) then
        factionText = "Create new faction\nList all factions\nCancel"
    else
        factionName = Players[pid].data.factions.id

        if tonumber(Players[pid].data.factions.rank) == 2 then
            factionText = "List all members\nInvite player to faction\nPromote member\nKick member\nDisband faction\n"
                .. "Claim current cell\nWarp to faction cell\nList all factions\nCancel"
        elseif tonumber(Players[pid].data.factions.rank) == 1 then
            factionText = "List all members\nInvite player to faction\nKick member\nLeave faction\nClaim current cell\n"
                .. "Warp to faction cell\nList all factions\nCancel"
        else
            factionText = "List all members\nLeave faction\nWarp to faction cell\nList all factions\nCancel"
        end
    end

    local factionLabel = "Current Faction: " .. factionName
    tes3mp.ListBox(pid, ccWindowSettings.Faction, factionLabel, factionText)
end

function ccFactions.isFactionNameOK(pid, factionName)
    -- Checks chosen faction name versus existing factions and disallowed names
    local chosenName = string.lower(factionName)
    local message = ""

    -- Check chosen name against existing factions
    if ccFactions.doesFactionExist(chosenName) then
        message = color.Red .. "A faction with that name already exists. Please choose a different name.\n"
        tes3mp.SendMessage(pid, message, false)
        return false
    end

    -- Check chosen names against disallowed names
    for _, disallowedName in pairs(config.disallowedNameStrings) do

        if string.find(chosenName, string.lower(disallowedName)) ~= nil then
            message = color.Red .. "The chosen name contains a disallowed word. Please choose a different name.\n"
            tes3mp.SendMessage(pid, message, false)
            return false
        end
    end
    return true
end

function ccFactions.isInAFaction(pid)
    -- Checks whether a player is a member of any faction

    if Players[pid].data.factions.id == nil or Players[pid].data.factions.id == "" then return false
    else return true
    end
end

function ccFactions.joinFaction(pid, factionName)
    -- Finishes faction joining process
    -- Updates player and factionlist.json files with new membership info
    local playerName = Players[pid].name
    local playerNameLC = string.lower(Players[pid].name)
    local factionNameLC = string.lower(factionName)
    local message = color.Green .. playerName .. " has "

    if playerNameLC == string.lower(ccFactions.FactionList[factionNameLC].leader) then
        table.insert(ccFactions.FactionList[factionNameLC].members, { playerNameLC, 2 })
        Players[pid].data.factions.rank = 2
        message = message .. "formed a new faction: " .. color.Yellow .. factionName .. ".\n"
    else
        table.insert(ccFactions.FactionList[factionNameLC].members, { playerNameLC, 0 })
        message = message .. "joined a faction: " .. color.Yellow .. factionName .. ".\n"
    end
    ccFactions.saveFactionList()
    tes3mp.SendMessage(pid, message, true)

    Players[pid].data.factions.id = factionName
    Players[pid]:QuicksaveToDrive()
end

function ccFactions.kickMember(pid, pick, factionNameLC)
    -- Kicks a player from the faction
    local target = ccFactions.FactionList[factionNameLC].members[pick][1]
    tes3mp.LogMessage(2, "ccFactions.FactionList[factionNameLC].members[pick] = " .. target)

    if string.lower(Players[pid].name) == string.lower(target) then
        tes3mp.SendMessage(pid, color.Error .. "You can't kick yourself from your faction.\n", false)
        return false
    elseif Players[currentPid].data.factions.rank <= ccFactions.FactionList[factionNameLC].members[pick][2] then
        tes3mp.SendMessage(pid, color.Error .. "You can't kick a member with an equal or higher rank.\n", false)
        return false
    end

    local isOnline = false

    for _, p in pairs(Players) do

        if string.lower(target) == string.lower(p.name) then
            local currentPid = tonumber(p.pid)

            if factionNameLC == string.lower(Players[currentPid].data.factions.id) then

                if Players[currentPid] ~= nil and Players[currentPid]:IsLoggedIn() then
                    tes3mp.LogMessage(1, "[ccFactions] kickMember: isOnline is true")
                    isOnline = true
                    ccFactions.removeFactionEntry(currentPid)
                else
                    tes3mp.SendMessage(pid, color.Error .. "ERROR: " .. target .. " is improperly connected. Kicking ".. target
                        .." via ccFactions.FactionList approach.", false)
                end
                break
            end
        end
    end

    if not isOnline then
        tes3mp.LogMessage(1, "[ccFactions] kickMember: isOnline false, kicking " .. target .. " from faction")

        if ccFactions.removeMemberEntry(factionNameLC, string.lower(target)) then
            local message = color.Orange .. "You've kicked " .. target .. " from your faction.\n"
            tes3mp.SendMessage(pid, message, false)
        end
    end
end

function ccFactions.leaveFaction(pid)
    -- Removes player from faction if not leader, disbands faction if leader
    local factionNameLC = string.lower(Players[pid].data.factions.id)
    local playerName = string.lower(Players[pid].name)

    if playerName == string.lower(ccFactions.FactionList[factionNameLC].leader) then ccFactions.disbandFaction(pid)
    else
        ccFactions.removeFactionEntry(pid)
        ccFactions.removeMemberEntry(factionNameLC, playerName)
    end
end

function ccFactions.listMembers(factionName)
    -- Returns a list of all members of the player's faction including the player
    local memberText = ""

    for _, member in pairs(ccFactions.FactionList[factionName].members) do

        if tonumber(member[2]) == 2 then memberText = memberText .. member[1] .. " (Leader)\n"
        elseif tonumber(member[2]) == 1 then memberText = memberText .. member[1] .. " (Officer)\n"
        else memberText = memberText .. member[1] .. "\n"
        end
    end

    memberText = memberText .. "Cancel"
    return memberText
end

function ccFactions.promoteMember(pid, pick, factionNameLC)
    -- Promote a player of rank 0 (member) to rank 1 (officer)
    local target = ccFactions.FactionList[factionNameLC].members[pick][1]
    tes3mp.LogMessage(2, "ccFactions.FactionList[factionNameLC].members[pick] = " .. target)

    if string.lower(Players[pid].name) == string.lower(target) then
        tes3mp.SendMessage(pid, color.Error .. "You can't promote yourself.\n", false)
        return false
    elseif ccFactions.FactionList[factionNameLC].members[pick][2] >= 1 then
        tes3mp.SendMessage(pid, color.Error .. "You can't promote an Officer.\n", false)
        return false
    end

    for _, p in pairs(Players) do

        if target == string.lower(p.name) then
            --local targetName = p.name
            local targetPid = tonumber(p.pid)
            local message = ""

            if factionNameLC == string.lower(Players[targetPid].data.factions.id) then
                tes3mp.LogMessage(1, "[ccFactions] promoteMember: Promoting player " .. target)

                for k, v in pairs(ccFactions.FactionList[factionNameLC].members) do

                    if v[1] == target then
                        tes3mp.LogMessage(1, "[ccFactions] removeMemberEntry: Updating " .. target .. "'s rank to 1 in faction " .. factionNameLC)
                        v[2] = 1
                        ccFactions.saveFactionList()
                    end
                end

                if Players[targetPid] ~= nil and Players[targetPid]:IsLoggedIn() then
                    Players[targetPid].data.factions.rank = 1
                    Players[targetPid]:QuicksaveToDrive()
                    message = "FACTION: You have been promoted to the rank of Officer.\n"
                end

                message = color.Orange .. "FACTION: You have promoted " .. target .. " to Officer.\n"
                tes3mp.SendMessage(pid, message, false)
                break
            end
        end
    end
end

function ccFactions.removeFactionEntry(pid)
    -- Remove faction entry from player files after faction is deleted
    local factionName = Players[pid].data.factions.id
    local factionNameLC = string.lower(factionName)
    local playerName = Players[pid].name
    local playerNameLC = string.lower(Players[pid].name)

    Players[pid].data.factions.id = ""
    Players[pid].data.factions.rank = 0
    Players[pid]:QuicksaveToDrive()

    local message = ""

    if ccFactions.doesFactionExist(factionNameLC) then
        ccFactions.removeMemberEntry(factionNameLC, playerNameLC)
        message = color.Orange .. "FACTION: " .. playerName .. " is no longer a member of:\n" .. color.Yellow .. factionName .. "\n"
        tes3mp.SendMessage(pid, message, true)
    else
        message = color.Orange .. "FACTION: You have been removed from your faction because it no longer exists.\n"
        tes3mp.SendMessage(pid, message, false)
    end
end

function ccFactions.removeMemberEntry(factionNameLC, playerName)
    -- Removes a player from a faction

    -- Iterate through faction members and remove to-be-kicked player if found
    for k, v in pairs(ccFactions.FactionList[factionNameLC].members) do

        if v[1] == playerName then
            tes3mp.LogMessage(1, "[ccFactions] removeMemberEntry: Removing " .. playerName .. " from faction " .. factionNameLC)
            ccFactions.FactionList[factionNameLC].members[tonumber(k)] = nil
            ccFactions.saveFactionList()
            return true
        end
    end
    return false
end

function ccFactions.saveFactionList()
    -- Saves factionlist.json
    tes3mp.LogMessage(1, "[ccFactions] Saving factionlist.json")
    jsonInterface.save("custom/ccsuite/factionlist.json", ccFactions.FactionList)
end

function ccFactions.warpFactionCell(pid)
    -- Teleports player to their faction's claimed cell
    local factionNameLC = string.lower(Players[pid].data.factions.id)

    if ccFactions.FactionList[factionNameLC] then

        if ccFactions.FactionList[factionNameLC].cells[1] then
            local diff = (os.time() - Players[pid].data.factions.lastWarp)
            local numSeconds = ccConfig.Factions.WarpCooldown

            if (diff / numSeconds) > 1 then
                Players[pid].data.factions.lastWarp = os.time()
                Players[pid]:QuicksaveToDrive()
                tes3mp.SetCell(pid, ccFactions.FactionList[factionNameLC].cells[1])
                tes3mp.SendCell(pid)
            else
                tes3mp.SendMessage(pid, color.Error .. "You must wait to use that command again.", false)
            end
        else
            tes3mp.SendMessage(pid, color.Error .. "Your faction hasn't claimed a cell.", false)
        end
    else
        tes3mp.LogMessage(2, "[ccFactions] ERROR in ccFactions.warpFactionCell")
        tes3mp.SendMessage(pid, color.Error .. "ERROR: Please alert an admin.", false)
    end
end

function ccFactions.windowClaimCell(pid)
    -- Asks the player to confirm Yes/No whether they want to claim their current cell

    -- Return if error encountered
    if not ccConfig.Factions.ClaimCellsEnabled then
        tes3mp.SendMessage(pid, color.Error .. "That option isn't enabled on this server.\n", false)
        return false
    elseif tes3mp.IsInExterior(pid) then
        tes3mp.SendMessage(pid, color.Error .. "You can only claim interior cells.\n", false)
        return false
    end

    local currentCell = tes3mp.GetCell(pid)

    for _, v in pairs(ccConfig.Factions.ProhibitedCells) do

        if string.find(currentCell, v[1]) then
            tes3mp.SendMessage(pid, color.Error .. "You can't claim this cell.\n", false)
            return false
        end
    end

    local claimText = "Are you sure that you want to claim this cell?\nYou can only claim one cell at a time."
    tes3mp.CustomMessageBox(pid, ccWindowSettings.ClaimCell, claimText, "Yes;No")
end

function ccFactions.windowCreateFaction(pid)
    -- Asks the player to input a name for their new faction 
    local createLabel = "Please enter a name for your faction."
    tes3mp.InputDialog(pid, ccWindowSettings.CreateFaction, createLabel, "")
end

function ccFactions.windowDisbandFaction(pid)
    -- Asks the player to confirm Yes/No whether they want to delete faction
    local deleteText = "Are you sure you want to disband your faction?"
    tes3mp.CustomMessageBox(pid, ccWindowSettings.DisbandFaction, deleteText, "Yes;No")
end

function ccFactions.windowFactionInvite(pid)
    -- Displays list box of online players to invite into faction
    local inviteLabel = "Please choose a player to invite:"
    local inviteText = ""

    for _, p in pairs(Players) do

        if p ~= nil and p:IsLoggedIn() then
            table.insert(ccFactions.PidTable, tonumber(p.pid))
            inviteText = inviteText .. p.name .. "\n"
        end
    end

    inviteText = inviteText .. "Cancel"
    tes3mp.ListBox(pid, ccWindowSettings.FactionInvite, inviteLabel, inviteText)
end

function ccFactions.windowFactionInviteSend(pid, targetPid)
    -- Controls inviting other online players into your faction
    ccFactions.PidTable = {}

    if tonumber(pid) == tonumber(targetPid) then
        tes3mp.SendMessage(pid, color.Error .. "You can't invite yourself.\n", false)
        return false
    elseif ccFactions.isInAFaction(targetPid) then
        tes3mp.SendMessage(pid, color.Error .. "That player is already in a faction.\n", false)
        return false
    end

    local factionName = Players[pid].data.factions.id
    local factionPlayer = Players[pid].name
    local message = color.LightBlue .. "Invitation sent. Waiting on response...\n"
    tes3mp.SendMessage(pid, message, false)

    local inviteIdGui = tonumber(pid + ccWindowSettings.FactionInviteSend)
    local inviteText = factionPlayer .. " has invited you to join their faction:\n" .. factionName .. ".\n\nClick 'Yes'" ..
        " to accept the invitation, or 'No' to reject it."
    tes3mp.CustomMessageBox(targetPid, inviteIdGui, inviteText, "Yes;No")
end

function ccFactions.windowKickMember(pid)
    -- Displays list box of faction members to kick from faction
    local factionNameLC = string.lower(Players[pid].data.factions.id)
    local kickLabel = "Please choose a member to kick:"
    local kickText = ccFactions.listMembers(factionNameLC)
    tes3mp.ListBox(pid, ccWindowSettings.KickMember, kickLabel, kickText)
end

function ccFactions.windowListFactions(pid)
    -- Creates window that displays all factions
    local listLabel = "Faction (Leader)"
    local listText = ""

    for _, faction in pairs(ccFactions.FactionList) do
        local leaderName = faction.leader
        listText = listText .. faction.displayName .. " (" .. leaderName .. ")\n"
    end

    tes3mp.ListBox(pid, ccWindowSettings.ListFactions, listLabel, listText)
end

function ccFactions.windowListMembers(pid)
    -- Creates window that displays all members in player's functions
    local memberLabel = "List of faction members"
    local factionName = string.lower(Players[pid].data.factions.id)
    local memberText = ccFactions.listMembers(factionName)
    tes3mp.ListBox(pid, ccWindowSettings.ListMembers, memberLabel, memberText)
end

function ccFactions.windowLeaveFaction(pid)
    -- Asks the player to confirm Yes/No whether they want to leave their faction
    local leaveText = "Are you sure that you want to leave your faction?"
    tes3mp.CustomMessageBox(pid, ccWindowSettings.LeaveFaction, leaveText, "Yes;No")
end

function ccFactions.windowPromoteMember(pid)
    -- Displays list box of faction members to promote
    local factionNameLC = string.lower(Players[pid].data.factions.id)
    local promoteLabel = "Please choose a member to promote to Officer:"
    local promoteText = ccFactions.listMembers(factionNameLC)
    tes3mp.ListBox(pid, ccWindowSettings.PromoteMember, promoteLabel, promoteText)
end

------------------
-- EVENTS
------------------

function ccFactions.OnPlayerEndCharGen(eventStatus, pid)
    -- Give new players the ccFactions data entries
    tes3mp.LogMessage(1, "[ccFactions] OnPlayerEndCharGen: " .. Players[pid].name .. " called")
    ccFactions.checkPlayerFileEntry(pid)
end

function ccFactions.OnPlayerFinishLogin(eventStatus, pid)
    -- Check whether player's stored faction still exists upon logging in and updates latest login time for faction
    tes3mp.LogMessage(1, "[ccFactions] OnPlayerFinishLogin: " .. Players[pid].name .. " called")
    ccFactions.checkPlayerFileEntry(pid)

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() and ccFactions.isInAFaction(pid) then
        tes3mp.LogMessage(1, "[ccFactions] OnPlayerFinishLogin: " .. Players[pid].name .. " is/was in a faction")
        local factionName = Players[pid].data.factions.id
        local factionNameLC = string.lower(factionName)

        if not ccFactions.doesFactionExist(factionNameLC) then
            tes3mp.LogMessage(1, "[ccFactions] OnPlayerFinishLogin: Removing " .. Players[pid].name .. " from faction due" ..
                " to deletion")
            ccFactions.removeFactionEntry(pid)
        else
            local playerName = string.lower(Players[pid].name)
            local playerNameLC = string.lower(Players[pid].name)

            for _, entry in pairs(ccFactions.FactionList[factionNameLC].members) do

                if entry[1] == playerNameLC then

                    -- Check if player was promoted while offline
                    if Players[pid].data.factions.rank ~= entry[2] then

                        if Players[pid].data.factions.rank < entry[2] then
                            tes3mp.SendMessage(pid, color.Orange .. "FACTION: You have been promoted to Officer!\n", false)
                        else
                            tes3mp.SendMessage(pid, color.Orange .. "FACTION: You have been demoted.\n", false)
                        end
                        Players[pid].data.factions.rank = entry[2]
                        Players[pid]:QuicksaveToDrive()
                    end

                    -- Update the faction's last login time to avoid deletion
                    tes3mp.LogMessage(1, "[ccFactions] OnPlayerFinishLogin: " .. playerName .. " updated last login of" .. 
                        " faction " .. factionName)
                    ccFactions.FactionList[factionNameLC].lastLogin = os.time()
                    ccFactions.saveFactionList()
                    return
                end
            end

            tes3mp.LogMessage(1, "[ccFactions] OnPlayerFinishLogin: Removing " .. playerName .. " from faction" ..
                " due to being kicked")
            ccFactions.removeFactionEntry(pid)
        end
    end
end

function ccFactions.OnServerPostInit(eventStatus)
    -- Initializes factions table
	tes3mp.LogMessage(1, "[ccFactions] Loading factionlist.json")
	ccFactions.FactionList = jsonInterface.load("custom/ccsuite/factionlist.json")

    -- Cleans up inactive factions
    tes3mp.LogMessage(1, "[ccFactions] Cleaning factionlist.json")
    local changeMade = false
    local factionNames = ccFactions.FactionList 

    for i, f in pairs(factionNames) do

        if f.lastLogin == "" or type(f.lastLogin) == "string" then -- Shouldn't happen
            -- WIP: ccFactions.FactionList[i] = os.time()
            f.lastLogin = os.time()
        else
            local diff = (os.time() - f.lastLogin)

            if (diff / 86400) > ccConfig.DaysInactive then
                tes3mp.LogMessage(1,"[ccFactions] ...deleting an inactive faction entry...")
                ccFactions.FactionList[i] = nil
                changeMade = true
            end
        end
    end

    if changeMade then ccFactions.saveFactionList() end
end

if ccConfig.FactionsEnabled then
    customCommandHooks.registerCommand("f", ccFactions.factionChatCommand)
    customCommandHooks.registerCommand("faction", ccFactions.factionCommand)

    customEventHooks.registerHandler("OnPlayerEndCharGen", ccFactions.OnPlayerEndCharGen)
    customEventHooks.registerHandler("OnPlayerFinishLogin", ccFactions.OnPlayerFinishLogin)
    customEventHooks.registerHandler("OnServerPostInit", ccFactions.OnServerPostInit)
end

return ccFactions
