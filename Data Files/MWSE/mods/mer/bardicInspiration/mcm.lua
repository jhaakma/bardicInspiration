local common = require("mer.bardicInspiration.common")
local messages = require("mer.bardicInspiration.messages.messages")

local function registerModConfig()
    local config = mwse.loadConfig(common.staticData.configPath, common.defaultConfig)
    local template = mwse.mcm.createTemplate{ name = messages.modName }
    template.onClose = function()
        common.config.save(config)
    end
    template:register()

    local settings = template:createSideBarPage{
        label = messages.mcm_page_settings,
        description = messages.mcm_page_description,
    }

    settings:createOnOffButton{
        label = string.format("Enable %s", common.modName),
        description = "Turn the mod on or off.",
        variable = mwse.mcm.createTableVariable{id = "enabled", table = config }
    }

    settings:createDropdown{
        label = messages.mcm_debug_label,
        description = messages.mcm_debug_description,
        options = {
            { label = "TRACE", value = "TRACE"},
            { label = "DEBUG", value = "DEBUG"},
            { label = "INFO", value = "INFO"},
            { label = "ERROR", value = "ERROR"},
            { label = "NONE", value = "NONE"},
        },
        variable = mwse.mcm.createTableVariable{ id = "logLevel", table = config },
        callback = function(self)
            common.log:setLogLevel(self.variable.value)
        end
    }
    

    template:createExclusionsPage{
        label = messages.mcm_tavernspage_name,
        description = messages.mcm_tavernspage_description,
        variable = mwse.mcm:createTableVariable{ id = "taverns", table = config },
        leftListLabel = messages.mcm_tavernspage_leftListLabel,
        rightListLabel = messages.mcm_tavernspage_rightListLabel,
        filters = {
            {
                label = "",
                callback = function()
                    local interiorCells = {}
                    for _, cell in pairs(tes3.dataHandler.nonDynamicData.cells) do
                        if cell.isInterior then
                            table.insert(interiorCells, cell.id)
                        end
                    end
                    return interiorCells
                end
            }
        }
    }
end
event.register("modConfigReady", registerModConfig)
