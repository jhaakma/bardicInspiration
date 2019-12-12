local common = require("mer.bardicInspiration.common")
local messages = require("mer.bardicInspiration.messages.messages")

local function registerModConfig()
    local config = common.getConfig()
    local template = mwse.mcm.createTemplate{ name = messages.mcm.modName }
    template:saveOnClose(common.configPath, config)
    template:register()

    local pageGeneral = template:createExclusionsPage{
        label = messages.mcm.pages.taverns.name,
        description = message.mcm.pages.taverns.description,
        variable = mwse.mcm:createTableVariable{ id = "taverns", table = config },
        filters = {
            {
                label = "Interior Cells",
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
