local QBCore = exports['qb-core']:GetCoreObject()

local carsName = ""
local eventStatus = false
local lastCd = 0

local rcarlist = { -- Parçalanacak Araç Listesi
    ["1"] = "carbonizzare",
    ["2"] = "huntley",
    ["3"] = "blista2",
    ["4"] = "youga",
    ["5"] = "jester",
    ["6"] = "massacro",
    ["7"] = "fusilade",
    ["8"] = "surfer2",
    ["9"] = "rebel2",
    ["10"] = "penumbra",
    ["11"] = "dominator",
    ["12"] = "sultan",
    ["13"] = "infernus",
    ["14"] = "felon2",
    ["15"] = "f620",
    ["16"] = "coquette",
    ["17"] = "banshee",
    ["18"] = "seminole",
    ["19"] = "rhapsody",
    ["20"] = "prairie",
    ["21"] = "oracle",
    ["22"] = "jackal",
    ["23"] = "sentinel",
    ["24"] = "buccaneer",
    ["25"] = "picador",
    ["26"] = "regina",
    ["27"] = "fugitive",
    ["28"] = "ingot",
    ["29"] = "asterope",
    ["30"] = "pigalle",
    ["31"] = "manana",
    ["32"] = "manana2",
    ["33"] = "rapidgt",
    ["34"] = "rapidgt2",
    ["35"] = "ninef",
    ["36"] = "ninef2",
    ["37"] = "futo",
    ["38"] = "washington",
    ["39"] = "asea",
    ["40"] = "radi",
    ["41"] = "rocoto",
    ["42"] = "serrano",
    ["43"] = "mesa",
    ["44"] = "dubsta",
    ["45"] = "cavalcade",
    ["46"] = "cavalcade2",
    ["47"] = "fq2",
    ["48"] = "granger",
    ["49"] = "gresley",
    ["50"] = "habanero",
    ["51"] = "bullet",
}

local carList = {}

Citizen.CreateThread(function()
    local first = true
    local number = 0
    for x,y in pairs(rcarlist) do
        number = number + 1
        if number > config.vehicleCount then
            break
        end
        carList[y] = false
    end
    for x,y in pairs(carList) do
        if first then
            first = false
            carsName = carsName .. " " .. x
        else
            carsName = carsName .. ", " .. x
        end
    end
end)

RegisterServerEvent("schVehicleShred:set-event")
AddEventHandler("schVehicleShred:set-event", function(bool)
    eventStatus = bool
    TriggerClientEvent("schVehicleShred:vehicleJob", -1, carList, eventStatus, carsName, false)
end)

RegisterServerEvent("schVehicleShred:giveItems")
AddEventHandler("schVehicleShred:giveItems", function(class, key)
    local src = source
        local xPlayer = QBCore.Functions.GetPlayer(src)
        if xPlayer then
            local random1 = math.random(2, 4)
            local random2 = math.random(1,2)

            if math.random(0, 100) < 40 then 
                xPlayer.Functions.AddItem('splaka', 1)
            end

            if math.random(0,100) < 25 then 
                xPlayer.Functions.AddItem('nos', 1)
            end

            if math.random(0, 100) > 80 then
                xPlayer.Functions.AddItem('lockpick2', 1)
            end


            xPlayer.Functions.AddItem('battery', 1)

            xPlayer.Functions.AddItem('pparca', 5)

            xPlayer.Functions.AddItem('hurda', random1)


            xPlayer.Functions.AddItem('speaker', random1)
            xPlayer.Functions.AddItem('kapi', random2)
        
            if not class == 8 and not class == 4 then
                xPlayer.Functions.AddItem('airbag', 1)
                xPlayer.Functions.AddMoney("cash", config.money.tier2)
            end

            if class == 7 or class == 6 then
                xPlayer.Functions.AddItem('highradio', 1)
                xPlayer.Functions.AddItem('highrim', random1)
                xPlayer.Functions.AddMoney("cash", config.money.tier3)
                if math.random(0, 100) > 98 then 
                    xPlayer.Functions.AddItem('sablon_kart', random2)
                end
            else
                xPlayer.Functions.AddItem('lowradio', 1)
                xPlayer.Functions.AddMoney("cash", config.money.tier1)
                xPlayer.Functions.AddItem('stockrim', random1)
            end
        end
end)

QBCore.Functions.CreateCallback("schVehicleShred:give-item", function(source, cb, model)
    local vehicleModel = model
        carList[vehicleModel] = true
        local xPlayer = QBCore.Functions.GetPlayer(source)
        xPlayer.Functions.AddItem(config.extraItem, config.extraItemCount)
        TriggerClientEvent("QBCore:Notify", source, config.Text[config.lang]["receivedTheItem"]..config.extraItemCount.."x "..QBCore.Shared.Items[config.extraItem].label)
        local moreCar = false
        local firstCar = true
        -- for x,y in pairs(carList) do
        --     if not y then
        --         moreCar = true
        --     end
        -- end
        if not moreCar then
            TriggerEvent("schVehicleShred:set-event", false)
        -- else
        --     TriggerClientEvent("schVehicleShred:car-added", -1, vehicleModel)
        end
        cb(true)
end)

QBCore.Functions.CreateCallback('schVehicleShred:check-cd', function(source, cb)
    if lastCd == 0 or (os.time() - lastCd) > 60 then 
        lastCd = os.time()
        cb(true)
    else
        cb(false)
    end
end)

QBCore.Functions.CreateCallback('schVehicleShred:police-count', function(source, cb)
    cb(getJobCount("police"))
end)

function getJobCount(jobName)
    local sayi = 0
    local xPlayers = QBCore.Functions.GetPlayers()
	for i=1, #xPlayers, 1 do
        local xPlayer = QBCore.Functions.GetPlayer(xPlayers[i])
            if xPlayer.PlayerData.job.name == jobName and xPlayer.PlayerData.job.onduty then
                sayi = sayi + 1
            end
        end
    return sayi
end