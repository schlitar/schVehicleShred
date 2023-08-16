local QBCore = exports['qb-core']:GetCoreObject()

local clientCooldown = false
local jobStarted = false
local carShredded = false
local eventStatus = false
local vehicleFound = false
local gpsCoords = nil
local availableCars = ""
local modelToName = {}
    
local randomGPS = {
    vector3(759.41, -1865.93, 29.29),
    vector3(1130.28, -1300.54, 34.74),
    vector3(231.84, 130.13, 102.6),
    vector3(60.81, 159.66, 104.25),
    vector3(151.48, -127.3, 54.35),
    vector3(-64.8, -1836.89, 26.32),
    vector3(756.02, -3195.31, 5.59),
    vector3(-1429.22, -677.04, 26.18),
    vector3(-1362.11, -472.15, 31.6),
    vector3(-1039.7, -412.43, 33.27),
}

local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)
Citizen.CreateThread(function()
    while true do
        playerPed = PlayerPedId()
        playerCoords = GetEntityCoords(playerPed)
        Citizen.Wait(500)
    end
end)

function jobBlip(trueorfalse)
    if trueorfalse then
        carBlip = AddBlipForCoord(gpsCoords.x, gpsCoords.y, gpsCoords.z)
        SetBlipSprite(carBlip, config.Blip.sprite)
        SetBlipColour(carBlip, config.Blip.colour)
        SetBlipAsShortRange(carBlip, true)
        SetBlipScale(carBlip, config.Blip.scale)
        SetBlipRoute(carBlip, true)
        SetBlipRouteColour(carBlip, 5)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(config.Blip.text)
        EndTextCommandSetBlipName(carBlip)
    elseif not trueorfalse then
        RemoveBlip(carBlip)
    end
end

exports("isJobStarted", function()
    return jobStarted
end)

RegisterNetEvent("schVehicleShred:startJob")
AddEventHandler("schVehicleShred:startJob", function()
    PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.job.name == "police" or PlayerData.job.name == "ambulance" then
        QBCore.Functions.Notify(config.Text[config.lang]["theresNothingForYouHere"], "error")
    else
    QBCore.Functions.TriggerCallback('schVehicleShred:police-count', function(ActivePolice)
        if ActivePolice >= config.policeCount then
        QBCore.Functions.TriggerCallback('schVehicleShred:check-cd', function(cd)
            if cd and not clientCooldown then
                TriggerServerEvent("schVehicleShred:set-event", true)
                jobStarted = true
            else
                QBCore.Functions.Notify(config.Text[config.lang]["comeBackLater"], "error")
            end
        end)
        else
            QBCore.Functions.Notify(config.Text[config.lang]["notEnoughPolice"], "error")
        end
    end)
    end
end)

RegisterNetEvent("schVehicleShred:finishJob")
AddEventHandler("schVehicleShred:finishJob", function()
    jobStarted = false
end)

RegisterNetEvent('schVehicleShred:vehicleJob')
AddEventHandler('schVehicleShred:vehicleJob', function(carList, bool, text, firstLoginData)
    for x,y in pairs(carList) do modelToName[GetHashKey(x)] = x end
    eventStatus = bool
    startEventText(text, eventStatus, firstLoginData)
end)

function startEventText(text, eventStatus, firstLoginData)
    if firstLoginData then Citizen.Wait(10000) end
    if eventStatus then
        SendNUIMessage({
            type = 'open',
            title = config.MessageName,
            description = config.Text[config.lang]["vehicleShreddingJob"],
            message =  "("..text.. " )"..config.Text[config.lang]["findOneOfTheseCars"],
        })
        Citizen.Wait(config.nuiWaitTime)
        SendNUIMessage({type = "close"})
    else
        if not firstLoginData then
            SendNUIMessage({
                type = 'open',
                title = config.MessageName,
                description = config.Text[config.lang]["vehicleShreddingJob"],
                message = config.Text[config.lang]["seeYouAgain"],
            })
            Citizen.Wait(3000)
            SendNUIMessage({type = "close"})
        end
    end
end

