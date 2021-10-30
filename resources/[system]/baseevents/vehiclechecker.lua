local isInVehicle = false
local currentVehicle = 0
local currentSeat = 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)

		if(not isInVehicle and not IsPlayerDead(GetPlayerId())) then
			if(IsCharSittingInAnyCar(GetPlayerChar(-1))) then
				isInVehicle = true
				currentVehicle = GetCarCharIsUsing(GetPlayerChar(-1))
				currentSeat = GetPedVehicleSeat(GetPlayerChar(-1))

				TriggerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)))
				TriggerServerEvent('baseevents:enteredVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)))
			end
		elseif(isInVehicle) then
			if(not IsCharSittingInAnyCar(GetPlayerChar(-1)) or IsPlayerDead(GetPlayerId())) then
				TriggerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)))
				TriggerServerEvent('baseevents:leftVehicle', currentVehicle, currentSeat, GetDisplayNameFromVehicleModel(GetCarModel(currentVehicle)))

				isInVehicle = false
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