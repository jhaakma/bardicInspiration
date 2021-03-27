
local this = {}

this.staticData = require("mer.bardicInspiration.data.staticData")
this.modName = this.staticData.modName
this.skills = require("mer.bardicInspiration.controllers.skillController").skills


do --mcm config
    local inMemConfig
    this.defaultConfig = require("mer.bardicInspiration.data.defaultConfig")
    this.config = setmetatable({
        save = function(newConfig)
            inMemConfig = newConfig
            mwse.saveConfig(this.staticData.configPath, inMemConfig)
        end
    }, {
        __index = function(_, key)
                inMemConfig = inMemConfig or mwse.loadConfig(this.staticData.configPath, this.defaultConfig)
            return inMemConfig[key]
        end,
        __newindex = function(_, key, value)
            inMemConfig = inMemConfig or mwse.loadConfig(this.staticData.configPath, this.defaultConfig)
            inMemConfig[key] = value
            mwse.saveConfig(this.staticData.configPath, inMemConfig)
        end
    })
end

do --save data
    local function initPlayerData()
        tes3.player.data.mer_bardicInspiration = tes3.player.data.mer_bardicInspiration or {}
        for k, v in ipairs(this.staticData.initPlayerData) do
            tes3.player.data.mer_bardicInspiration[k] = tes3.player.data.mer_bardicInspiration[k] or v
        end
    end
    this.data = setmetatable({}, {
        __index = function(_, key)
            if tes3.player then
                initPlayerData()
                return tes3.player.data.mer_bardicInspiration[key]
            end
        end,
        __newindex = function(_, key, value)
            if tes3.player then
                initPlayerData()
                tes3.player.data.mer_bardicInspiration[key] = value
            end
        end
    })
end

local logLevel = this.config.logLevel
this.log = require("mer.bardicInspiration.logger").new{
    name = "Bardic Inspiration",
    --outputFile = "Ashfall.log",
    logLevel = logLevel
}


local messageBoxId = tes3ui.registerID("CustomMessageBox")
function this.messageBox(params)
    --[[
        button = 
    ]]--
    local message = params.message
    local buttons = params.buttons
    local sideBySide = params.sideBySide

    local menu = tes3ui.createMenu{ id = messageBoxId, fixedFrame = true }
    menu:getContentElement().childAlignX = 0.5
    tes3ui.enterMenuMode(messageBoxId)
    local title = menu:createLabel{id = tes3ui.registerID("BardicInspiration:MessageBox_Title"), text = message}

    local buttonsBlock = menu:createBlock()
    buttonsBlock.borderTop = 4
    buttonsBlock.autoHeight = true
    buttonsBlock.autoWidth = true
    if sideBySide then
        buttonsBlock.flowDirection = "left_to_right"
    else
        buttonsBlock.flowDirection = "top_to_bottom"
        buttonsBlock.childAlignX = 0.5
    end 
    for i, data in ipairs(buttons) do
        local doAddButton = true
        if data.showRequirements then
            if data.showRequirements() ~= true then
                doAddButton = false
            end
        end
        if doAddButton then
            --If last button is a Cancel (no callback), register it for Right Click Menu Exit
            local buttonId = tes3ui.registerID("CustomMessageBox_Button")
            if data.doesCancel then
                buttonId = tes3ui.registerID("CustomMessageBox_CancelButton")
            end

            local button = buttonsBlock:createButton{ id = buttonId, text = data.text}

            local disabled = false
            if data.requirements then
                if data.requirements() ~= true then
                    disabled = true
                end
            end

            if disabled then
                button.widget.state = 2
            else
                button:register( "mouseClick", function()
                    if data.callback then
                        data.callback()
                    end
                    tes3ui.leaveMenuMode()
                    menu:destroy()
                end)
            end

            if not disabled and data.tooltip then
                button:register( "help", function()
                    this.createTooltip(data.tooltip)
                end)
            elseif disabled and data.tooltipDisabled then
                button:register( "help", function()
                    this.createTooltip(data.tooltipDisabled)
                end)
            end
        end
    end
end

function this.shuffle(tbl)
    for i = #tbl, 2, -1 do
        local j = math.random(i)
        tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
end

function this.sortSongListByDifficulty(e)
    table.sort(e.list, function(songA, songB)
        local sorter = {
            beginner = 1,
            intermediate = 2,
            advanced = 3
        }
        if e.reverse then
            return sorter[songA.difficulty]>sorter[songB.difficulty]
        else
            return sorter[songA.difficulty]<sorter[songB.difficulty]
        end
    end)
end

local function setControlsDisabled(state)
    tes3.mobilePlayer.controlsDisabled = state
    tes3.mobilePlayer.jumpingDisabled = state
    tes3.mobilePlayer.attackDisabled = state
    tes3.mobilePlayer.magicDisabled = state
    tes3.mobilePlayer.mouseLookDisabled = state
end
function this.disableControls()
    setControlsDisabled(true)
end
function this.enableControls()
    setControlsDisabled(false)
    tes3.runLegacyScript{command = "EnableInventoryMenu"}
end

function this.hasLute()
    for id in pairs(this.staticData.lutes) do
        if tes3.player.object.inventory:contains(id) then
            return true
        end
    end
    return false
end

function this.stopMusic(e)
    e = e or {}
    tes3.streamMusic{ path = "mer_bard/silence.mp3", crossfade = e.crossfade}
end

--Fades out, passes time then runs callback when finished
function this.fadeTimeOut(e)
    local function fadeTimeIn()
        tes3.runLegacyScript({command = 'EnablePlayerControls'})
        e.callback()
    end

    tes3.fadeOut({duration = 0.5})
    tes3.runLegacyScript({command = 'DisablePlayerControls'})
    --Halfway through, advance gamehour
    local iterations = 10
    timer.start(
        {
            type = timer.real,
            iterations = iterations,
            duration = (e.secondsTaken / iterations),
            callback = (function()
                local gameHour = tes3.findGlobal('gameHour')
                gameHour.value = gameHour.value + (e.hoursPassed / iterations)
            end)
        }
    )
    --All the way through, fade back in
    timer.start(
        {
            type = timer.real,
            iterations = 1,
            duration = e.secondsTaken,
            callback = (function()
                local fadeBackTime = 1
                tes3.fadeIn({duration = fadeBackTime})
                timer.start(
                    {
                        type = timer.real,
                        iterations = 1,
                        duration = fadeBackTime,
                        callback = fadeTimeIn
                    }
                )
            end)
        }
    )
end

return this