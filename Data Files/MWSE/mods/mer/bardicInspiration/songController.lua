local this = {}
local songList = require("mer.bardicInspiration.songList")

function this.showMenu()
    local common = require("mer.bardicInspiration.common")
    local messages = require("mer.bardicInspiration.messages.messages")
    --delay a frame so it triggers outside menuMode
    timer.delayOneFrame(function()
        local buttons = {}
        --add songs
        for _, song in ipairs(songList) do
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
    table.choice(songList:play())
end

return this