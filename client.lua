IsInVehicle = false
PlayerPed = nil
VehiclePlayerIsIn = 0
SeatPlayerIsIn = -2

function GetSeatPedIsIn(ped)
    local vehicle = GetVehiclePedIsIn(ped, false)
    for i=-2,GetVehicleMaxNumberOfPassengers(vehicle) do
        if(GetPedInVehicleSeat(vehicle, i) == ped) then return i end
    end
    return -2
end

function IsShuffling()
    if (GetIsTaskActive(PlayerPed, 165) == 1) then
        return true
    elseif (GetIsTaskActive(PlayerPed, 165) == false) then
        return false
    else
        return false
    end
end

function IsExitingVehicle()
    if (GetIsTaskActive(PlayerPed, 2) == 1) then
        return true
    elseif (GetIsTaskActive(PlayerPed, 2) == false) then
        return false
    else
        return false
    end
end

Citizen.CreateThread(function()
    while true do
        PlayerPed = GetPlayerPed(PlayerId())
        IsInVehicle = IsPedInAnyVehicle(PlayerPed, false)
        if (IsInVehicle) then
            VehiclePlayerIsIn = GetVehiclePedIsIn(PlayerPed)
            SeatPlayerIsIn = GetSeatPedIsIn(PlayerPed)
            if (not IsPedGettingIntoAVehicle(PlayerPed) and not IsExitingVehicle() and CanShuffleSeat(VehiclePlayerIsIn)) then
                if (IsShuffling() == false and SeatPlayerIsIn ~= -1) then
                    if (not IsControlPressed(1, 25) and not IsControlPressed(1, 24)) then
                        SetPedIntoVehicle(PlayerPed, VehiclePlayerIsIn, SeatPlayerIsIn)
                    end
                end
            end
        end
        Citizen.Wait(500)
    end
end)

Citizen.CreateThread(function()
    while true do
        if (IsInVehicle and PlayerPed ~= nil) then
            if (IsControlPressed(0, 21) and IsControlJustPressed(0, 26)) then
                TaskShuffleToNextVehicleSeat(PlayerPed, VehiclePlayerIsIn)
            end
            if (IsControlPressed(1, 25) or IsControlPressed(1, 24)) then

                if (IsShuffling()) then
                    SetPedIntoVehicle(PlayerPed, VehiclePlayerIsIn, SeatPlayerIsIn)
                end
            end
        end
        Citizen.Wait(0)
    end
end)