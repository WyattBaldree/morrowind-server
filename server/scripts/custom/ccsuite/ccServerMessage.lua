---------------------------
-- ccServerMessage 0.7.0 by Texafornian
--
-- Many thanks to:
-- Dave for the very first iteration

------------------
-- TIMER SECTION
------------------

-- Creates a timer that calls CheckTime() every specified interval of seconds
local ccServerMessageTimer = tes3mp.CreateTimer("CheckTime", time.seconds(ccConfig.ServerMessage.Timer))

if ccConfig.ServerMessageEnabled then
    do tes3mp.StartTimer(ccServerMessageTimer) end
end

---------------------
-- FUNCTIONS SECTION
---------------------

-- Check current time against the entries in ccServerMessageConfig
function CheckTime()
    local hour = os.date("%H")
    local msg = ""
    local minute = os.date("%M")

    -- If current hour and minute match an entry in ccConfig.ServerMessage.RestartWarningTimes,
    -- then send a "one minute left" warning message
    if ccConfig.ServerMessage.RestartWarningEnabled then

        for index, _ in pairs(ccConfig.ServerMessage.RestartWarningTimes) do

            if hour == ccConfig.ServerMessage.RestartWarningTimes[index][1] and minute == ccConfig.ServerMessage.RestartWarningTimes[index][2] then
                tes3mp.LogMessage(2, "[ccServerMessage] Server shutting down in 2 minutes")
                msg = color.Orange .. "\n=~=~=~=~=~=~=~=~=~=~=\nSERVER WILL RESTART IN 2 MINUTES\n=~=~=~=~=~=~=~=~=~=~=\n\n"
                ServerMessage(msg)
            end
        end
    end

    -- If current minute matches a message in ccServerMessageConfig, then
    -- print that message
    for index, _ in pairs(ccConfig.ServerMessage.Messages) do

        if minute == ccConfig.ServerMessage.Messages[index][1] then
            msg = ccConfig.ServerMessage.Messages[index][2]
            ServerMessage(msg)
        end
    end

    tes3mp.RestartTimer(ccServerMessageTimer, time.seconds(ccConfig.ServerMessage.Timer))
end

-- Send supplied message to all players on server
function ServerMessage(msg)

    for _, player in pairs(Players) do
        tes3mp.SendMessage(player.pid, msg, false)
    end
end
