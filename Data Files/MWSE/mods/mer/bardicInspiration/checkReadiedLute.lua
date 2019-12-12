--[[
    Checks whether the player has readied a lute under
    the right conditions, and triggers a performance,
    or else shows a message saying which conditions aren't met.
]]
local common = require("mer.bardicInspiration.common")
local messages = require("mer.bardicInspiration.messages")
local songController = require("mer.bardicInspiration.songController")

local function isLute(item)
    return common.idSet[item.id] == true
end

local function isPlayer(ref)
    return ref == tes3.player
end

local function inTavern()
    return common.getConfig().taverns[tes3.mobilePlayer.cell.id]
end

local function isIndoors()
    return tes3.mobilePlayer.cell.isInterior
end

local function isNight()
    local startHour = 20
    local gameHour = tes3.worldController.hour.value
    return gameHour > startHour
end

local function alreadyPlayed()
    local cellId = tes3.mobilePlayer.cell.id
    local today = tes3.worldController.day.value
    local tavern = common.getData().taverns[cellId]
    if tavern and tavern.lastPlayed then
        return today == tavern.lastPlayed
    else
        return false
    end
end

local function weaponReadied(e)
    local weapon = e.weaponStack.object
    if isLute(weapon) and isPlayer(e.reference) then
        if isIndoors() then
            if inTavern() then
                if isNight() then
                    if not alreadyPlayed() then
                        --Tavern performance
                        songController.showMenu()
                    else
                        tes3.messageBox(messages.alreadyPlayed)
                    end
                else
                    tes3.messageBox(messages.notNightTime)
                end
            else
                tes3.messageBox(messages.notTavern)
            end
        else
            --Outdoor performance
            songController.playRandom()
        end
    end
end

event.register("weaponReadied", weaponReadied)