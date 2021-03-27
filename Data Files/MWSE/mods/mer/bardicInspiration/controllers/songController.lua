local this = {}
local Song = require("mer.bardicInspiration.Song")
local common = require("mer.bardicInspiration.common")
local messages = require("mer.bardicInspiration.messages.messages")

function this.showMenu()
    --delay a frame so it triggers outside menuMode
    timer.delayOneFrame(function()
        local buttons = {}
        --add songs
        for _, song in ipairs(this.getKnownSongs()) do
            local text = string.format("%s (%s)", song.name, messages["difficulty_" .. song.difficulty] )
            table.insert(buttons, { text = text, callback = function() 
                common.log:debug("Performing: %s", song.name)
                song:perform() 
            end })
        end
        --add cancel button
        table.insert(buttons, { text = tes3.findGMST(tes3.gmst.sCancel).value })

        common.messageBox({
            message = messages.whatToPlay,
            buttons = buttons
        })
    end)
end

function this.getKnownSongs()
    if not tes3.player then return end
    common.log:debug("getKnownSongs()")
    local songs = {}
    for _, songData in ipairs(common.data.knownSongs) do
        common.log:debug("getting song %s", songData.name)
        if lfs.attributes("Data Files/Music/" .. songData.path) then
            table.insert(songs, Song:new(songData))
        else
            common.log:debug("Cannot find 'Music/%s'", songData.path)
        end
    end    
    return songs
end

function this.learnSong(songData)
    assert(type(songData.name) == "string")
    assert(type(songData.path) == "string")
    assert(common.staticData.difficulties[songData.difficulty])
    table.insert(common.data.knownSongs, songData)
end

function this.playRandom()
    common.log:debug("playRandom()")
    local knownSongs = this.getKnownSongs()
    if #knownSongs == 0 then
        tes3.messageBox(messages.noSongsKnown)
    else
        local song = table.choice(knownSongs)
        common.log:debug("Playing random song %s", song.name)
        song:play()
    end
end


-- event.register("loaded", function()
--     common.data.knownSongs = common.data.knownSongs or {}
--     local name = "Silence"
--     this.learnSong{   
--         name = name,
--         path = "mer_bard/silence.mp3",
--         difficulty = "beginner",
--     }
--     tes3.messageBox("You learned \"%s\"", name)
--     name = "Full Song"
--     this.learnSong{   
--         name = name,
--         path = "mer_bard/beg/4.mp3",
--         difficulty = "beginner",
--     }
--     tes3.messageBox("You learned \"%s\"", name)
-- end)

return this