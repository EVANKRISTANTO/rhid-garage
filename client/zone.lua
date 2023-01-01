
local currentGarage = nil
local indexGarage = nil
local AKendaraan = false
local MKendaraan = false

local zoneImpound
local zoneAmbil
local zoneMasukin

local coordsAmbil
local coordsMasukin


CreateThread(function ()

    for i, g in pairs(Config.CarGarages) do 

        if g.type == "impound" then
            coordsAmbil = vec3(g.AmbilKendaraan.x, g.AmbilKendaraan.y, g.AmbilKendaraan.z)
            zoneImpound = BoxZone:Create(coordsAmbil, 1.0, 1.0, {
                name = i,
                heading = g.AmbilKendaraan.w,
                minZ = g.AmbilKendaraan.z - 3,
                maxZ = g.AmbilKendaraan.z + 2
            })
            zoneImpound:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['rhid-drawtext']:DrawText("E - Aksess Asuransi" .. "<br>" .. g.label)
                    currentGarage = g
                    AKendaraan = true
                else
                    exports['rhid-menu']:closeMenu()
                    exports['rhid-drawtext']:HideText()
                    AKendaraan = false
                end
            end)
        else
            coordsAmbil = vec3(g.AmbilKendaraan.x, g.AmbilKendaraan.y, g.AmbilKendaraan.z)
            coordsMasukin = vec3(g.SimpanKendaraan.x, g.SimpanKendaraan.y, g.SimpanKendaraan.z)
            zoneAmbil = BoxZone:Create(coordsAmbil, 1.0, 1.0, {
                name = i,
                heading = g.AmbilKendaraan.w,
                minZ = g.AmbilKendaraan.z - 3,
                maxZ = g.AmbilKendaraan.z + 2
            })
            zoneAmbil:onPlayerInOut(function(isPointInside)
                if isPointInside then
                    exports['rhid-drawtext']:DrawText("E - Buka Garasi" .. "<br>" .. g.label)
                    AKendaraan = true
                    currentGarage = g
                    indexGarage = i
                else
                    exports['rhid-menu']:closeMenu()
                    exports['rhid-drawtext']:HideText()
                    AKendaraan = false
                end
            end)

            
            zoneMasukin = BoxZone:Create(coordsMasukin, 5.0, 10.0, {
                name = i,
                heading = g.SimpanKendaraan.w,
                debugPoly = g.debugPoly,
                minZ = g.SimpanKendaraan.z - 3,
                maxZ = g.SimpanKendaraan.z + 2
            })
            zoneMasukin:onPlayerInOut(function(zonaMsukin)
                if zonaMsukin then
                    if IsPedInAnyVehicle(PlayerPedId(), true) then
                        exports['rhid-drawtext']:DrawText("E - Simpan Kendaraan" .. "<br>" .. g.label)
                        MKendaraan = true
                        indexGarage = i
                    end
                else
                    exports['rhid-drawtext']:HideText()
                    MKendaraan = false
                end
            end)
        end
    end
end)

CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        for k, v in pairs(Config.CarGarages) do
            local MarkerCoords = vec3(v.AmbilKendaraan.x, v.AmbilKendaraan.y, v.AmbilKendaraan.z)
            local pedCoords = GetEntityCoords(PlayerPedId())
            local DistMarker = #(pedCoords - MarkerCoords)

            if DistMarker < 5 then
                DrawMarker(2, v.AmbilKendaraan.x, v.AmbilKendaraan.y, v.AmbilKendaraan.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0, 222, false, false, false, true, false, false, false)
                sleep = 0
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    local sleep
    while true do
        sleep = 1000
        if currentGarage ~= nil then
            if MKendaraan or AKendaraan then
                if IsControlJustPressed(0, 38) then
                    if MKendaraan then
                       if IsPedInAnyVehicle(PlayerPedId()) then
                            if GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                print("Masukin")
                                StoreOwnedCarsMenu(indexGarage)
                                exports['rhid-drawtext']:KeyPressed()
                                MKendaraan = false
                            else
                                print("Hanya Untuk Pengemudi Kendaraan")
                            end
                        else
                            exports['rhid-drawtext']:KeyPressed()
                            print("Harus Berada Di Dalam Kendaraan")
                        end
                    elseif AKendaraan then
                        if currentGarage.type == "impound" then
                            print("Impound")
                            ReturnOwnedCarsMenu({garage = currentGarage})
                        else
                            print("Public")
                            ListOwnedCarsMenu({garasi = indexGarage, spawner = currentGarage})
                        end
                    end
                end
                sleep = 0
            end
        end
        Wait(sleep)
    end
end)
