---------------------------
-- ccWindowManager 0.7.0 by Texafornian
--
-- 

-----------------
-- DECLARATIONS
-----------------

-- ccBuild
ccWindowSettings.Build = 81000

-- ccCommands
ccWindowSettings.DeleteCharacter = 81100
ccWindowSettings.MOTD = 81101

-- ccFactions
-- FactionInvite & FactionInviteSend must be last!
ccWindowSettings.Faction = 81200
ccWindowSettings.ClaimCell = 81201
ccWindowSettings.CreateFaction = 81202
ccWindowSettings.DisbandFaction = 81203
ccWindowSettings.FactionStats = 81204
ccWindowSettings.KickMember = 81205
ccWindowSettings.ListFactions = 81206
ccWindowSettings.ListMembers = 81207
ccWindowSettings.LeaveFaction = 81208
ccWindowSettings.PromoteMember = 81209
ccWindowSettings.FactionInvite = 81210
ccWindowSettings.FactionInviteSend = 81211

-- ccHardcore
ccWindowSettings.HardcoreLadder = 81300

-- ccPerks
ccWindowSettings.Perks = 81400
ccWindowSettings.Birthsign = 81401
ccWindowSettings.Gender = 81402
ccWindowSettings.Hair = 81403
ccWindowSettings.Head = 81404
ccWindowSettings.Race = 81405
ccWindowSettings.Rewards = 81406
ccWindowSettings.SetCreature = 81407
ccWindowSettings.SpawnPet = 81408
ccWindowSettings.Warp = 81409
ccWindowSettings.Weather = 81410

-----------------
-- FUNCTIONS
-----------------

function ccWindowManager.build(pid, idGui, data)
    -- Controls GUI window mechanics for ccPerks
    -- LUA table entries require adding 1 to data var
    local pick = 0

    if tonumber(data) ~= nil then pick = tonumber(data) + 1 end

    if idGui == ccWindowSettings.Build then -- Main /build window

        if pick <= #ccBuild.BuildTable then ccBuild.choiceHandler(pid, pick) end
    end
end

function ccWindowManager.commands(pid, idGui, data)
    -- Controls GUI window mechanics for ccCommands

    if idGui == ccWindowSettings.DeleteCharacter then

        -- Delete character
        if tonumber(data) == 0 then ccCommands.finalizeDeleteCharacter(pid) end
    elseif idGui == ccWindowSettings.MOTD then

        -- Yes to HC Mode
        if ccConfig.HardcoreEnabled and tonumber(data) == 0 then ccHardcore.hardcoreMode(pid) end
    end
end

function ccWindowManager.factions(pid, idGui, data)
    -- Controls GUI window mechanics for ccFactions
    local pick = tonumber(data)

    if idGui == ccWindowSettings.Faction then -- Main /faction window

        if not ccFactions.isInAFaction(pid) then

            if pick == 0 then ccFactions.windowCreateFaction(pid)
            elseif pick == 1 then ccFactions.windowListFactions(pid)
            end
        else

            if tonumber(Players[pid].data.factions.rank) == 2 then

                if pick == 0 then ccFactions.windowListMembers(pid)
                elseif pick == 1 then ccFactions.windowFactionInvite(pid)
                elseif pick == 2 then ccFactions.windowPromoteMember(pid)
                elseif pick == 3 then ccFactions.windowKickMember(pid)
                elseif pick == 4 then ccFactions.windowDisbandFaction(pid)
                elseif pick == 5 then ccFactions.windowClaimCell(pid)
                elseif pick == 6 then ccFactions.warpFactionCell(pid)
                elseif pick == 7 then ccFactions.windowListFactions(pid)
                end
            elseif tonumber(Players[pid].data.factions.rank) == 1 then

                if pick == 0 then ccFactions.windowListMembers(pid)
                elseif pick == 1 then ccFactions.windowFactionInvite(pid)
                elseif pick == 2 then ccFactions.windowKickMember(pid)
                elseif pick == 3 then ccFactions.windowLeaveFaction(pid)
                elseif pick == 4 then ccFactions.windowClaimCell(pid)
                elseif pick == 5 then ccFactions.warpFactionCell(pid)
                elseif pick == 6 then ccFactions.windowListFactions(pid)
                end         
            else

                if pick == 0 then ccFactions.windowListMembers(pid)
                elseif pick == 1 then ccFactions.windowLeaveFaction(pid)
                elseif pick == 2 then ccFactions.warpFactionCell(pid)
                elseif pick == 2 then ccFactions.windowListFactions(pid)
                end
            end
        end
    elseif idGui == ccWindowSettings.ClaimCell then

        if pick == 0 then ccFactions.claimCell(pid) end
    elseif idGui == ccWindowSettings.CreateFaction then
        ccFactions.createFaction(pid, data)
    elseif idGui == ccWindowSettings.DisbandFaction then

        if pick == 0 then ccFactions.disbandFaction(pid) end
    elseif idGui == ccWindowSettings.FactionInvite then
        -- Have to iterate by 1 to account for LUA table index; do nothing if player clicks "cancel"
        local pick = pick + 1

        if pick <= #ccFactions.PidTable then ccFactions.windowFactionInviteSend(pid, ccFactions.PidTable[pick]) end
    elseif idGui >= ccWindowSettings.FactionInviteSend and idGui <= (ccWindowSettings.FactionInviteSend + ccConfig.NumberOfPlayers) then
        local calculatedPid = tonumber(idGui - ccWindowSettings.FactionInviteSend)

        if pick == 0 then
            local factionName = Players[calculatedPid].data.factions.id
            ccFactions.joinFaction(pid, factionName)
        elseif pick == 1 then
            tes3mp.SendMessage(calculatedPid, color.Error .. Players[pid].name .. " rejected your invitation.\n", false)
        end
    elseif idGui == ccWindowSettings.KickMember then
        -- Have to iterate by 1 to account for LUA table index; do nothing if player clicks "cancel"
        local pick = pick + 1
        local factionNameLC = string.lower(Players[pid].data.factions.id)

        if pick <= #ccFactions.FactionList[factionNameLC].members then ccFactions.kickMember(pid, pick, factionNameLC) end
    -- elseif idGui == ccWindowSettings.FactionStats then

        -- if pick == 0 then ccFactions.factionStats() end
    elseif idGui == ccWindowSettings.LeaveFaction then

        if pick == 0 then ccFactions.leaveFaction(pid) end
    elseif idGui == ccWindowSettings.PromoteMember then
        -- Have to iterate by 1 to account for LUA table index; do nothing if player clicks "cancel"
        local pick = pick + 1
        local factionNameLC = string.lower(Players[pid].data.factions.id)

        if pick <= #ccFactions.FactionList[factionNameLC].members then ccFactions.promoteMember(pid, pick, factionNameLC) end
    end
