local this = {}

local Song = require("mer.bardicInspiration.Song")

function this.getSongs()
    local songs = {}
    local config = common.getConfig()
    for _, song in ipairs(config) do
        table.insert(songs, Song:new(song))
    end
    return songs
end

function this.showMenu()
    local common = require("mer.bardicInspiration.common")
    local messages = require("mer.bardicInspiration.messages")
    --delay a frame so it triggers outside menuMode
    timer.delayOneFrame(function()
        local buttons = {}
        --add songs
        for _, song in ipairs(this.getSongs()) do
            table.insert(buttons, { text = song.name, callback = function() song:perform() end })
        end
        --add cancel button
        table.insert(buttons, { text = tes3.findGMST(tes3.gmst.sCancel).value })

        common.messageBox({
            message = messages.whatToPlay,
            buttons = buttons
        })
    end)
end

function this.playRandom()
    table.choice(this.getSongs()):play()
end

return this