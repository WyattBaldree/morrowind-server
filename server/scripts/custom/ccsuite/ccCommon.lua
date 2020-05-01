---------------------------
-- ccCommon 0.7.0 by Texafornian
--
--

-----------------
-- FUNCTIONS
-----------------

function ccCommon.teleportHandler(pid, coordTable)
    -- Takes input table (one row) of coordinate to teleport player
    -- Assumes the player is always going to look straight ahead (x rot = 0)
    tes3mp.SetCell(pid, coordTable[1])
    tes3mp.SendCell(pid)
    tes3mp.SetPos(pid, coordTable[2], coordTable[3], coordTable[4])
    tes3mp.SetRot(pid, 0, coordTable[5])
    tes3mp.SendPos(pid)
end

return ccCommon
