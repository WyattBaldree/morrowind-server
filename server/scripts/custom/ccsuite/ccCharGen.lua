---------------------------
-- ccCharGen 0.7.0 by Texafornian
--
-- 

config.defaultSpawnCell = nil --disable default spawning behavior

-----------------
-- FUNCTIONS
-----------------

function ccCharGen.checkClass(pid)
    -- Check player class for additional items (ccConfig.lua)
    tes3mp.LogMessage(2, "[ccCharGen] Checking player class")
    local playerClass = string.lower(Players[pid].data.character.class)

    for index, _ in pairs(ccCharGen.ClassItemsTable) do

        if ccCharGen.ClassItemsTable[index][1] == playerClass then

            for index2, _ in pairs(ccCharGen.ClassItemsTable[index]) do
                local item = {}

                if type(ccCharGen.ClassItemsTable[index][index2]) == "table" then
                    item = { refId = ccCharGen.ClassItemsTable[index][index2][1], count = ccCharGen.ClassItemsTable[index][index2][2], 
                        charge = ccCharGen.ClassItemsTable[index][index2][3] }
                    table.insert(Players[pid].data.inventory, item)
                end
            end
            break
        end
    end
end

function ccCharGen.checkSkills(pid)
    -- Check player's skills for additional items (ccConfig.lua)
    tes3mp.LogMessage(2, "[ccCharGen] Checking player's skills")

    for skillName, skillValue in pairs(Players[pid].data.skills) do

        if skillValue.base >= ccConfig.CharGen.StartingSkillMinLevel then

            for index2, _ in pairs(ccCharGen.SkillItemsTable) do

                if ccCharGen.SkillItemsTable[index2][1] == string.lower(skillName) then

                    for index3, _ in pairs(ccCharGen.SkillItemsTable[index2]) do
                        local item = {}

                        if type(ccCharGen.SkillItemsTable[index2][index3]) == "table" then
                            item = { 
                                refId = ccCharGen.SkillItemsTable[index2][index3][1], 
                                count = ccCharGen.SkillItemsTable[index2][index3][2], 
                                charge = ccCharGen.SkillItemsTable[index2][index3][3] 
                                }
                            table.insert(Players[pid].data.inventory, item)
                        end
                    end
                end
            end
        end
    end
end

