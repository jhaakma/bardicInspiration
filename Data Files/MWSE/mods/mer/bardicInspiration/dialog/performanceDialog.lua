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
    common.log:trace("---infoGetReward - reward and reset")
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
        common.log:trace("passes, setting performance data")
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
        -- If there is a bard in the cell, the publican will point them out to you.
        for ref in tes3.player.cell:iterateReferences(tes3.objectType.npc) do
            if ref.object.class.id == "Bard" and not ref.disabled then
                local message = ref.object.female 
                    and messages.dialog_NoSongsBardFemale 
                    or messages.dialog_NoSongsBardMale 
                e.text = string.format(message, ref.object.name)
            end
        end
    end
end
event.register("infoGetText", showNoSongs, { filter = tes3.getDialogueInfo(infos.noSongs) } )


local function infoGetReward(e)
    if e.passes ~= false then
        common.log:trace("---infoGetReward - reward and reset")
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
    common.log:trace("---filterHasPlayed")

    local thisPerformance = performances.getCurrent()
    if not thisPerformance then
        common.log:trace("No performance here, blocking")
        e.passes = false
        return
    end
    local hasPlayedAlready = thisPerformance.state == STATE.PLAYED
    if not hasPlayedAlready then
        common.log:trace("Hasn't played yet, blocking")
        e.passes = false     
    end
end
event.register("infoFilter", filterHasPlayed, { filter = tes3.getDialogueInfo(infos.hasPlayed) })

local function filterhasAccepted(e)
    common.log:trace("---filterhasAccepted")
    local thisPerformance = performances.getCurrent()

    local isScheduled = thisPerformance and thisPerformance.state == STATE.SCHEDULED
    if not isScheduled then
        common.log:trace("State is not scheduled, blocking event")
        e.passes = false
        return
    end

    local isToday = thisPerformance and thisPerformance.day == tes3.worldController.daysPassed.value
    if not isToday then
        common.log:trace("Performance is not today, blocking event")
        e.passes = false
        return
    end
end
event.register("infoFilter", filterhasAccepted, { filter = tes3.getDialogueInfo(infos.hasAccepted) })


local function filterDescribeGig(e)
    common.log:trace("---filterDescribeGig")
    reward.calculate(e.reference.object)
    currentPublican = e.reference.object
end
event.register("infoFilter", filterDescribeGig, { filter = tes3.getDialogueInfo(infos.describeGig)})


local function filterAskToPerform(e)
    common.log:trace("---filterAskToPerform")
    if #common.data.knownSongs == 0 or not common.hasLute() then 
        common.log:trace("No lute, blocking")
        e.passes = false 
    end
end
event.register("infoFilter", filterAskToPerform, { filter = tes3.getDialogueInfo(infos.askToPerform)})

local function filterTooLate(e)
    common.log:trace("---filterTooLate")
    if #common.data.knownSongs == 0 or not common.hasLute() then 
        common.log:trace("No lute or songs, blocking")
        e.passes = false 
    end
end
event.register("infoFilter", filterTooLate, { filter = tes3.getDialogueInfo(infos.tooLate)})

local function filterNoLute(e)
    common.log:trace("---filterNoLute")
    if common.hasLute() then 
        common.log:trace("No lute, blocking")
        e.passes = false 
    end
end
event.register("infoFilter", filterNoLute, { filter = tes3.getDialogueInfo(infos.noLute)})


