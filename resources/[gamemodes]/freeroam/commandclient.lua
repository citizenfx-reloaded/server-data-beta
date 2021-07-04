--Client event handler, usually for commands

local hudEnabled = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if(hudEnabled) then
            DisplayAmmo(true)
            DisplayCash(true)
            DisplayHud(true)
            DisplayRadar(true)
        end
    end
end)

RegisterNetEvent('giveWeapon')
AddEventHandler('giveWeapon', function(weapon, ammo)
    GiveWeaponToChar(GetPlayerChar(-1), weapon, ammo)
end)

RegisterNetEvent('createCheckpoint')
AddEventHandler('createCheckpoint', function()
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
    
    CreateCheckpoint(3, pos[1]+6, pos[2], pos[3], pos[1], pos[2]+10, pos[3], 1.0)
    
    ShowText("Checkpoint created.")
end)

RegisterNetEvent('hudOff')
AddEventHandler('hudOff', function()
    hudEnabled = false
end)

RegisterNetEvent('hudOn')
AddEventHandler('hudOn', function()
    hudEnabled = true
end)

RegisterNetEvent('playAudioStuff')
AddEventHandler('playAudioStuff', function(audio)
    PlayAudioEvent(audio)
end)

function GetIDFromName(name)
    local players = GetPlayers()

    for _, i in ipairs(players) do
        if(string.lower(GetPlayerName(i)) == string.lower(name)) then
            return i
        end
    end

    return nil
end

RegisterNetEvent('showScreenMsg')
AddEventHandler('showScreenMsg', function(text, timeout)
    if(timeout == nil) then
        PrintStringWithLiteralStringNow("STRING", tostring(text), 2000, 1)
    else
        PrintStringWithLiteralStringNow("STRING", tostring(text), tonumber(timeout), 1)
    end
end)

RegisterNetEvent('tpToPlayer')
AddEventHandler('tpToPlayer', function(nameorid)
    local target = 255

    if(isNumber(nameorid) and GetPlayerFromServerId(tonumber(nameorid)) ~= -1) then target = GetPlayerFromServerId(tonumber(nameorid))
    elseif(GetIDFromName(nameorid) ~= nil) then target = GetIDFromName(nameorid)
    end

    if(target == 255) then
        return ShowText("~r~Invalid player name/ID.")
    end

    if(GetPlayerName(target) == GetPlayerName(GetPlayerId())) then
        return ShowText("~r~You can't teleport to yourself.")
    end

    if(IsCharInAnyCar(GetPlayerChar(target))) then
        if(IsCharInAnyCar(GetPlayerChar(-1)) and GetCarCharIsUsing(GetPlayerChar(target)) == GetCarCharIsUsing(GetPlayerChar(-1))) then
            return ShowText("~r~You can't teleport to yourself.")
        end

        if(GetMaximumNumberOfPassengers(GetCarCharIsUsing(GetPlayerChar(target))) == GetNumberOfPassengers(GetCarCharIsUsing(GetPlayerChar(target)))) then
            ShowText("~r~There's no more free seats in " .. GetPlayerName(target) .. "'s vehicle! ~g~Warping to the vehicle.")
            return TeleportToChar(GetPlayerChar(target))
        end

        WarpCharIntoCarAsPassenger(GetPlayerChar(-1), GetCarCharIsUsing(GetPlayerChar(target)))

        return ShowText("~g~You've successfully teleported into ~y~" .. GetPlayerName(target) .. "~g~'s vehicle.")
    end

    TeleportToChar(GetPlayerChar(target))
    ShowText("~g~You've successfully teleported to ~y~" .. GetPlayerName(target) .. "~g~.")
end)

function TeleportToChar(char)
    local pos = table.pack(GetCharCoordinates(char))
    table.insert(pos, GetCharHeading(char))

    if(IsCharInAnyCar(GetPlayerChar(-1))) then
        WarpCharFromCarToCoord(GetPlayerChar(-1), pos[1], pos[2], pos[3])
    end

    SetCharCoordinatesNoOffset(GetPlayerChar(-1), pos[1], pos[2], pos[3])
    SetCharHeading(GetPlayerChar(-1), pos[4])
end

function round(num, idp)
    local mult = 10^(idp or 0)
    return math.floor(num * mult + 0.5) / mult
end

RegisterNetEvent('sendPos')
AddEventHandler('sendPos', function()
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
    table.insert(pos, GetCharHeading(GetPlayerChar(-1)))

    TriggerServerEvent('savePos', round(pos[1], 5), round(pos[2], 5), round(pos[3], 5), pos[4])
    TriggerEvent('createBlip', 63, 2)
end)

RegisterNetEvent('sendSaveCar')
AddEventHandler('sendSaveCar', function()
    local pos = table.pack(GetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(-1))))

    TriggerServerEvent('saveCar', round(pos[1], 5), round(pos[2], 5), round(pos[3], 5))
end)

RegisterNetEvent('createBlip')
AddEventHandler('createBlip', function(sprite, color)
    local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
    local blip = AddBlipForCoord(pos[1], pos[2], pos[3])

    ChangeBlipSprite(blip, tonumber(sprite))
    ChangeBlipColour(blip, tonumber(color))

    ShowText("~g~Blip created.")
end)

RegisterNetEvent('changeCarColor')
AddEventHandler('changeCarColor', function(col1, col2)
	if(not IsCharInAnyCar(GetPlayerChar(-1))) then
        return ShowText("~r~You are not in any vehicle!")
	end

	ChangeCarColour(GetCarCharIsUsing(GetPlayerChar(-1)), tonumber(col1), tonumber(col2))
	ShowText("~g~You have set your vehicles' colour.")
end)

