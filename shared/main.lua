config = {

    money = {
        tier1 = 350,
        tier2 = 500,
        tier3 = 1250,
    },

    classTestCommand = false,
    nuiWaitTime = 15000,
    policeCount = 0,
    policeNotificationChance = 65,
    MessageName = "Mike",
    extraItemCount = 2,
    extraItem = "carcoin",
    vehicleCount = 6,
    lang = "en",

    progressbar = {
        time = math.random(9000, 12000),
        text = "You are shredding the vehicle..."
    },

    Blip = {
        sprite = 326,
        colour = 5,
        scale = 0.7,
        text = "Shredding Zone",
    },

    npc = {
        {
            position = vector4(1152.60, -431.9, 67.01, 74.41), -- NPC position X, Y, Z, Heading
            model = "s_m_m_autoshop_01", -- NPC model (here is a list of all models https://wiki.rage.mp/index.php?title=Peds)
            animation = { -- Animation list : https://alexguirre.github.io/animations-list/ (dict in bold, animation name in regular)
                enable = false, -- Activate the animation for the NPC
                dict = "missheistdockssetup1clipboard@base", -- Dictionary associated to the animation
                name = "base" -- Animation's name
            },
            props = {
                enable = false, -- Activate the use of a prop for the NPC
                list = {
                    {
                        model = "prop_notepad_01", -- Model of the prop
                        bone = 18905, -- Bone associated to the prop
                        position = vec3(0.1, 0.02, 0.05), -- Position of the prop relative to the NPC
                        rotation = vec3(10.0, 0.0, 0.0) -- Rotation of the prop relative to the NPC
                    },
                    {
                        model = "prop_pencil_01", -- Model of the prop
                        bone = 58866, -- Bone associated to the prop
                        position = vec3(0.11, -0.02, 0.001), -- Position of the prop relative to the NPC
                        rotation = vec3(-120.0, 0.0, 0.0) -- Rotation of the prop relative to the NPC
                    },
                }
            }
        },
    }
}

config.Text = {
    en = {
        ["receivedTheItem"] = "In exchange for the vehicle, you received the following item: ",
        ["getAJob"] = "Get a Vehicle Shredding Job",
        ["finishTheJob"] = "Finish Vehicle Shredding Job",
        ["notEnoughPolice"] = "Not enough police",
        ["theresNothingForYouHere"] = "There's nothing for you here!",
        ["comeBackLater"] = "You can't shred the car now, come back later!",
        ["vehicleShreddingJob"] = "Vehicle Shredding Job",
        ["findOneOfTheseCars"] = "Find one of these cars and shred it!",
        ["seeYouAgain"] = "See you again on another job.",
        ["thanksForShredding"] = "Thanks for shredding the car and doing my job, don't stop working with me. I need guys like you.",
        ["shredTheVehicle"] = "Shred The Vehicle",
        ["steppedOut"] = "Removal Canceled Because You Stepped Out Of The Vehicle!",
        ["moveMarkedLocation"] = "You found the right vehicle, now move it to the marked location",
        ["vehicleClass"] = "Vehicle Class:",
        ["commandNotAvailable"] = "This Command is Not Available Right Now!",
        ["classTestCommand"] = "classtest",
        ["shreddingCanceled"] = "Vehicle Shredding Canceled!",
        ["wrongCar"] = "This is not the car I asked you for!",
        ["wrongSeat"] = "You're not in the driver's seat!",
    },
    tr = {
        ["receivedTheItem"] = "Araç karşılığında şu eşyayı aldın: ",
        ["getAJob"] = "Araç Parçalama İşi Al",
        ["finishTheJob"] = "Araç Parçalama İşini Bitir",
        ["notEnoughPolice"] = "Yeterli Sayıda Polis Yok!",
        ["theresNothingForYouHere"] = "Burda Senlik Birşey Yok!",
        ["comeBackLater"] = "Bir süre araç parçalayamazsın, daha sonra tekrar gel!",
        ["vehicleShreddingJob"] = "Araç Parçalama Görevi",
        ["findOneOfTheseCars"] = "Bu araçlardan birini bul ve parçala!",
        ["seeYouAgain"] = "Başka bir işte tekrar görüşmek üzere.",
        ["thanksForShredding"] = "Arabayı parçaladığın ve işimi yaptığın için teşekkürler, benimle çalışmayı bırakma. Senin gibi adamlara ihtiyacım var.",
        ["shredTheVehicle"] = "Aracı Parçala",
        ["steppedOut"] = "Araçtan İndiğin İçin Götürme İşlemi İptal Edildi!",
        ["moveMarkedLocation"] = "Doğru Aracı Buldun Şimdi Aracı İşaretli Konuma Götür",
        ["vehicleClass"] = "Araç Klas:",
        ["commandNotAvailable"] = "Bu Komut Şuan Kullanılamaz!",
        ["classTestCommand"] = "klastest",
        ["shreddingCanceled"] = "Araç Parçalama İptal Edildi!",
        ["wrongCar"] = "Senden İstediğim Araç Bu Değil!",
        ["wrongSeat"] = "Sürücü Koltuğunda Değilsin!",
    },
}

function DrawText3D(x, y, z, text)
	SetTextScale(0.30, 0.30)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 250
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end