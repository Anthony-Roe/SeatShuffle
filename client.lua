function GetSeatPedIsIn(ped)
    local vehicle = GetVehiclePedIsIn(ped)
    for i = -1, 50, 1 do
        return GetPedInVehicleSeat(vehicle, i) == ped and i or nil
    end
end

function IsShuffling()
    if (GetIsTaskActive(GetPlayerPed(PlayerId()), 165) == 1) then
        return true
    elseif (GetIsTaskActive(GetPlayerPed(PlayerId()), 165) == false) then
        return false
    else
        return false
    end
end

function IsExitingVehicle()
    if (GetIsTaskActive(GetPlayerPed(PlayerId()), 2) == 1) then
        return true
    elseif (GetIsTaskActive(GetPlayerPed(PlayerId()), 2) == false) then
        return false
    else
        return false
    end
end

Citizen.CreateThread(function()
    while true do
        if (IsPedInAnyVehicle(GetPlayerPed(PlayerId()), false) and not IsPedGettingIntoAVehicle(GetPlayerPed(PlayerId())) and not IsExitingVehicle() and CanShuffleSeat(GetVehiclePedIsIn(GetPlayerPed(PlayerId())))) then
            if (IsShuffling() == false and GetSeatPedIsIn(GetPlayerPed(PlayerId())) ~= -1) then
                if (not IsControlPressed(1, 25) and not IsControlPressed(1, 24)) then
                    SetPedIntoVehicle(GetPlayerPed(PlayerId()), GetVehiclePedIsIn(GetPlayerPed(PlayerId())), GetSeatPedIsIn(GetPlayerPed(PlayerId())))
                end
            end
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if (IsControlPressed(0, 21) and IsControlJustPressed(0, 26)) then
            TaskShuffleToNextVehicleSeat(GetPlayerPed(PlayerId()), GetVehiclePedIsIn(GetPlayerPed(PlayerId())))
        end
        if (IsControlPressed(1, 25) or IsControlPressed(1, 24)) then
            if (IsShuffling()) then
                SetPedIntoVehicle(GetPlayerPed(PlayerId()), GetVehiclePedIsIn(GetPlayerPed(PlayerId())), GetSeatPedIsIn(GetPlayerPed(PlayerId())))
            end
        end
        
        Citizen.Wait(0)
    end
end)