fx_version 'adamant'

game 'gta5'

description 'esx_advancedgarage costumize by RH'

Author 'Rey Hafizh'

version '1.0.0'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua',

    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua'
}

client_scripts {
	'client/main.lua',
	'client/prop.lua',
	'client/deleter.lua'
}

dependencies {
	'es_extended',
	'qb-menu',
	'qb-drawtext' 
}

lua54 'yes'