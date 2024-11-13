require("BananaCore")

local args = {...}

local printUtil = BananaCore.GUI.PrintUtil:new()

if #args ~= 2 then
	printUtil:Error("Usage: branches <branches> <branchlength>")
	error()
end

local branches = tonumber(args[1])
local branchLength = tonumber(args[2])
local routeLength = (branchLength * 4 * branches) + (branches * 3)

if (routeLength > turtle.getFuelLimit()) then
	printUtil:Error("Route exceeds " .. turtle.getFuelLimit() .. " blocks")
	error()
end


local function restack()
	local items = {}
	local previouslySelectedSlot = turtle.getSelectedSlot()

	for slot = 1, 16 do
		local count = turtle.getItemCount(slot)
		if (count > 0) then
			local item = turtle.getItemDetail(slot)
			items[slot] = item.name
		end
	end

	for slot = 1, 16 do
		local item = turtle.getItemDetail(slot)
		turtle.select(slot)

		for key, value in pairs(items) do
			if (item.name == value) then
				turtle.transferTo(key)
			end
		end
	end

	turtle.select(previouslySelectedSlot)
end

local function greedyRefuel(configuration)
	for slot = 1, 16 do
		if (slot == configuration.slots.cobble) then
			-- do nothing
		elseif (slot == configuration.slots.chest) then
			-- do nothing
		else
			turtle.select(slot)
			turtle.refuel()
		end
	end
	turtle.select(configuration.slots.cobble)
end


local function dumpToChest(configuration)
	configuration.logger:Info("dump items to chest")
	turtle.turnLeft()
	turtle.dig()

	turtle.select(configuration.slots.chest)
	turtle.place()

	local importantSlots = {}
	for key, value in pairs(configuration.slots) do
		importantSlots[value] = key
	end

	for slot = 1, 16 do
		if (importantSlots[slot] == nil) then
			turtle.select(slot)
			local item = turtle.getItemDetail()
			local count = turtle.getItemCount()
			if (turtle.drop()) then
				configuration.logger:Info("\tdumped %i %s", count, item.name)
			end
		end
	end

	turtle.turnRight()
end

local function hasFreeSlots()
	local previouslySelectedSlot = turtle.getSelectedSlot()
	for slot = 1, 16 do
		turtle.select(slot)
		local count = turtle.getItemCount()
		if (count == 0) then
			turtle.select(previouslySelectedSlot)
			return true
		end
	end
	-- reached last slot and its not empty
	return false
end

local function digForward(configuration)
	while (not turtle.forward()) do
		turtle.attack()
		turtle.dig()
	end
	while (turtle.detectUp()) do
		turtle.digUp()
		sleep(0.45)
	end
end

local function bridge(configuration)
	local success, block = turtle.inspectDown()
	turtle.select(configuration.slots.cobble)

	if (success) then
		for _, v in pairs(configuration.liquids) do
			if (v == block.name) then
				turtle.placeDown()
			end
		end
	else
		while (not turtle.detectDown()) do
			turtle.attackDown()
			turtle.placeDown()
		end
	end
end

local function move(configuration)
	digForward(configuration)
	bridge(configuration)
end

local function exploreBranch(length, configuration)
	for i = 1, length do
		move(configuration)
	end

	turtle.turnRight()
	turtle.turnRight()

	for i = 1, length do
		move(configuration)
	end
end

local function main()
	local currentBranches = 0

	local logger = BananaCore.Logger:new()
	logger:SetLogLevel("INFO")

	local configuration = {
		slots = {
			cobble = 1,
			chest = 2,
		},
		liquids = {
			"minecraft:water",
			"minecraft:lava"
		},
		logger = logger
	}

	greedyRefuel(configuration)

	while (currentBranches < branches) do
		for i = 1, 3 do
			move(configuration)
		end

		-- turn to right branch
		turtle.turnRight()
		exploreBranch(branchLength, configuration)
		-- explore other direction
		exploreBranch(branchLength, configuration)
		--turn back
		turtle.turnLeft()

		greedyRefuel(configuration)
		if (not hasFreeSlots()) then
			restack()
			if (not hasFreeSlots()) then
				dumpToChest(configuration)
			end
		end

		currentBranches = currentBranches + 1
	end
end

main()