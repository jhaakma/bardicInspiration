local function initialized()
    if tes3.isModActive("BardicInspiration.esp") then
        --Deals with replacing vanilla lutes with playable ones
        require("mer.bardicInspiration.switchLutes")
        --Checks when the player readies a lute and triggers performances
        require("mer.bardicInspiration.checkReadiedLute")
        --Manage performance skill
        require("mer.bardicInspiration.skillController")
    end
end
event.register("initialized", initialized)