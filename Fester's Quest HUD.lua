-- Fester's Quest Crappy Heads Up Display. Made with Mesen2 by Mogwai_Ren

-- Defines the slot ID lookup table
local slotIdLookup = {
    [0x00] = "Spore",
    [0x01] = "Fly",
    [0x02] = "FaceBounce",
    [0x03] = "Scorpion",
    [0x04] = "Flea",
    [0x05] = "BlueFrog",
    [0x06] = "OrangeFrog",
    [0x07] = "GreenFrog",
    [0x08] = "PinkFrog",
    [0x09] = "Fireball",
    [0x0A] = "Digger",
    [0x0B] = "Rat",
    [0x0C] = "Larva",
    [0x0D] = "Snail",
    [0x0E] = "Slime",
    [0x0F] = "Dome",
    [0x10] = "Bubble",
    [0x11] = "SpinEYE",
    [0x12] = "GreenSpit",
    [0x13] = "FaceMove",
    [0x14] = "GreenRock",
    [0x16] = "EyeBall",
    [0x20] = "Item", -- Can't find how items are stored yet. 0x00C6 & 0x04E7?
}

-- Defines the slot # and health lookup table
local slotHealthLookup = {
    [0x308] = "1",
    [0x318] = "2",
    [0x328] = "3",
    [0x338] = "4",
    [0x348] = "5",
    [0x358] = "6",
    [0x368] = "7",
}

function displayInfo()
    -- Gets slotIdValues from RAM
    local slotIdValues = {}
    local checkValues = {}
    for i = 0, 6 do
        slotIdValues[i + 1] = emu.read(0x030E + 0x10 * i, emu.memType.nesDebug)
        checkValues[i + 1] = emu.read(0x0300 + 0x10 * i, emu.memType.nesDebug)
    end

    -- Gets Fester's Key Count, Gun Level, GPS, Step from RAM addresses
    local keyCount = emu.read(0x015D, emu.memType.nesDebug)
    local gunLevel = emu.read(0x04E7, emu.memType.nesDebug)
    local festerStep = emu.read(0x04F7, emu.memType.nesDebug)
    
    -- Gets festerX:Y
    --local festerX = emu.read(0x04F3, emu.memType.nesDebug) -- Not sure correct address; using for now
    --local festerY = emu.read(0x04F9, emu.memType.nesDebug) -- Not sure correct address; using for now

    -- Displays Key, Gun, Step
    emu.drawString(130, 0, "Key:" .. (keyCount - 1), 0xFFFFFF, 0xFF000000)
    emu.drawString(130, 8, "Gun:" .. gunLevel, 0xFFFFFF, 0xFF000000)
    emu.drawString(130, 16, "Step:" .. festerStep, 0xFFFFFF, 0xFF000000)
    
    -- GPS
    --emu.drawString(100, 0, 'X:' .. festerX, 0xFFFFFF, 0xFF000000)
    --emu.drawString(100, 8, "Y:" .. festerY, 0xFFFFFF, 0xFF000000)

    -- Display mSlot(Enemy) Health
    for address, mSlot in pairs(slotHealthLookup) do
        local slotHealth = emu.read(address, emu.memType.nesDebug)
        emu.drawString(162, (mSlot - 1) * 8, mSlot .. ":" .. slotHealth, 0xFFFFFF, 0xFF000000)
    end

    -- Displays SlotIdValue
    for slotNumber, slotIdValue in ipairs(slotIdValues) do
        -- Only displays slot ID if the check value is above 0
        if checkValues[slotNumber] > 0 then
            -- Gets the slot IDs from the lookup table
            local slotId = slotIdLookup[slotIdValue] or "Null"
            -- Prints the slot IDs on the screen
            emu.drawString(192, (slotNumber - 1) * 8, slotId, 0xFFFFFF, 0xFF000000)
        end
    end
end

emu.addEventCallback(displayInfo, emu.eventType.endFrame)
