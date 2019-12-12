--[[
    Skills
]]
local messages = require("mer.bardicInspiration.messages.messages")
local skillModule = include("OtherSkills.skillModule")
local this = {}
this.skills = {}
--Tell player if they don't have the right version of Skills Module
local function checkVersion()
    if not skillModule then
        timer.start({
            callback = function()
                tes3.messageBox{
                    message = messages.skills_warning_install,
                    buttons = {tes3.findGMST(tes3.gmst.sOK).value}
                }
            end,
            type = timer.simulate,
            duration = 1.0
        })
    end
    if ( skillModule.version == nil ) or ( skillModule.version < 1.4 ) then
        timer.start({
            callback = function()
                tes3.messageBox{
                    message = messages.skills_warning_update,
                    buttons = {tes3.findGMST(tes3.gmst.sOK).value}
                }
            end,
            type = timer.simulate,
            duration = 1.0
        })
    end
end

--Determine the starting skill level based on class/personality
local function getStartingSkillLevel()
    local val = 10
    if tes3.player then
        local class = tes3.player.object.class.id
        if class == "Bard" then
            val = 40
        else
            local minPersonality = 10
            local maxPersonality = 60
            local minVal = 1
            local maxVal = 40
            local personality = tes3.mobilePlayer.personality.base
            val = math.remap(personality, minPersonality, maxPersonality, minVal, maxVal)
            val = math.clamp(val, min, max)
            --make it by increments of 5
            val = math.ceil(val / 5) * 5
        end
    end
    return val
end

--Don't initialise skills until chargen is finished
local charGen
local function checkCharGen()
    if charGen.value == -1 then
        event.unregister("simulate", checkCharGen)
        local startingSkillLevel = getStartingSkillLevel()
        skillModule.registerSkill("BardicInspiration:Performance",
            {
                name = messages.skills_performance_name,
                icon = "Icons/mer_bard/performSkill.dds",
                value = startingSkillLevel,
                attribute = tes3.attribute.personality,
                description = messages.skills_performance_description,
                specialization = tes3.specialization.stealth
            }
        )
        this.performance = skillModule.getSkill("BardicInspiration:Performance")
    end
end

local function onSkillsReady()
    checkVersion()
    charGen = tes3.findGlobal("CharGenState")
    event.register("simulate", checkCharGen)
end
event.register("OtherSkills:Ready", onSkillsReady)

return this