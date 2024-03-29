-- Fester's Quest Heads Up Display. Made with Mesen2 by Mogwai_Ren

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
    [0x20] = "Item", 
}

-- Defines the item drop lookup table
local itemDropLookup = {
    [0x00] = "Key",
    [0x01] = "Money",
    [0x02] = "Lightbulb",
    [0x03] = "GunUp",
    [0x04] = "WhipUp",
    [0x05] = "GunDown",
    [0x06] = "WhipDown",
}

-- Non Boss Memory Slots 
	-- 0x0300-0x0360 (Each 0x10 is new slot 1-7)
		-- 0x03*0 Slot timer
		-- 0x03*1 Slot Y
		-- 0x03*2 ??
		-- 0x03*3 Slot X 
		-- 0x03*4 Visible on screen
		-- 0x03*5 **Item DropID if (slotIdLookup == 20 then 0x03*5 == (itemDropLookup))**
		-- 0x03*6 ?? 
		-- 0x03*7 ??
		-- 0x03*8 Slot Health
		-- 0x03*9-0x03*C Next Spawn locations?
		-- 0x03*F Slot status
			
-- Defines the Slot # and health lookup table
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

    	-- Item Memory 0x015C-0x0164
    		-- Bulb 0x015C
    		-- Key 0x015D
    		-- Noose 0x015E
    		-- Vice Grips 0x015F 
    		-- Potion 0x0160 
    		-- Invisible 0x0161, Invisible timer 0x00CC
    		-- Money 0x162 
    		-- Missile 0x0163 
    		-- TNT 0x0164
    	-- Fester Memory 
        	-- Fester Current Health 0x04E9
    		-- # of Fester Health Slots 0x04EA
    		-- Gun 0x04E7
    		-- Whip 0x04E8
    		-- Step 0x04F7
    		
    -- Gets Fester's Key Count, Gun Level, "Step" from RAM addresses
    local keyCount = emu.read(0x015D, emu.memType.nesDebug) 
    local gunLevel = emu.read(0x04E7, emu.memType.nesDebug)
    --local festerStep = emu.read(0x04F7, emu.memType.nesDebug)
  
    	-- Displays Key, Gun, Step
    emu.drawString(140, 0, "Key:" .. (keyCount - 1), 0xFFFFFF, 0xFF000000) -- 140
    emu.drawString(140, 8, "Gun:" .. gunLevel, 0xFFFFFF, 0xFF000000) -- 140
    --emu.drawString(140, 16, "Step:" .. festerStep, 0xFFFFFF, 0xFF000000) -- 140
    
    -- Display mSlot(Enemy) Health
    for address, mSlot in pairs(slotHealthLookup) do
        local slotHealth = emu.read(address, emu.memType.nesDebug)
        emu.drawString(172, (mSlot - 1) * 8, mSlot .. ":" .. slotHealth, 0xFFFFFF, 0xFF000000)
    end

    	-- Displays SlotIdValue and ItemDropId
	for slotNumber, slotIdValue in ipairs(slotIdValues) do
    	-- Only displays slot ID if the check value is above 0
    	if checkValues[slotNumber] > 0 then
        	-- Gets the slot IDs from the lookup tables
        local slotId
		if slotIdValue == 0x20 then
           	-- Retrieve item drop ID using the itemDropLookup table
			local itemDropId = emu.read(0x0305 + 0x10 * (slotNumber - 1), emu.memType.nesDebug)
			slotId = itemDropLookup[itemDropId] or "Null"
			else
	        	-- Retrieve regular slot ID using the slotIdLookup table
          	slotId = slotIdLookup[slotIdValue] or "Null"
        	end
	        -- Prints the slot IDs on the screen
	        emu.drawString(202, (slotNumber - 1) * 8, slotId, 0xFFFFFF, 0xFF000000) -- 202
		end
	end
end

emu.addEventCallback(displayInfo, emu.eventType.endFrame)
