-- Start of Car Code
ESX.RegisterServerCallback('rhid-garage:getOwnedCars', function(source, cb, garage)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle, stored, plate FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND garage = @garage AND owned_vehicles.plate NOT IN (SELECT plate from h_impounded_vehicles);', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@job'] = 'civ',
		['@stored'] = true,
		['@garage'] = garage,
	}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate, fuel = v.fuelLevel, engine = v.vehicle.engineHealt, body = v.vehicle.bodyHealt})
		end
		cb(ownedCars)
	end)

end)

ESX.RegisterServerCallback('rhid-garage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle, stored, plate FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job  AND `stored` = @stored AND owned_vehicles.plate NOT IN (SELECT plate from h_impounded_vehicles);', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@job'] = 'civ',
		['@stored'] = false
		
	}, function(data)
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, {vehicle = vehicle, plate = v.plate})
		end
		cb(ownedCars)
	end)
end)

ESX.RegisterServerCallback('rhid-garage:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('rhid-garage:payCar')
AddEventHandler('rhid-garage:payCar', function()
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)
	xPlayer.removeMoney(Config.CarPoundPrice)
	xPlayer.triggerEvent("GarageNotify", "Kamu membayar $" .. Config.CarPoundPrice.." untuk asuransi kendaraan kamu !")
end)
-- End of Car Code

-- Store Vehicles
ESX.RegisterServerCallback('rhid-garage:storeVehicle', function (source, cb, vehicleProps, garage)
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle, garage = @garage WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate,
					['@garage'] = garage
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('rhid-garage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('rhid-garage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))

						DropPlayer(source, "Jangan Cheat Ya !!")
						cb(false)
					else
						print(('rhid-garage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))

						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('rhid-garage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: '.. originalvehprops.model):format(xPlayer.identifier))
					cb(false)
				end
			end
		else
			print(('rhid-garage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
			cb(false)
		end
	end)
end)


-- Modify State of Vehicles
RegisterServerEvent('rhid-garage:setVehicleState')
AddEventHandler('rhid-garage:setVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('rhid-garage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
