local weapons = {}
weapons["baseballbat"] = 1
weapons["poolcue"] = 2
weapons["knife"] = 3
weapons["grenade"] = 4
weapons["molotov"] = 5
weapons["pistol"] = 7
weapons["deagle"] = 9
weapons["deserteagle"] = 9
weapons["shotgun"] = 10
weapons["baretta"] = 11
weapons["microuzi"] = 12
weapons["uzi"] = 12
weapons["mp5"] = 13
weapons["ak47"] = 14
weapons["m4"] = 15
weapons["sniper"] = 16
weapons["m40a1"] = 17
weapons["rpg"] = 18
weapons["rocketlauncher"] = 18

--commands
RegisterServerEvent('savePos')
	AddEventHandler('savePos', function(x, y, z, heading)
	local f,err = io.open("pos.txt","a")
	if not f then return print(err) end
	f:write(tonumber(x) .. ", " .. tonumber(y) .. ", " .. tonumber(z) .. " heading " .. heading .. "\n")
	f:close()
end)

RegisterServerEvent('saveCar')
	AddEventHandler('saveCar', function(x, y, z)
	local f,err = io.open("cars.txt","a")
	if not f then return print(err) end
	f:write("car_generator { " .. x .. ", " .. y .. ", " .. z .. " }\\n")
	f:close()
end)

RegisterServerEvent('saveRandomPickup')
	AddEventHandler('saveRandomPickup', function(x, y, z)
	local f,err = io.open("pickups.txt","a")
	if not f then return print(err) end
	f:write("createPickup(getPickupType(" .. math.random(0, 2) .. "), 23, 200, " .. x .. ", " .. y .. ", " .. z .. ")\\n")
	f:close()
end)

--The command handling
AddEventHandler('chatMessage', function(source, name, message)
	if(string.len(message) == 0) then
		CancelEvent()
	end

	if(string.sub(message, 1, 1) == "/" and string.len(message) >= 2) then
		TriggerEvent('commandEntered', source, message)
		CancelEvent()
	end
end)

