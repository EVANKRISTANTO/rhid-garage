local inGarage = false


function pressToStoreVehicle(garage)
    CreateThread(function () 
        while inGarage do
            if IsControlJustPressed(0, 38) then
                StoreOwnedCarsMenu(garage)
                inGarage = false
            end
        Wait(10)
        end
    end)
end

CreateThread(function ()
    for k,v in pairs(Config.CarGarages) do
        local Deleter = BoxZone:Create(v.delcoords - 1, v.dellength, v.delwidth, {
            name = k,
            heading = v.delheading,
            minZ = v.delcoords.z - 3,
            maxZ = v.delcoords.z + 2
        })
        Deleter:onPlayerInOut(function(isPointInside)
            if isPointInside and IsPedInAnyVehicle(ESX.PlayerData.ped, true) and GetPedInVehicleSeat(ESX.PlayerData.ped, -1) then
                exports['qb-drawtext']:DrawText("E - Simpan Kendaraan")
                
                pressToStoreVehicle(k)
                inGarage = true
            
            else
                inGarage = false
                exports['qb-drawtext']:HideText()
            end
        end)
    end
end)