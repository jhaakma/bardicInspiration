--[[
    Translations may be incomplete, however
    any subtables should be completed entirely. For
    example, if you translate the mcm values, you
    must translate everything in the mcm table
]]
return {
    
    --General
    modName = "Bardic Inspiration",

    --performances
    notTavern = "Find a tavern in order to perform.",
    notNightTime = "You may only perform between 6pm and 12am.",
    whatToPlay = "Which piece will you perform?",
    noGigScheduled = "You have not booked a performance here.",
    alreadyPlayed = "You have already performed in this tavern today.",
    donePerforming = "You earned %G gold worth of tips, well done! Speak to %s for your payment.",
   
    noSongsKnown = "You don't know any songs.",
    playingSong = "Playing \"%s\".",

    learnedSong = "You learned \"%s\"!",

    --song difficulty
    difficulty = "Difficulty",
    difficulty_beginner = "Beginner",
    difficulty_intermediate = "Intermediate",
    difficulty_advanced = "Advanced",

    --dialog
    dialog_teachChoice = "Yes, I may have something suitable for your skill level. This %s song is called \"%s\". Would you like me to teach it to you?",
    dialog_NoSongsBardMale = "You should actually learn to play something before you embarrass yourself in front of my patrons. %s is a bard, perhaps he could teach you? I'm sure I saw him around here somewhere.",
    dialog_NoSongsBardFemale = "You should actually learn to play something before you embarrass yourself in front of my patrons. %s is a bard, perhaps she could teach you? I'm sure I saw her around here somewhere.",

    --mcm
    mcm_page_settings = "Settings",
    mcm_page_description = "Bardic Inspiration allows you to book performances at taverns and perform with a lute.",

    mcm_baseValue_label = "Base Reward Value",
    mcm_baseValue_description = "The base gold amount you recieve when performing in taverns, before skill and disposition effects are taken into account. In other words, this is how much gold you'd get with 0 disposition and 0 Performance skill.",

    mcm_progressTavern_label = "Performance Progress Gain",
    mcm_progressTavern_description = "How much progress in the Performance skill you gain each time you perform in a tavern.",

    mcm_debug_label = "Log Level",
    mcm_debug_description = "Set the logging level for mwse.log. Keep on INFO unless you are debugging.",

    mcm_tavernspage_name = "Taverns",
    mcm_tavernspage_description = "In Bardic Inspiration, you can only perform for gold at inns and taverns. Use the lists below to view and edit which cells you are allowed to perform in.",
    mcm_tavernspage_leftListLabel = "Tavern cells",
    mcm_tavernspage_rightListLabel = "Interior cells",
    --skills
    skills_performance_name = "Performance",
    skills_performance_description = "Determines your ability to perform with musical instruments.",
    skills_warning_install = "Please install Skills Module",
    skills_warning_update = "Please update Skills Module",

    blockLoad = "You can not load a game right now.",

    tips = { --Add as many of these as you like. Just make sure it includes exactly one %G
        "A patron loves your performance and gives you %G gold.",
        "A child gives you her %G drakes.",
        "You have recieved %G gold from a shy child.",
        "A traveler enjoys your music and puts %G gold into the hat.",
        "An old lady tells you to 'Keep it up, child!' and gives you %G septims.",
        "You find %G gold in your hat.",
        "You get %G gold from a peasent who loves your song.",
        "You haven been given %G drakes.",
        "A wealthy merchant has one of his servants bring you %G gold for your playing.",
        "You get %G gold from a mage-in-training.",
        "You get %G gold from a snobby rich kid who is barely amused by your tune.",
        "You get %G gold from a tavern keeper, he wants you to play in his tavern, but didn't say *which* tavern.",
        "You have been given %G gold.",
    }
}