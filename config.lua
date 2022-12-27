Config = {}

Config.fuelLevel = "rhid-fuel"

Config.KickPossibleCheaters = false -- true = Kick Player that tries to Cheat Garage by changing Vehicle Hash/Plate.
Config.UseCustomKickMessage = false -- true = Sets Custom Kick Message for those that try to Cheat. Note: "Config.KickPossibleCheaters" must be true.

Config.PGarageBlip = {Sprite = 357, Color = 3, Display = 2, Scale = 0.8} 
Config.PoundBlip = {Sprite = 473, Color = 60, Display = 2, Scale = 0.8} 

Config.CarPoundPrice = 35000 -- How much it Costs to get Vehicle from Car Pound.

---- clietn notify 
Config.Notify = function (msg, type)
	return lib.defaultNotify({description = msg, status = type})
end

-- Start of Cars
Config.CarGarages = {
	Garasi_Motel = {
		useBlip = true,
		label = "Garasi Motel",
		propcoords = vec4(276.1044, -343.3794, 44.9199, 339.8335),
		Spawner = vec4(271.0853, -342.5992, 44.6496, 161.5497),

		--- zone delete Vehicle
		delcoords = vec3(279.6, -333.57, 44.92),
		dellength = 5.8,
		delwidth = 10,
		delheading = 70
	},
	Garasi_Kota = {
		useBlip = true,
		label = "Garasi Kota",
		propcoords = vec4(-282.8413, -888.6794, 31.0806, 75.0839),
		Spawner = vec4(-312.1350, -891.3203, 31.3518, 257.6216),

		--- zone delete Vehicle
		delcoords = vec3(-299.94, -884.81, 31.08),
		dellength = 6.0,
		delwidth = 10,
		delheading = 348
	},
	Garasi_Karnaval = {
		useBlip = true,
		label = "Garasi Karnaval",
		propcoords = vec4(-1625.2913, -958.7419, 8.1125, 55.0109),
		Spawner = vec4(-1628.4305, -948.9922, 8.5175, 319.7689),

		--- zone delete Vehicle
		delcoords = vec3(-1634.71, -961.51, 8.01),
		dellength = 5.2,
		delwidth = 10,
		delheading = 320
	},
	Garasi_Permai = {
		useBlip = true,
		label = "Garasi Permai",
		propcoords = vec4(1035.0675, -765.2919, 57.9955, 150.4061),
		Spawner = vec4(1041.0337, -776.9388, 58.2920, 11.2391),

		--- zone delete Vehicle
		delcoords = vec3(1025.29, -782.32, 58.02),
		dellength = 4.6,
		delwidth = 10,
		delheading = 309
	},
	Garasi_Shandy = {
		useBlip = true,
		label = "Garasi Shandy Shores",
		propcoords = vec4(1691.3849, 3585.7627, 35.6210, 295.2759),
		Spawner = vec4(1702.9312, 3599.0435, 35.7057, 209.3239),

		--- zone delete Vehicle
		delcoords = vec3(1693.72, 3590.74, 35.62),
		dellength = 6.6,
		delwidth = 5,
		delheading = 30
	},
	Garasi_Paleto = {
		useBlip = true,
		label = "Garasi Paleto",
		propcoords = vec4(121.3881, 6628.7422, 31.9290, 227.2483),
		Spawner = vec4(129.1089, 6623.7021, 32.0387, 134.6603),

		--- zone delete Vehicle
		delcoords = vec3(125.19, 6593.54, 31.99),
		dellength = 22.8,
		delwidth = 10,
		delheading = 45
	},
	Garasi_Federal = {
		useBlip = true,
		label = "Garasi Federal",
		propcoords = vec4(1828.3921, 2545.2014, 45.8806, 185.3308),
		Spawner = vec4(1864.2457, 2545.4282, 45.9450, 359.0323),

		--- zone delete Vehicle
		delcoords = vec3(1832.85, 2542.28, 45.88),
		dellength = 5.6,
		delwidth = 10,
		delheading = 0
	},
	Garasi_TolKiri = {
		useBlip = true,
		label = "Garasi Tol Kiri",
		propcoords = vec4(-3146.9487, 1113.5682, 20.8551, 252.7477),
		Spawner = vec4(-3143.7253, 1098.1029, 20.9663, 345.5481),

		--- zone delete Vehicle
		delcoords = vec3(-3136.87, 1098.36, 20.69),
		dellength = 6.9,
		delwidth = 10,
		delheading = 81
	},
}

Config.CarPounds = {
	Los_Santos = {
		useBlip = true,
		label = "Garasi Impound",
		propcoords = vector4(409.0651, -1622.8602, 29.2919, 236.1071),
		Spawner = vector4(405.3436, -1644.0187, 29.5655, 228.3524),
	},
}
-- -- End of Cars
