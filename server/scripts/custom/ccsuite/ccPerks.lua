---------------------------
-- ccPerks 0.7.0 by Texafornian
--
-- Many thanks to:
-- * ppsychrite
-- * Reinhart
-- * Mupf
-- * Atkana

--------------------
-- FUNCTIONS SECTION
--------------------

function ccPerks.checkPlayerFileEntry(pid)
    -- Check whether player file has new "perks" data tables
    local changeMade = false

    if not Players[pid].data.perks then Players[pid].data.perks = {} end

    if not Players[pid].data.perks.pets then
        local petsData = {}
        petsData.packRatSpawnTime = tonumber(0)
        petsData.ratSpawnTime = tonumber(0)
        petsData.scribSpawnTime = tonumber(0)
        Players[pid].data.perks.pets = petsData
        changeMade = true
    end

    if not Players[pid].data.perks.tokens then
        local tokensData = {}
        tokensData.claimDate = tonumber(0)
        tokensData.storedLevel = 1
        tokensData.storedTokens = tonumber(0)
        Players[pid].data.perks.tokens = tokensData
        changeMade = true
    end

    if changeMade then Players[pid]:QuicksaveToDrive() end
end

function ccPerks.choiceHandler(pid, pick)
    tes3mp.LogMessage(2, "[ccPerks] ccPerks.choiceHandler called")
    ccPerks.PerksTable[pick].storedFunc(pid)
end

function ccPerks.expelledFactions(pid)
    -- Clears expulsion status for a player's vanilla faction
    tes3mp.LogMessage(2, "[ccPerks] ccPerks.expelledFactions called")

    if Players[pid].data.factionExpulsion["mages guild"] == nil then
        tes3mp.SendMessage(pid, color.Error .. "You have not been expelled from the Mages Guild.\n", false)
        return false
    else

        if Players[pid].data.factionExpulsion["mages guild"] == false then
            tes3mp.SendMessage(pid, color.Error .. "You have not been expelled from the Mages Guild.\n", false)
            return false
        end
    end

    if Players[pid]:IsModerator() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostExpulsion) then
            return false
        end
    end

    tes3mp.LogMessage(2, "[ccPerks] ccPerks.expelledFactions: Clearing expulsion for " .. Players[pid].name)
    Players[pid].data.factionExpulsion["mages guild"] = false
    Players[pid]:QuicksaveToDrive()
    tes3mp.SendFactionChanges(pid, true, true)
    tes3mp.SendMessage(pid, color.Yellow .. "You have made amends with the Mages Guild. Please disconnect and rejoin the server to remove your expulsion status.\n", false)
end

function ccPerks.finalizeBirthsign(pid, pick)
    local message = ""
    local birthsignSet = {"elfborn", "wombburned", "lady's favor", "trollkin", "mooncalf", "fay", "blessed touch sign",
        "star-cursed", "moonshadow sign", "charioteer", "hara", "beggar's nose", "warwryd"}
    local playerName = string.lower(Players[pid].name)
    local birthsign = birthsignSet[pick]

    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " tried to use /setbirthsign with pick of " .. pick)

    if birthsign == Players[pid].data.character.birthsign then -- Check whether player already has this birthsign
        message = color.Gold .. "You already have that Birthsign.\n"
        tes3mp.SendMessage(pid, message, false)
        return false
    end

    if Players[pid]:IsModerator() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostBirthsign) then
            return false
        end
    end

    Players[pid].data.character.birthsign = birthsign
    -- Players[pid]:LoadCharacter() - Sets level to 1 but could be fixed via setcreature solution
    message = color.Gold .. "Your Birthsign is now " .. birthsign .. ".\nReconnect to the server to apply the change.\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.finalizeCreature(pid, pick)
    local playerName = string.lower(Players[pid].name)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " tried to use creatureChanger with pick " .. pick)

    if Players[pid]:IsModerator() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostCreature) then
            return false
        end
    end

    local creatureRefId = ""

    if ccPerks.CreatureTable[pick] ~= nil then
        creatureRefId = ccPerks.CreatureTable[pick][1]
    else
        tes3mp.SendMessage(pid, color.Red .. "creatureChanger: Error occurred. Please contact an admin!\n", false)
        return false
    end

    Players[pid].data.shapeshift.creatureRefId = creatureRefId
    tes3mp.SetCreatureRefId(pid, creatureRefId)
    tes3mp.SendShapeshift(pid)
    tes3mp.SendMessage(pid, color.Gold .. "Other players now see you as: " .. ccPerks.CreatureTable[pick][2] .. ".\n", false)
end