RegisterNetEvent('setWeather')
AddEventHandler('setWeather', function(weatherid)
    ForceWeatherNow(tonumber(weatherid))
end)

RegisterNetEvent('setTime')
AddEventHandler('setTime', function(hour)
    SetTimeOfDay(tonumber(hour))
end)

RegisterNetEvent('setPos')
AddEventHandler('setPos', function(x, y, z)
    ShowText("~g~Warping to server sent coordinates ~y~" .. x .. " " .. y .. " " .. z .. " ~g~.")
    SetCharCoordinatesNoOffset(GetPlayerChar(-1), x, y, z)
end)

RegisterNetEvent('setHealth')
AddEventHandler('setHealth', function(amount)
    SetCharHealth(GetPlayerChar(-1), tonumber(amount))
end)

RegisterNetEvent('giveArmour')
AddEventHandler('giveArmour', function(amount)
    AddArmourToChar(GetPlayerChar(-1), tonumber(amount))
end)

RegisterNetEvent('fixVehicle')
AddEventHandler('fixVehicle', function()
	if(not IsCharInAnyCar(GetPlayerChar(-1))) then 
        return ShowText("~r~You are not in any vehicle!")
	end

	FixCar(GetCarCharIsUsing(GetPlayerChar(-1)))
    ShowText("~g~You have fixed your vehicle.")
end)

RegisterNetEvent('flipVehicle')
AddEventHandler('flipVehicle', function()
    if(not IsCharInAnyCar(GetPlayerChar(-1))) then 
        return ShowText("~r~You are not in any vehicle!")
    end

    FlipVehicle(GetCarCharIsUsing(GetPlayerChar(-1)))
    ShowText("~g~You have flipped your vehicle.")
end)

function FlipVehicle(vehicle)
    local pos = table.pack(GetCarCoordinates(vehicle))
    table.insert(pos, GetCarHeading(vehicle))

    SetCarCoordinates(vehicle, pos[1], pos[2], pos[3])
    SetCarHeading(vehicle, pos[4])
end

RegisterNetEvent('giveHealth')
AddEventHandler('giveHealth', function(amount)
    SetCharHealth(GetPlayerChar(-1), GetCharHealth(GetPlayerChar(-1)) + tonumber(amount))
end)

RegisterNetEvent('takeHealth')
AddEventHandler('takeHealth', function(amount)
    SetCharHealth(GetPlayerChar(-1), GetCharHealth(GetPlayerChar(-1)) - tonumber(amount))
end)

RegisterNetEvent('cleanYourCar')
AddEventHandler('cleanYourCar', function()
    if(not IsCharInAnyCar(GetPlayerChar(-1))) then 
        return ShowText("~r~You are not in any vehicle!")
    end

    SetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(-1)), 0.0)
    WashVehicleTextures(GetCarCharIsUsing(GetPlayerChar(-1)), 255)

    ShowText("~g~You've successfully cleaned your vehicle.")
end)

RegisterNetEvent('kill')
AddEventHandler('kill', function()
    SetCharHealth(GetPlayerChar(-1), 0)
    ShowText("~y~You have committed suicide.")
end)

RegisterNetEvent('godmode')
AddEventHandler('godmode', function()
    SetCharInvincible(GetPlayerChar(-1), true)
    ShowText("~y~Godmode on.")
end)

RegisterNetEvent('createCarAtPlayerPos')
AddEventHandler('createCarAtPlayerPos', function(modelname)
    if(IsModelInCdimage(GetHashKey(modelname))) then
        local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
        table.insert(pos, GetCharHeading(GetPlayerChar(-1)))

        CreateNewCar(pos[1], pos[2], pos[3], pos[4], GetHashKey(modelname), true)
        ShowText("~g~You've spawned the ~y~" .. modelname .. "~g~.")
    else
        TriggerEvent('chatMessage', '', { 0, 0x99, 255 }, "^1That's an unknown vehicle. Usage: /veh (vehicle name).")
    end
end)

function CreateNewCar(x, y, z, heading, model, throwin)
    Citizen.CreateThread(function()
        RequestModel(model)

        while not HasModelLoaded(model) do 
            Citizen.Wait(0) 
        end

        local car = CreateCar(model, x, y, z, true)
        SetCarHeading(car, heading)
        SetCarOnGroundProperly(car)
        SetVehicleDirtLevel(car, 0.0)
        WashVehicleTextures(car, 255)

        if(throwin == true) then
            WarpCharIntoCar(GetPlayerChar(-1), car)
        end

        MarkModelAsNoLongerNeeded(model)
        MarkCarAsNoLongerNeeded(car)
    end)
end

function IsPlayerNearCoords(x, y, z, radius)
	local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
	local dist = GetDistanceBetweenCoords3d(x, y, z, pos[1], pos[2], pos[3])

	if(dist < radius) then
        return true
	else
        return false
	end
end

function IsPlayerNearChar(char, radius)
	local pos = table.pack(GetCharCoordinates(GetPlayerChar(-1)))
	local pos2 = table.pack(GetCharCoordinates(char))
	local dist = GetDistanceBetweenCoords3d(pos2[1], pos2[2], pos2[3], pos[1], pos[2], pos[3])

	if(dist <= radius) then
        return true
	else
        return false
	end
end

function isNumber(str)
    local num = tonumber(str)

    if not num then
        return false
    else
        return true
    end
end