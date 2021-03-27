local this = {}
local common = require("mer.bardicInspiration.common")

local mesh = "mer_bard\\anim\\Bard.nif"
local group = tes3.animationGroup.idle2

local function onTabDown()
    tes3.mobilePlayer.controlsDisabled = false
    tes3.setVanityMode({ enabled = false })
end

local function onTabUp()
    tes3.mobilePlayer.controlsDisabled = true
    tes3.setVanityMode({ enabled = true })
end


local function attachPlayLute(e)
    e = e or {}
    local shieldBone = tes3.player.sceneNode:getObjectByName("Bip01 L Hand")
    if not e.remove then
        local luteMesh = tes3.loadMesh("mer_bard/mer_lute_play.nif"):clone()
        shieldBone:attachChild(luteMesh, true)
    else
        local luteMesh = shieldBone:getObjectByName("LUTE_PLAY")
        shieldBone:detachChild(luteMesh)
    end
end

function this.play()
    --Vanity mode, disable controls
    tes3.setVanityMode({ enabled = true })
    common.disableControls()
    if mesh then
        common.data.previousAnimationMesh = tes3.player.object.mesh
        common.data.heldLute = tes3.getEquippedItem{ actor = tes3.player, objectType = tes3.objectType.weapon}.object.id
        common.log:debug("Held lute: %s", common.data.heldLute)
        tes3.playAnimation({
            reference = tes3.player,
            mesh = mesh,
            group = group,
            startFlag = 1
        })
        tes3.mobilePlayer:unequip{ type = tes3.objectType.weapon}
        attachPlayLute()
    end
    event.register("keyUp", onTabUp, { filter = tes3.getInputBinding(tes3.keybind.togglePOV).code })
    event.register("keyDown", onTabDown, { filter = tes3.getInputBinding(tes3.keybind.togglePOV).code })
end

function this.stop()
    if mesh and common.data.previousAnimationMesh then
        tes3.playAnimation({
            reference = tes3.player,
            mesh = common.data.previousAnimationMesh,
            group = tes3.animationGroup.idle,
            startFlag = 1
        })
        common.data.previousAnimationMesh = nil
        common.log:debug("Held lute2: %s", common.data.heldLute)
        
        attachPlayLute{remove = true}
        mwscript.equip{ reference = tes3.player, item = common.data.heldLute }
        common.data.heldLute = nil

    end
    tes3.setVanityMode({ enabled = false })
    common.enableControls()
    event.unregister("keyUp", onTabUp, { filter = tes3.getInputBinding(tes3.keybind.togglePOV).code })
    event.unregister("keyDown", onTabDown, { filter = tes3.getInputBinding(tes3.keybind.togglePOV).code })
end

local function clearEventsOnLoad()
    event.unregister("keyUp", onTabUp, { filter = tes3.getInputBinding(tes3.keybind.togglePOV).code })
    event.unregister("keyDown", onTabDown, { filter = tes3.getInputBinding(tes3.keybind.togglePOV).code })
end
event.register("loaded", clearEventsOnLoad)

return this