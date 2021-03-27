local common = require("mer.bardicInspiration.common")
local songList = require("mer.bardicInspiration.data.songList")
local infos = common.staticData.dialogueEntries
local messages = require("mer.bardicInspiration.messages.messages")
local songController = require("mer.bardicInspiration.controllers.songController")
local currentBard

--Helpers

local function getHoursPassed()
    return ( tes3.worldController.daysPassed.value * 24 ) + tes3.worldController.hour.value
end

local function knowsSong(song)
    for _, knownSong in ipairs(common.data.knownSongs) do
        if song.name == knownSong.name then 
            return true
        end
    end
    return false
end

local function hasSkillsToLearn(song)
    local minSkill = common.staticData.difficulties[song.difficulty].minSkill
    local playerSkill = common.skills.performance.value
    local isSkilledEnough = playerSkill >= minSkill
    return isSkilledEnough
end

local function canLearnSong(song)
    return song
        and hasSkillsToLearn(song)
        and not knowsSong(song)
end



--[[ 
    Add a random set of songs from each difficulty to a bard's repertiore
]]
local function addSongsToBard(bard)
    common.log:debug("Adding songs to %s", bard.object.name)
    local data = bard.data.mer_bardicInspiration
    for difficulty, diffConf in pairs(common.staticData.difficulties) do
        local shuffledSongs = common.shuffle(table.copy(songList[difficulty]))
        for _ = 1, diffConf.songsPerBard do
            if #shuffledSongs > 0 then
                local song = table.remove(shuffledSongs)
                table.insert(data.songs, song)
                common.log:debug("Added %s song: %s", difficulty, song.name)
            end
        end
    end
end

local function isBard(ref)
    return ref.object
        and ref.object.class
        and ref.object.class.id == "Bard"
end

--[[
    Initialise the data on a bard reference
]]
local function initBardData(bard)
    bard.data.mer_bardicInspiration = bard.data.mer_bardicInspiration or {
        songs = {},
    }
    if #bard.data.mer_bardicInspiration.songs == 0 then
        addSongsToBard(bard)
    end
end

--[[
    metafunctions for accessing data on bard reference
]]
local function getBardData(bard)
    if not isBard(bard) then return end
    local data = setmetatable({}, {
        __index = function(_, key)
            if bard then
                initBardData(bard)
                return bard.data.mer_bardicInspiration[key]
            end
        end,
        __newindex = function(_, key, value)
            if bard then
                initBardData(bard)
                bard.data.mer_bardicInspiration[key] = value
            end
        end
    })
    return data
end

local function bardReadyToTeach(bard)
    local now = getHoursPassed()
    local data = getBardData(bard)
    if data then
        local timeLastTaughtHour = data.timeLastTaughtHour or -1000
        local interval = common.staticData.bardTeachIntervalHours

        return timeLastTaughtHour + interval < now
    end
end


local function getSongFromBard(bard)
    if not bard then return end
    local bardData = getBardData(bard)

    if canLearnSong(bardData.currentSong) then
        return bardData.currentSong
    else
        --sort from most to least difficult
        common.sortSongListByDifficulty{list = bardData.songs, reverse = true}
        for _, song in ipairs(bardData.songs) do
            if canLearnSong(song) then
                common.log:debug("Bard will now teach %s", song.name)
                bardData.currentSong = song
                break
            end
        end
        return bardData.currentSong
    end
end

--Infos
local function infoTeachConfirm(e)
    if e.passes ~= false then
        timer.delayOneFrame(function()
            local song = getSongFromBard(currentBard)
            if song then
                tes3.streamMusic{ path = song.path, crossfade = 0.1}
                common.fadeTimeOut{
                    hoursPassed = 0.25,
                    secondsTaken = 10,
                    callback = function()
                        common.stopMusic{crossfade = 2.0}
                        tes3.messageBox{
                            message = string.format(messages.learnedSong, song.name),
                            buttons = { tes3.findGMST(tes3.gmst.sOK).value }
                        }
                        getBardData(currentBard).timeLastTaughtHour = getHoursPassed()
                        songController.learnSong(song)
                    end
                }
            end
        end)
    end
end
event.register("infoGetText", infoTeachConfirm, {filter = tes3.getDialogueInfo(infos.teachConfirm) })

local function infoTeachChoice(e)
    if e.passes ~= false then
        local songToLearn = getSongFromBard(currentBard)
        if songToLearn then
            e.text = string.format(messages.dialog_teachChoice, songToLearn.name)
        else
            common.log:debug("infoTeachChoice(): No song to learn")
        end
    end
end
event.register("infoGetText", infoTeachChoice, {filter = tes3.getDialogueInfo(infos.teachChoice) })



--Filters
local function filterNoTeachMustWait(e)
    if not isBard(e.reference) then return end
    common.log:debug("---filterNoTeachMustWait")
    currentBard = e.reference
    if bardReadyToTeach(currentBard) then
        e.passes = false
    end
end
event.register("infoFilter", filterNoTeachMustWait, { filter = tes3.getDialogueInfo(infos.noTeachMustWait)})


local function filterTeachChoice(e)
    if not isBard(e.reference) then return end
    common.log:debug("---filterTeachChoice")
    currentBard = e.reference
    local songToLearn = getSongFromBard(currentBard)
    if songToLearn and hasSkillsToLearn(songToLearn) and not knowsSong(songToLearn) then
        --passes based on vanilla filters
    else -- 
        e.passes = false
    end
end
event.register("infoFilter", filterTeachChoice, { filter = tes3.getDialogueInfo(infos.teachChoice)})


local function filterNoTeachLowSkill(e)
    if not isBard(e.reference) then return end
    common.log:debug("---filterNoTeachLowSkill")
    currentBard = e.reference
    local songToLearn = getSongFromBard(currentBard)
    if songToLearn then
        --passes based on vanilla filters
    else -- 
        e.passes = false
    end
end
event.register("infoFilter", filterNoTeachLowSkill, { filter = tes3.getDialogueInfo(infos.noTeachLowSkill)})
