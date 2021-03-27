local function initialized()
    if tes3.isModActive("BardicInspiration.esp") then
        --Deals with replacing vanilla lutes with playable ones
        require("mer.bardicInspiration.controllers.switchLutes")
        --Checks when the player readies a lute and triggers performances
        require("mer.bardicInspiration.controllers.checkReadiedLute")
        --Manage performance skill
        require("mer.bardicInspiration.controllers.skillController")
        require("mer.bardicInspiration.controllers.experienceController")
        --Manage Dialog entries
        require("mer.bardicInspiration.dialog.performanceDialog")
        require("mer.bardicInspiration.dialog.learnMusicDialog")
    end
end
event.register("initialized", initialized)


local function onLoad()
    mwse.log('adding topic "give a performance"')
    mwscript.addTopic{ topic = "give a performance"}
    mwse.log('adding topic "teach me a song"')
    mwscript.addTopic{ topic = "teach me a song"}
end
event.register("loaded", onLoad)
--MCM
require("mer.bardicInspiration.mcm")
