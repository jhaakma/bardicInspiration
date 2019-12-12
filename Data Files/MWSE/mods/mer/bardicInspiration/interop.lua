local Song = require("mer.bardicInspiration.Song")
local songList = require("mer.bardicInspiration.songList")

local this = {}

--[[
    Params:
    name:
        Name of the song
    path:
        path to sound file, relative to Data Files/Music
    buffId (optional):
        id of ability added when travel playing.
        Default: "mer_bard_inspiration"
    difficulty (optional):
        How hard the song is to play
        Default: 5
]]
function this.addSong(data)
    assert(data.name, "No song name provided")
    assert(data.path, "No path to sound file provided")
    table.insert(songList, Song:new(data))
end