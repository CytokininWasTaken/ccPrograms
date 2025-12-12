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
            setRedstoneState(false)
            sleep(1)
            setRedstoneState(true)
            return true
        end,
        preResponse = function(_) return "Sending you home :3" end,
    },
    ping = {
        onTrigger = function(cmdArgs)
            print("ponged")
            return true
        end,
        preResponse = function(_) return "Pong!" end,
    },
    checkPearl = {
        onTrigger = function(cmdArgs)
            return hasPearl()
        end,
        postResponse = function(pearl) return pearl and "Pearl is present" or "Pearl is not present" end,
    }
}

local function splitString(str)
    local words = {}
    for word in str:gmatch("%S+") do table.insert(words, word) end
    return words
end

local function processResponse(responseFunc, responseArgs)
    if not responseFunc then return end
    local response = responseFunc(responseArgs)
    if not response then return end
    sendBingusOSMessage(response)
end

local function tryRunCommand(commandArgs)
    local cmd = commands[commandArgs[1]]
    if not cmd then return false end
    processResponse(cmd.preResponse)
    local res = cmd.onTrigger(commandArgs)
    processResponse(cmd.postResponse, res)
    return true
end

setRedstoneState(true)

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