function ccCharGen.checkWeaponSkills(pid)
    -- Check a player's skills for a random weapon after chargen (ccConfig.lua)
    tes3mp.LogMessage(2, "[ccCharGen] Checking player weapon skills")

    -- Try to improve RNG
    math.randomseed(os.time())
    math.random(); math.random()

    if Players[pid].data.skills.Axe.base >= ccConfig.CharGen.StartingWeaponMinLevel then
        local rando = math.random(1, #ccCharGen.AxeWeaponTable)
        ccCharGen.giveEquipment(pid, rando, ccCharGen.AxeWeaponTable, 16)
    elseif Players[pid].data.skills.Bluntweapon.base >= ccConfig.CharGen.StartingWeaponMinLevel then
        local rando = math.random(1, #ccCharGen.BluntWeaponTable)
       ccCharGen. giveEquipment(pid, rando, ccCharGen.BluntWeaponTable, 16)
    elseif Players[pid].data.skills.Longblade.base >= ccConfig.CharGen.StartingWeaponMinLevel then
        local rando = math.random(1, #ccCharGen.LongWeaponTable)
        ccCharGen.giveEquipment(pid, rando, ccCharGen.LongWeaponTable, 16)
    elseif Players[pid].data.skills.Marksman.base >= ccConfig.CharGen.StartingWeaponMinLevel then
        local rando = math.random(1, #ccCharGen.MarksmanWeaponTable)
        ccCharGen.giveEquipment(pid, rando, ccCharGen.MarksmanWeaponTable, 16)
        rando = math.random(1, #ccCharGen.MarksmanAmmoTable)
        ccCharGen.giveEquipment(pid, rando, ccCharGen.MarksmanAmmoTable, 18)
    elseif Players[pid].data.skills.Shortblade.base >= ccConfig.CharGen.StartingWeaponMinLevel then
        local rando = math.random(1, #ccCharGen.ShortWeaponTable)
        ccCharGen.giveEquipment(pid, rando, ccCharGen.ShortWeaponTable, 16)
    elseif Players[pid].data.skills.Spear.base >= ccConfig.CharGen.StartingWeaponMinLevel then
        local rando = math.random(1, #ccCharGen.SpearWeaponTable)
        ccCharGen.giveEquipment(pid, rando, ccCharGen.SpearWeaponTable, 16)
    end
end

function ccCharGen.giveEquipment(pid, index, sourceTable, position)
    -- Give player an item that is automatically equipped
    tes3mp.LogMessage(2, "[ccCharGen] giveEquipment called")
    local equipEntry = { refId = sourceTable[index][1], count = sourceTable[index][2], charge = sourceTable[index][3] }
    Players[pid].data.equipment[position] = equipEntry
end

function ccCharGen.spawnItems(pid)
    -- Give players all items listed in ccConfig and randomize set of clothes
    local item = {}
    local rando = 1
    local race = string.lower(Players[pid].data.character.race)

    Players[pid].data.inventory = {}
    Players[pid].data.equipment = {}

    tes3mp.LogMessage(2, "[ccCharGen] Adding items to new character")

    -- Give player misc. items if enabled in ccConfig
    if ccConfig.CharGen.StartingMiscItems then

        for index, _ in pairs(ccCharGen.MiscItemsTable) do
            item = { refId = ccCharGen.MiscItemsTable[index][1], count = ccCharGen.MiscItemsTable[index][2], charge = ccCharGen.MiscItemsTable[index][3] }
            table.insert(Players[pid].data.inventory, item)
        end
    end

    -- Give player randomized clothing if enabled in ccConfig
    if ccConfig.CharGen.RandomizedClothes then
        tes3mp.LogMessage(2, "[ccCharGen] Randomizing new player's clothes")

        -- Try to improve RNG
        math.randomseed(os.time())
        math.random(); math.random()

        -- Give player random shoes from ccConfig if applicable
        if race ~= "argonian" and race ~= "khajiit" and race ~= "t_els_cathay-raht" and race ~= "t_els_ohmes-raht" then
            rando = math.random(1, #ccCharGen.ShoesTable)
            item = { refId = ccCharGen.ShoesTable[rando][1], count = ccCharGen.ShoesTable[rando][2], charge = ccCharGen.ShoesTable[rando][3] }
            Players[pid].data.equipment[7] = item
        end

        -- Give player a random shirt from ccConfig
        rando = math.random(1, #ccCharGen.ShirtTable)
        item = { refId = ccCharGen.ShirtTable[rando][1], count = ccCharGen.ShirtTable[rando][2], charge = ccCharGen.ShirtTable[rando][3] }
        Players[pid].data.equipment[8] = item

        -- Give player random legwear from ccConfig
        if Players[pid].data.character.gender == 1 then
            rando = math.random(1, #ccCharGen.PantsTable)
            item = { refId = ccCharGen.PantsTable[rando][1], count = ccCharGen.PantsTable[rando][2], charge = ccCharGen.PantsTable[rando][3] }
            Players[pid].data.equipment[9] = item
        else
            rando = math.random(1, #ccCharGen.SkirtTable)
            item = { refId = ccCharGen.SkirtTable[rando][1], count = ccCharGen.SkirtTable[rando][2], charge = ccCharGen.SkirtTable[rando][3] }
            Players[pid].data.equipment[10] = item
        end
    end

    -- -- Give player all class-specific items if enabled
    if ccConfig.CharGen.StartingClassItems then
        ccCharGen.checkClass(pid)
    end

    -- Give player all skill-specific items if enabled 
    if ccConfig.CharGen.StartingSkillItems then
        ccCharGen.checkSkills(pid)
    end

    -- Give player a random starting weapon if enabled
    if ccConfig.CharGen.StartingWeapon then
        ccCharGen.checkWeaponSkills(pid)
    end

    -- Update inventory and send packet for entire inventory
    -- Probably more efficient than Players[pid]:LoadItemChanges in this case
    Players[pid]:LoadInventory()
    Players[pid]:LoadEquipment()
end

function ccCharGen.spawnPosition(pid)
    -- Randomized spawn position based on global ccCharGen.SpawnTable in server.lua
    -- Try to improve RNG
    math.randomseed(os.time())
    math.random(); math.random()

    local tempRef = math.random(1, #ccCharGen.SpawnTable) -- Pick a random value from the spawn table

    tes3mp.LogMessage(2, "[ccCharGen] Spawning new player in cell ... ")
    tes3mp.LogMessage(2, "[ccCharGen] (" .. ccCharGen.SpawnTable[tempRef][1] .. ")")
    tes3mp.SetCell(pid, ccCharGen.SpawnTable[tempRef][1])
    tes3mp.SendCell(pid)
    tes3mp.SetPos(pid, ccCharGen.SpawnTable[tempRef][2], ccCharGen.SpawnTable[tempRef][3], ccCharGen.SpawnTable[tempRef][4])
    tes3mp.SetRot(pid, 0, ccCharGen.SpawnTable[tempRef][5])
    tes3mp.SendPos(pid)
end


function ccCharGen.OnPlayerEndCharGen(eventStatus, pid)
    ccCharGen.spawnPosition(pid)
    ccCharGen.spawnItems(pid)

    -- Displays the server MOTD after chargen if enabled in ccConfig
    if ccConfig.HardcoreEnabled then
        tes3mp.CustomMessageBox(pid, ccWindowSettings.MOTD, ccConfig.CharGen.MOTDGenerated, "Yes;No")
    else
        tes3mp.CustomMessageBox(pid, ccWindowSettings.MOTD, ccConfig.CharGen.MOTDGenerated, "Ok")
    end
end

customEventHooks.registerHandler("OnPlayerEndCharGen", ccCharGen.OnPlayerEndCharGen)

return ccCharGen
