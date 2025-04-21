local common = require("mer.bardicInspiration.common")
local messages = require("mer.bardicInspiration.messages.messages")
local Publican = require("mer.bardicInspiration.data.publican")
---@class BardicInspiration.JournalController
local Journal = {}

local function getTavernName(cell)
    --Turn "Balmora, Lucky Lockup" into "Lucky Lockup"
    local cellName = cell.name
    local commaIndex = string.find(cellName, ",")
    if commaIndex then
        cellName = string.sub(cellName, commaIndex + 2)
    end
    return cellName
end



function Journal.completedGig(tipsAmount)
    local currentPublican = Publican.get()
    if not currentPublican then
        common.log:warn("No current publican, blocking")
        return
    else
        local publican = currentPublican.object.name
        local tavern = getTavernName(currentPublican.cell)
        tes3.addJournalEntry{
            text = string.format(messages.journal_completedGig,
                tipsAmount, publican, tavern),
        }
    end
end

function Journal.gotPaid(amount)
    local currentPublican = Publican.get()
    if not currentPublican then
        common.log:warn("No current publican, blocking")
        return
    end
    local tavern = getTavernName(currentPublican.cell)

    tes3.addJournalEntry{
        text = string.format(messages.journal_gotPaid,
            amount, tavern),
    }
end


function Journal.scheduleGig()
    local currentPublican = Publican.get()
    if not currentPublican then
        common.log:warn("No current publican, blocking")
        return
    end
    tes3.addJournalEntry{
        text = string.format(messages.journal_acceptedGig, getTavernName(currentPublican.cell)),
    }
end

return Journal