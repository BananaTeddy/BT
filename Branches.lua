-- [BT_BRANCHES]
-- stripmining programm by BananaTeddy
-- version 5

local args = {...}

local btCoreLoaded = require('BT_API')
if btCoreLoaded == false then
    error('BT_API not loaded')
end


if BT_API.GetVersion() < 6 then
    print("BananaTeddy API is outdated!");
    print('Please update using')
    print('wget https://raw.githubusercontent.com/BananaTeddy/BT_API/main/Install.lua Install');
    error();
end
BT_API.LoadTurtleAPI()


if #args ~= 2 then
    if term.isColor() then
        term.setTextColor(colors.red)
    end
    print("Usage: branches <branches> <branchlength>")
    term.setTextColor(colors.white)
    error()
end

-- constants
local BRANCHES = tonumber(args[1])
local BRANCH_LENGTH = tonumber(args[2])
local ROUTE_LENGTH = (BRANCH_LENGTH * 4 * BRANCHES) + (BRANCHES * 3)

if ROUTE_LENGTH > 1e5 then
    print('Route exceeds 100,000 blocks. Turtle may run out of fuel.')
    print('Are you sure you want to start this operation? (y/n)')

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
print('Fuels: ')
for _, v in pairs(BT_API.Turtle.fuelItems) do
    print('  ' .. v)
end
print('---------------')

local desiredItems = BT_API.ReadLinesIntoTable('whitelist')

print('Whitelisted Items:')
for _, v in pairs(desiredItems) do
    print('  ' .. v)
end
print('---------------')

local undesiredItems = BT_API.ReadLinesIntoTable('blacklist')

print('Blacklisted Items: ')
for _, v in pairs(undesiredItems) do
    print('  ' .. v)
end
print('---------------')

local fluids = BT_API.ReadLinesIntoTable('fluids')
print('Fluids: ')
for _, v in pairs(fluids) do
    print('  ' .. v)
end
print('---------------')

if turtle.getFuelLevel() < ROUTE_LENGTH then
    BT_API.Turtle.Refuel(ROUTE_LENGTH - turtle.getFuelLevel())
    -- if we still have less than needed
    if turtle.getFuelLevel() < ROUTE_LENGTH then
        local deficit = ROUTE_LENGTH - turtle.getFuelLevel()

        print('Not enough fuel for given route ' .. BRANCHES .. ' ' .. BRANCH_LENGTH)
        print('Need ' .. deficit .. ' more fuel')
        print('Start anyway? (y/n)')

        local answer = read()

        if (answer == 'n' or answer == 'N') then
            error('Operation was cancelled')
        end
    end
end

error('nope')

function StackItems()

    local partiallyStackedItems = BT_API.GetPartiallyStackedItems()
    if #partiallyStackedItems < 2 then
        -- we need at least 2 partially stacked items to move items between slots
        return
    end
    local previousSlot = turtle.getSelectedSlot()
    for psi = #partiallyStackedItems, 1, -1 do
        -- stack items
    end

end

local function Forward()
    if turtle.detect() then
        turtle.dig()
    end

    while not turtle.forward() do
        turtle.attack()
        turtle.dig()
    end

    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.45)
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
            for _, v in pairs(fluids) do
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
    if BT_API.isInvFull("slot") then
        BT_API.Refuel();
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