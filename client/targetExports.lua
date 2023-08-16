
for _, npcData in pairs(config.npc) do
    exports['qb-target']:AddTargetModel(npcData.model, {
        options = {
            {
                event = "schVehicleShred:startJob",
                icon = "fas fa-screwdriver",
                label = config.Text[config.lang]["getAJob"],
                canInteract = function() -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
                    if not exports["schVehicleShred"]:isJobStarted() then return true end -- This will return false if the entity interacted with is a player and otherwise returns true
                    return false
                end,
            },
            {
                event = "schVehicleShred:finishJob",
                icon = "fas fa-screwdriver",
                label = config.Text[config.lang]["finishTheJob"],
                canInteract = function() -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
                    if exports["schVehicleShred"]:isJobStarted() then return true end -- This will return false if the entity interacted with is a player and otherwise returns true
                    return false
                end,
            },
        },
        distance = 2
    })
end