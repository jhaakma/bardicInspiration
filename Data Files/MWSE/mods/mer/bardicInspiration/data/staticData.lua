return {
    modName = "Bardic Inspiration",
    configPath = "BardicInspiration",
    --Lute id mapping
    lutes = {
        ["mer_lute"] = true,
        ["mer_lute_fat"] = true,
    },
    idMapping = {
        ["misc_de_lute_01"] = "mer_lute",
        ["misc_de_lute_01_phat"] = "mer_lute_fat"
    },
    initPlayerData = {
        taverns = {},
        knownSongs = {}
    },
    bardTeachIntervalHours = 48,
    difficulties = {
        beginner = { 
            minSkill = -1,
            expMulti = 0.5,
            songsPerBard = 5
        },
        intermediate = { 
            minSkill = 50,
            expMulti = 0.75,
            songsPerBard = 5
        },
        advanced = { 
            minSkill = 75,
            expMulti = 1.0,
            songsPerBard = 1
        }
    },
    skillLevelMultis = {
        min = 6.0,
        max = 1.0
    },

    --Tavern reward configs
    performExperiencePerSecond = 1.5,
    baseRewardAmount = 10,
    maxDispRewardEffect = 2.0,
    maxSkillRewardEffect = 10.0,
    --Tip configs
    minTip = 2,
    baseTip = 5,
    maxSkillTipEffect = 5.0,
    --Tip interval configs
    maxTipInterval = 30,
    baseTipInterval = 20, --seconds
    maxLuckTipIntervalEffect = 0.10,--multiplier
    maxSkillTipIntervalEffect = 0.5,--multiplier
    --Disposition increase configs
    dispIncreasePerRewardAmount = 0.1,
    maxDispositionIncrease = 20,
    --Dialog entries
    dialogueEntries = {
        --"give a performance"
        hasPlayed = {
            dialogue = "give a performance", 
            id = "7279130782524329959"
        },
        doAccept = {
            dialogue = "give a performance",
            id = "1603219220275755837"
        },
        hasAccepted = {
            dialogue = "give a performance",
            id = "115733748750646221139"
        },
        describeGig = {
            dialogue = "give a performance",
            id = "2347617621151716375"
        },
        askToPerform = {
            dialogue = "give a performance",
            id = "2348628403660916185"
        },
        tooLate = {
            dialogue = "give a performance",
            id = "1921131585645619076"
        },
        noLute = {
            dialogue = "give a performance",
            id = "11347136332025822472"
        },
        noSongs = {
            dialogue = "give a performance",
            id = "2342613600664222302"
        },


        --"teach me a song"
        teachCancel = {
            dialogue = "teach me a song",
            id = "1909021375137333678"
        },
        teachConfirm = {
            dialogue = "teach me a song",
            id = "1073418513242012439"
        },
        teachChoice = {
            dialogue = "teach me a song",
            id = "143714305235015036"
        },
        noTeachMustWait = {
            dialogue = "teach me a song",
            id = "1103015831284715100"
        },
        noTeachLowSkill = {
            dialogue = "teach me a song",
            id = "27040121121630217252"
        },
        noTeachNoSongs = {
            dialogue = "teach me a song",
            id = "1541615497468425745"
        },
        noTeachAvgDisp = {
            dialogue = "teach me a song",
            id = "258111209199954193"
        },
        noTeachBadDisp = {
            dialogue = "teach me a song",
            id = "635676781298714316"
        },
    }
}