RegisterServerEvent('commandEntered')
AddEventHandler('commandEntered', function(source, fullcommand)
	local name = GetPlayerName(source)
	local command = stringsplit(fullcommand, ' ')

	print("[Command]" .. name .. " entered command " .. fullcommand)

	if(command[1] == "/commands") then TriggerClientEvent('chatMessage', source, '', { 0, 0x99, 255 }, "^6Commands: ^3/moddedvehicles | /veh ^7(vehicle name)^3 | /vehcol ^7(colour ID) (colour ID)^3 | /repair | /flip | /fix | /clean | /heal | /armour | /givewep ^7(weapon name)^3 | /suicide | /tp ^7(target player ID/name)^3 | /hudoff | /hudon")

	elseif command[1] == "/goto" or command[1] == "/tp" then
		if command[2] == nil then TriggerClientEvent('chatMessage', source, '', { 0, 0x99, 255 }, "^1Invalid name. Usage: /tp (target name).")
		else TriggerClientEvent('tpToPlayer', source, command[2])
	end

	elseif(command[1] == "/race") then TriggerClientEvent('startRace', source)
	
	elseif(command[1] == "/moddedvehicles") then TriggerClientEvent('chatMessage', source, 'ModdedVehicles', { 0, 0x99, 255 }, "^3Admiral | Ambulance | Annihilator | SuperGT | Faction | Infernus | Maverick | nstockade (NOOSE van) | Police | Police2 | polpatriot | Sultan | Taxi | Turismo.")
	
	elseif(command[1] == "/givewep") then
	    if command[2] == nil then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1That's an unknown weapon.")
	    elseif not weapons[command[2]] then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1That's an unknown weapon.")
	    else TriggerClientEvent('giveWeapon', source, weapons[command[2]], 50000)
    end
	
	elseif(command[1] == "/veh") then
		if command[2] == nil or string.len(command[2]) < 1 or string.len(command[2]) > 30 then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1That's an unknown vehicle.")
		else TriggerClientEvent('createCarAtPlayerPos', source, command[2])
	end
	
	elseif(command[1] == "/vehcol") then
		if command[2] == nil or command[3] == nil or isNumber(command[2]) == false or isNumber(command[3]) == false then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1Invalid carcolours. Usage: /vehcol (id1) (id2).")
		else TriggerClientEvent('changeCarColor', source, command[2], command[3])
	end
	
	elseif(command[1] == "/hudoff") then TriggerClientEvent('hudOff', source)
	elseif(command[1] == "/hudon") then TriggerClientEvent('hudOn', source)

	elseif(command[1] == "/ped" and command[2] ~= nil) then TriggerClientEvent('createPed', source, command[2])
	
	elseif command[1] == "/heal" then TriggerClientEvent('setHealth', source, 200)

	elseif command[1] == "/armor" or command[1] == "/armour" then TriggerClientEvent('giveArmour', source, 200)

	elseif command[1] == "/flip" then TriggerClientEvent('flipVehicle', source)
	
	elseif command[1] == "/fix" or command[1] == "/repair" then TriggerClientEvent('fixVehicle', source)
	
	elseif command[1] == "/clean" or command[1] == "/carwash" then TriggerClientEvent('cleanYourCar', source)

	elseif command[1] == "/kill" or command[1] == "/suicide" then TriggerClientEvent('kill', source)

	elseif command[1] == "/host" then TriggerClientEvent('showScreenMsg', source, "~b~The current host is ~r~" .. GetPlayerName(GetHostId()))
----------------------------------------------------------------------------------------------------------------------------------------
	elseif(name == "Lion" and command[1] == "/anim") then TriggerClientEvent('playAnimStuff', source, command[2], command[3], command[4], false, 0, 0, 0, 5000)

	elseif(name == "Lion" and command[1] == "/checkpoint") then TriggerClientEvent('createCheckpoint', source)

	elseif(name == "Lion" and command[1] == "/pos") then TriggerClientEvent('setPos', source, string.sub(command[2], 1, string.len(command[2])-1), string.sub(command[3], 1, string.len(command[3])-1), string.sub(command[4], 1, string.len(command[4])-1))

	elseif(name == "Lion" and command[1] == "/audio") then TriggerClientEvent('playAudioStuff', source, command[2])

	elseif(name == "Lion" and command[1] == "/giverpg") then TriggerClientEvent('giveWeapon', source, 18, 7)
	elseif(name == "Lion" and command[1] == "/godmode") then TriggerClientEvent('godmode', source)
	elseif(name == "Lion" and command[1] == "/savecar") then TriggerClientEvent('sendSaveCar', source)
	elseif(name == "Lion" and command[1] == "/pos" or command[1] == "/savepos") then TriggerClientEvent('sendPos', source)

	elseif(name == "Lion" and command[1] == "/kick") then
		if(command[2] == nil) then return TriggerClientEvent('showScreenMsg', source, '', { 0, 0x99, 255 }, "^1Unknown playername. Usage: /kick (playername).")
		else TriggerClientEvent('kickPlayer', GetHostId(), command[2])
	end

	elseif(name == "Lion" and command[1] == "/blip") then
		if(command[2] == nil or command[3] == nil or isNumber(command[2]) == false or isNumber(command[3]) == false) then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1Wrong syntax.")
		else TriggerClientEvent('createBlip', source, command[2], command[3])
	end

	elseif(name == "Lion" and command[1] == "/weather") then
		if(tonumber(command[2]) < 0 or tonumber(command[2]) > 10) then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1That's an unknown weather ID.")
		else TriggerClientEvent('setWeather', GetHostId(), command[2])
	end
	
	elseif(name == "Lion" and command[1] == "/time") then
		if(isNumber(command[2]) == false) then TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1Invalid hour of day.")
		else TriggerClientEvent('setTime', GetHostId(), command[2])
	end

	elseif(name == "Lion" and command[1] == "/msgtoeveryone") then
		if(command[2] == nil or string.len(command[2]) < 2) then return TriggerClientEvent('showScreenMsg', source, "~r~No message specified. Usage: ~y~/msgtoeveryone (message)")
		else TriggerClientEvent('showScreenMsg', -1, "~r~" .. string.sub(fullcommand, string.len(command[1]) + 1))
	end

	elseif(name == "Lion" and command[1] == "/chattoeveryone") then
		if(command[2] == nil or string.len(command[2]) < 2) then return TriggerClientEvent('showScreenMsg', source, "~r~No message specified. Usage: ~y~/chattoeveryone (message)")
		else TriggerClientEvent('chatMessage', source, '', { 0, 0x99, 255 }, "^1" .. string.sub(fullcommand, string.len(command[1]) + 1))
	end
----------------------------------------------------------------------------------------------------------------------------------------
	else TriggerClientEvent('chatMessage', source, 'Server', { 0, 0x99, 255 }, "^1Sorry, but we don't know that command.")
	end
end)

function startswith(sbig, slittle)
  if type(slittle) == "table" then
    for k,v in ipairs(slittle) do
      if string.sub(sbig, 1, string.len(v)) == v then 
        return true
      end
    end
    return false
  end
  return string.sub(sbig, 1, string.len(slittle)) == slittle
end

function isNumber(str)
	num = tonumber(str)
	if not num then return false
	else return true
	end
end

function stringsplit(self, delimiter)
  local a = self:Split(delimiter)
  local t = {}

  for i = 0, #a - 1 do
     table.insert(t, a[i])
  end

  return t
end