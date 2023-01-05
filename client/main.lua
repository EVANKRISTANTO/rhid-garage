local vehInstance, BlipList = {}, {}

Citizen.CreateThread(function()
	ESX.PlayerData = ESX.GetPlayerData()

	CreateBlips()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('GarageNotify', function(msg, type)
	Config.Notify(msg, type)
end)

-- Start of Car Code
function ListOwnedCarsMenu(data)
	local elements = {}

	ESX.TriggerServerCallback('rhid-garage:getOwnedCars', function(ownedCars)
		if #ownedCars == 0 then
			Config.Notify("Tidak ada kendaraan di dalam garasi")
		else

			elements = {
				{
					header = data.spawner.label,
					isMenuHeader = true
				}
			}

			for _,v in pairs(ownedCars) do
				local hashVehicule = v.vehicle.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate
				
				local eDamage = Round(v.vehicle.engineHealth)
				local bDamage = Round(v.vehicle.bodyHealth)
				local fLevel = Round(v.vehicle.fuelLevel)

				local Status
				local inGarage = "Di Dalam Garasi"
				local outGarage = "Di Luar Garasi"

				local disable
				local vehInGarage = false
				local vehOutGarage = true
				
				if v.stored == true then
					Status = inGarage
					disable = vehInGarage
				else
					disable = vehOutGarage
					Status = outGarage
				end

				-- print(json.encode(bDamage))

				elements[#elements+1] = {
					header = vehicleName.." ["..plate.."] <br>Status: "..Status, 
					txt = "Fuel: "..fLevel.." | Engine: "..eDamage.." | Body: "..bDamage,
					disabled = disable,
					params = {
						event = "rhid-garage:spawnVehicle",
						args = {
							vehicle = v.vehicle,
							plate = plate,
							stored = v.stored,
							spawner = data.spawner
						}
					}
				}
			end
			elements[#elements+1] = {
                header = "⬅ Kembali",
                txt = "",
                params = {
                    event = "qb-menu:closeMenu",
                }
            }
			exports['qb-menu']:openMenu(elements)
		end
	end, data.garasi)
end

RegisterNetEvent("rhid-garage:spawnVehicle", function(data)
	if data.stored then
		SpawnVehicle({vehicle = data.vehicle, plate = data.plate, spawner = data.spawner})
	else
		Config.Notify("Kendaraan kemu sedang berada di luar !", "error")
	end
end)

function StoreOwnedCarsMenu(garage)
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

		ESX.TriggerServerCallback('rhid-garage:storeVehicle', function(valid)
			if valid then
				StoreVehicle(vehicle, vehicleProps)	
			else
				Config.Notify("Kamu tidak bisa memasukkan kendaraan ini ke dalam garasi !", "error")
			end
		end, vehicleProps, garage)
	else
		Config.Notify("Kamu harus berada di dalam kendaraan !", "errro")
	end
end

function ReturnOwnedCarsMenu(data)
	local ImpoundMenu = {}

	ESX.TriggerServerCallback('rhid-garage:getOutOwnedCars', function(ownedCars)
		ImpoundMenu = {
			{
				header = "Asurani Kendaraan",
				isMenuHeader = true
			}
		}
		if #ownedCars == 0 then
			ImpoundMenu[#ImpoundMenu+1] = {
				header = "Tidak Ada Kendaraan",
				txt = "",
				disabled = true
			}
		else
	
			for _,v in pairs(ownedCars) do
				local hashVehicule = v.vehicle.model
				local aheadVehName = GetDisplayNameFromVehicleModel(hashVehicule)
				local vehicleName = GetLabelText(aheadVehName)
				local plate = v.plate

				local disabled 
				local inImpound = false
				local outImpound = true

				local text 
				local txtInImpound = "Impound Price: "..Config.CarPoundPrice
				local txtOutImpound = "Kendaraan tidak berada di asuransi"

				local doesVehicleExist = false

				for fck, you in pairs (vehInstance) do
					if ESX.Math.Trim(you.plate) == ESX.Math.Trim(plate) then
						if DoesEntityExist(you.vehicleentity) then
							doesVehicleExist = true
						else
							table.remove(vehInstance, fck)
							doesVehicleExist = false
						end
					end
				end

				if not doesVehicleExist and not DoesAPlayerDrivesVehicle(plate) then
					disabled = inImpound
					text = txtInImpound
				else
					disabled = outImpound
					text = txtOutImpound
				end
		
				ImpoundMenu[#ImpoundMenu+1] = {
					header = vehicleName.." ["..plate.."]", 
					txt = text,
					disabled = disabled,
					params = {
						event = "rhid-garage:takeImpound",
						args = {
							vehicle = v.vehicle,
							plate = plate,
							spawner = data.garage
							
						}
					}
				}
			end
		end
		ImpoundMenu[#ImpoundMenu+1] = {
			header = "⬅ Kembali",
			txt = "",
			params = {
				event = "qb-menu:closeMenu",
			}
		}
		exports['qb-menu']:openMenu(ImpoundMenu)
	end)
end
-- End of Car Code

RegisterNetEvent("rhid-garage:takeImpound", function (data)
	ESX.TriggerServerCallback('rhid-garage:checkMoneyCars', function(hasEnoughMoney)
		if hasEnoughMoney then
			if data.vehicle == nil then
			else
				SpawnVehicleImpoud({vehicle = data.vehicle, plate = data.plate, lokasi = data.spawner})
				TriggerServerEvent('rhid-garage:payCar')
			end
		else
			Config.Notify("Kamu tidak memiliki cukup uang untuk mengambil kendaraan !", "error")
		end
	end)
end)


-- Store Vehicles
function StoreVehicle(vehicle, props)
	local exitLocation = nil
	
	for k,v in pairs (vehInstance) do
		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(props.plate) then
			table.remove(vehInstance, k)
		end
	end

	for i = -1, 5, 1 do
		local ped = GetPedInVehicleSeat(vehicle, i)
		if ped then
			TaskLeaveVehicle(ped, vehicle, 0)
			TaskLeaveVehicle(ped, vehicle, 1)
			TaskLeaveVehicle(ped, vehicle, 2)
			TaskLeaveVehicle(ped, vehicle, 3)
			if exitLocation then
				SetEntityCoords(ped, exitLocation.x, exitLocation.y, exitLocation.z)
			end
		end
	end

	SetVehicleDoorsLocked(vehicle)


	Wait(1500)


	ESX.Game.DeleteVehicle(vehicle)
	TriggerServerEvent('rhid-garage:setVehicleState', props.plate, true)
	Config.Notify("Kendaraan berhasil di masukkan ke dalam garasi", "success")
end

local function doCarDamage(data)
 
	local mods = data.mods
	-- print(json.encode(mods))
	for k, v in pairs(mods.doorsBroken) do
		if v then
			SetVehicleDoorBroken(data.vehicle, tonumber(k), true)
		end
	end

	for k, v in pairs(mods.tyreBurst) do
		if v then
			SetVehicleTyreBurst(data.vehicle, tonumber(k), true)
		end
	end
end



-- Spawn Vehicles
function SpawnVehicle(data)
	local lokasiSpawn = ESX.Game.GetVehiclesInArea(vec3(data.spawner.Spawner.x, data.spawner.Spawner.y, data.spawner.Spawner.z), 4.0)
	if #lokasiSpawn <= 0 then
		ESX.Game.SpawnVehicle(data.vehicle.model, vec3(data.spawner.Spawner.x, data.spawner.Spawner.y, data.spawner.Spawner.z), data.spawner.Spawner.w, function(callback_vehicle)
			ESX.Game.SetVehicleProperties(callback_vehicle, data.vehicle)	
			SetVehRadioStation(callback_vehicle, "OFF")
			SetVehicleUndriveable(callback_vehicle, false)
			SetVehicleEngineOn(callback_vehicle, true, true)
			SetVehicleEngineHealth(callback_vehicle, data.vehicle.engineHealth) -- Might not be needed
			SetVehicleBodyHealth(callback_vehicle, data.vehicle.bodyHealth) -- Might not be needed
			exports[Config.fuelLevel]:SetFuel(callback_vehicle, data.vehicle.fuelLevel)
			doCarDamage({vehicle = callback_vehicle, mods = data.vehicle})
			local carplate = GetVehicleNumberPlateText(callback_vehicle)
			table.insert(vehInstance, {vehicleentity = callback_vehicle, plate = carplate})
			TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
			TriggerEvent("vehiclekeys:client:SetOwner", data.plate)
		end)
		TriggerServerEvent('rhid-garage:setVehicleState', data.plate, false)
	else
		Config.Notify("Tunggu lokasi spawn kendaraan kosong !")
	end
end

function SpawnVehicleImpoud(data)
	ESX.Game.SpawnVehicle(data.vehicle.model, vec3(data.lokasi.Spawner.x, data.lokasi.Spawner.y, data.lokasi.Spawner.z), data.lokasi.Spawner.w, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, data.vehicle)
		SetVehRadioStation(callback_vehicle, "OFF")
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		SetVehicleEngineHealth(callback_vehicle, data.vehicle.engineHealth) -- Might not be needed
		SetVehicleBodyHealth(callback_vehicle, data.vehicle.bodyHealth) -- Might not be needed
		exports[Config.fuelLevel]:SetFuel(callback_vehicle, data.vehicle.fuelLevel)
		doCarDamage({vehicle = callback_vehicle, mods = data.vehicle})	
		local carplate = GetVehicleNumberPlateText(callback_vehicle)
		table.insert(vehInstance, {vehicleentity = callback_vehicle, plate = carplate})
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
	end)
	TriggerServerEvent('rhid-garage:setVehicleState', data.plate, false)
