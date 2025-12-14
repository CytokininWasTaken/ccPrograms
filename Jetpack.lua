--local emptyStorageSlot = settings.get("emptyStorageSlot")
--local filledStorageSlot = settings.get("filledStorageSlot")

--local emptyStorage = peripheral.wrap("minecraft:barrel_" .. emptyStorageSlot)
--local filledStorage = peripheral.wrap("minecraft:barrel_" .. filledStorageSlot)

local tankMode = settings.get("tankMode")
local tankMinimum = settings.get("tankMinimum") or 0
local sleepTime = settings.get("sleepTime") or 1

local inventoryManager = peripheral.wrap("back")
local chatBox = peripheral.wrap("right")

print(inventoryManager)

local function getPlayerTank()
    for k, v in pairs(inventoryManager.getArmor()) do
        if v.slot == 102 then return v end
    end
    return nil
end

local function shouldSwapTank(tank)
    if not tank then return false end
    return tank.components["create:banktank_air"] <= tankMinimum
end

local function takePlayerTank()
    inventoryManager.removeItemFromPlayer(
        "left",
        { fromSlot = 102 }
    )
end

local function putPlayerTank()
    inventoryManager.addItemToPlayer(
        "top",
        { toSlot = 102 }
    )
end

local function notifySwap()
    chatBox.sendToastToPlayer(
        "Tank Swapped!",
        "Backtank Swapper",
        inventoryManager.getOwner()
    )
end
local function mainLoop()
    while true do
        local tank = getPlayerTank()
        if shouldSwapTank(tank) then
            print("Should swap tank")
            takePlayerTank()
            putPlayerTank()
            notifySwap()
        end
        os.sleep(sleepTime)
    end
end

mainLoop()
