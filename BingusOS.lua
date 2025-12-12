local chatBox = peripheral.wrap("top")
local playerDetector = peripheral.wrap("right")

local user = "Cytokinin"

local function sendBingusOSMessage(message, emergency)
    local prefix = emergency and "&c" or "&a"
    local osName = emergency and "BingusOS:Emergency" or "BingusOS"
    chatBox.sendMessageToPlayer(message, user, prefix .. osName, "{}", prefix)
end

local function setRedstoneState(state)
    redstone.setOutput("back", state)
end

local function hasPearl()
    return redstone.getInput("left")
end

local commands = {
    home = {
        onTrigger = function(cmdArgs)
            local pearl = hasPearl()
            if pearl then
                sendBingusOSMessage("Sending you home :3")
                setRedstoneState(true)
                sleep(2)
                setRedstoneState(false)
            else
                sendBingusOSMessage("No pearl in stasis chamber.")
                return false
            end
            return true
        end,
    },
    ping = {
        onTrigger = function(cmdArgs)
            sendBingusOSMessage("Pong!")
            return true
        end,
    },
    checkPearl = {
        onTrigger = function(cmdArgs)
            local pearl = hasPearl()
            sendBingusOSMessage(pearl and "Pearl is present" or "Pearl is not present")
            return pearl
        end,
    }
}

local function splitString(str)
    local words = {}
    for word in str:gmatch("%S+") do table.insert(words, word) end
    return words
end

local function tryRunCommand(commandArgs)
    local cmd = commands[commandArgs[1]]
    if not cmd then return false end
    local res = cmd.onTrigger(commandArgs)
    return true
end

setRedstoneState(false)

local function listenForCommands()
    repeat
        local success = false
        local event, username, message, uuid, isHidden, messageUtf8 = os.pullEvent("chat")
        if isHidden and username == user then
            local messageArgs = splitString(message)
            success = tryRunCommand(messageArgs)
        end
    until success
end
local function mainLoop()
    while true do
        listenForCommands()
    end
end

print("hi :3")
mainLoop()
