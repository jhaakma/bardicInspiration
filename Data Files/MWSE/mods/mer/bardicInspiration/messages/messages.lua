-- Get the ISO language code.
local language = tes3.getLanguage() or "eng"
local path = string.format("mer.bardicInspiration.messages.%s", language)
return require(path)