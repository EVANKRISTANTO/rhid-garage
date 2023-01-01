Config = {}

Config.fuelLevel = "rhid-fuel"

Config.KickPossibleCheaters = true -- true = Kick Player that tries to Cheat Garage by changing Vehicle Hash/Plate.
Config.UseCustomKickMessage = true -- true = Sets Custom Kick Message for those that try to Cheat. Note: "Config.KickPossibleCheaters" must be true.

Config.PGarageBlip = {Sprite = 357, Color = 3, Display = 2, Scale = 0.8} 
Config.PoundBlip = {Sprite = 473, Color = 60, Display = 2, Scale = 0.8} 


Config.CarPoundPrice = 35000 -- How much it Costs to get Vehicle from Car Pound.

Config.Notify = function (msg, type)
	lib.defaultNotify({description = msg, status = type})
end

Config.MarkerDist = 10

-- Start of Cars
Config.CarGarages = {
	Garasi_Motel = {
		useBlip = true,
		label = "Garasi Motel",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(275.6310, -345.0410, 45.1734, 339.9729),
		SimpanKendaraan = vec4(279.4214, -333.5352, 44.6493, 249.0761),
		Spawner = vec4(270.7225, -343.6201, 44.6495, 158.2901),
	},
	Garasi_Kota = {
		useBlip = true,
		label = "Garasi Kota",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(-281.0736, -888.1171, 31.3180, 157.0090),
		SimpanKendaraan = vec4(-303.9352, -884.4565, 31.3525, 347.6553),
		Spawner = vec4(-311.0177, -891.7442, 31.3530, 259.1978),
	},
	Garasi_Karnaval = {
		useBlip = true,
		label = "Garasi Karnaval",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(-1625.2913, -958.7419, 8.1125, 55.0109),
		SimpanKendaraan = vec4(-1628.0321, -948.8911, 7.9823, 139.4559),
		Spawner = vec4(-1624.5908, -944.4270, 8.1049, 319.8697),
	},
	Garasi_Permai = {
		useBlip = true,
		label = "Garasi Permai",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(1036.3306, -763.2114, 57.9930, 144.7824),
		SimpanKendaraan = vec4(1046.3700, -780.1360, 58.2770, 271.5609),
		Spawner = vec4(1040.4419, -774.8251, 58.2920, 5.6404),
	},
	Garasi_Shandy = {
		useBlip = true,
		label = "Garasi Shandy Shores",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(1691.5182, 3585.8867, 35.6210, 307.9250),
		SimpanKendaraan = vec4(1694.3833, 3590.0046, 35.8934, 31.3872),
		Spawner = vec4(1703.0291, 3597.6235, 35.7105, 218.2937),
	},
	Garasi_Paleto = {
		useBlip = true,
		label = "Garasi Paleto",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(122.7772, 6626.5420, 31.9343, 234.3556),
		SimpanKendaraan = vec4(123.3776, 6594.5508, 32.2689, 137.2604),
		Spawner = vec4(127.2175, 6624.0249, 32.0616, 135.2615),
	},
	Garasi_Federal = {
		useBlip = true,
		label = "Garasi Federal",
		debugPoly = false,
		type = "public",
		AmbilKendaraan = vec4(1828.5775, 2545.1851, 45.8806, 9.3637),
		SimpanKendaraan = vec4(1833.0913, 2541.8926, 45.8806, 0.8108),
		Spawner = vec4(1860.2338, 2542.2761, 45.9445, 359.7830),
	},


	--------------------------------------------------==== Car Impound ====--------------------------------------------------
	Asuransi_Kendaraan = {
		useBlip = true,
		label = "Asuransi Kendaraan",
		debugPoly = false,
		type = "impound",
		AmbilKendaraan = vector4(409.0651, -1622.8602, 29.2919, 236.1071),
		Spawner = vector4(405.3436, -1644.0187, 29.5655, 228.3524),
	},
}

-- -- End of Cars