function ccPerks.finalizeGender(pid, gender)
    local message = ""
    local playerName = string.lower(Players[pid].name)
    local race = string.lower(Players[pid].data.character.race)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " (" .. race .. ") tried to use /setgender " .. gender)

    if gender == Players[pid].data.character.gender then -- Check whether player already has this gender
        tes3mp.SendMessage(pid, color.Gold .. "You already have that gender.\n", false)
        return false
    end

    local genderHair = (gender * 4) + 2
    local genderHead = (gender * 4) + 4

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    local hair = ccPerks.RaceTable[holdIndex][genderHair] .. "01"
    local head = ccPerks.RaceTable[holdIndex][genderHead] .. "01"

    if race == "t_sky_reachman" then
        hair = hair .. "a"
        head = head .. "a"
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostGender) then
            return false
        end
    end

    Players[pid].data.character.gender = gender
    Players[pid].data.character.hair = hair
    Players[pid].data.character.head = head

    message = color.Gold .. "Your gender has been switched.\nReconnect to the server to apply the change.\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.finalizeHair(pid, pick)
    local message = ""
    local gender = Players[pid].data.character.gender
    local playerName = string.lower(Players[pid].name)
    local race = string.lower(Players[pid].data.character.race)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " (" .. race .. ") tried to use /sethair " .. pick)

    if pick < 10 then
        pick = "0" .. pick

        if race == "t_sky_reachman" then
            pick = pick .. "a"
        end
    end

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    -- Check whether player already has this head
    local chosenHair = ""
    local genderHair = (gender * 4) + 2

    chosenHair = ccPerks.RaceTable[holdIndex][genderHair] .. pick

    if chosenHair == string.lower(Players[pid].data.character.hair) then
        tes3mp.SendMessage(pid, color.Gold .. "You already have that hairstyle.\n", false)
        return false
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostHair) then
            return false
        end
    end

    Players[pid].data.character.hair = ccPerks.RaceTable[holdIndex][genderHair] .. pick

    message = color.Gold .. "Your hairstyle is now " .. chosenHair .. ".\nReconnect to the server to apply the change.\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.finalizeHead(pid, pick)
    local message = ""
    local gender = Players[pid].data.character.gender
    local playerName = string.lower(Players[pid].name)
    local race = string.lower(Players[pid].data.character.race)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " (" .. race .. ") tried to use /sethead " .. pick)

    if pick < 10 then
        pick = "0" .. pick
        
        if race == "t_sky_reachman" then
            pick = pick .. "a"
        end
    end

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    -- Check whether player already has this head
    local chosenHead = ""
    local genderHead = (gender * 4) + 4

    chosenHead = ccPerks.RaceTable[holdIndex][genderHead] .. pick

    if chosenHead == string.lower(Players[pid].data.character.head) then
        tes3mp.SendMessage(pid, color.Gold .. "You already have that head.\n", false)
        return false
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostHead) then
            return false
        end
    end

    Players[pid].data.character.head = ccPerks.RaceTable[holdIndex][genderHead] .. pick

    message = color.Gold .. "Your head is now " .. chosenHead .. ".\nReconnect to the server to apply the change.\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.finalizePet(pid, pet)
    local message = ""
    local playerName = string.lower(Players[pid].name)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " tried to use ccPerks.finalizePet " .. pet)

    local spawnCommand = ""
    local timeStored = 0

    if pet == 0 then -- Pack rat
        timeStored = Players[pid].data.perks.pets.packRatSpawnTime
        spawnCommand = "placeatme Rat_pack_rerlas 1 10 0"
    elseif pet == 1 then -- Rat
        timeStored = Players[pid].data.perks.pets.ratSpawnTime
        spawnCommand = "placeatme rat_rerlas 1 10 0"
    elseif pet == 2 then -- Scrib
        timeStored = Players[pid].data.perks.pets.scribSpawnTime
        spawnCommand = "placeatme scrib_rerlas 1 10 0"
    end

    if timeStored == 0 or type(timeStored) == "number" then -- This should happen
        local diff = (os.time() - timeStored)
        tes3mp.LogMessage(2, "[ccPerks] diff == " .. diff)

        if (diff / 86400) <= 1 then
            message = color.Red .. "You've already spawned that pet today.\n"
            tes3mp.SendMessage(pid, message, false)
            return false
        end
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostPet) then
            return false
        end

        if pet == 0 then
            Players[pid].data.perks.pets.packRatSpawnTime = os.time()
        elseif pet == 1 then
            Players[pid].data.perks.pets.ratSpawnTime = os.time()
        elseif pet == 2 then
            Players[pid].data.perks.pets.scribSpawnTime = os.time()
        end
    end

    Players[pid]:QuicksaveToDrive()

    logicHandler.RunConsoleCommandOnPlayer(pid, spawnCommand)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " successfully used ccPerks.finalizePet " .. pet)

    message = color.Gold .. "You now have a pet.\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.finalizeRace(pid, pick)
    local message = ""
    local playerName = string.lower(Players[pid].name)
    local race = string.lower(Players[pid].data.character.race)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " (" .. race .. ") tried to use ccPerks.finalizeRace " .. pick)

    if ccPerks.RaceTable[pick][1] ~= nil then

        if string.lower(ccPerks.RaceTable[pick][1]) == Players[pid].data.character.race then -- Check whether player already has this race
            tes3mp.SendMessage(pid, color.Gold .. "You already are that race.\n", false)
            return false
        end
    else
        tes3mp.LogMessage(2, "[ccPerks] ccPerks.finalizeRace: Failure in initial nil check with pick = " .. pick)
        tes3mp.SendMessage(pid, color.Red .. "RACE CHANGER: Error occurred. Please contact an admin!\n", false)
        return false
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostRace) then
            return false
        end
    end

    local hair = ccPerks.RaceTable[pick][6] .. "01"
    local head = ccPerks.RaceTable[pick][8] .. "01"

    if ccPerks.RaceTable[pick][1] == "t_sky_reachman" then
        hair = hair .. "a"
        head = head .. "a"
    end

    Players[pid].data.character.gender = 1
    Players[pid].data.character.hair = hair
    Players[pid].data.character.head = head
    Players[pid].data.character.race = ccPerks.RaceTable[pick][1]
    Players[pid]:QuicksaveToDrive()

    -- Add racial spells if needed
    if ccPerks.RaceTable[pick][1] == "argonian" then
        tes3mp.AddSpell(pid, "argonian breathing")
    elseif ccPerks.RaceTable[pick][1] == "khajiit" then
        tes3mp.AddSpell(pid, "eye of night")
    end

    tes3mp.SendSpellbookChanges(pid)
    -- Players[pid]:QuicksaveToDrive()  original location

    message = color.Gold .. "Your race is now " .. ccPerks.RaceTable[pick][10] .. ".\nReconnect to the server to apply the change.\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.finalizeRewards(pid, pick)
    local playerName = string.lower(Players[pid].name)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " tried to use ccPerks.finalizeRewards with pick " .. pick)

    if ccPerks.RewardsTable[pick] == nil then
        tes3mp.SendMessage(pid, color.Red .. "ccPerks.finalizeRewards: ERROR: Invalid pick! Please contact an admin!.!\n", false)
        return false
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostRewards) then
            return false
        end
    end

    local rewardItem = {
        refId = ccPerks.RewardsTable[pick][1],
        count = ccPerks.RewardsTable[pick][2],
        charge = ccPerks.RewardsTable[pick][3]
    }

    table.insert(Players[pid].data.inventory, rewardItem)
    Players[pid]:LoadItemChanges({rewardItem}, enumerations.inventory.ADD)

    tes3mp.SendMessage(pid, color.Yellow .. "You have received: " .. ccPerks.RewardsTable[pick][4] .. " \n", false)
