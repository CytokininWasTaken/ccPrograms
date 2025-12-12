local url = "https://raw.githubusercontent.com/CytokininWasTaken/ccPrograms/refs/heads/main/BingusOS.lua"
local function writeFile(programUrl)
    shell.run("delete", "startup/BingusOS.lua")
    shell.run("wget", programUrl, "startup/BingusOS.lua")
end
writeFile(url)
