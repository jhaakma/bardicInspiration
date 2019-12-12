local common = require("mer.bardicInspiration.common")
local messages = require("mer.bardicInspiration.messages.messages")

local function registerModConfig()
    local config = common.getConfig()
    local template = mwse.mcm.createTemplate{ name = messages.modName }
    template:saveOnClose(common.configPath, config)
    template:register()

    local pageGeneral = template:createExclusionsPage{
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
