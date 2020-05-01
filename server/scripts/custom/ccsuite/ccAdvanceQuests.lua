---------------------------
-- ccAdvanceQuests 0.7.0 by Texafornian
--
--

-----------------
-- DECLARATIONS
-----------------

local ccAdvanceQuests = {}

-----------------
-- FUNCTIONS 
-----------------

-- Clear the journal and topics list, add vanilla info (ccAdvanceQuestsConfig),
-- then add Tamriel info if applicable
function ccAdvanceQuests.resetWorld()
    tes3mp.LogMessage(2, "[ccAdvanceQuests] Resetting world data entries")

    WorldInstance.data.factionRanks = {}
    WorldInstance.data.factionExpulsion = {}
    WorldInstance.data.fame = {}
    WorldInstance.data.journal = {}
    WorldInstance.data.kills = {}

    for _, item in pairs(ccConfig.AdvanceQuests.Quests.Vanilla) do
        local journalItem = {
            type = item[1],
            index = item[2],
            quest = item[3],
            actorRefId = item[4]
        }

        table.insert(WorldInstance.data.journal, journalItem)
    end

    for _, topicId in pairs(ccConfig.AdvanceQuests.Topics.Vanilla) do

        if not tableHelper.containsValue(WorldInstance.data.topics, topicId[1]) then
            table.insert(WorldInstance.data.topics, topicId[1])
        end
    end

    if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel

        for _, item in pairs(ccConfig.AdvanceQuests.Quests.Tamriel) do
            local journalItem = {
                type = item[1],
                index = item[2],
                quest = item[3],
                actorRefId = item[4]
            }

            table.insert(WorldInstance.data.journal, journalItem)
        end

        for _, topicId in pairs(ccConfig.AdvanceQuests.Topics.Tamriel) do

            if not tableHelper.containsValue(WorldInstance.data.topics, topicId[1]) then
                table.insert(WorldInstance.data.topics, topicId[1])
            end
        end
    end

    WorldInstance:QuicksaveToDisk()
end

-- If server isn't set to always wipe world file on restart (ccAdvanceQuestsConfig),
-- then compare the current hour (on startup) to the appropriate wipe time table
function ccAdvanceQuests.OnServerPostInit(eventStatus)
    tes3mp.LogMessage(2, "[ccAdvanceQuests] Checking time for world file reset")

    if not ccConfig.AdvanceQuests.AlwaysWipeOnRestart then
        local currentHour = os.date("%H")
        local wipeTimes = {}

        if string.lower(ccConfig.ServerPlugins) == "tamriel" then -- TCC Tamriel
            wipeTimes = ccConfig.AdvanceQuests.WipeTimes.Tamriel
        else
            wipeTimes = ccConfig.AdvanceQuests.WipeTimes.Vanilla
        end

        for index, _ in pairs(wipeTimes) do

            if currentHour == wipeTimes[index][1] then
                ccAdvanceQuests.resetWorld()
                break
            end
        end
    else
        ccAdvanceQuests.resetWorld()
    end
end

if ccConfig.AdvanceQuestsEnabled then
    customEventHooks.registerHandler("OnServerPostInit", ccAdvanceQuests.OnServerPostInit)
end

return ccAdvanceQuests
