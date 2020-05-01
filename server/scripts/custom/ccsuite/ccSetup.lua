---------------------------
-- ccSetup 0.7.0 by Texafornian
--
-- 

-----------------
-- DECLARATIONS
-----------------

ccBuild = {}
ccBuild.BuildTable = {}
ccBuild.BuildTableText = ""
ccCellReset = {}
ccCellReset.CellResetList = {}
ccCharGen = {}
ccCharGen.AxeWeaponTable = {}
ccCharGen.BluntWeaponTable = {}
ccCharGen.ClassItemsTable = {}
ccCharGen.LongWeaponTable = {}
ccCharGen.MarksmanAmmoTable = {}
ccCharGen.MarksmanWeaponTable = {}
ccCharGen.MiscItemsTable = {}
ccCharGen.PantsTable = {}
ccCharGen.ShirtTable = {}
ccCharGen.SkirtTable = {}
ccCharGen.ShoesTable = {}
ccCharGen.ShortWeaponTable = {}
ccCharGen.SkillItemsTable = {}
ccCharGen.SpawnTable = {}
ccCharGen.SpearWeaponTable = {}
ccCommands = {}
ccCommands.Punish = {}
ccCommands.Punish.IntTable = {}
ccCommands.Punish.ExtTable = {}
ccCommon = {}
ccDynamicDifficulty = {}
ccFactions = {}
ccFactions.FactionList = {}
ccFactions.PidTable = {}
ccHardcore = {}
ccHardcore.CurrentLadder = ""
ccHardcore.DeathDropTable = {}
ccHardcore.LadderList = {}
ccHardcore.SafeCellsTable = {}
ccHolidays = {}
ccPerks = {}
ccPerks.CreatureTable = {}
ccPerks.CreatureTableText = ""
ccPerks.Lottery = {}
ccPerks.Lottery.TokenEntries = 0
ccPerks.Lottery.ItemEntries = 0
ccPerks.Lottery.TotalEntries = 0
ccPerks.PerksTable = {}
ccPerks.PerksTableText = ""
ccPerks.RaceTable = {}
ccPerks.RaceTableText = ""
ccPerks.RewardsTable = {}
ccPerks.RewardsTableText = ""
-- ccPerks.WarpTable = {}   not used yet
ccPerks.WarpTableText = ""
ccPerks.WeatherTable = {}
ccPerks.WeatherTableText = ""
ccSetup = {}
ccStats = {}
ccWindowManager = {}
ccWindowSettings = {}

-----------------
-- FUNCTIONS
-----------------

function ccSetup.populateTable(infoTable)
    -- Iterates through entries of an info table { a source table, a destination table } to 
    -- place source table into destination table

    for index, _ in ipairs(infoTable) do

        if infoTable[index][1] ~= nil then

            for _, value2 in ipairs(infoTable[index][1]) do
                table.insert(infoTable[index][2], value2)
            end
        end
    end
end

function ccSetup.setupItems()
    -- Populates items table that stores all items that new players receive after chargen
    tes3mp.LogMessage(2, "[ccSetup] Populating all item tables with vanilla entries")

    local infoTableVanilla = {
        { ccConfig.CharGen.Vanilla.ClassItems, ccCharGen.ClassItemsTable },
        { ccConfig.CharGen.Vanilla.SkillItems, ccCharGen.SkillItemsTable },
        { ccConfig.CharGen.Vanilla.MiscItems, ccCharGen.MiscItemsTable },
        { ccConfig.CharGen.Vanilla.Pants, ccCharGen.PantsTable },
        { ccConfig.CharGen.Vanilla.Shirts, ccCharGen.ShirtTable },
        { ccConfig.CharGen.Vanilla.Skirts, ccCharGen.SkirtTable },
        { ccConfig.CharGen.Vanilla.Shoes, ccCharGen.ShoesTable }
    }

    ccSetup.populateTable(infoTableVanilla)

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccSetup] Populating all item tables with Tamriel entries")

        local infoTableTamriel = {
            { ccConfig.CharGen.Tamriel.ClassItems, ccCharGen.ClassItemsTable },
            { ccConfig.CharGen.Tamriel.SkillItems, ccCharGen.SkillItemsTable },
            { ccConfig.CharGen.Tamriel.MiscItems, ccCharGen.MiscItemsTable },
            { ccConfig.CharGen.Tamriel.Pants, ccCharGen.PantsTable },
            { ccConfig.CharGen.Tamriel.Shirts, ccCharGen.ShirtTable },
            { ccConfig.CharGen.Tamriel.Skirts, ccCharGen.SkirtTable },
            { ccConfig.CharGen.Tamriel.Shoes, ccCharGen.ShoesTable }
        }

        ccSetup.populateTable(infoTableTamriel)
    end
end

function ccSetup.setupMOTD()
    -- Creates MOTD message based on ccConfig settings
    tes3mp.LogMessage(2, "[ccSetup] Generating MOTD")

    ccConfig.CharGen.MOTDGenerated = ccConfig.CharGen.MOTDMessage

    if ccConfig.HardcoreEnabled then
        ccConfig.CharGen.MOTDGenerated = ccConfig.CharGen.MOTDGenerated .. "\n" .. ccConfig.CharGen.MOTDMessageHC
    end
end

