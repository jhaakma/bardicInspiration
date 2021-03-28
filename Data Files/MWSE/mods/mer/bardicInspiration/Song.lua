--[[
    An object representing a song that can be played on a lute.
    Includes functions for performing songs in a tavern or playing
    them to get a passive buff.
]]
local common = require("mer.bardicInspiration.common")
local animate = require("mer.bardicInspiration.controllers.animationController")
local tips = require("mer.bardicInspiration.controllers.tipsController")
local messages = require("mer.bardicInspiration.messages.messages")
local performances = require("mer.bardicInspiration.data.performances")

local Song = {
    buffId = "bardic_inspiration_self"
}
--Constructor
function Song:new(songData)
    assert(type(songData.name) == "string")
    assert(type(songData.path) == "string")
    assert(common.staticData.difficulties[songData.difficulty])
    setmetatable(songData, self)
    self.__index = self
    return songData
end

local function endPerformance()
    common.log:debug("Ending performance")
    common.restoreMusic()
    --unregister our events
    event.unregister("musicSelectTrack", endPerformance)
    timer.delayOneFrame(function()
        local song = common.data.isPlaying
        if not song then return end
        
        --Set status to played
        local currentPerformance = performances.getCurrent()
        if not currentPerformance then
            common.log:debug("Ended a performance when none was scheduled.")
            animate.stop()
        else
            common.log:debug("Ending performance, setting state to PLAYED")
            currentPerformance.state = performances.STATE.SKIP
            animate.stop()
            currentPerformance.state = performances.STATE.PLAYED
        end
        
        --Enable controls and congratulate player
        
        local tipsTotal = tips.getTotal()
        tips.stop()
        tes3.messageBox{ 
            message = string.format(messages.donePerforming,
                tipsTotal, currentPerformance.publicanName
            ), 
            buttons = { "Okay" } 
        }
        common.data.isPlaying = nil
    end)
end

function Song:getSkillIncrease()
    local skillLevel = common.skills.performance.value
    local experienceMulti = common.staticData.difficulties[self.difficulty].expMulti
    local minLevelMulti = common.staticData.skillLevelMultis.min
    local maxLevelMulti = common.staticData.skillLevelMultis.max

    local skillLevelMulti = math.clamp(math.remap(skillLevel, 0,100, minLevelMulti, maxLevelMulti),0,100)

    common.log:debug("experienceMulti: %s", experienceMulti)
    common.log:debug("skillLevelMulti: %s", skillLevelMulti)
    common.log:debug("performSkillProgress: %s", common.staticData.performSkillProgress)

    local progress = experienceMulti * skillLevelMulti * common.staticData.performSkillProgress
    common.log:debug("Song skill progress: %s", progress)
    return progress
end



--Perform at a tavern, earn gold
function Song:perform()
    animate.play()
    tips.start()
    common.data.currentSongDifficulty = self.difficulty
    common.data.isPlaying = true
    --tes3.fadeOut{ duration = 5 }
    --Start playing music
    common.playMusic{ path = self.path }
    
    --Ends performance when the song ends (and another track is selected):
    
    event.register("musicSelectTrack", endPerformance)
end

--Play while travelling, gives Inspiration buff
function Song:play()
    local endPlay
    local function checkCell(e)
        if e.cell.isInterior and not e.cell.behavesAsExterior then
            endPlay()
        end
    end
    endPlay = function()
        event.unregister( "musicSelectTrack", endPlay )
        event.unregister("equip", endPlay )
        event.unregister("cellChanged", checkCell)
        event.unregister("weaponUnreadied", endPlay )
        common.data.travelPlay = nil
        common.stopMusic()
        mwscript.removeSpell{ reference = tes3.player, spell = self.buffId }
        -- for actor in tes3.iterate(tes3.mobilePlayer.friendlyActors) do
        --     mwscript.removeSpell{ reference = actor, spell = self.buffId }
        -- end
    end
    common.log:debug("playing song at path %s", self.path)
    tes3.messageBox(messages.playingSong, self.name)
    common.playMusic{ path = self.path, crossfade = 0.2 }
    common.data.travelPlay = true
    mwscript.addSpell{ reference = tes3.player, spell = self.buffId }
    -- for actor in tes3.iterate(tes3.mobilePlayer.friendlyActors) do
    --     mwscript.addSpell{ reference = actor, spell = self.buffId }
    -- end
    event.register("musicSelectTrack", endPlay )
    event.register("equip", endPlay )
    event.register("cellChanged", checkCell)
    event.register("weaponUnreadied", endPlay )
end

local function clearOnLoad()
    event.unregister("musicSelectTrack", endPerformance )
    --Clear on load

    if common.data.isPlaying then
        endPerformance()
    end
end
event.register("BardicInspiration:DataLoaded", clearOnLoad)

return Song