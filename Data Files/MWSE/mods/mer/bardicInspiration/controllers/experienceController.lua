local common = require("mer.bardicInspiration.common")
local function onLoad()
    timer.start{
        duration = 1,
        type = timer.simulate,
        iterations = -1,
        callback = function()
            if common.data.isPlaying then
                local difficulty = common.data.currentSongDifficulty or "beginner"
                local skillLevel = common.skills.performance.value
                local difficultyMulti = common.staticData.difficulties[difficulty].expMulti
                local minLevelMulti = common.staticData.skillLevelMultis.min
                local maxLevelMulti = common.staticData.skillLevelMultis.max
            
                local skillLevelMulti = math.clamp(math.remap(skillLevel, 0,100, minLevelMulti, maxLevelMulti),0,100)
            
                common.log:debug("difficultyMulti: %s", difficultyMulti)
                common.log:debug("skillLevelMulti: %s", skillLevelMulti)
                common.log:debug("performSkillProgress: %s", common.staticData.performExperiencePerSecond)
            
                local progress = difficultyMulti * skillLevelMulti * common.staticData.performExperiencePerSecond

                common.log:trace("Progressing skill by %s", progress)
                common.skills.performance:progressSkill(progress)
                common.log:trace("Current progress: %s", common.skills.performance.progress)
            end
        end
    }
end
event.register("loaded", onLoad)