end

-- Check Vehicles
function DoesAPlayerDrivesVehicle(plate)
	local isVehicleTaken = false
	local players = ESX.Game.GetPlayers()
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		if target ~= PlayerPedId() then
			local plate1 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, true))
			local plate2 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, false))
			if plate == plate1 or plate == plate2 then
				isVehicleTaken = true
				break
			end
		end
	end
	return isVehicleTaken
end


function CreateBlips()
	local blip
	for k,v in pairs(Config.CarGarages) do
		if v.useBlip == true then
			if v.type == "impound" then
				blip = AddBlipForCoord(vec3(v.AmbilKendaraan.x, v.AmbilKendaraan.y, v.AmbilKendaraan.z))
				SetBlipSprite (blip, Config.PoundBlip.Sprite)
				SetBlipColour (blip, Config.PoundBlip.Color)
				SetBlipDisplay(blip, Config.PoundBlip.Display)
				SetBlipScale  (blip, Config.PoundBlip.Scale)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.label)
				EndTextCommandSetBlipName(blip)
				table.insert(BlipList, blip)
			else
				blip = AddBlipForCoord(vec3(v.AmbilKendaraan.x, v.AmbilKendaraan.y, v.AmbilKendaraan.z))
				SetBlipSprite (blip, Config.PGarageBlip.Sprite)
				SetBlipColour (blip, Config.PGarageBlip.Color)
				SetBlipDisplay(blip, Config.PGarageBlip.Display)
				SetBlipScale  (blip, Config.PGarageBlip.Scale)
				SetBlipAsShortRange(blip, true)
				BeginTextCommandSetBlipName("STRING")
				AddTextComponentString(v.label)
				EndTextCommandSetBlipName(blip)
				table.insert(BlipList, blip)
			end
		end
	end
end

