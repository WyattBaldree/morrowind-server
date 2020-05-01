---------------------------
-- ccHolidays 0.7.0 by Texafornian
--
-- 

-----------------
-- FUNCTIONS
-----------------

function ccHolidays.checkHoliday(pid)
    -- Runs appropriate holiday commands on the player

    if ccHolidays.CurrentHoliday == "Anniversary" then ccHolidays.holidayAnniversary(pid)
    elseif ccHolidays.CurrentHoliday == "Halloween" then ccHolidays.holidayHalloween(pid)
    elseif ccHolidays.CurrentHoliday == "Morrowind" then ccHolidays.holidayMorrowind(pid)
    elseif ccHolidays.CurrentHoliday == "Winter" then ccHolidays.holidayWinter(pid)
    end
end

function ccHolidays.checkPlayerFileEntry(pid)
    -- Check whether player file has new "holidays" data tables
    local changeMade = false

    if not Players[pid].data.holidays then
        Players[pid].data.holidays = {}
        Players[pid].data.holidays.celebrated = ""
        changeMade = true
    end

    if changeMade then Players[pid]:QuicksaveToDrive() end
end

function ccHolidays.holidayCommand(pid)
    -- Gives the player a gift(s) if command used on a holiday

    if not ccHolidays.CurrentHoliday or ccHolidays.CurrentHoliday == "" then
        tes3mp.SendMessage(pid, color.Error .. "There is no holiday being celebrated today.", false)
        return false
    end

    if Players[pid].data.holidays.celebrated == os.date("%x") then
        tes3mp.SendMessage(pid, color.Error .. "You have already celebrated today's holiday.", false)
        return false
    else

        if ccHolidays.CurrentHoliday == "Anniversary" then
            -- give "Anniversary 2019" blue plate or brown plate
        elseif ccHolidays.CurrentHoliday == "Halloween" then
            -- "Halloween 2019" enlarged skull
        elseif ccHolidays.CurrentHoliday == "Winter" then
            -- give one of a set of things incl red colovian hat
        end
        Players[pid].data.holidays.celebrated = os.date("%x")
    end
end

function ccHolidays.holidayAnniversary(pid)
    -- Does Anniversary-related things
    local years = tonumber(os.date("%Y")) - 2017
    local message = "The Cornerclub is " .. years .. " years old today!\nThank you for being a part of our community!\
        \nType /holiday to receive a gift.\n"
    tes3mp.SendMessage(pid, color.LightGreen .. message, false)
end

function ccHolidays.holidayHalloween(pid)
    -- Does Halloween-related things

    -- Make the player spooky
    Players[pid].data.shapeshift.creatureRefId = "skeleton"
    tes3mp.SetCreatureRefId(pid, "skeleton")
    tes3mp.SendShapeshift(pid)
    tes3mp.SendMessage(pid, color.Orange .. "Spooooky!\n", false)
end

function ccHolidays.holidayMorrowind(pid)
    -- Does Morrowind Anniversary-related things
    local years = tonumber(os.date("%Y")) - 2002
    local message = "TESIII: Morrowind is " .. years .. " years old today!\nType /holiday to receive a gift.\n"
    tes3mp.SendMessage(pid, color.LightGreen .. message, false)
end

function ccHolidays.holidayWinter(pid)
    -- Does winter-related things
    
end

-----------------
-- EVENTS
-----------------

function ccHolidays.OnPlayerEndCharGen(eventStatus, pid)
    -- Give new players the ccHolidays data entries
    ccHolidays.checkPlayerFileEntry(pid)
    ccHolidays.checkHoliday(pid)
end

function ccHolidays.OnPlayerFinishLogin(eventStatus, pid)
    -- Make sure players have ccHolidays data entries
    ccHolidays.checkPlayerFileEntry(pid)
    ccHolidays.checkHoliday(pid)
end

function ccHolidays.OnServerPostInit(eventStatus)
    -- Checks current date to determine holiday
    tes3mp.LogMessage(2, "[ccHolidays] Checking current date against holidays")
    ccHolidays.CurrentHoliday = ""
    local day = tonumber(os.date("%d"))
    local month = tonumber(os.date("%m"))

    for index, _ in pairs(ccConfig.Holidays.Table) do

        if ccConfig.Holidays.Table[index][2] == "day" and month == ccConfig.Holidays.Table[index][3]
            and day ==ccConfig.Holidays.Table[index][4] then

            tes3mp.LogMessage(2, "[ccHolidays] Current holiday: " .. ccConfig.Holidays.Table[index][1])
            ccHolidays.CurrentHoliday = ccConfig.Holidays.Table[index][1]
            break
        elseif ccConfig.Holidays.Table[index][2] == "period" and ccConfig.Holidays.Table[index][5] ~= nil then

            -- Period carries over into subsequent year
            if ccConfig.Holidays.Table[index][5] < ccConfig.Holidays.Table[index][3] then

                if (month >= ccConfig.Holidays.Table[index][3] and day >= ccConfig.Holidays.Table[index][4])
                    or (month <= ccConfig.Holidays.Table[index][5] and day <= ccConfig.Holidays.Table[index][6]) then

                    tes3mp.LogMessage(2, "[ccHolidays] Current holiday: " .. ccConfig.Holidays.Table[index][1])
                    ccHolidays.CurrentHoliday = ccConfig.Holidays.Table[index][1]
                    break
                end
            -- Period is within same year
            else

                if (month >= ccConfig.Holidays.Table[index][3] and day >= ccConfig.Holidays.Table[index][4])
                    and (month <= ccConfig.Holidays.Table[index][5] and day <= ccConfig.Holidays.Table[index][6]) then

                    tes3mp.LogMessage(2, "[ccHolidays] Current holiday: " .. ccConfig.Holidays.Table[index][1])
                    ccHolidays.CurrentHoliday = ccConfig.Holidays.Table[index][1]
                    break
                end
            end
        end
    end
end

if ccConfig.HolidaysEnabled then
    customCommandHooks.registerCommand("holiday", ccHolidays.holidayCommand)

    customEventHooks.registerHandler("OnPlayerEndCharGen", ccHolidays.OnPlayerEndCharGen)
    customEventHooks.registerHandler("OnPlayerFinishLogin", ccHolidays.OnPlayerFinishLogin)
    customEventHooks.registerHandler("OnServerPostInit", ccHolidays.OnServerPostInit)
end

return ccHolidays
