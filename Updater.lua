local url = "https://raw.githubusercontent.com/CytokininWasTaken/ccPrograms/refs/heads/main/BingusOS.lua"
local function writeFile(programUrl)
    shell.execute("delete", "startup/BingusOS.lua")
    shell.execute("wget", programUrl)
end
