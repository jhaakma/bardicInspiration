local skillController = require("mer.bardicInspiration.skillController")
local this = {}

this.skills = skillController.skills

this.lutes = {
    ["mer_lute"] = true,
    ["mer_lute_fat"] = true,
}

this.idMapping = {
    ["misc_de_lute_01"] = "mer_lute",
    ["misc_de_lute_01_phat"] = "mer_lute_fat"
}

this.configPath = "bardicInspiration"
local defaultConfig = {
    taverns = {
        ["Balmora, Lucky Lockup"] = true
    }
}
local inMemConfig
function this.getConfig()
    inMemConfig = (
        inMemConfig or
        mwse.loadConfig(this.configPath) or
        defaultConfig
    )
    return inMemConfig
end

function this.getData()
    if tes3.player then
        tes3.player.data.bardicInspiration = tes3.player.data.bardicInspiration or {
            taverns = {}
        }
        return tes3.player.data.bardicInspiration
    end
end

function this.messageBox(params)
    --[[
        Button = { text, callback}
    ]]--
    local message = params.message
    local buttons = params.buttons
    local function callback(e)
        --get button from 0-indexed MW param
        local button = buttons[e.button+1]
        if button.callback then
            button.callback()
        end
    end
    --Make list of strings to insert into buttons
    local buttonStrings = {}
    for _, button in ipairs(buttons) do
        table.insert(buttonStrings, button.text)
    end
    tes3.messageBox({
        message = message,
        buttons = buttonStrings,
        callback = callback
    })
end

return this