RegisterNetEvent('schVehicleShred:car-added')
AddEventHandler('schVehicleShred:car-added', function(vehicleModel)
        SendNUIMessage({
            type = 'open',
            title = config.MessageName,
            description = config.Text[config.lang]["vehicleShreddingJob"],
            message = config.Text[config.lang]["thanksForShredding"],
        })
        Citizen.Wait(config.nuiWaitTime)
        SendNUIMessage({type = "close"})
end)

Citizen.CreateThread(function()
    while true do
        if jobStarted then
            if IsPedSittingInAnyVehicle(playerPed) and not vehicleFound then
                if checkVehicleModel() then
                    QBCore.Functions.Notify(config.Text[config.lang]["moveMarkedLocation"])
                    vehicleFound = true
                    local setRandomGPS = math.random(1, #randomGPS)
                    gpsCoords = randomGPS[setRandomGPS]
                    jobBlip(true)
                    vehicleFoundFunction()
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand(config.Text[config.lang]["classTestCommand"], function()
    if config.classTestCommand then
        local vehicleclass = GetVehicleClass(GetVehiclePedIsIn(PlayerPedId()))
        QBCore.Functions.Notify(config.Text[config.lang]["vehicleClass"]..vehicleclass, "success")
        print(vehicleclass)
    else
        QBCore.Functions.Notify(config.Text[config.lang]["commandNotAvailable"], "error")
    end
end)

function checkVehicleModel()
    local playerVehicle = GetVehiclePedIsIn(playerPed)
    local vehicleModel = GetEntityModel(playerVehicle)
    return modelToName[vehicleModel], vehicleModel
end

function vehicleFoundFunction()
    while vehicleFound do
        Citizen.Wait(0)
            local distance = #(playerCoords - gpsCoords)
            local playerPed = PlayerPedId()
            local playerVehicle = GetVehiclePedIsIn(playerPed)
            local VehicleClass = GetVehicleClass(playerVehicle)
            if not IsPedInAnyVehicle(playerPed) then
                QBCore.Functions.Notify(config.Text[config.lang]["steppedOut"], "error")
                vehicleFound = false
                break
            end

            if distance < 30 then
                DrawMarker(2, gpsCoords.x, gpsCoords.y, gpsCoords.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.3, 0.3, 0.3,  255, 255, 255, 125, false, true, 2, false, false, false, false)
                if distance < 3 and not carShredded then
                    DrawText3D(gpsCoords.x, gpsCoords.y, gpsCoords.z, "[E] "..config.Text[config.lang]["shredTheVehicle"])
                    if IsControlJustReleased(0, 38) then
                        local playerVehicle = GetVehiclePedIsIn(playerPed)
                        if GetPedInVehicleSeat(playerVehicle, -1) == playerPed then
                            local vehModel = checkVehicleModel()
                            if vehModel then
                                if math.random(1,100) < config.policeNotificationChance then
                                    policeNotification()
                                end
                                clientCooldown = true
                                jobBlip(false)
                                QBCore.Functions.Progressbar('vehicleshred', config.progressbar.text, config.progressbar.time, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                                    disableMovement = true,
                                    disableCarMovement = true,
                                    disableMouse = false,
                                    disableCombat = true,
                                }, {}, {}, {}, function() -- Play When Done
                                    TriggerServerEvent("schVehicleShred:giveItems", VehicleClass, QBCore.Key)
                                    QBCore.Functions.TriggerCallback("schVehicleShred:give-item", function(result)
                                        if result then
                                            QBCore.Functions.DeleteVehicle(playerVehicle)
                                        end
                                    end, vehModel)
                                    carShredded = true
                                    vehicleFound = false
                                    TriggerEvent("schVehicleShred:finishJob")
                                end, function() -- Play When Cancel
                                    QBCore.Functions.Notify(config.Text[config.lang]["shreddingCanceled"])
                                end)
                            else
                                QBCore.Functions.Notify(config.Text[config.lang]["wrongCar"], "error")
                            end
                        else
                            QBCore.Functions.Notify(config.Text[config.lang]["wrongSeat"], "error")
                        end
                    end
                end
            end
    end
end

Citizen.CreateThread(function ()
	while true do
		if clientCooldown then
			Citizen.Wait(1800000) -- Citizen.Wait(1800000) -- 1800000
			clientCooldown = false
		end 
		Citizen.Wait(1000)
	end
end)

function policeNotification()
    -- You can use your own custom notification system
end