-- [BT_BRANCHES]
-- stripmining programm by BananaTeddy
-- version 5

local args = {40, 40}

local btLoaded = require('BT_CORE')
if btLoaded == false then
    error('BT_CORE not loaded')
end

local fuels = BT_CORE.fuelItems
for _, v in pairs(fuels) do
    print(v)
end

if BT_CORE.GetVersion() < 4 then
    print("BananaTeddy API is outdated!");
    print("Please update from ");
    error();
end


if #args ~= 2 then
    color = BT_CORE.isColor();
    if color then
        term.setTextColor(colors.red);
    end
    print("Usage: branches <branches> <branchlength>");
    term.setTextColor(colors.white);
    error();
end

-- constants
local BRANCHES = tonumber(args[1])
local BRANCH_LENGTH = tonumber(args[2])
local ROUTE_LENGTH = (BRANCH_LENGTH * 4 * BRANCHES) + (BRANCHES * 3)

if ROUTE_LENGTH > 1e5 then
    print('Route exceeds 100,000 blocks. Turtle may run out of fuel.', 80)
    print('Are you sure you want to start this operation?', 80)

    local answer = read()

    if (answer == 'n' or answer == 'N') then
        error('Operation was cancelled')
    end

end

local curBranches = 0;
local curBranchlength = 0;

local hasEnderchest = false;
local enderSlot = nil;
local clearInventory;

--prepare tables
local desiredItems = {
    'denseores:block0',
    'ThermalFoundation:Ore',
    'minecraft:gold_ore',
    'minecraft:iron_ore',
    'minecraft:redstone_ore',
    'minecraft:lapis_ore',
    'minecraft:diamond_ore',
    'minecraft:emerald_ore',
    'minecraft:coal_ore',
    'appliedenergistics2:tile.OreQuartz'
}

local undesiredItems = {
    'minecraft:cobblestone',
    'minecraft:gravel',
    'minecraft:dirt',
    'minecraft:planks',
    'chisel:limestone',
    'chisel:diorite',
    'chisel:granite',
    'chisel:andesite',
    'ProjRed:Core:projectred.core.part',
    'BigReactors:YelloriteOre',
    'Botania:mushroom',
    'TConstruct:ore.berries.one',
    'TConstruct:oreBerries',
    'minecraft:flint',
    'appliedenergistics2:tile.OreQuartzCharged'
}

local liquids = {
    'minecraft:water',
    'minecraft:flowing_water',
    'minecraft:lava',
    'minecraft:flowing_lava',
    'BuildCraft|Energy:blockOi'
}

while turtle.getFuelLevel() < ROUTE_LENGTH do
    local success = BT_CORE.Refuel(ROUTE_LENGTH);
    if not success then
        local deficit = ROUTE_LENGTH - turtle.getFuelLevel();
        if color then
            term.setTextColor(colors.red);
        end
        print('Not enough fuel for desired route.');
        print("Need fuel for " .. deficit .. " blocks to start.")
        term.setTextColor(colors.white);
        error();
    end
end


function StackItems()

    local partiallyStackedItems = BT_CORE.GetPartiallyStackedItems()
    if #partiallyStackedItems < 2 then
        -- we need at least 2 partially stacked items to move items between slots
        return
    end
    local previousSlot = turtle.getSelectedSlot()
    for psi = #partiallyStackedItems, 1, -1 do
        -- stack items
    end

end

local function forward()
    while not bt.isInvFull("slot") do
        if turtle.detect() then
            turtle.dig();
        end
        while not turtle.forward() do
            --while we cannot move forward we attack in case theres a mob or dig in case theres gravel/sand
            turtle.attack();
            turtle.dig();
        end
        while turtle.detectUp() do
                turtle.digUp();
                sleep(0.45) -- pause for blocks to fall down
        end
        sleep(0.05);
        local success, data = turtle.inspectDown();
        if success then
            --if theres a block beneath the turtle, check if its a liquid
            for _, v in pairs(liquids) do
                if v == data.name then
                    turtle.select(1)
                    turtle.placeDown();
                end
            end
        else
            --if there's no block
            while not turtle.detectDown() do
                turtle.attackDown();
                turtle.select(1);
                turtle.placeDown();
            end
        end
        break;
    end
    if BT_CORE.isInvFull("slot") then
        BT_CORE.Refuel();
        clearInventory();
    end
end

local function returnToMainBranch()
    turtle.turnRight();
    turtle.turnRight();
    for i=1, BRANCH_LENGTH do
        forward();
    end
end


local function discardItems()
local prevSlot = turtle.getSelectedSlot();
    for slot=1, 16 do
        turtle.select(slot)
        local data = turtle.getItemDetail();
        if data then
            for _, v in pairs(undesiredItems) do
                if v == data.name then
                    if slot == 1 then
                        if  data.name ~= "minecraft:cobblestone" then
                            turtle.drop();
                        end
                    else
                        if data.name == "minecraft:cobblestone" then
                            turtle.transferTo(1);
                        end
                        turtle.drop();
                    end
                end
            end
        end
    end
turtle.select(prevSlot);        
end

clearInventory = function()
--do we have an enderchest from enderstorage?
hasEnderchest = false;
    for slot=1, 16 do
    turtle.select(slot);
    local data = turtle.getItemDetail();
        if data then
            if data.name == "EnderStorage:enderChest" then
                hasEnderchest = true;
                enderSlot = slot;
                break;
            end
        end
    end
    
    if hasEnderchest then
        --if we do have an enderchest, select it
        turtle.select(enderSlot);
        --turn around, thats where we came from so there has to be some space to place the chest
        turtle.turnRight();
        turtle.turnRight();
        --try to place the chest
        while not turtle.place() do
            turtle.attack();
            turtle.dig();
        end
        -- remove everything except 1st slot, which should be cobblestone. we need it for potential bridges
        for slot=2, 16 do
            turtle.select(slot);
            local data = turtle.getItemDetail();
            if data then
                if data.name == "minecraft:cobblestone" then
                    turtle.transferTo(1);
                end
            end
            turtle.drop();
        end
        turtle.select(enderSlot);
        turtle.dig();
        turtle.turnRight();
        turtle.turnRight();
    else
        discardItems();
    end
end

while curBranches < BRANCHES do
        for i=1, 3 do
            forward();
        end
        --enter branch on right side
        turtle.turnRight();
        for i=1, BRANCH_LENGTH do
            forward();
        end
        returnToMainBranch();
        --enter opposite branch
        for i=1, BRANCH_LENGTH do
            forward();
        end
        returnToMainBranch();
        turtle.turnLeft();
        curBranches = curBranches+1;
end

if curBranches == BRANCHES then
    clearInventory();
end