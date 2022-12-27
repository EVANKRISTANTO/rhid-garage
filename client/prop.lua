local time = 1000
function loadModel(model) 
    if not HasModelLoaded(model) then
        while not HasModelLoaded(model) do
            if time > 0 then time = time - 1 RequestModel(model)
            else time = 1000 break
            end
            Wait(10)
        end
    end 
end

function makeProp(data, freeze, synced)
    loadModel(data.prop)
    local prop = CreateObject(data.prop, data.coords.x, data.coords.y, data.coords.z-1.03, synced or 0, synced or 0, 0)
    SetEntityHeading(prop, data.coords.w-180.0)
    FreezeEntityPosition(prop, freeze or 0)
    return prop
end

AddEventHandler('onResourceStop', function(resource)
   if resource == GetCurrentResourceName() then
      DeleteObject(prop)
      DeleteEntity(prop)
   end
end)



CreateThread(function ()
    ---- public garages target
    for k, v in pairs(Config.CarGarages) do
    
        makeProp({coords = v.propcoords, prop = "prop_parkingpay"}, 1, 0)
  
        exports.ox_target:addBoxZone({ --- public garage
            coords = vec3(v.propcoords.x, v.propcoords.y, v.propcoords.z),
            size = vec3(0.8, 0.8, 2),
            rotation = v.propcoords.w,
            debug = false,
            options = {
                {
                    event = "rhid-garage:openListMenu",
                    icon = "fas fa-warehouse",
                    label = "Buka Garasi",
                    garasi = k,
                    spawner = v,
                }
            }
        })
    end

    ---- car impound target
    for k, v in pairs(Config.CarPounds) do
     
        makeProp({coords = v.propcoords, prop = "prop_parkingpay"}, 1, 0)
  
        exports.ox_target:addBoxZone({ --- impound garage
            coords = vec3(v.propcoords.x, v.propcoords.y, v.propcoords.z),
            size = vec3(0.8, 0.8, 2),
            rotation = v.propcoords.w,
            debug = false,
            options = {
                {
                    event = "rhid-garage:impoundMenu",
                    icon = "fas fa-warehouse",
                    label = "Akses Impound",
                    garage = v
                }
            }
        })
    end
end)