local messages = {}
messages.notTavern = "Find a tavern in order to perform."
messages.notNightTime = "You may only perform between 6pm and 12am."
messages.whatToPlay = "Which piece will you perform?"
messages.alreadyPlayed = "You have already performed in this tavern today."
messages.songs = {
    lute1 = "A Long Journey Home"
}
messages.mcm = {
    modName = "Bardic Inspiration",
    pages = {
        taverns = {
            name = "Taverns",
            description = ( 
                "In Bardic Inspiration, you can only perform for gold at inns and taverns. " ..
                "Use the lists below to view and edit which cells you are allowed to perform in."
            ),
            leftList = "Tavern cells",
            rightList = "Interior cells"
        }
    }
}
messages.skills = {
    performance = {
        name = "Performance",
        description = "Determines your ability to perform with musical instruments.",
    },
    pleaseInstall = "Please install Skills Module",
    pleaseUpdate = "Please update Skills Module",
}

return messages