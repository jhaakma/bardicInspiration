--[[
    This script finds all vanilla lutes the player may
    come across and converts them into playable lutes.
]]

local common = require("mer.bardicInspiration.common")

--In case the player has bought one from a merchant
local function switchLutesInInventory(from, to)
    timer.frame.delayOneFrame(function()
        tes3.removeItem{
            reference = tes3.player,
            item = from,
            playSound = false
        }
        tes3.addItem{
            reference = tes3.player,
            item = to,
            playSound = false
        }
    end)
end
local function onMenu()
    if mwscript.getItemCount{ reference = tes3.player, item = "misc_de_lute_01" } > 0 then
        switchLutesInInventory("misc_de_lute_01", "mer_lute")
    elseif mwscript.getItemCount{ reference = tes3.player, item = "misc_de_lute_01_phat" } > 0 then
        switchLutesInInventory("misc_de_lute_01_phat", "mer_lute_fat")
    end
end
event.register("menuEnter", onMenu)
event.register("menuExit", onMenu)


--[[
    Switch node to ground mesh so it sits on the ground properly
]]
local function switchLuteNode(lute, isEquipped)
    local switchNode = lute.sceneNode:getObjectByName("SWITCH_LUTE")
    switchNode.switchIndex = isEquipped and 0 or 1
end

--[[
    Remove a vanilla lute from the ground and replace it with a new one
]]
local function replaceLute(reference)
    if reference.disabled == true then return end
    local id = reference.baseObject.id
    if common.idMapping[id] then
        timer.delayOneFrame(function()
            tes3.createReference{
                object = common.idMapping[id],
                position = reference.position,
                orientation = reference.orientation,
                cell = reference.cell
            }
            mwscript.disable({ reference = reference})
        end)
    end
end

--[[
    Check for a vanilla lute placed in the world and switch it
]]
local function switchPlacedLute(e)
    if e.reference then
        local id = e.reference.baseObject.id

        if common.idMapping[id] then
            replaceLute(e.reference)
        end
        if  common.lutes[id] then
            switchLuteNode(e.reference)
        end
    end
end
event.register("referenceSceneNodeCreated", switchPlacedLute)

--[[
    referenceSceneNodeCreated isn't triggered on load, so 
    iterate references manually
]]
local function checkLoadedLutes()
    for ref in tes3.getPlayerCell():iterateReferences(tes3.objectType.miscItem) do
        if common.idMapping[ref.baseObject.id] then
            replaceLute(ref)
        end
    end
end
event.register("loaded", checkLoadedLutes)