end

function ccPerks.finalizeWarp(pid, destination)
    local playerName = string.lower(Players[pid].name)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " tried to use /warp " .. destination)

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostWarp) then
            return false
        end
    end

    local coordTable = { ccCharGen.SpawnTable[destination][1], ccCharGen.SpawnTable[destination][2], ccCharGen.SpawnTable[destination][3],
        ccCharGen.SpawnTable[destination][4], ccCharGen.SpawnTable[destination][5] }
    ccCommon.teleportHandler(pid, coordTable)
end

function ccPerks.finalizeWeather(pid, pick)
    local playerName = string.lower(Players[pid].name)
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " tried to use weatherHandler with pick " .. pick)

    if not tes3mp.IsInExterior(pid) then
        tes3mp.SendMessage(pid, color.Red .. "You must be outdoors to use that command.\n", false)
        return false
    end

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostWeather) then
            return false
        end
    end

    local regionName = tes3mp.GetRegion(pid)
    local weather = ccPerks.WeatherTable[pick][1]

    tes3mp.LogMessage(1, "[ccPerks] Running changeweather \"" .. regionName .. "\" " .. weather)
    logicHandler.RunConsoleCommandOnPlayer(pid, "changeweather \"" .. regionName .. "\" " .. weather )
    eventHandler.OnWorldWeather(pid)

    local message = color.Gold .. "You've changed the local weather to " .. ccPerks.WeatherTable[pick][2] .. ".\n"
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.generateCommand(pid, str)
    -- Admin-only command that generates a custom record for the chosen ccRewards table item
    -- Only needs to be done once

    if not Players[pid]:IsAdmin() then return false end

    tes3mp.LogMessage(1, "[ccPerks] Attempted generateCommand with table entry " .. str[2])
    local pick = 0

    if tonumber(str[2]) ~= nil and ccConfig.Perks.RewardItems[tonumber(str[2])] ~= nil then
        pick = tonumber(str[2])
    else
        tes3mp.SendMessage(pid, color.Red .. "Format: /generate <number>. Table entries start at 1.\n", false)
        return false
    end

    local cmd = ""
    local inputType = ccConfig.Perks.RewardItems[pick][1]
    local message = ""

    if inputType == "weapon" then

        for i = 1, 19 do
            local j = i - 1

            if i > 1 then

                if ccConfig.Perks.RewardItems[pick][i] ~= nil then

                    if i == 16 or i == 17 or i == 18 then
                        message = "storerecord " .. inputType .. " " .. config.validRecordSettings.weapon[j] .. " " .. ccConfig.Perks.RewardItems[pick][i][1] ..
                            " " .. ccConfig.Perks.RewardItems[pick][i][2]
                    else
                        message = "storerecord " .. inputType .. " " .. config.validRecordSettings.weapon[j] .. " " .. ccConfig.Perks.RewardItems[pick][i]
                    end

                    cmd = (message:sub(2, #message)):split(" ")
                    commandHandler.StoreRecord(pid, cmd)
                end
            else
                message = "storerecord " .. inputType .. " clear"
                cmd = (message:sub(2, #message)):split(" ")
                commandHandler.StoreRecord(pid, cmd)
            end
        end
    else
        tes3mp.SendMessage(pid, color.Red .. "GenerateRecords: Only weapon records can be generated via this script at the moment.!\n", false)
        return false
    end

    message = "createrecord " .. inputType
    cmd = (message:sub(2, #message)):split(" ")
    commandHandler.CreateRecord(pid, cmd)

    tes3mp.SendMessage(pid, color.Green .. "GenerateRecords: Open your player file and copy the contents of the record to records/weapon.lua. \n", false)
end

function ccPerks.hairCancelCheck(pid, pick)
    local genderHairNum = (Players[pid].data.character.gender * 4) + 3
    local race = string.lower(Players[pid].data.character.race)

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    if pick <= ccPerks.RaceTable[holdIndex][genderHairNum] then
        return true
    else
        return false 
    end
end

function ccPerks.handlerLottery(pid) -- Used to generate prizes for tokens
    local playerName = string.lower(Players[pid].name)
    local message = ""

    -- Try to improve RNG
    math.randomseed(os.time())
    math.random(); math.random()

    local rando = math.random(1, ccPerks.Lottery.TotalEntries)

    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " uses /lottery with rando = " .. rando)

    if Players[pid]:IsAdmin() then
    else

        if not ccPerks.tokenCalculate(pid, playerName, ccConfig.Perks.TokenCostLottery) then
            return false
        end
    end

    -- First block of entries consists of item prizes in ccPerksConfig
    if rando >= 1 and rando <= ccPerks.Lottery.ItemEntries then
        local lotteryPrize = {}

        if ccConfig.Perks.Lottery.Items[rando] ~= nil then
            lotteryPrize = {
                refId = ccConfig.Perks.Lottery.Items[rando][1],
                count = ccConfig.Perks.Lottery.Items[rando][2],
                charge = ccConfig.Perks.Lottery.Items[rando][3]
            }
        else
            tes3mp.LogMessage(2, "[ccPerks] ccPerks.handlerLottery: Failure in first block check with rando = " .. rando)
            tes3mp.SendMessage(pid, color.Red .. "LOTTERY: Error occurred. Please contact an admin!\n", false)
            return false
        end

        message = color.Gold .. "LOTTERY: You won " .. ccConfig.Perks.Lottery.Items[rando][4]

        -- Check whether item exists in inventory
        -- If not, increase its count by proper amount
        if Players[pid].data.inventory.refId ~= nil then 
            Players[pid].data.inventory.count = Players[pid].data.inventory.count + lotteryPrize.count
        else
            table.insert(Players[pid].data.inventory, lotteryPrize)
        end

        Players[pid]:LoadItemChanges({lotteryPrize}, enumerations.inventory.ADD)

    -- Second block of entries consists of token prizes defined in ccPerksConfig
    elseif ccPerks.Lottery.TokenEntries > 0 and rando > ccPerks.Lottery.ItemEntries and 
        rando <= (ccPerks.Lottery.TokenEntries + ccPerks.Lottery.ItemEntries) then

        local rando2 =  math.random(1, ccPerks.Lottery.TokenEntries)
        local entryCounter = 0
        local tokenCount = Players[pid].data.perks.tokens.storedTokens
        local error = true

        -- Iterate through each reward in the token table in ccPerksConfig and total up the entries
        -- Check if "rando2" falls within the total number of entries at the end of a reward
        for index, _ in ipairs(ccConfig.Perks.Lottery.Tokens) do
            entryCounter = entryCounter + ccConfig.Perks.Lottery.Tokens[index][2]

            if rando2 <= entryCounter then
                error = false
                tokenCount = tokenCount + ccConfig.Perks.Lottery.Tokens[index][1]
                message = color.Gold .. "LOTTERY: You won " .. ccConfig.Perks.Lottery.Tokens[index][3]
                break
            end
        end

        if error then
            tes3mp.LogMessage(2, "[ccPerks] ccPerks.handlerLottery: Failure in second block check with rando2 = " .. rando2)
            tes3mp.SendMessage(pid, color.Red .. "LOTTERY: Error occurred. Please contact an admin!\n", false)
            return false
        end

        Players[pid].data.perks.tokens.storedTokens = tokenCount
        Players[pid]:QuicksaveToDrive()
    else
        message = color.Gold .. "LOTTERY: You didn't win anything this time...\n"
    end

    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.headCancelCheck(pid, pick)
    local genderHeadNum = (Players[pid].data.character.gender * 4) + 5
    local race = string.lower(Players[pid].data.character.race)

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    if pick <= ccPerks.RaceTable[holdIndex][genderHeadNum] then
        return true
    else
        return false 
    end
end

function ccPerks.parseRaceTable(race)
    -- Iterate through ccPerks.RaceTable and find match for player's race, then store index
    local holdIndex = 0

    for index, _ in ipairs(ccPerks.RaceTable) do

        if ccPerks.RaceTable[index] ~= nil and ccPerks.RaceTable[index][1] == race then
            holdIndex = index
            break
        end
    end

    if holdIndex ~= 0 then
        return holdIndex
    else
        tes3mp.LogMessage(2, "[ccPerks] ccPerks.parseRaceTable failed for race " .. race)
        tes3mp.SendMessage(pid, color.Red .. "HoldIndex error occurred. Please contact an admin!\n", false)
        return false
    end
end

function ccPerks.perksCommand(pid)
    local tokenCounter = Players[pid].data.perks.tokens.storedTokens
    local windowLabel = "Current number of tokens: " .. tokenCounter .. "\nPlease choose a perk:"
    tes3mp.ListBox(pid, ccWindowSettings.Perks, windowLabel, ccPerks.PerksTableText)
end

function ccPerks.setupCreatures()
    tes3mp.LogMessage(2, "[ccPerks] Populating creatures table with vanilla entries")

    for index, _ in ipairs(ccConfig.Perks.Vanilla.Creatures) do

        if ccConfig.Perks.Vanilla.Creatures[index] ~= nil then
            table.insert(ccPerks.CreatureTable, ccConfig.Perks.Vanilla.Creatures[index])
            ccPerks.CreatureTableText = ccPerks.CreatureTableText .. ccConfig.Perks.Vanilla.Creatures[index][2] .. "\n"
        end
    end

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccPerks] Populating creatures table with Tamriel entries")

        for index, _ in ipairs(ccConfig.Perks.Tamriel.Creatures) do

            if ccConfig.Perks.Tamriel.Creatures[index] ~= nil then
                table.insert(ccPerks.CreatureTable, ccConfig.Perks.Tamriel.Creatures[index])
                ccPerks.CreatureTableText = ccPerks.CreatureTableText .. ccConfig.Perks.Tamriel.Creatures[index][2] .. "\n"
            end
        end

    end

    ccPerks.CreatureTableText = ccPerks.CreatureTableText .. "Cancel"
end

function ccPerks.setupLottery() 
    local count = 0

    for index, _ in pairs(ccConfig.Perks.Lottery.Tokens) do

        if ccConfig.Perks.Lottery.Tokens[index][2] ~= 0 then
            count = count + ccConfig.Perks.Lottery.Tokens[index][2]
        end
    end

    ccPerks.Lottery.ItemEntries = tableHelper.getCount(ccConfig.Perks.Lottery.Items)
    ccPerks.Lottery.TokenEntries = count
    ccPerks.Lottery.TotalEntries = (ccPerks.Lottery.TokenEntries + ccPerks.Lottery.ItemEntries + ccConfig.Perks.Lottery.FillerEntries)
end

function ccPerks.setupPerks()
    tes3mp.LogMessage(2, "[ccPerks] Populating perks table")

    for index, _ in ipairs(ccPerks.PerksTable) do

        if ccPerks.PerksTable[index].name ~= nil then
            ccPerks.PerksTableText = ccPerks.PerksTableText .. ccPerks.PerksTable[index].name .. "\n"
        end
    end

    ccPerks.PerksTableText = ccPerks.PerksTableText .. "Cancel"
end

function ccPerks.setupRaces()
    tes3mp.LogMessage(2, "[ccPerks] Populating races table with vanilla entries")

    for index, _ in ipairs(ccConfig.Perks.Vanilla.Races) do

        if ccConfig.Perks.Vanilla.Races[index] ~= nil then
            table.insert(ccPerks.RaceTable, ccConfig.Perks.Vanilla.Races[index])
            ccPerks.RaceTableText = ccPerks.RaceTableText .. ccConfig.Perks.Vanilla.Races[index][10] .. "\n"
        end
    end

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
        tes3mp.LogMessage(2, "[ccPerks] Populating races table with Tamriel entries")

        for index, _ in ipairs(ccConfig.Perks.Tamriel.Races) do

            if ccConfig.Perks.Tamriel.Races[index] ~= nil then
                table.insert(ccPerks.RaceTable, ccConfig.Perks.Tamriel.Races[index])
                ccPerks.RaceTableText = ccPerks.RaceTableText .. ccConfig.Perks.Vanilla.Races[index][10] .. "\n"
            end
        end
    end

    ccPerks.RaceTableText = ccPerks.RaceTableText .. "Cancel"
end

function ccPerks.setupRewards()
    tes3mp.LogMessage(2, "[ccPerks] Populating rewards table")

    for index, _ in ipairs(ccConfig.Perks.RewardItems) do

        if ccConfig.Perks.RewardItems[index] ~= nil then
            -- Add new entry to table with values: id, count, charge, and displayed name
            local newEntry = { ccConfig.Perks.RewardItems[index][3], ccConfig.Perks.RewardItems[index][20], ccConfig.Perks.RewardItems[index][21], ccConfig.Perks.RewardItems[index][22] }

            table.insert(ccPerks.RewardsTable, newEntry)
            ccPerks.RewardsTableText = ccPerks.RewardsTableText .. ccConfig.Perks.RewardItems[index][22] .. "\n"
        end
    end
end

function ccPerks.setupWarp()
    tes3mp.LogMessage(2, "[ccPerks] Populating warp table")

    for index, _ in ipairs(ccCharGen.SpawnTable) do

        if ccCharGen.SpawnTable[index][6] ~= nil then
            ccPerks.WarpTableText = ccPerks.WarpTableText .. ccCharGen.SpawnTable[index][6] .. "\n"
        end
    end

    ccPerks.WarpTableText = ccPerks.WarpTableText .. "Cancel"
end

function ccPerks.setupWeather()
    tes3mp.LogMessage(2, "[ccPerks] Populating weather table")

    for index, _ in ipairs(ccConfig.Perks.WeatherTypes) do

        if ccConfig.Perks.WeatherTypes[index][2] ~= nil then
            table.insert(ccPerks.WeatherTable, ccConfig.Perks.WeatherTypes[index])
            ccPerks.WeatherTableText = ccPerks.WeatherTableText .. ccConfig.Perks.WeatherTypes[index][2] .. "\n"
        end
    end

    ccPerks.WeatherTableText = ccPerks.WeatherTableText .. "Cancel"
end

function ccPerks.tokenAdd(pid, targetPid, numTokens)
    -- Used to manually give a player tokens

    if logicHandler.CheckPlayerValidity(pid, targetPid) then
        local playerName = string.lower(Players[targetPid].name)
        local tokenCounter = 0
        local message = ""

        if numTokens ~= nil then
            tokenCounter = tonumber(Players[pid].data.perks.tokens.storedTokens) + numTokens
            message = color.Gold .. "SERVER: " .. playerName .. " has received " .. numTokens .. " token(s)!\n"
        else
            tokenCounter = Players[pid].data.perks.tokens.storedTokens + 1
            message = color.Gold .. "SERVER: " .. playerName .. " has received a token!\n"
        end
        tes3mp.SendMessage(pid, message, true)
        Players[pid].data.perks.tokens.storedTokens = tokenCounter
        Players[pid]:QuicksaveToDrive()
    end
end

function ccPerks.tokenAddAll(origPid, numTokens)
    -- Used to manually give all connected player tokens

    for _, p in pairs(Players) do -- Check connected players for faction's entry and send message

        if p ~= nil and p:IsLoggedIn() and p.pid ~= origPid then
            local playerName = string.lower(Players[p.pid].name)
            local tokenCounter = 0
            local message = ""

            if numTokens ~= nil then
                tokenCounter = tonumber(Players[pid].data.perks.tokens.storedTokens) + numTokens
                message = color.Gold .. "SERVER: " .. playerName .. " has received " .. numTokens .. " token(s)!\n"
            else
                tokenCounter = Players[pid].data.perks.tokens.storedTokens + 1
                message = color.Gold .. "SERVER: " .. playerName .. " has received a token!\n"
            end
            tes3mp.SendMessage(p.pid, message, true)
            Players[pid].data.perks.tokens.storedTokens = tokenCounter
            Players[pid]:QuicksaveToDrive()
        end
    end
end

function ccPerks.tokenCalculate(pid, playerName, tokenCost)
    -- Used to check number of tokens before perk is applied
    local message = ""
    local tokenCounter = Players[pid].data.perks.tokens.storedTokens

    if tokenCounter >= 1 then
        tokenCounter = Players[pid].data.perks.tokens.storedTokens - tokenCost
        Players[pid].data.perks.tokens.storedTokens = tokenCounter
        Players[pid]:QuicksaveToDrive()
        
        message = color.Gold .. "You use a token and now have " .. tokenCounter .. " token(s).\n"
        tes3mp.SendMessage(pid, message, false)
        return true
    else
        message = color.Gold .. "You don't have enough tokens to use this perk.\n"
        tes3mp.SendMessage(pid, message, false)
        return false
    end
end

function ccPerks.tokenCheck(pid, targetPid)
    -- Used to check a player's number of tokens
    local tokenCounter = 0
    local message = ""

    if logicHandler.CheckPlayerValidity(pid, targetPid) then
        local playerName = Players[tonumber(targetPid)].name

        tokenCounter = Players[pid].data.perks.tokens.storedTokens

        if tokenCounter <= 0 then
            message = color.Gold .. playerName .. " doesn't have any tokens.\n"
        else
            message = color.Gold .. playerName .. " has " .. tokenCounter .. " token(s).\n"
        end
    end
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.tokenCommand(pid, cmd)

    if not Players[pid]:IsModerator() then return false end

    if cmd[2] == "add" then

        if tonumber(cmd[3]) ~= nil then
            ccPerks.tokenAdd(pid, tonumber(cmd[3]))
        elseif string.lower(cmd[3]) == "all" and tonumber(cmd[4]) ~= nil then
            ccPerks.tokenAddAll(pid, tonumber(cmd[4]))
        end
    elseif cmd[2] == "check" and tonumber(cmd[3]) ~= nil then
        ccPerks.tokenCheck(pid, tonumber(cmd[3]))
    else
        local message = color.Red .. "The correct formats are:\n" .. "/token add <pid/all> <number>\n"
            .. "/token check <pid>\n"
        tes3mp.SendMessage(pid, message, false)
    end
end

function ccPerks.windowBirthsign(pid)
    local windowLabel = "Please choose a birthsign (" .. ccConfig.Perks.TokenCostBirthsign .. " token(s)):"
    local windowText = "The Apprentice\nThe Atronach\nThe Lady\nThe Lord\nThe Lover\nThe Mage\nThe Ritual\nThe Serpent\n\
        The Shadow\nThe Steed\nThe Thief\nThe Tower\nThe Warrior\nCancel"
    tes3mp.ListBox(pid, ccWindowSettings.Birthsign, windowLabel, windowText)
end

function ccPerks.windowCreature(pid)

    if Players[pid].data.shapeshift.isWerewolf then

        if Players[pid].data.shapeshift.isWerewolf then
            tes3mp.SendMessage(pid, color.Red .. "You can't use that perk as a werewolf." .. color.Default .. "\n", false)
            return false
        end
    end

    local windowLabel = "Please choose a creature (" .. ccConfig.Perks.TokenCostCreature .. " token(s)):"
    tes3mp.ListBox(pid, ccWindowSettings.SetCreature, windowLabel, ccPerks.CreatureTableText)
end

function ccPerks.windowGender(pid)
    local windowLabel = "Please choose a gender (" .. ccConfig.Perks.TokenCostGender .. " token(s)):"
    local windowText = "Female\nMale\nCancel"
    tes3mp.ListBox(pid, ccWindowSettings.Gender, windowLabel, windowText)
end

function ccPerks.windowHair(pid)
    local genderHairNum = (Players[pid].data.character.gender * 4) + 3
    local race = string.lower(Players[pid].data.character.race)
    local windowText = ""

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    for i = 1, ccPerks.RaceTable[holdIndex][genderHairNum] do
        windowText = windowText .. "Style " .. i .. "\n"
    end

    windowText = windowText .. "Cancel"

    local windowLabel = "Please choose a hairstyle (" .. ccConfig.Perks.TokenCostHair .. " token(s)):"
    tes3mp.ListBox(pid, ccWindowSettings.Hair, windowLabel, windowText)
end

function ccPerks.windowHead(pid)
    local genderHeadNum = (Players[pid].data.character.gender * 4) + 5
    local race = string.lower(Players[pid].data.character.race)
    local windowText = ""

    -- Find corresponding entry in ccPerks.RaceTable
    local holdIndex = ccPerks.parseRaceTable(race)

    for i = 1, ccPerks.RaceTable[holdIndex][genderHeadNum] do
        windowText = windowText .. "Style " .. i .. "\n"
    end

    windowText = windowText .. "Cancel"

    local windowLabel = "Please choose a head (" .. ccConfig.Perks.TokenCostHead .. " token(s)):"
    tes3mp.ListBox(pid, ccWindowSettings.Head, windowLabel, windowText)
end

function ccPerks.windowPet(pid)
    local windowLabel = "Please choose a pet (" .. ccConfig.Perks.TokenCostPet .. " token(s)):\nThey might adopt someone" ..
        " else if you log out!"
    local windowText = "Pack Rat\nRat\nScrib\nCancel"
    tes3mp.ListBox(pid, ccWindowSettings.SpawnPet, windowLabel, windowText)
end

function ccPerks.windowRace(pid)
    local windowLabel = "Please choose a race (" .. ccConfig.Perks.TokenCostRace .. " token(s)):"
    tes3mp.ListBox(pid, ccWindowSettings.Race, windowLabel, ccPerks.RaceTableText)
end

function ccPerks.windowRewards(pid)
    local windowLabel = "Please choose a reward (" .. ccConfig.Perks.TokenCostRewards .. " token(s)):"
    tes3mp.ListBox(pid, ccWindowSettings.Rewards, windowLabel, ccPerks.RewardsTableText)
end

function ccPerks.windowTokenClaim(pid) -- Used to give one token per day
    local getToken = false
    local playerName = string.lower(Players[pid].name)
    local message = ""
    local timeStored = Players[pid].data.perks.tokens.claimDate
    tes3mp.LogMessage(2, "[ccPerks] " .. playerName .. " uses /claimtoken")

    -- This should happen:
    if timeStored == 0 or type(timeStored) == "number" then
        local diff = (os.time() - timeStored)

        if (diff / 86400) > 1 then getToken = true end
    -- This shouldn't happen, takes care of "" values:
    elseif type(timeStored) == "string" then getToken = true
    end

    if getToken then
        message = color.Gold .. "You've claimed your daily token. Type /perks for a list of commands that you can use.\n"
        Players[pid].data.perks.tokens.claimDate = os.time()
        Players[pid].data.perks.tokens.storedTokens = tonumber(Players[pid].data.perks.tokens.storedTokens)
            + ccConfig.Perks.TokensPerClaim
        Players[pid]:QuicksaveToDrive()
    else message = color.Error .. "You've already claimed your daily token.\n"
    end
    tes3mp.SendMessage(pid, message, false)
end

function ccPerks.windowWarp(pid)
    local windowLabel = "Please choose a destination (" .. ccConfig.Perks.TokenCostWarp .. " token(s)):"
    tes3mp.ListBox(pid, ccWindowSettings.Warp, windowLabel, ccPerks.WarpTableText)
end

function ccPerks.windowWeather(pid)
    local windowLabel = "Please choose a weather style (" .. ccConfig.Perks.TokenCostWeather .. " token(s)):\nIt may take a" ..
        " minute for the weather to appear."
    tes3mp.ListBox(pid, ccWindowSettings.Weather, windowLabel, ccPerks.WeatherTableText)
end

-- ccPerks commands available to the player
-- NOTE: Don't edit anything inside the entries
-- If you want to prevent a player from using a command, then remove the entire entry from the table
ccPerks.PerksTable = {
    { name = "Claim Daily Token", storedFunc = ccPerks.windowTokenClaim },
    { name = "Appear as Creature", storedFunc = ccPerks.windowCreature },
    { name = "Rejoin Mages Guild", storedFunc = ccPerks.expelledFactions },
    { name = "Change Birthsign", storedFunc = ccPerks.windowBirthsign },
    { name = "Change Gender", storedFunc = ccPerks.windowGender },
    { name = "Change Hair", storedFunc = ccPerks.windowHair },
    { name = "Change Head", storedFunc = ccPerks.windowHead },
    { name = "Change Race", storedFunc = ccPerks.windowRace },
    { name = "Change Weather", storedFunc = ccPerks.windowWeather },
    { name = "Lottery", storedFunc = ccPerks.handlerLottery },
    -- { name = "Rewards", storedFunc = ccPerks.windowRewards },    temporarily disabled
    { name = "Spawn Pet", storedFunc = ccPerks.windowPet },
    { name = "Warp", storedFunc = ccPerks.windowWarp }
}

-----------------
-- EVENTS
-----------------

function ccPerks.OnPlayerEndCharGen(eventStatus, pid)
    -- Give new players the ccPerks data entries
    ccPerks.checkPlayerFileEntry(pid)
end

function ccPerks.OnPlayerFinishLogin(eventStatus, pid)
    -- Make sure players have ccPerks data entries
    ccPerks.checkPlayerFileEntry(pid)

    -- Clear creature disguise upon logging in
    if not Players[pid].data.shapeshift.creatureRefId or Players[pid].data.shapeshift.creatureRefId ~= nil then
        Players[pid].data.shapeshift.creatureRefId = "nothing"
        tes3mp.SetCreatureRefId(pid, "nothing")
        tes3mp.SendShapeshift(pid)
    end
end

function ccPerks.OnPlayerLevel(eventStatus, pid)
    -- Give player a token every specified number of levels

    if Players[pid] ~= nil and Players[pid]:IsLoggedIn() then
        local newLevel = tes3mp.GetLevel(pid)
        local playerName = string.lower(Players[pid].name)

        if ccConfig.Perks.TokensOnLevelUpEnabled then

            if newLevel == 1 then return
            elseif newLevel <= Players[pid].data.perks.tokens.storedLevel then return 
            end

            Players[pid].data.perks.tokens.storedLevel = newLevel

            if newLevel <= ccConfig.Perks.TokensMaxLevel and math.fmod(newLevel, ccConfig.Perks.TokensLevelInterval) == 0 then
                tes3mp.LogMessage(2, "[ccPerks] Player " .. playerName .. " has leveled up to level " .. newLevel .. " (" .. type(newLevel) ..
                    " var)")
                Players[pid].data.perks.tokens.storedTokens = Players[pid].data.perks.tokens.storedTokens + ccConfig.Perks.TokensPerLevelUp
                tes3mp.SendMessage(pid, color.Gold .. "You've received a token(s) for leveling up! You can use it on /perks." ..
                    color.Default .. "\n", false)
            end
            Players[pid]:QuicksaveToDrive()
        end
    end
end

function ccPerks.OnServerPostInit(eventStatus)
    -- Performs data initialization duties every restart
    ccPerks.setupPerks()
    ccPerks.setupCreatures()
    ccPerks.setupLottery()
    ccPerks.setupRaces()
    ccPerks.setupRewards()
    ccPerks.setupWarp()
    ccPerks.setupWeather()
end

if ccConfig.PerksEnabled then
    customCommandHooks.registerCommand("generate", ccPerks.generateCommand)
    customCommandHooks.registerCommand("perks", ccPerks.perksCommand)
    customCommandHooks.registerCommand("token", ccPerks.tokenCommand)

    customEventHooks.registerHandler("OnPlayerEndCharGen", ccPerks.OnPlayerEndCharGen)
    customEventHooks.registerHandler("OnPlayerFinishLogin", ccPerks.OnPlayerFinishLogin)
    customEventHooks.registerHandler("OnPlayerLevel", ccPerks.OnPlayerLevel)
    customEventHooks.registerHandler("OnServerPostInit", ccPerks.OnServerPostInit)
end

return ccPerks
