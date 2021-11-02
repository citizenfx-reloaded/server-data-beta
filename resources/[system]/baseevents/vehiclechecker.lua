local isInVehicle = false
local isVehicleJacked = false
local currentVehicle = 0
local currentSeat = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		local char = GetPlayerChar(-1)

		if(not isInVehicle and not IsPlayerDead(GetPlayerId())) then
			if(IsPedJacking(char)) then
				isVehicleJacked = true
			end

			if(IsCharSittingInAnyCar(char)) then
				isInVehicle = true
				currentVehicle = GetCarCharIsUsing(char)
				currentSeat = GetPedVehicleSeat(char)

				TriggerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)), isVehicleJacked)
				TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)), isVehicleJacked)
			end
		elseif(isInVehicle) then
			if(not IsCharSittingInAnyCar(char) or IsPlayerDead(GetPlayerId())) then
				TriggerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)), isVehicleJacked)
				TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)), isVehicleJacked)

				isInVehicle = false
				isVehicleJacked = false
				currentVehicle = 0
				currentSeat = 0
			end
		end
	end
end)

function GetPedVehicleSeat(ped)
    local vehicle = GetCarCharIsUsing(ped)

	for i = -1, GetMaximumNumberOfPassengers(vehicle) do
        if(GetCharInCarPassengerSeat(vehicle, i) == ped) then
			return i
		end
    end
	
    return -1
end