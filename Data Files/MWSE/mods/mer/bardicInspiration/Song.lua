--[[
    An object representing a song that can be played on a lute.
    Includes functions for performing songs in a tavern or playing
    them to get a passive buff.
]]
local common = require("mer.bardicInspiration.common")
local Song = {
    buffId = "mer_bard_inspiration"
}
--Constructor
function Song:new(data)
    local t = data or {}
    setmetatable(t, self)
    self.__index = self
    return t
end

--Perform at a tavern, earn gold
function Song:perform()
    local goldTimer
    local function endPerformance()
        event.unregister("musicSelectTrack", endPerformance )
        if not tes3.mobilePlayer.vanityDisabled then
            tes3.runLegacyScript({command = "TVM"})
        end
        tes3.mobilePlayer.controlsDisabled = false
        tes3.mobilePlayer.mouseLookDisabled = false

        --Set cell lastPlayed to today
        local cellId = tes3.mobilePlayer.cell.id
        local data = common.getData()
        data.taverns[cellId] = data.taverns[cellId] or {}
        data.taverns[cellId].lastPlayed = tes3.worldController.day.value
    end

    --Vanity mode, disable controls
    if tes3.mobilePlayer.vanityDisabled then
        tes3.runLegacyScript({command = "TVM"})
    end
    tes3.mobilePlayer.controlsDisabled = true
    tes3.mobilePlayer.mouseLookDisabled = true

    --Start playing music
    tes3.streamMusic{ path = self.path, crossfade = 0.2 }
    event.register("musicSelectTrack", endPerformance )

    local duration

    -- goldTimer = timer.start{
    --     duration
    -- }
end

--Play while travelling, gives Inspiration buff
function Song:play()
    local function endPlay()
        event.unregister("musicSelectTrack", endPlay )
        mwscript.removeSpell{ reference = tes3.player, spell = self.buffId }
    end
    tes3.streamMusic{ path = self.path, crossfade = 0.2 }
    mwscript.addSpell{ reference = tes3.player, spell = self.buffId }
    event.register( "musicSelectTrack", endPlay )
end

return Song