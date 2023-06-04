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
	    [0x20] = "Item", -- Can't find how items are stored yet.
	}

function displayInfo()
-- Gets slotIdValues from RAM
    local slotIdValues = {}
    local checkValues = {}
    	for i=0,6 do
        	slotIdValues[i+1] = emu.read(0x030E + 0x10*i, emu.memType.nesDebug)
        	checkValues[i+1] = emu.read(0x0300 + 0x10*i, emu.memType.nesDebug)
    	end

-- Gets Fester's Key Count, Gun Level, GPS, Step, and Enemy(slot) Health Value from RAM addresses

    local keyCount = emu.read(0x015D, emu.memType.nesDebug)
    local gunLevel = emu.read(0x04E7, emu.memType.nesDebug)
    local whipLevel = emu.read(0x04E8, emu.memType.nesDebug)

    --local festerX = emu.read(0x04F3, emu.memType.nesDebug) -- Not sure correct address; using for now
    --local festerY = emu.read(0x04F9, emu.memType.nesDebug) -- Not sure correct address; using for now

    local festerStep = emu.read(0x04F7, emu.memType.nesDebug)

    local en1health = emu.read(0x0308, emu.memType.nesDebug)
    local en2health = emu.read(0x0318, emu.memType.nesDebug)
    local en3health = emu.read(0x0328, emu.memType.nesDebug)
    local en4health = emu.read(0x0338, emu.memType.nesDebug)
    local en5health = emu.read(0x0348, emu.memType.nesDebug)
    local en6health = emu.read(0x0358, emu.memType.nesDebug)
    local en7health = emu.read(0x0368, emu.memType.nesDebug)

-- Displays Fester's GPS, Key Count, Gun Level, Step, and Enemy(slot) Health Value

    --emu.drawString(100, 0, 'X:' .. festerX, 0xFFFFFF, 0xFF000000)
    --emu.drawString(100, 8, "Y:" .. festerY, 0xFFFFFF, 0xFF000000)

    emu.drawString(130, 0, "Key:" .. (keyCount - 1), 0xFFFFFF, 0xFF000000)
    emu.drawString(130, 8, "Gun:" .. gunLevel, 0xFFFFFF, 0xFF000000)
    emu.drawString(130, 16, "Whip:" .. whipLevel, 0xFFFFFF, 0xFF000000)
    emu.drawString(130, 24, "Step:" .. festerStep, 0xFFFFFF, 0xFF000000)

-- Display Enemy(slot) Health

    emu.drawString(162, 0, "1:" .. en1health, 0xFFFFFF, 0xFF000000)
    emu.drawString(162, 8, "2:" .. en2health, 0xFFFFFF, 0xFF000000)
    emu.drawString(162, 16, "3:" .. en3health, 0xFFFFFF, 0xFF000000) 
    emu.drawString(162, 24, "4:" .. en4health, 0xFFFFFF, 0xFF000000)
    emu.drawString(162, 32, "5:" .. en5health, 0xFFFFFF, 0xFF000000)
    emu.drawString(162, 40, "6:" .. en6health, 0xFFFFFF, 0xFF000000)
    emu.drawString(162, 48, "7:" .. en7health, 0xFFFFFF, 0xFF000000)

-- Displays SlotIdValue

    for slotNumber, slotIdValue in ipairs(slotIdValues) do
        -- Only displays slot ID if the check value is above 0
        if checkValues[slotNumber] > 0 then
            -- Gets the slot IDs from the lookup table 
            local slotId = slotIdLookup[slotIdValue] or "Unknown"
            -- Prints the slot IDs on the screen
            emu.drawString(192, (slotNumber - 1) * 8, slotId, 0xFFFFFF, 0xFF000000)
        end
    end   
end

emu.addEventCallback(displayInfo, emu.eventType.endFrame)