end

function ccWindowManager.perks(pid, idGui, data)
    -- Controls GUI window mechanics for ccPerks
    -- LUA table entries require adding 1 to data var
    local pick = 0

    if tonumber(data) ~= nil then pick = tonumber(data) + 1 end

    if idGui == ccWindowSettings.Perks then -- Main /perks window

        if pick <= #ccPerks.PerksTable then ccPerks.choiceHandler(pid, pick) end
    elseif idGui == ccWindowSettings.Birthsign then

        if pick < 14 then ccPerks.finalizeBirthsign(pid, pick) end
    elseif idGui == ccWindowSettings.Gender then
        pick = pick - 1

        if pick < 2 then ccPerks.finalizeGender(pid, pick) end
    elseif idGui == ccWindowSettings.Hair then

        if ccPerks.hairCancelCheck(pid, pick) then ccPerks.finalizeHair(pid, pick) end
    elseif idGui == ccWindowSettings.Head then

        if ccPerks.headCancelCheck(pid, pick) then ccPerks.finalizeHead(pid, pick) end
    elseif idGui == ccWindowSettings.Race then

        if pick <= #ccPerks.RaceTable then ccPerks.finalizeRace(pid, pick) end
    elseif idGui == ccWindowSettings.Rewards then

        if pick <= #ccPerks.RewardsTable then ccPerks.finalizeRewards(pid, pick) end
    elseif idGui == ccWindowSettings.SetCreature then

        if pick <= #ccPerks.CreatureTable then ccPerks.finalizeCreature(pid, pick) end
    elseif idGui == ccWindowSettings.SpawnPet then
        pick = pick - 1

        if pick < 3 then ccPerks.finalizePet(pid, pick) end
    elseif idGui == ccWindowSettings.Warp then

        if pick <= #ccCharGen.SpawnTable then ccPerks.finalizeWarp(pid, pick) end
    elseif idGui == ccWindowSettings.Weather then

        if pick <= #ccPerks.WeatherTable then ccPerks.finalizeWeather(pid, pick) end
    end
end

function ccWindowManager.OnGUIAction(eventStatus, pid, idGui, data)
    -- Controls GUI window mechanics for various ccSuite scripts
    ccWindowManager.commands(pid, idGui, data)

    if ccConfig.BuildEnabled then
        ccWindowManager.build(pid, idGui, data)
    end

    if ccConfig.FactionsEnabled then
        ccWindowManager.factions(pid, idGui, data)
    end

    if ccConfig.PerksEnabled then
        ccWindowManager.perks(pid, idGui, data)
    end
end

customEventHooks.registerHandler("OnGUIAction", ccWindowManager.OnGUIAction)

return ccWindowManager
