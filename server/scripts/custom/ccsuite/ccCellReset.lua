---------------------------
-- ccCellReset 0.7.0 by Texafornian
--
-- Many thanks to Urm for json approach

-----------------
-- FUNCTIONS
-----------------

function ccCellReset.deleteCells()
    -- Performs deletion of non-preserved cells
    tes3mp.LogMessage(2, "[ccCellReset] Populating cell preservation table with vanilla entries")
    local preserveTable = {}

    for _, preserveData in ipairs(ccConfig.CellReset.SavedCells.Vanilla) do
        table.insert(preserveTable, preserveData)
    end

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccCellReset] Populating cell preservation table with Tamriel entries")

        for _, preserveData in ipairs(ccConfig.CellReset.SavedCells.Tamriel) do
            table.insert(preserveTable, preserveData)
        end
    end

    if ccConfig.CellReset.SaveBuildCell and ccConfig.Build.BuildCell[1] then
        tes3mp.LogMessage(2, "[ccCellReset] Adding ccBuild cell to preservation table")
        table.insert(preserveTable, ccConfig.Build.BuildCell[1])
    end

    if ccConfig.CellReset.SaveFactionCells then

        for faction, _ in pairs(ccFactions.FactionList) do

            if ccFactions.FactionList[faction].cells[1] then
                tes3mp.LogMessage(2, "[ccCellReset] Adding " .. ccFactions.FactionList[faction].displayName
                .. " faction cell to preservation table")
                table.insert(preserveTable, ccFactions.FactionList[faction].cells[1]) 
            end
        end
    end

    -- Delete cells listed in cellresetlist.json
    tes3mp.LogMessage(2, "[ccCellReset] Preparing to delete cells")

    for cellDescription, _ in pairs(ccCellReset.CellResetList) do
        local deleteCell = true
        local cellName = ""

        for _, preserveCell in pairs(preserveTable) do

            if cellDescription == preserveCell then
                deleteCell = false
                cellName = preserveCell
                break
            end
        end

        if deleteCell then
            -- tes3mp.LogMessage(2, "[ccCellReset] Deleting cell " .. cellDescription)
            local cell = Cell(cellDescription)
            os.remove(ccConfig.CellPath .. cell.entryFile)
        else tes3mp.LogMessage(2, "[ccCellReset] Ignoring cell " .. cellName)
        end
    end

    -- Clear the list of cells and save
    tes3mp.LogMessage(2, "[ccCellReset] Saving cellresetlist.json")
    ccCellReset.CellResetList = {}
    jsonInterface.save("custom/ccsuite/cellresetlist.json", ccCellReset.CellResetList)
end

-----------------
-- EVENTS
-----------------

function ccCellReset.OnCellLoad(eventStatus, pid, cellDescription)
    -- Update cellresetlist.json when player enter cell

    if ccCellReset.CellResetList[cellDescription] == nil then
        ccCellReset.CellResetList[cellDescription] = {}
        jsonInterface.save("custom/ccsuite/cellresetlist.json", ccCellReset.CellResetList)
    end
end

function ccCellReset.OnServerPostInit(eventStatus)
    -- Initializes cell reset table
    tes3mp.LogMessage(2, "[ccCellReset] Loading cellresetlist.json")
    ccCellReset.CellResetList = jsonInterface.load("custom/ccsuite/cellresetlist.json")

    -- Checks time then populates cell preservation table
    tes3mp.LogMessage(2, "[ccCellReset] Checking time for cell reset")

    if not ccConfig.CellReset.AlwaysWipeOnRestart then
        local currentHour = os.date("%H")
        local wipeTimes = {}

        if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
            wipeTimes = ccConfig.CellReset.WipeTimes.Tamriel
        else
            wipeTimes = ccConfig.CellReset.WipeTimes.Vanilla
        end

        for index, _ in pairs(wipeTimes) do

            if currentHour == wipeTimes[index][1] then
                ccCellReset.deleteCells()
                break
            end
        end
    else ccCellReset.deleteCells()
    end
end

if ccConfig.CellResetEnabled then
    customEventHooks.registerHandler("OnCellLoad", ccCellReset.OnCellLoad)
    customEventHooks.registerHandler("OnServerPostInit", ccCellReset.OnServerPostInit)
end

return ccCellReset