function ccSetup.setupPunish()
    -- Populates cell tables for punish command
    tes3mp.LogMessage(2, "[ccSetup] Populating punish cell tables with vanilla entries")

    local infoTableVanilla = {
        { ccConfig.Commands.Punish.Vanilla.Interiors, ccCommands.Punish.IntTable },
        { ccConfig.Commands.Punish.Vanilla.Exteriors, ccCommands.Punish.ExtTable }
    }

    ccSetup.populateTable(infoTableVanilla)

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccSetup] Populating punish cell tables with Tamriel entries")

        local infoTableTamriel = {
            { ccConfig.Commands.Punish.Tamriel.Interiors, ccCommands.Punish.IntTable },
            { ccConfig.Commands.Punish.Tamriel.Exteriors, ccCommands.Punish.ExtTable }
        }

        ccSetup.populateTable(infoTableTamriel)
    end
end

function ccSetup.setupSpawns()
    -- Populates spawn table (and warp table) for randomized spawns
    tes3mp.LogMessage(2, "[ccSetup] Populating spawn table with vanilla entries")

    for _, spawnData in ipairs(ccConfig.CharGen.Vanilla.Cells) do
        table.insert(ccCharGen.SpawnTable, spawnData)
    end

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccSetup] Populating spawn table with Tamriel entries")

        for _, spawnData in ipairs(ccConfig.CharGen.Tamriel.Cells) do
            table.insert(ccCharGen.SpawnTable, spawnData)
        end
    end
end

function ccSetup.setupSafeCells()
    -- Populates safe cells table to allow player deaths without consequences
    tes3mp.LogMessage(2, "[ccSetup] Populating safe cells table with spawn table entries")

    -- Add all spawn cells to safe cells table if enabled in ccConfig.lua
    if ccConfig.Hardcore.SafeCells.useSpawnCells then

        for index, _ in pairs(ccCharGen.SpawnTable) do
            local tableEntry = { ccCharGen.SpawnTable[index][1] }
            table.insert(ccHardcore.SafeCellsTable, tableEntry)
        end
    end

    tes3mp.LogMessage(2, "[ccSetup] Populating safe cells table with additional vanilla entries")

    -- Add additional cells to safe cells table
    local infoTableVanilla = {
        { ccConfig.Hardcore.SafeCells.Vanilla, ccHardcore.SafeCellsTable }
    }

    ccSetup.populateTable(infoTableVanilla)

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccSetup] Populating safe cells table with additional Tamriel entries")

        local infoTableTamriel = {
            { ccConfig.Hardcore.SafeCells.Tamriel, ccHardcore.SafeCellsTable }
        }

        ccSetup.populateTable(infoTableTamriel)
    end
end

function ccSetup.setupWeapons()
    -- Populates weapons table that stores all weapons that new players receive after chargen
    tes3mp.LogMessage(2, "[ccSetup] Populating weapon tables with vanilla entries")

    local infoTableVanilla = {
        { ccConfig.CharGen.Vanilla.Axes, ccCharGen.AxeWeaponTable },
        { ccConfig.CharGen.Vanilla.BluntWeapons, ccCharGen.BluntWeaponTable },
        { ccConfig.CharGen.Vanilla.Longblades, ccCharGen.LongWeaponTable },
        { ccConfig.CharGen.Vanilla.MarksmanAmmo, ccCharGen.MarksmanAmmoTable },
        { ccConfig.CharGen.Vanilla.MarksmanWeapons, ccCharGen.MarksmanWeaponTable },
        { ccConfig.CharGen.Vanilla.Shortblades, ccCharGen.ShortWeaponTable },
        { ccConfig.CharGen.Vanilla.Spears, ccCharGen.SpearWeaponTable }
    }

    ccSetup.populateTable(infoTableVanilla)

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccSetup] Populating weapon tables with Tamriel entries")

        local infoTableTamriel = {
            { ccConfig.CharGen.Tamriel.Axes, ccCharGen.AxeWeaponTable },
            { ccConfig.CharGen.Tamriel.BluntWeapons, ccCharGen.BluntWeaponTable },
            { ccConfig.CharGen.Tamriel.Longblades, ccCharGen.LongWeaponTable },
            { ccConfig.CharGen.Tamriel.MarksmanAmmo, ccCharGen.MarksmanAmmoTable },
            { ccConfig.CharGen.Tamriel.MarksmanWeapons, ccCharGen.MarksmanWeaponTable },
            { ccConfig.CharGen.Tamriel.Shortblades, ccCharGen.ShortWeaponTable },
            { ccConfig.CharGen.Tamriel.Spears, ccCharGen.SpearWeaponTable }
        }

        ccSetup.populateTable(infoTableTamriel)
    end
end

-----------------
-- EVENTS
-----------------

function ccSetup.OnPlayerFinishLogin(eventStatus, pid)
    -- Ensures that legacy characters have new data entries

    if Players[pid].data.customVariables == nil then
        Players[pid].data.customVariables = {}
    end
end

function ccSetup.OnServerPostInit(eventStatus)
    -- Performs housekeeping after every server restart
    ccSetup.setupItems()
    ccSetup.setupPunish()
    ccSetup.setupSpawns()
    ccSetup.setupSafeCells()
    ccSetup.setupWeapons()
    ccSetup.setupMOTD()
end

customEventHooks.registerHandler("OnPlayerFinishLogin", ccSetup.OnPlayerFinishLogin)
customEventHooks.registerHandler("OnServerPostInit", ccSetup.OnServerPostInit)

return ccSetup
