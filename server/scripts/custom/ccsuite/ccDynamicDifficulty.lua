---------------------------
-- ccDynamicDifficulty 0.7.0 by Texafornian
--
--

-----------------
-- FUNCTIONS
-----------------

function ccDynamicDifficulty.changeDifficulty(event)
    local newDifficulty = tonumber(config.difficulty)
    local playerCount = tonumber(logicHandler.GetConnectedPlayerCount())

    newDifficulty = newDifficulty + (playerCount * ccConfig.DynamicDifficulty.DifficultyPerPlayer)

    if ccConfig.DynamicDifficulty.MaxDifficultyEnabled and newDifficulty > ccConfig.DynamicDifficulty.MaxDifficultyValue then 
        newDifficulty = ccConfig.DynamicDifficulty.MaxDifficultyValue
    end

    for _, p in pairs(Players) do
        local tempDifficulty = newDifficulty

        if not p.data.hardcoreMode then
        elseif p.data.hardcoreMode.enabled then
            tempDifficulty = tempDifficulty + ccConfig.Hardcore.AddedDifficulty
        end

        -- Might not take effect until player changes cells
        p:SetDifficulty(tempDifficulty)
        p:LoadSettings()

        local message = "The world difficulty has been "

        if event == "connect" then tes3mp.SendMessage(p.pid, color.Orange .. message .. "increased.\n", false)
        elseif event == "disconnect" then tes3mp.SendMessage(p.pid, color.Orange .. message .. "decreased.\n", false)
        end
    end
end

function ccDynamicDifficulty.OnPlayerDisconnect(eventStatus)
    ccDynamicDifficulty.changeDifficulty("disconnect")
end

function ccDynamicDifficulty.OnPlayerFinishLogin(eventStatus)
    ccDynamicDifficulty.changeDifficulty("connect")
end

function ccDynamicDifficulty.OnPlayerEndCharGen(eventStatus)
    ccDynamicDifficulty.changeDifficulty("connect")
end

if ccConfig.DynamicDifficultyEnabled then
    customEventHooks.registerHandler("OnPlayerFinishLogin", ccDynamicDifficulty.OnPlayerFinishLogin)
    customEventHooks.registerHandler("OnPlayerDisconnect", ccDynamicDifficulty.OnPlayerDisconnect)
    customEventHooks.registerHandler("OnPlayerEndCharGen", ccDynamicDifficulty.OnPlayerEndCharGen)
end

return ccDynamicDifficulty
