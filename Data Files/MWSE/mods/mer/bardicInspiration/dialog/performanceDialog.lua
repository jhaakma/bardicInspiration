local common = require("mer.bardicInspiration.common")
local reward = require("mer.bardicInspiration.controllers.rewardController")
local performances = require("mer.bardicInspiration.data.performances")
local messages = require("mer.bardicInspiration.messages.messages")
--Configs--------------------------------------------------------
local STATE = performances.STATE
local infos = common.staticData.dialogueEntries
--Dialog event handlers-----------------------------------

--INFOS---------------------

local function infoGetReward(e)
    common.log:debug("---infoGetReward - reward and reset")
    local thisPerformance = performances.getCurrent()
    local amount = thisPerformance.reward
    reward.give(amount)
    reward.raiseDisposition{ actorId = thisPerformance.publicanId, rewardAmount = amount }
    performances.clearCurrent()
end
event.register("infoGetText", infoGetReward, {filter = tes3.getDialogueInfo(infos.hasPlayed) })


local currentPublican
local function showDoAccept(e)--Schedule a performance
    if e.passes ~= false then
        common.log:debug("passes, setting performance data")
        performances.add{ 
            day = tes3.worldController.daysPassed.value, 
            state = STATE.SCHEDULED,
            reward = reward.get(),
            publicanId = currentPublican.id,
            publicanName = currentPublican.name,
        }
    end
end
event.register("infoGetText", showDoAccept, { filter = tes3.getDialogueInfo(infos.doAccept) } )

local function showNoSongs(e)
    if e.passes ~= false then
        for ref in tes3.player.cell:iterateReferences(tes3.objectType.npc) do
            if ref.object.class.id == "Bard" then
                e.text = string.format(
                    messages.dialog_NoSongsBard,
                    ref.object.name,
                    ( ref.object.female and messages.she or messages.he ),
                    ( ref.object.female and messages.her or messages.him )
                )
            end
        end
    end
end
event.register("infoGetText", showNoSongs, { filter = tes3.getDialogueInfo(infos.noSongs) } )


local function infoGetReward(e)
    if e.passes ~= false then
        common.log:debug("---infoGetReward - reward and reset")
        local thisPerformance = performances.getCurrent()
        if not thisPerformance then return end
        local amount = thisPerformance.reward
        reward.give(amount)
        reward.raiseDisposition{ actorId = thisPerformance.publicanId, rewardAmount = amount }
        performances.clearCurrent()
    end
end
event.register("infoGetText", infoGetReward, {filter = tes3.getDialogueInfo(infos.hasPlayed) })


---FILTERS-----------------

local function filterHasPlayed(e)--"Thanks for playing! Here's your payment"
    common.log:debug("---filterHasPlayed")

    local thisPerformance = performances.getCurrent()
    if not thisPerformance then
        common.log:debug("No performance here, blocking")
        e.passes = false
        return
    end
    local hasPlayedAlready = thisPerformance.state == STATE.PLAYED
    if not hasPlayedAlready then
        common.log:debug("Hasn't played yet, blocking")
        e.passes = false     
    end
end
event.register("infoFilter", filterHasPlayed, { filter = tes3.getDialogueInfo(infos.hasPlayed) })

local function filterhasAccepted(e)
    common.log:debug("---filterhasAccepted")
    local thisPerformance = performances.getCurrent()

    local isScheduled = thisPerformance and thisPerformance.state == STATE.SCHEDULED
    if not isScheduled then
        common.log:debug("State is not scheduled, blocking event")
        e.passes = false
        return
    end

    local isToday = thisPerformance and thisPerformance.day == tes3.worldController.daysPassed.value
    if not isToday then
        common.log:debug("Performance is not today, blocking event")
        e.passes = false
        return
    end
end
event.register("infoFilter", filterhasAccepted, { filter = tes3.getDialogueInfo(infos.hasAccepted) })


local function filterDescribeGig(e)
    common.log:debug("---filterDescribeGig")
    reward.calculate(e.reference.object)
    currentPublican = e.reference.object
end
event.register("infoFilter", filterDescribeGig, { filter = tes3.getDialogueInfo(infos.describeGig)})


local function filterAskToPerform(e)
    common.log:debug("---filterAskToPerform")
    if #common.data.knownSongs == 0 or not common.hasLute() then 
        common.log:debug("No lute, blocking")
        e.passes = false 
    end
end
event.register("infoFilter", filterAskToPerform, { filter = tes3.getDialogueInfo(infos.askToPerform)})

local function filterTooLate(e)
    common.log:debug("---filterTooLate")
    if #common.data.knownSongs == 0 or not common.hasLute() then 
        common.log:debug("No lute or songs, blocking")
        e.passes = false 
    end
end
event.register("infoFilter", filterTooLate, { filter = tes3.getDialogueInfo(infos.tooLate)})

local function filterNoLute(e)
    common.log:debug("---filterNoLute")
    if common.hasLute() then 
        common.log:debug("No lute, blocking")
        e.passes = false 
    end
end
event.register("infoFilter", filterNoLute, { filter = tes3.getDialogueInfo(infos.noLute)})


--Clear on load
local function onLoad()
    local data = common.data
    if data.isPlaying then
        common.log:debug("Resetting controls from previous load")
        tes3.setVanityMode({ enabled = false })
        common.enableControls()
        data.isPlaying = nil
    end
end
event.register("loaded", onLoad)