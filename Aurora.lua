----------------------------------------------------------------------------------------------------------
-- Welcome to "Aurora"! Dont copy or use it as your script.
-- Warning: Codes were taken from other scripts and are therefore not my codes. DO NOT PUBLISH THE SCRIPT!
-- Creator: I3lackExo.
----------------------------------------------------------------------------------------------------------
-- [[ Aurora Script ]]
	local Name = "Aurora for Stand"
	local Version = 4.4
	local DevName = "I3lackExo."
	local GTAOVersion = "1.68"
	local GameVersion = "3179"

	require("lib/AuroraScript/Natives")
	local required <const> = {"lib/AuroraScript/Natives.lua"}
	local Natives = require "AuroraScript.Natives"

	local LogFile = filesystem.scripts_dir() .. "lib\\AuroraScript\\" .. "Log" .. ".log"
	local HistoryFile = filesystem.scripts_dir() .. "lib\\AuroraScript\\" .. "Playerhistory" .. ".log"

	-- [[ Github Update ]]
	-- Script Updater
		local response = false
			async_http.init("raw.githubusercontent.com", "/I3lackExo/AuroraScript/main/lib/Version.lua", function(output)
				currentVer = tonumber(output)
				response = true
				if Version ~= currentVer then
					menu.action(menu.my_root(), "Update Aurora", {}, "", function()
						async_http.init("raw.githubusercontent.com","/I3lackExo/AuroraScript/main/Aurora.lua",function(a)
							local err = select(2,load(a))
							if err then
								--util.show_corner_help("~r~Script failed to download. Please try again later. If this continues to happen then manually update via github.")
								util.toast("[Mira] <3\n".."> There seems to be an error... Please try again later.")
							return end
							local f = io.open(filesystem.scripts_dir()..SCRIPT_RELPATH, "wb")
							f:write(a)
							f:close()
							--util.show_corner_help("~g~Successfully updated ExoScript.")
							util.toast("[Mira] <3\n".."> Update is successfully downloaded.")
							util.yield(1250)
							util.restart_script()
						end)
						async_http.dispatch()
					end)
				end
			end, function() response = true end)
			async_http.dispatch()
			repeat 
				util.yield()
			until response
	-- Native Updater
		local nativeresponse = false
			async_http.init("raw.githubusercontent.com", "/I3lackExo/AuroraScript/main/lib/NativeVersion.lua", function(output)
				currentVer = tonumber(output)
				nativeresponse = true
				if NativeVersion ~= currentVer then
					local path_root = filesystem.scripts_dir() .."lib/AuroraScript/"
						async_http.init("raw.githubusercontent.com","/I3lackExo/ExoScript/main/lib/Natives.lua",function(a)
							local err = select(2,load(a))
							if err then
								--util.toast("Failed to update Natives.lua, please download it manually.\nThe link is copied in your clipboard.")
								util.toast("[Mira] <3\n".."> There seems to be an error, please download it manually... I copied the link in your clipboard.")
								util.copy_to_clipboard("https://github.com/I3lackExo/AuroraScript/blob/main/lib/Natives.lua", true)
							return end
							local f = io.open(path_root.."Natives.lua", "wb")
							f:write(a)
							f:close()
							--util.toast("Successfully updated Natives.lua from the repository.")
							util.toast("[Mira] <3\n".."> Successfully updated Natives.lua.")
						end)
						async_http.dispatch()
				end
			end, function() nativeresponse = true end)
			async_http.dispatch()
			repeat 
				util.yield()
			until nativeresponse
	-- Logo Updater
		local icon
			if not filesystem.exists(filesystem.scripts_dir() .. "lib/AuroraScript/icon.png") then
				local path_root = filesystem.scripts_dir() .."lib/AuroraScript/"
				async_http.init("raw.githubusercontent.com", "/I3lackExo/AuroraScript/main/lib/icon.png", function(req)
					if not req then
						--util.toast("Failed to download C4tScripts/stand_icon.png, please download it manually.\nThe link is copied in your clipboard.")
						util.copy_to_clipboard("https://github.com/I3lackExo/AuroraScript/blob/main/lib/icon.png", true)
						return 
					end
					filesystem.mkdir(path_root)
					local f = io.open(path_root.."icon.png", "wb")
					f:write(req)
					f:close()
					--util.toast("Successfully downloaded icon.png from the repository.")
					icon = directx.create_texture(filesystem.scripts_dir() .. "lib/AuroraScript/icon.png")
				end)
				async_http.dispatch()
			else
				icon = directx.create_texture(filesystem.scripts_dir() .. "lib/AuroraScript/icon.png")
			end

	menu.divider(menu.my_root(), "~~~> "..Name.." <~~~")
	local selfoptions = menu.list(menu.my_root(), "Self Options")
	local playerslist = menu.list(menu.my_root(), "Custom Playerlist")
	local onlineoptions = menu.list(menu.my_root(), "Online Options")
	local weaponsoptions = menu.list(menu.my_root(), "Weapon Options")
	local vehicleoptions = menu.list(menu.my_root(), "Vehicle Options")
	local miscoptions = menu.list(menu.my_root(), "Misc Options")
	local settings = menu.list(menu.my_root(), "Settings")
	local credits = menu.list(menu.my_root(), "Credits")
	local admin_bail = true
	menu.toggle(menu.my_root(), "R* Admin Protection", {}, "", function(on)
		if on then
			admin_bail = on
			util.toast("[Mira] <3\n".."> Okay, I will notify you when I see an admin.")
		else
			admin_bail = off
			util.toast("[Mira] <3\n".."> Warning: If you meet an admin the risk of being banned is high.")

			while admin_bail do
				if util.is_session_started() then
					for _, pid in players.list(false, true, true) do 
						if players.is_marked_as_admin(pid) then 
							util.toast("[Mira] <3\n".."> I have spotted an admin. Launch protective countermeasures. (Admin: "..players.get_name(pid)..")")
							log("R* Admin Protection: (Playername: "..players.get_name(pid).." / RID: "..players.get_rockstar_id(pid))
							util.yield(1500)
							menu.trigger_commands("quickbail")
						end    
					end
				end
				util.yield()
			end
		end end, true)

	-- [[ Locals ]]
		local levelPly = 120
		local delayPly = 0
		local rpLoopPlyr

		local lockon
		local x, y = 0.992, 0.008
		local add_x = 0.0055
		local add_y = 0.0
		local show_name = true,
		local show_rid = false,
		local show_sessioncode = true,
		local show_gtaversion = true;
		local show_time = true,
		--local show_players = false,
		local show_firstl = 2
		bg_color = {["r"] = 0.0, ["g"] = 0.0, ["b"] = 0.0, ["a"] = 0.571}
		tx_color = {["r"] = 1.0, ["g"] = 1.0, ["b"] = 1.0, ["a"] = 1.0}
		local utils = {edition = menu.get_edition(), editions = {"Free", "Basic", "Regular", "Ultimate"}}

		local player = players.user_ped()
		local agroup = "missfbi3ig_0"
		local anim1 = "shit_loop_trev"
		local particleName = "ent_anim_dog_peeing"
		local mshit = util.joaat("prop_big_shit_02")
		local rshit = util.joaat("prop_big_shit_01")
		local ashit = util.joaat("ng_proc_sodacan_01a")
		local mshit2 = util.joaat("ex_prop_crate_money_bc")
		local basePrint = print

		local whitelisted_langs = {}
		local language_codes_by_enum = {
			[0]= "en",
			[1]= "fr",
			[2]= "de",
			[3]= "it",
			[4]= "es",
			[5]= "pt",
			[6]= "pl",
			[7]= "ru",
			[8]= "ko",
			[9]= "zh",
			[10] = "ja",
			[11] = "es",
			[12] = "zh"}
			for _, iso_code in pairs(language_codes_by_enum) do
				whitelisted_langs[iso_code] = true end
		local language_display_names_by_enum = {
			[0] = "English",
			[1] = "French",
			[2] = "German",
			[3] = "Italian",
			[4] = "Spanish",
			[5] = "Portuguese",
			[6] = "Polish",
			[7] = "Russian",
			[8] = "Korean",
			[9] = "Chinese (Traditional)",
			[10] = "Japanese",
			[11] = "Mexican",
			[12] = "Chinese (Simplified)"}
		local my_lang = lang.get_current()
			if my_lang == "en-us" then 
				my_lang = "en" end
		local do_translate = false
		local only_translate_foreign = true
		local players_on_cooldown = {}

		local chatColor = 27
		local colors = {
			{-1, "Default"},
			{1, "White"},
			{27, "Red"},
			{26, "Blue"},
			{18, "Green"},
			{37, "Teal"},
			{21, "Purple"},
			{24, "Magenta"},
			{30, "Pink"},
			{45, "Pastel Pink"},
			{46, "Lime Green"},
			{12, "Yellow"},
			{15, "Orange"},}
		local color = {
			green = 184, 
			red = 6,
			orange = 15,
			yellow = 190,
			black = 2,
			white = 1,
			gray = 3,
			pink = 24,
			purple = 21,
			blue = 11,
			lightblue = 10,
			cyan = 9}
		local colorcodes = {
			red = "~r~",
			blue = "~b~",
			green = "~g~",
			yellow = "~y~",
			purple = "~p~",
			pink = "~q~",
			orange = "~o~",
			grey = "~c~",
			grey2 = "~t~",
			black = "~u~",
			black2 = "~l~",
			white = "~w~",
			white2 = "~s~",
			boldtext = "~h~",
			italics = "<i>",
			logo = "~ex_r*~",
			small = "<font size='10'>",
			middle = "<font size='12'>"}

		local annoy_tgl
		local orb_delay = 1000
		local infibounty_amt = 10000
		local hud_rgb_index = 1
		local hud_rgb_colors = {6, 6, 6}

		local placed_firework_rockets = {}
		local placed_firework_cones = {}
		local placed_firework_fontains = {}
		local placed_firework_boxes = {}

		local module_base <const> = memory.scan("")
		if not module_base then util.toast("Cant Load") return end
		local vehicle_data_t <const> ={lazer_t = {p99_explosive_type = module_base + 0x1037C03,alter_wait_time = module_base + 0x1E458B0,shoot_between_time = module_base + 0x1E45734 },}

		local SessionBrokenAlteredSHQueue = false
		local SessionBrokenBadScriptEvent = false
		local SessionBrokenAlteredSHMigration = false
		local SessionBrokenModifiedEntityState = false
		local SessionBrokenOutOfRangeWorldRender = false
		local InvalidPickupPlacement = false
		local SessionBrokenGameServerModify = false
		local SessionBrokenModifiedWeather = false
		local all_session_flags = ""
		local all_session_flags_count = 0
		local altered_sh_queue = false
		local missing_session_host = false
		local missing_script_host = false
		local bad_script_event = false
		local altered_sh_migration = false
		local modified_entity_state = false
		local out_of_range_world_render = false
		local invalid_pickup_placement = false
		local game_server_modify = false
		local modified_weather = false
		local players_car = entities.get_user_vehicle_as_handle()
		local carSettings carSettings = {}
		local kills_ptr = memory.alloc_int()
		local deaths_ptr = memory.alloc_int()
		local Int_PTR = memory.alloc_int()
		local thrust_offset = 0x8
		local last_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
		local better_heli_handling_offsets = {["fYawMult"] = 0x18, ["fYawStabilise"] = 0x20, ["fSideSlipMult"] = 0x24, ["fRollStabilise"] = 0x30, ["fAttackLiftMult"] = 0x48, ["fAttackDiveMult"] = 0x4C, ["fWindMult"] = 0x58, ["fPitchStabilise"] = 0x3C}
		local values = {[0] = 0, [1] = 50, [2] = 88, [3] = 160, [4] = 208,}
		local interiors = {
			{"Safe Space [AFK Room]", {x=-158.71494, y=-982.75885, z=149.13135}},
			{"Mission Garage [AFK Room]", {x=402.0445, y=-970.0147, z=-99.00417}},
			{"Snipespot-1 (Glitched/PVP)", {x=-1088.6375, y=-2721.819, z=13.978062}},
			{"Snipespot-2 (Glitched/PVP)", {x=-1280.4398, y=-2655.9102, z=14.045677}},
			{"Alien Room (Halloween)", {x=-1876, y=3750, z=-100}},}
		local orbitalTableCords = {
			[1] = { x = 330.48312, y = 4827.281, z = -59.368515 },
			[2] = { x = 327.5724,  y = 4826.48,  z = -59.368515 },
			[3] = { x = 325.95273, y = 4828.985, z = -59.368515 },
			[4] = { x = 327.79208, y = 4831.288, z = -59.368515 },
			[5] = { x = 330.61765, y = 4830.225, z = -59.368515 },}
		local attachments_table = {
			["0xFED0FD71"] = "Default Mag", --Default Clip
			["0xED265A1C"] = "Extended Mag", --Extended Clip
			["0x359B7AAE"] = "Flashlight", --Flashlight
			["0x65EA7EBB"] = "Suppressor", --Suppressor
			["0xD7391086"] = "Yusuf Amir Luxury Finish", --Yusuf Amir Luxury Finish
			["0x721B079"] = "Default Mag", --Default Clip
			["0xD67B4F2D"] = "Extended Mag", --Extended Clip
			["0xC304849A"] = "Suppressor", --Suppressor
			["0xC6654D72"] = "Yusuf Amir Luxury Finish", --Yusuf Amir Luxury Finish
			["0x31C4B22A"] = "Default Mag", --Default Clip
			["0x249A17D5"] = "Extended Mag", --Extended Clip
			["0x9B76C72C"] = "Gilded Gun Metal Finish", --Gilded Gun Metal Finish
			["0x2297BE19"] = "Default Mag", --Default Clip
			["0xD9D3AC92"] = "Extended Mag", --Extended Clip
			["0xA73D4664"] = "Suppressor", --Suppressor
			["0x77B8AB2F"] = "Platinum Pearl Deluxe Finish", --Platinum Pearl Deluxe Finish
			["0x16EE3040"] = "VIP Variant", --VIP Variant
			["0x9493B80D"] = "Bodyguard Variant", --Bodyguard Variant
			["0xE9867CE3"] = "Default Mag", --Default Clip
			["0xF8802ED9"] = "Default Mag", --Default Clip
			["0x7B0033B3"] = "Extended Mag", --Extended Clip
			["0x8033ECAF"] = "Etched Wood Grip Finish", --Etched Wood Grip Finish
			["0xD4A969A"] = "Default Mag", --Default Clip
			["0x64F9C62B"] = "Extended Mag", --Extended Clip
			["0x7A6A7B7B"] = "Etched Wood Grip Finish", --Etched Wood Grip Finish
			["0xBA23D8BE"] = "Default Rounds", --Default Rounds
			["0xC6D8E476"] = "Tracer Rounds", --Tracer Rounds
			["0xEFBF25"] = "Incendiary Rounds", --Incendiary Rounds
			["0x10F42E8F"] = "Hollow Point Rounds", --Hollow Point Rounds
			["0xDC8BA3F"] = "Full Metal Jacket Rounds", --Full Metal Jacket Rounds
			["0x420FD713"] = "Holographic Sight", --Holographic Sight
			["0x49B2945"] = "Small Scope", --Small Scope
			["0x27077CCB"] = "Compensator", --Compensator
			["0xC03FED9F"] = "Digital Camo", --Digital Camo
			["0xB5DE24"] = "Brushstroke Camo", --Brushstroke Camo
			["0xA7FF1B8"] = "Woodland Camo", --Woodland Camo
			["0xF2E24289"] = "Skull", --Skull
			["0x11317F27"] = "Sessanta Nove", --Sessanta Nove
			["0x17C30C42"] = "Perseus", --Perseus
			["0x257927AE"] = "Leopard", --Leopard
			["0x37304B1C"] = "Zebra", --Zebra
			["0x48DAEE71"] = "Geometric", --Geometric
			["0x20ED9B5B"] = "Boom!", --Boom!
			["0xD951E867"] = "Patriotic", --Patriotic
			["0x1466CE6"] = "Default Mag", --Default Clip
			["0xCE8C0772"] = "Extended Mag", --Extended Clip
			["0x902DA26E"] = "Tracer Rounds", --Tracer Rounds
			["0xE6AD5F79"] = "Incendiary Rounds", --Incendiary Rounds
			["0x8D107402"] = "Hollow Point Rounds", --Hollow Point Rounds
			["0xC111EB26"] = "Full Metal Jacket Rounds", --Full Metal Jacket Rounds
			["0x4A4965F3"] = "Flashlight", --Flashlight
			["0x47DE9258"] = "Mounted Scope", --Mounted Scope
			["0xAA8283BF"] = "Compensator", --Compensator
			["0xF7BEEDD"] = "Digital Camo", --Digital Camo
			["0x8A612EF6"] = "Brushstroke Camo", --Brushstroke Camo
			["0x76FA8829"] = "Woodland Camo", --Woodland Camo
			["0xA93C6CAC"] = "Skull", --Skull
			["0x9C905354"] = "Sessanta Nove", --Sessanta Nove
			["0x4DFA3621"] = "Perseus", --Perseus
			["0x42E91FFF"] = "Leopard", --Leopard
			["0x54A8437D"] = "Zebra", --Zebra
			["0x68C2746"] = "Geometric", --Geometric
			["0x2366E467"] = "Boom!", --Boom!
			["0x441882E6"] = "Boom!", --Boom!
			["0xE7EE68EA"] = "Digital Camo", --Digital Camo
			["0x29366D21"] = "Brushstroke Camo", --Brushstroke Camo
			["0x3ADE514B"] = "Woodland Camo", --Woodland Camo
			["0xE64513E9"] = "Skull", --Skull
			["0xCD7AEB9A"] = "Sessanta Nove", --Sessanta Nove
			["0xFA7B27A6"] = "Perseus", --Perseus
			["0xE285CA9A"] = "Leopard", --Leopard
			["0x2B904B19"] = "Zebra", --Zebra
			["0x22C24F9C"] = "Geometric", --Geometric
			["0x8D0D5ECD"] = "Boom!", --Boom!
			["0x1F07150A"] = "Patriotic", --Patriotic
			["0x94F42D62"] = "Default Mags", --Default Clip
			["0x5ED6C128"] = "Extended Mags", --Extended Clip
			["0x25CAAEAF"] = "Tracer Rounds", --Tracer Rounds
			["0x2BBD7A3A"] = "Incendiary Rounds", --Incendiary Rounds
			["0x85FEA109"] = "Hollow Point Rounds", --Hollow Point Rounds
			["0x4F37DF2A"] = "Full Metal Jacket Rounds", --Full Metal Jacket Rounds
			["0x8ED4BB70"] = "Mounted Scope", --Mounted Scope
			["0x43FD595B"] = "Flashlight", --Flashlight
			["0x21E34793"] = "Compensator", --Compensator
			["0x5C6C749C"] = "Digital Camo", --Digital Camo
			["0x15F7A390"] = "Brushstroke Camo", --Brushstroke Camo
			["0x968E24DB"] = "Woodland Camo", --Woodland Camo
			["0x17BFA99"] = "Skull", --Skull
			["0xF2685C72"] = "Sessanta Nove", --Sessanta Nove
			["0xDD2231E6"] = "0xDD2231E6", --Perseus
			["0xBB43EE76"] = "Leopard", --Leopard
			["0x4D901310"] = "Zebra", --Zebra
			["0x5F31B653"] = "Geometric", --Geometric
			["0x697E19A0"] = "Boom!", --Boom!
			["0x930CB951"] = "Patriotic", --Patriotic
			["0xB4FC92B0"] = "Digital Camo", --Digital Camo
			["0x1A1F1260"] = "Digital Camo", --Digital Camo
			["0xE4E00B70"] = "Digital Camo",
			["0x2C298B2B"] = "Digital Camo",
			["0xDFB79725"] = "Digital Camo",
			["0x6BD7228C"] = "Digital Camo",
			["0x9DDBCF8C"] = "Digital Camo",
			["0xB319A52C"] = "Digital Camo",
			["0xC6836E12"] = "Digital Camo",
			["0x43B1B173"] = "Digital Camo",
			["0x4ABDA3FA"] = "Patriotic", --Patriotic
			["0x45A3B6BB"] = "Default Mag", --Default Clip
			["0x33BA12E8"] = "Extended Mag", --Extended Clip
			["0xD7DBF707"] = "Festive tint", --Festive tint
			["0x54D41361"] = "Default Mag", --Default Clip
			["0x81786CA9"] = "Extended Mag", --Extended Clip
			["0x9307D6FA"] = "Suppressor", --Suppressor
			["0x1663E75E"] = "Default Mag",
			["0x1E02B7E0"] = "Suppressor",
			["0xCB48AEF0"] = "Default Mag",
			["0x10E6BA2B"] = "Extended Mag",
			["0x359B7AAE"] = "Flashlight",
			["0x9D2FBF29"] = "Scope",
			["0x487AAE09"] = "Yusuf Amir Luxury Finish",
			["0x26574997"] = "Default Mag",
			["0x350966FB"] = "Extended Mag",
			["0x79C77076"] = "Drum Magazine",
			["0x7BC4CDDC"] = "Flashlight",
			["0x3CC6BA57"] = "Scope",
			["0x27872C90"] = "Yusuf Amir Luxury Finish",
			["0x8D1307B0"] = "Default Mag",
			["0xBB46E417"] = "Extended Mag",
			["0x278C78AF"] = "Yusuf Amir Luxury Finish",
			["0x84C8B2D3"] = "Default Mag",
			["0x937ED0B7"] = "Extended Mag",
			["0x4C24806E"] = "Default Mag",
			["0xB9835B2E"] = "Extended Mag",
			["0x7FEA36EC"] = "Tracer Rounds",
			["0xD99222E5"] = "Incendiary Rounds",
			["0x3A1BD6FA"] = "Hollow Point Rounds",
			["0xB5A715F"] = "Full Metal Jacket Rounds",
			["0x9FDB5652"] = "Holographic Sight",
			["0xE502AB6B"] = "Small Scope",
			["0x3DECC7DA"] = "Medium Scope",
			["0xB99402D4"] = "Flat Muzzle Brake",
			["0xC867A07B"] = "Tactical Muzzle Brake",
			["0xDE11CBCF"] = "Fat-End Muzzle Brake",
			["0xEC9068CC"] = "Precision Muzzle Brake",
			["0x2E7957A"] = "Heavy Duty Muzzle Brake",
			["0x347EF8AC"] = "Slanted Muzzle Brake",
			["0x4DB62ABE"] = "Split-End Muzzle Brake",
			["0xD9103EE1"] = "Default Barrel",
			["0xA564D78B"] = "Heavy Barrel",
			["0xC4979067"] = "Digital Camo",
			["0x3815A945"] = "Brushstroke Camo",
			["0x4B4B4FB0"] = "Woodland Camo",
			["0xEC729200"] = "Skull",
			["0x48F64B22"] = "Sessanta Nove",
			["0x35992468"] = "Perseus",
			["0x24B782A5"] = "Leopard",
			["0xA2E67F01"] = "Zebra",
			["0x2218FD68"] = "Geometric",
			["0x45C5C3C5"] = "Boom!",
			["0x399D558F"] = "Patriotic",
			["0x476E85FF"] = "Default Mag",
			["0xB92C6979"] = "Extended Mag",
			["0xA9E9CAF4"] = "Drum Magazine",
			["0x4317F19E"] = "Default Mag",
			["0x334A5203"] = "Extended Mag",
			["0x6EB8C8DB"] = "Drum Magazine",
			["0xC164F53"] = "Grip",
			["0xAA2C45B4"] = "Scope",
			["0xE608B35E"] = "Suppressor",
			["0xA2D79DDB"] = "Yusuf Amir Luxury Finish",
			["0x85A64DF9"] = "Gilded Gun Metal Finish",
			["0x94E81BC7"] = "Default Mag",
			["0x86BD7F72"] = "Extended Mag",
			["0x837445AA"] = "Suppressor",
			["0xCD940141"] = "Default Shells",
			["0x9F8A1BF5"] = "Dragon's Breath Shells",
			["0x4E65B425"] = "Steel Buckshot Shells",
			["0xE9582927"] = "Flechette Shells",
			["0x3BE4465D"] = "Explosive Slugs",
			["0x3F3C8181"] = "Medium Scope",
			["0xAC42DF71"] = "Suppressor",
			["0x5F7DCE4D"] = "Squared Muzzle Brake	",
			["0xE3BD9E44"] = "Digital Camo",
			["0x17148F9B"] = "Brushstroke Camo",
			["0x24D22B16"] = "Woodland Camo",
			["0xF2BEC6F0"] = "Skull",
			["0x85627D"] = "Sessanta Nove",
			["0xDC2919C5"] = "Perseus",
			["0xE184247B"] = "Leopard",
			["0xD8EF9356"] = "Zebra",
			["0xEF29BFCA"] = "Geometric",
			["0x67AEB165"] = "Boom!",
			["0x46411A1D"] = "Patriotic",
			["0x324F2D5F"] = "Default Mag",
			["0x971CF6FD"] = "Extended Mag",
			["0x88C7DA53"] = "Drum Magazine",
			["0xBE5EEA16"] = "Default Mag",
			["0xB1214F9B"] = "Extended Mag",
			["0xDBF0A53D"] = "Drum Magazine",
			["0x4EAD7533"] = "Yusuf Amir Luxury Finish",
			["0x9FBE33EC"] = "Default Mag",
			["0x91109691"] = "Extended Mag",
			["0xBA62E935"] = "Box Magazine",
			["0xA0D89C42"] = "Scope",
			["0xD89B9658"] = "Yusuf Amir Luxury Finish",
			["0xFA8FA10F"] = "Default Mag",
			["0x8EC1C979"] = "Extended Mag",
			["0x377CD377"] = "Gilded Gun Metal Finish",
			["0xC6C7E581"] = "Default Mag",
			["0x7C8BD10E"] = "Extended Mag",
			["0x6B59AEAA"] = "Drum Magazine",
			["0x730154F2"] = "Etched Gun Metal Finish",
			["0xC5A12F80"] = "Default Mag",
			["0xB3688B0F"] = "Extended Mag",
			["0xA857BC78"] = "Gilded Gun Metal Finish",
			["0x18929DA"] = "Default Mag",
			["0xEFB00628"] = "Extended Mag",
			["0x822060A9"] = "Tracer Rounds",
			["0xA99CF95A"] = "Incendiary Rounds",
			["0xFAA7F5ED"] = "Armor Piercing Rounds",
			["0x43621710"] = "Full Metal Jacket Rounds",
			["0xC7ADD105"] = "Small Scope",
			["0x659AC11B"] = "Default Barrel",
			["0x3BF26DC7"] = "Heavy Barrel",
			["0x9D65907A"] = "Grip",
			["0xAE4055B7"] = "Digital Camo",
			["0xB905ED6B"] = "Brushstroke Camo",
			["0xA6C448E8"] = "Woodland Camo",
			["0x9486246C"] = "Skull",
			["0x8A390FD2"] = "Sessanta Nove",
			["0x2337FC5"] = "Perseus",
			["0xEFFFDB5E"] = "Leopard",
			["0xDDBDB6DA"] = "Zebra",
			["0xCB631225"] = "Geometric",
			["0xA87D541E"] = "Boom!",
			["0xC5E9AE52"] = "Patriotic",
			["0x16C69281"] = "Default Mag",
			["0xDE1FA12C"] = "Extended Mag",
			["0x8765C68A"] = "Tracer Rounds",
			["0xDE011286"] = "Incendiary Rounds",
			["0x51351635"] = "Armor Piercing Rounds",
			["0x503DEA90"] = "Full Metal Jacket Rounds",
			["0xC66B6542"] = "Large Scope",
			["0xE73653A9"] = "Default Barrel",
			["0xF97F783B"] = "Heavy Barrel",
			["0xD40BB53B"] = "Digital Camo",
			["0x431B238B"] = "Brushstroke Camo",
			["0x34CF86F4"] = "Woodland Camo",
			["0xB4C306DD"] = "Skull",
			["0xEE677A25"] = "Sessanta Nove",
			["0xDF90DC78"] = "Perseus",
			["0xA4C31EE"] = "Leopard",
			["0x89CFB0F7"] = "Zebra",
			["0x7B82145C"] = "Geometric",
			["0x899CAF75"] = "Boom!",
			["0x5218C819"] = "Patriotic",
			["0x8610343F"] = "Default Mag",
			["0xD12ACA6F"] = "Extended Mag",
			["0xEF2C78C1"] = "Tracer Rounds",
			["0xFB70D853"] = "Incendiary Rounds",
			["0xA7DD1E58"] = "Armor Piercing Rounds",
			["0x63E0A098"] = "Full Metal Jacket Rounds",
			["0x43A49D26"] = "Default Barrel",
			["0x5646C26A"] = "Heavy Barrel",
			["0x911B24AF"] = "Digital Camo",
			["0x37E5444B"] = "Brushstroke Camo",
			["0x538B7B97"] = "Woodland Camo",
			["0x25789F72"] = "Skull",
			["0xC5495F2D"] = "Sessanta Nove",
			["0xCF8B73B1"] = "Perseus",
			["0xA9BB2811"] = "Leopard",
			["0xFC674D54"] = "Zebra",
			["0x7C7FCD9B"] = "Geometric",
			["0xA5C38392"] = "Boom!",
			["0xB9B15DB0"] = "Patriotic",
			["0x4C7A391E"] = "Default Mag",
			["0x5DD5DBD5"] = "Extended Mag",
			["0x1757F566"] = "Tracer Rounds",
			["0x3D25C2A7"] = "Incendiary Rounds",
			["0x255D5D57"] = "Armor Piercing Rounds",
			["0x44032F11"] = "Full Metal Jacket Rounds",
			["0x833637FF"] = "Default Barrel",
			["0x8B3C480B"] = "Heavy Barrel",
			["0x4BDD6F16"] = "Digital Camo",
			["0x406A7908"] = "Brushstroke Camo",
			["0x2F3856A4"] = "Woodland Camo",
			["0xE50C424D"] = "Skull",
			["0xD37D1F2F"] = "Sessanta Nove	",
			["0x86268483"] = "Perseus",
			["0xF420E076"] = "Leopard",
			["0xAAE14DF8"] = "Zebra",
			["0x9893A95D"] = "Geometric",
			["0x6B13CD3E"] = "Boom!",
			["0xDA55CD3F"] = "Patriotic",
			["0x513F0A63"] = "Default Mag",
			["0x59FF9BF8"] = "Extended Mag",
			["0xC607740E"] = "Drum Magazine",
			["0x2D46D83B"] = "Default Mag",
			["0x684ACE42"] = "Extended Mag",
			["0x6B82F395"] = "Iron Sights",
			["0xF434EF84"] = "Default Mag",
			["0x82158B47"] = "Extended Mag",
			["0x3C00AFED"] = "Scope",
			["0xD6DABABE"] = "Yusuf Amir Luxury Finish",
			["0xE1FFB34A"] = "Default Mag",
			["0xD6C59CD6"] = "Extended Mag",
			["0x92FECCDD"] = "Etched Gun Metal Finish",
			["0x492B257C"] = "Default Mag",
			["0x17DF42E9"] = "Extended Mag",
			["0xF6649745"] = "Tracer Rounds",
			["0xC326BDBA"] = "Incendiary Rounds",
			["0x29882423"] = "Armor Piercing Rounds",
			["0x57EF1CC8"] = "Full Metal Jacket Rounds",
			["0xC34EF234"] = "Default Barrel",
			["0xB5E2575B"] = "Heavy Barrel",
			["0x4A768CB5"] = "Digital Camo",
			["0xCCE06BBD"] = "Brushstroke Camo",
			["0xBE94CF26"] = "Woodland Camo",
			["0x7609BE11"] = "Skull",
			["0x48AF6351"] = "Sessanta Nove",
			["0x9186750A"] = "Perseus",
			["0x84555AA8"] = "Leopard",
			["0x1B4C088B"] = "Zebra",
			["0xE046DFC"] = "Geometric",
			["0x28B536E"] = "Boom!",
			["0xD703C94D"] = "Patriotic",
			["0x1CE5A6A5"] = "Default Mag",
			["0xEAC8C270"] = "Extended Mag",
			["0x9BC64089"] = "Default Mag",
			["0xD2443DDC"] = "Scope",
			["0xBC54DA77"] = "Advanced Scope",
			["0x4032B5E7"] = "Etched Wood Grip Finish",
			["0x476F52F4"] = "Default Mag",
			["0x94E12DCE"] = "Default Mag",
			["0xE6CFD1AA"] = "Extended Mag",
			["0xD77A22D2"] = "Tracer Rounds",
			["0x6DD7A86E"] = "Incendiary Rounds",
			["0xF46FD079"] = "Armor Piercing Rounds",
			["0xE14A9ED3"] = "Full Metal Jacket Rounds",
			["0x5B1C713C"] = "Zoom Scope",
			["0x381B5D89"] = "Default Barrel",
			["0x68373DDC"] = "Heavy Barrel",
			["0x9094FBA0"] = "Digital Camo",
			["0x7320F4B2"] = "Brushstroke Camo",
			["0x60CF500F"] = "Woodland Camo",
			["0xFE668B3F"] = "Skull",
			["0xF3757559"] = "Sessanta Nove",
			["0x193B40E8"] = "Perseus",
			["0x107D2F6C"] = "Leopard",
			["0xC4E91841"] = "Zebra",
			["0x9BB1C5D3"] = "Geometric",
			["0x3B61040B"] = "Boom!",
			["0xB7A316DA"] = "Boom!",
			["0xFA1E1A28"] = "Default Mag",
			["0x2CD8FF9D"] = "Extended Mag",
			["0xEC0F617"] = "Incendiary Rounds",
			["0xF835D6D4"] = "Armor Piercing Rounds",
			["0x3BE948F6"] = "Full Metal Jacket Rounds",
			["0x89EBDAA7"] = "Explosive Rounds",
			["0x82C10383"] = "Zoom Scope",
			["0xB68010B0"] = "Night Vision Scope",
			["0x2E43DA41"] = "Thermal Scope",
			["0x5F7DCE4D"] = "Squared Muzzle Brake",
			["0x6927E1A1"] = "Bell-End Muzzle Brake",
			["0x909630B7"] = "Default Barrel",
			["0x108AB09E"] = "Heavy Barrel",
			["0xF8337D02"] = "Digital Camo",
			["0xC5BEDD65"] = "Brushstroke Camo",
			["0xE9712475"] = "Woodland Camo",
			["0x13AA78E7"] = "Skull",
			["0x26591E50"] = "Sessanta Nove",
			["0x302731EC"] = "Perseus",
			["0xAC722A78"] = "Leopard",
			["0xBEA4CEDD"] = "Zebra",
			["0xCD776C82"] = "Geometric",
			["0xABC5ACC7"] = "Boom!",
			["0x6C32D2EB"] = "Patriotic",
			["0xD83B4141"] = "Default Mag",
			["0xCCFD2AC5"] = "Extended Mag",
			["0x1C221B1A"] = "Scope",
			["0x161E9241"] = "Yusuf Amir Luxury Finish",
			["0x11AE5C97"] = "Default Mag"}
		MOSFHTunables = {
			memory.tunable_offset("PSANDQS_HEALTH_REPLENISH_MULTIPLIER"),
            memory.tunable_offset("EGOCHASER_HEALTH_REPLENISH_MULTIPLIER"),
            memory.tunable_offset("METEORITE_HEALTH_REPLENISH_MULTIPLIER"),
            memory.tunable_offset("REDWOOD_HEALTH_DEPLETE_MULTIPLIER"),
            memory.tunable_offset("ORANGOTANG_HEALTH_REPLENISH_MULTIPLIER"),
            memory.tunable_offset("BOURGEOIX_HEALTH_REPLENISH_MULTIPLIER"),
            memory.tunable_offset("SPRUNK_HEALTH_REPLENISH_MULTIPLIER"),}

		selectedplayer = {}
			for b = 0, 31 do
				selectedplayer[b] = false
			end
			excludeselected = false
		local menus = {}

		-- [[ 2Take1 Script ]]
			local og_get_return_value_vector3 = native_invoker.get_return_value_vector3
			vec3 = v3
			local v3_meta = {
				__is_const = true,
				__sub=function (self, other)
					if type(other) == "table" then
						return v3(	self.x - other.x,
									self.y - other.y,
									self.z - (other.z or 0))
					elseif type(other) == "number" then
						return v3(	self.x - other,
									self.y - other,
									self.z - other)
					end
				end,
				__add=function (self, other)
					if type(other) == "table" then
						return v3(	self.x + other.x,
									self.y + other.y,
									self.z + (other.z or 0))
					elseif type(other) == "number" then
						return v3(	self.x + other,
									self.y + other,
									self.z + other)
					end
				end,
				__mul=function (self, other)
					if type(other) == "table" then
						return v3(	self.x * other.x,
									self.y * other.y,
									self.z * (other.z or 0))
					elseif type(other) == "number" then
						return v3(	self.x * other,
									self.y * other,
									self.z * other)
					end
				end,
				__div=function (self, other)
					if type(other) == "table" then
						return v3(	self.x / other.x,
									self.y / other.y,
									self.z / (other.z or 0))
					elseif type(other) == "number" then
						return v3(	self.x / other,
									self.y / other,
									self.z / other)
					end
				end,
				__eq=function (self, other)
					return self.x == other.x and self.y == other.y and self.z == other.z
				end,
				__lt=function (self, other)
					return self.x + self.y + self.z < other.x + other.y + other.z
				end,
				__le=function (self, other)
					return self.x + self.y + self.z <= other.x + other.y + other.z
				end,
				__tostring=function (self)
					return "x:"..self.x.." y:"..self.y.." z:"..self.z
				end,}

		-- [[ 2Take1 Compat ]]
			vehicle = {create_vehicle = function (hash, pos, heading, networked, alwaysFalse)
				local veh = entities.create_vehicle(hash, pos, heading)
				ENTITY._SET_ENTITY_CLEANUP_BY_ENGINE(veh, true)
				return veh end}
			entity = {get_entity_model_hash = function (veh)
				return int_to_uint(ENTITY.GET_ENTITY_MODEL(veh))end}
			audio = {play_sound_from_coord = function (soundId, audioName, pos, audioRef, isNetwork, range, p8)
				AUDIO.PLAY_SOUND_FROM_COORD(soundId, audioName, pos.x, pos.y, pos.z, audioRef, isNetwork, range, p8)end}
			fire = {add_explosion = function (pos, type, scale, isAudible, isInvis, fCamShake, nodamage, owner)
				FIRE.ADD_EXPLOSION(pos.x, pos.y ,pos.z, type, scale, isAudible, isInvis, fCamShake, nodamage, owner)end}
			graphics = {request_named_ptfx_asset = STREAMING.REQUEST_NAMED_PTFX_ASSET, set_next_ptfx_asset = GRAPHICS.USE_PARTICLE_FX_ASSET, has_named_ptfx_asset_loaded = STREAMING.HAS_NAMED_PTFX_ASSET_LOADED, start_networked_ptfx_non_looped_at_coord = function (name, pos, rot, scale, xAxis, yAxis, zAxis)
				GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(name, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale, xAxis, yAxis, zAxis)end}
			player = {get_player_ped = players.user_ped, player_id = players.user, get_player_coords = function (pid)
				return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid))end}
			object = {create_object = function (model, pos, networked, dynamic)
				return OBJECT.CREATE_OBJECT_NO_OFFSET(model, pos.x, pos.y, pos.z, networked, dynamic)end}			

	-- [[ Functions ]]
		local function player_list(playerID)
			if NETWORK.NETWORK_IS_SESSION_ACTIVE() then
				menus[playerID] = menu.toggle(playerslist, players.get_name(playerID), {}, "Player Info:\n".."- Name: "..players.get_name(playerID).."\n".."- RID: "..players.get_rockstar_id(playerID), function(on_toggle)
					if on_toggle then
						selectedplayer[playerID] = true
					else
						selectedplayer[playerID] = false
					end
				end)
			end end
		local function handle_player_list(playerID)
			local ref = menus[playerID]
			if not players.exists(playerID) then
				if ref then
					selectedplayer[playerID] = false
					menu.delete(ref)
					menus[playerID] = nil
				end
			end end
		--[[local function remove_explonsniper(pid)
			for pid = 0,31 do
				if NETWORK.NETWORK_IS_SESSION_ACTIVE() then
					if WEAPON.HAS_PED_GOT_WEAPON(players.user_ped(pid), 177293209) and WEAPON.HAS_PED_GOT_WEAPON_COMPONENT(players.user_ped(pid), 177293209, 2313935527) and pid ~= players.user() then		
						WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED(players.user_ped(pid), 177293209, 2313935527)
					end
				end	
			end end]]
		local function is_using_vehicle()
			local my_veh = PED.GET_VEHICLE_PED_IS_USING(players.user_ped())
			if my_veh and (VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_veh,-1) == players.user_ped() or VEHICLE.GET_PED_IN_VEHICLE_SEAT(my_veh,0) == players.user_ped() ) then
				return true
			end
			return false end
		local function get_veh_name()
			if is_using_vehicle() then
				return VEHICLE.GET_DISPLAY_NAME_FROM_VEHICLE_MODEL(ENTITY.GET_ENTITY_MODEL(PED.GET_VEHICLE_PED_IS_USING(players.user_ped())))
			end
			return "No Veh" end
		local function get_vehicle_weapon_info()
			local my_ptr <const> = entities.handle_to_pointer(players.user_ped())
			local weapon_manager_ptr = memory.read_long(my_ptr+0x10B8)
			local vehicle_weapon_info_ptr = memory.read_long(weapon_manager_ptr+0x70)
			if vehicle_weapon_info_ptr ~= 0 then
				return vehicle_weapon_info_ptr
			end
			return 0 end
		local function get_session_code_for_user()
			local applicable, code = util.get_session_code()
			if applicable then
				if code then
					return code
				end
				return "Please wait..."
			end
			return "N/A" end
		function RequestControlOfEnt(entity)
			local tick = 0
			local tries = 0
			NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
			while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick <= 1000 do
				NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
				tick = tick + 1
				tries = tries + 1
				if tries == 50 then 
					util.yield()
					tries = 0
				end
			end
			return NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity)end
		function get_player_veh(pid,with_access)
			local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)	
			if PED.IS_PED_IN_ANY_VEHICLE(ped,true) then
			local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
				if not with_access then
					return vehicle
				end
				if RequestControlOfEnt(vehicle) then
					return vehicle
				end
			end
			return 0 end
		local function BlockSyncs(pid, callback)
			for _, i in ipairs(players.list(false, true, true)) do
				if i ~= pid then
					local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
					menu.trigger_command(outSync, "on")
				end
			end
			util.yield(10)
			callback()
				for _, i in ipairs(players.list(false, true, true)) do
				if i ~= pid then
					local outSync = menu.ref_by_rel_path(menu.player_root(i), "Outgoing Syncs>Block")
					menu.trigger_command(outSync, "off")
				end
			end end
		local function get_friend_count()
			native_invoker.begin_call();native_invoker.end_call("203F1CFD823B27A4"); return native_invoker.get_return_value_int();end
		local function get_frined_name(friendIndex)
			native_invoker.begin_call();native_invoker.push_arg_int(friendIndex);native_invoker.end_call("4164F227D052E293"); return native_invoker.get_return_value_string();end
		local function gen_fren_funcs(name)
			bfriendlist = menu.list(friendlist, name, {"friend "..name}, "", function(); end)
				menu.divider(bfriendlist, "~~~> Your Socialclub Friends <~~~")
				menu.readonly(bfriendlist, "Friend: ", name)
				menu.divider(bfriendlist, "~~~> Actions <~~~")
				menu.action(bfriendlist,"Join", {"jf "..name}, "",function()
					menu.trigger_commands("join "..name)
				end)
				--[[menu.action(bfriendlist,"Spectate", {"sf "..name}, "",function()
					menu.trigger_commands("namespectate "..name)
				end)]]
				menu.action(bfriendlist,"Invite", {"if "..name}, "",function()
					menu.trigger_commands("invite "..name)
				end)
				menu.action(bfriendlist,"Open Profile", {"pf "..name}, "",function()
					menu.trigger_commands("nameprofile "..name)
				end)end
		function PlayerlistFeatures(pid)
			--menu.divider(menu.player_root(pid), "~~~> "..Name.." <~~~")
			end
			for pid = 0,30 do
				if players.exists(pid) then
						PlayerlistFeatures(pid)
					end
				end
			players.on_join(PlayerlistFeatures)
			if PLAYER.GET_PLAYER_NAME(pid) then
					playerrid = players.get_rockstar_id(players.user())
			end
			if PLAYER.GET_PLAYER_NAME(pid) then
				playerid = PLAYER.GET_PLAYER_NAME(players.user())
			end
		local function setCarOptions(toggle)
			for k, option in pairs(carSettings) do
				if option.on then option.setOption(toggle) end
			end end
		local function custom_alert(l1)
			poptime = os.time()
			while true do
				if PAD.IS_CONTROL_JUST_RELEASED(18, 18) then
					if os.time() - poptime > 0.1 then
						break
					end
				end
				native_invoker.begin_call()
				native_invoker.push_arg_string("ALERT")
				native_invoker.push_arg_string("JL_INVITE_ND")
				native_invoker.push_arg_int(2)
				native_invoker.push_arg_string("")
				native_invoker.push_arg_bool(true)
				native_invoker.push_arg_int(-1)
				native_invoker.push_arg_int(-1)
				native_invoker.push_arg_string(l1)
				native_invoker.push_arg_int(0)
				native_invoker.push_arg_bool(true)
				native_invoker.push_arg_int(0)
				native_invoker.end_call("701919482C74B5AB")
				util.yield()
			end end
		local function log(...)
			basePrint(...)
				local success, result = pcall(function(...)
					local args = {...}
					if #args == 0 then
						return
					end
					local currTime = os.date("*t")
					local file = io.open(LogFile, "a")
					for i=1,#args do
						file:write(string.format("[%02d-%02d-%02d | %02d:%02d:%02d] %s\n", currTime.day, currTime.month, currTime.year, currTime.hour, currTime.min, currTime.sec, tostring(args[i])))
					end  
					file:close()
				end, ...)
				if not success then
					basePrint("Error writing log: " .. result)
				end end
		local function history(...)
			basePrint(...)
				local success, result = pcall(function(...)
					local args = {...}
					if #args == 0 then
						return
					end
					local currTime = os.date("*t")
					local file = io.open(HistoryFile, "a")
					for i=1,#args do
						file:write(string.format("[%02d-%02d-%02d | %02d:%02d:%02d] %s\n", currTime.day, currTime.month, currTime.year, currTime.hour, currTime.min, currTime.sec, tostring(args[i])))
					end  
					file:close()
				end, ...)
				if not success then
					basePrint("Error writing log: " .. result)
				end end
		local function BitTest(bits, place)
			return (bits & (1 << place)) ~= 0 end
		local function roundDecimals(float, decimals)
			decimals = 10 ^ decimals
			return math.floor(float * decimals) / decimals end
		local function IsPlayerUsingOrbitalCannon(player)
			return BitTest(memory.read_int(memory.script_global((2657921 + (player * 463 + 1) + 424))), 0) end
			--return BitTest(memory.read_int(memory.script_global((2657704 + (player * 463 + 1) + 424))), 0) end
			--return BitTest(memory.read_int(memory.script_global((2657589 + (player * 466 + 1) + 427))), 0) end
		local function isHelpMessageBeingDisplayed(label)
			HUD.BEGIN_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(label)
			return HUD.END_TEXT_COMMAND_IS_THIS_HELP_MESSAGE_BEING_DISPLAYED(0)
			end
		function MP_INDEX()
			return "MP" .. util.get_char_slot() .. "_" end
		function IS_MPPLY(Stat)
			local Stats = {
				"MP_PLAYING_TIME",
			}

			for i = 1, #Stats do
				if Stat == Stats[i] then
					return true
				end
			end

			if string.find(Stat, "MPPLY_") then
				return true
			else
				return false
			end end
		function ADD_MP_INDEX(Stat)
			if not IS_MPPLY(Stat) then
				Stat = MP_INDEX() .. Stat
			end
			return Stat end
		function SET_INT_GLOBAL(Global, Value)
			memory.write_int(memory.script_global(Global), Value)end
		function SET_FLOAT_GLOBAL(global, value)
            memory.write_float(memory.script_global(global), value)end
		function STAT_SET_INT(Stat, Value)
			STATS.STAT_SET_INT(util.joaat(ADD_MP_INDEX(Stat)), Value, true)end
		function START_SCRIPT(ceo_mc, name)
            if HUD.IS_PAUSE_MENU_ACTIVE() then
                util.toast("[Mira] <3\nPlease close your opened pause menu to open any apps remotely.")
                return
            end
            if players.get_boss(players.user()) ~= -1 then
                if players.get_org_type(players.user()) == 0 then -- NOTE: https://www.unknowncheats.me/forum/3683018-post106.html
                    if ceo_mc == "MC" then
                        --menu.trigger_commands("ceotomc")
                        util.toast("[Mira] <3\nSeems like you need to be a MC President. So, Heist Control made you become MC President.")
                    end
                else
                    if ceo_mc == "CEO" then
                        --menu.trigger_commands("ceotomc")
                        util.toast("[Mira] <3\nSeems like you need to be a CEO. So, Heist Control made you become CEO.")
                    end
                end
            else
                if ceo_mc == "CEO" then
                    --menu.trigger_commands("ceostart")
                    util.toast("[Mira] <3\nSeems like you need to be a CEO. So, Heist Control made you become CEO.")
                elseif ceo_mc == "MC" then
                    --menu.trigger_commands("mcstart")
                    util.toast("[Mira] <3\nSeems like you need to be a MC President. So, Heist Control made you become MC President.")
                end
            end

            SCRIPT.REQUEST_SCRIPT(name)
            repeat util.yield_once() until SCRIPT.HAS_SCRIPT_LOADED(name)
            SYSTEM.START_NEW_SCRIPT(name, 5000)
            SCRIPT.SET_SCRIPT_AS_NO_LONGER_NEEDED(name)end
		local function getMPX()
			return 'MP'.. util.get_char_slot() ..'_' end
		local function STAT_GET_INT(Stat)
			STATS.STAT_GET_INT(util.joaat(getMPX() .. Stat), Int_PTR, -1)
			return memory.read_int(Int_PTR)end
		local function int_to_uint(int)
			if int >= 0 then
				return int
			end
			return (1 << 32) + int end
		local function request_anim_dict(dict)
			while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do
				STREAMING.REQUEST_ANIM_DICT(dict)
				util.yield()
			end end
		function request_ptfx_asset(asset)
			local request_time = os.time()
			STREAMING.REQUEST_NAMED_PTFX_ASSET(asset)
			while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(asset) do
				if os.time() - request_time >= 10 then
					break
				end
				util.yield()
			end end
		local function encode_for_web(text)
			return string.gsub(text, "%s", "+")end
		local function web_decode(text)
			return string.gsub(text, "+", " ")end
		local function RequestModel(hash, timeout)
			timeout = timeout or 3
			STREAMING.REQUEST_MODEL(hash)
			local end_time = os.time() + timeout
			repeat
				util.yield()
			until STREAMING.HAS_MODEL_LOADED(hash) or os.time() >= end_time
			return STREAMING.HAS_MODEL_LOADED(hash)end
		local function StandUser(pid)
			if players.exists(pid) and pid != players.user() then
				for menu.player_root(pid):getChildren() as cmd do
					if cmd:getType() == COMMAND_LIST_CUSTOM_SPECIAL_MEANING and cmd:refByRelPath("Stand User"):isValid() then
						return true
					end
				end
			end
			return false end
		local function google_translate(text, to_lang, pid, outgoing)
			if players_on_cooldown[pid] == nil then
				local encoded_text = encode_for_web(text)
				async_http.init("translate.googleapis.com", "/translate_a/single?client=gtx&sl=auto&tl=" .. to_lang .."&dt=t&q=".. encoded_text, function(data)
					translation, original, langs = data:match("^%[%[%[\"(.-)\",\"(.-)\",.-,.-,.-]],.-,\"(.-)\"")
					local decoded_text = web_decode(translation)
					if langs == nil then
						--Assistant("Sorry, i cant translate this message.", colors.black)
						return
					end
					langs = string.split(langs, '_')
					if #langs < 2 then
						-- source and dest lang are the same (in like 90% of cases)
						return 
					end
					local from_lang = langs[1]
					local dest_lang = langs[2]
					-- dont translate non-whitelisted languages
					if not whitelisted_langs[from_lang] then
						return
					end
					if from_lang ~= to_lang then
						if not outgoing then
							util.toast("[Mira] <3\n".."> "..players.get_name(pid).." said:\n\n"..decoded_text)
							players_on_cooldown[pid] = true
							util.yield(1000)
							players_on_cooldown[pid] = nil
						else
						chat.send_message(decoded_text, false, true, true)
						end
					end
				end, function()
					util.toast("Failed to translate : Issue reaching Google API. If you think you are blocked, turn on a VPN or switch VPN servers.")
				end)
				async_http.dispatch()
			else
				util.toast(players.get_name(pid) .. " sent a message, but is on cooldown from translations. Consider kicking this player if they are spamming the chat to prevent a possible temporary ban from Google translate.")
			end end

		get_vtable_entry_pointer = function(address, index)
				return memory.read_long(memory.read_long(address) + (8 * index))end
		get_sub_handling_types = function(vehicle, type)
			local veh_handling_address = memory.read_long(entities.handle_to_pointer(vehicle) + 0x918)
			local sub_handling_array = memory.read_long(veh_handling_address + 0x0158)
			local sub_handling_count = memory.read_ushort(veh_handling_address + 0x0160)
			local types = {registerd = sub_handling_count, found = 0}
			for i = 0, sub_handling_count - 1, 1 do
				local sub_handling_data = memory.read_long(sub_handling_array + 8 * i)
				if sub_handling_data ~= 0 then
					local GetSubHandlingType_address = get_vtable_entry_pointer(sub_handling_data, 2)
					local result = util.call_foreign_function(GetSubHandlingType_address, sub_handling_data)
					if type and type == result then return sub_handling_data end
					types[#types+1] = {type = result, address = sub_handling_data}
					types.found = types.found + 1
				end end
			if type then return nil else return types end end
		native_invoker.get_return_value_vector3 = function ()
			local table = og_get_return_value_vector3()
			return v3(table.x, table.y, table.z)end
		v3 = function (x, y, z)
			x = x or 0.0
			y = y or 0.0
			z = z or 0.0
			local vec =
			{	x = x, y = y or x, z = z or x,

				magnitude = function (self, other)
					local end_vec = other and (self - other) or self
					return math.sqrt(end_vec.x^2 + end_vec.y^2 + end_vec.z^2)
				end,
				transformRotToDir = function(self, deg_z, deg_x)
					local rad_z = deg_z * math.pi / 180;
					local rad_x = deg_x * math.pi / 180;
					local num = math.abs(math.cos(rad_x));
					self.x = -math.sin(rad_z) * num
					self.y = math.cos(rad_z) * num
					self.z = math.sin(rad_x)
				end,
				degToRad = function (self)
					self.x = self.x * math.pi / 180
					self.y = self.y * math.pi / 180
					self.z = self.z * math.pi / 180
				end,
				radToDeg = function (self)
					self.x = self.x * 180 / math.pi
					self.y = self.y * 180 / math.pi
					self.z = self.z * 180 / math.pi
				end
			}
			setmetatable(vec, v3_meta)
			return vec end

	-- [[ Playerlist ]]
		players.on_join(player_list)
		players.on_leave(handle_player_list)

	--[[ Start ]]
		util.show_corner_help(colorcodes.small..colorcodes.red.."WARNING: Codes were taken from other scripts and are therefore not my codes. DO NOT PUBLISH THE SCRIPT!")
		menu.trigger_commands("edithudlbdfmp".." ".."Universe "..tostring(math.random(1, 999999)).." (Public, ~1~)")
		util.toast("[Mira] <3\n".."> Hello "..SOCIALCLUB._SC_GET_NICKNAME().."! Welcome to Aurora!")
		AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "Pre_Screen_Stinger", players.user_ped(), "DLC_HEISTS_FINALE_SCREEN_SOUNDS", true, 20)
		util.yield(750)
		AUDIO.PLAY_SOUND_FROM_ENTITY(-1, "SPAWN", players.user_ped(), "BARRY_01_SOUNDSET", true, 20)

	-- [[ Source Code ]]
		menu.divider(selfoptions, "~~~> Self Options <~~~")
			animation = menu.list(selfoptions, "Animation", {}, "", function(); end)
				menu.divider(animation, "---> Animation <---")
				menu.action(animation, "Stop Animation", {}, "", function()
					TASK.CLEAR_PED_TASKS(players.user_ped())end)
				animfav = menu.list(animation, "> Favorites", {}, "", function(); end)
					menu.action(animfav, "Arm Crossing", {}, "", function()
						local dict = "anim_heist@arcade_combined@"
						local name = "ped_female@_stand@_03a@_base_base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animfav, "Crossing", {}, "", function()
						local dict = "anim@amb@business@bgen@bgen_no_work@"
						local name = "stand_phone_phoneputdown_idle_nowork"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animfav, "Dance Main", {}, "", function()
						local dict = "anim@amb@casino@mini@dance@dance_solo@female@var_b@"
						local name = "med_center"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animfav, "Main", {}, "", function()
						local dict = "anim@amb@casino@peds@"
						local name = "amb_world_human_hang_out_street_male_c_base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animfav, "Shy Girl", {}, "", function()
						local dict = "low_fun_mcs1-3"
						local name = "mp_m_g_vagfun_01^12_dual-3"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animfav, "Shy Girl 2", {}, "", function()
						local dict = "low_fun_mcs1-3"
						local name = "mp_m_g_vagfun_01^13_dual-3"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				menu.divider(animation, "---> Animations <---")
				animground = menu.list(animation, "> Ground Sitting", {}, "", function(); end)
					menu.action(animground, "Ground Sitting 1", {}, "", function()
						local dict = "anim@amb@casino@out_of_money@ped_male@02b@idles"
						local name = "idle_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false) end)		
					menu.action(animground, "Ground Sitting 2", {}, "", function()
						local dict = "anim@heists@fleeca_bank@ig_7_jetski_owner"
						local name = "owner_idle"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animground, "Ground Sitting 3", {}, "", function()
						local dict = "anim@amb@business@bgen@bgen_no_work@"
						local name = "sit_phone_idle_01-noworkfemale"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animground, "Ground Sitting 4", {}, "", function()
						local dict = "anim@amb@business@bgen@bgen_no_work@"
						local name = "sit_phone_phoneputdown_idle-noworkfemale"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animground, "Ground Sitting 5", {}, "", function()
						local dict = "anim@amb@business@bgen@bgen_no_work@"
						local name = "sit_phone_phoneputdown_idle_nowork"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animground, "Sitting 1", {}, "", function()
						local dict = "anim_heist@arcade_combined@"
						local name = "jimmy@_smoking_base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				animspoiler = menu.list(animation, "> Spoiler Sitting", {}, "", function(); end)
					menu.action(animspoiler, "Spoiler Sitting 1", {}, "", function()
						local dict = "mpcas3_mcs1-15"
						local name = "csb_agatha_dual-15"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animspoiler, "Spoiler Sitting 2", {}, "", function()
						local dict = "anim@amb@casino@brawl@reacts@hr_blackjack@bg_blackjack_breakout_t02@bg_blackjack_breakout_t02_s01_s03@"
						local name = "playing_loop_female_01"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animspoiler, "Spoiler Sitting 3", {}, "", function()
						local dict = "iaaj_int-9"
						local name = "mp_m_freemode_01^1_dual-9"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animspoiler, "Spoiler Sitting 4", {}, "", function()
						local dict = "anim@amb@office@boardroom@boss@female@"
						local name = "base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animspoiler, "Spoiler Sitting 5", {}, "", function()
						local dict = "anim@amb@office@boardroom@crew@female@var_a@base@"
						local name = "idle_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animspoiler, "Spoiler Sitting 6", {}, "", function()
						local dict = "amb@world_human_seat_steps@female@hands_by_sides@idle_a"
						local name = "idle_c"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animspoiler, "Spoiler Sitting 7", {}, "", function()
						local dict = "amb@world_human_seat_steps@female@hands_by_sides@idle_b"
						local name = "idle_d"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				animhood = menu.list(animation, "> Hood Sitting", {}, "", function(); end)	
					menu.action(animhood, "Hood Sitting 1", {}, "", function()
						local dict = "amb@world_human_seat_steps@male@elbows_on_knees@idle_a"
						local name = "idle_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animhood, "Hood Sitting 2", {}, "", function()
						local dict = "anim@amb@business@cfm@cfm_machine_no_work@"
						local name = "transition_sleep_v1_operator"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				animleaning = menu.list(animation, "> Car Leaning", {}, "", function(); end)
					menu.action(animleaning, "Car Leaning 1", {}, "", function()
						local dict = "amb@world_human_leaning@male@wall@back@foot_up@idle_a"
						local name = "idle_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animleaning, "Car Leaning 2", {}, "", function()
						local dict = "amb@world_human_leaning@female@coffee@base"
						local name = "base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animleaning, "Car Leaning 3", {}, "", function()
						local dict = "rcmnigel1aig_1"
						local name = "base_02_willie"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animleaning, "Car Leaning 4", {}, "", function()
						local dict = "anim@amb@nightclub@peds@"
						local name = "amb_world_human_leaning_male_wall_back_smoking_idle_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animleaning, "Car Leaning 5", {}, "", function()
						local dict = "anim_heist@arcade_combined@"
						local name = "stand_phone_lookaround_nowork"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animleaning, "Car Leaning 6", {}, "", function()
						local dict = "anim_heist@arcade_combined@"
						local name = "amb@world_human_leaning@male@wall@back@mobile@idle_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animleaning, "Car Leaning 7", {}, "", function()
						local dict = "anim@amb@business@bgen@bgen_no_work@"
						local name = "stand_phone_lookaround_nowork"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				animsleep = menu.list(animation, "> Sleeping", {}, "", function(); end)
					menu.action(animsleep, "Slepping left", {}, "", function()
						local dict = "anim@mp_bedmid@left_var_02"
						local name = "f_sleep_l_loop_bighouse"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animsleep, "Sleeping right", {}, "", function()
						local dict = "anim@mp_bedmid@right_var_02"
						local name = "f_sleep_r_loop_bighouse"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				animdance = menu.list(animation, "> Dances", {}, "", function(); end)
					menu.action(animdance, "Dance 1", {}, "", function()
						local dict = "anim@amb@casino@mini@dance@dance_solo@female@var_a@"
						local name = "low_center"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
				animother = menu.list(animation, "> Other Animations", {}, "", function(); end)
					menu.action(animother, "Coffee Drinking", {}, "", function()
						local dict = "amb@world_human_drinking@coffee@female@enter"
						local name = "enter"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false) end)	
					menu.action(animother, "Female Arm Crossing", {}, "", function()
						local dict = "amb@world_human_hang_out_street@female_arms_crossed@base"
						local name = "base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false) end)
					menu.action(animother, "Lead in out", {}, "", function()
						local dict = "missfbi4leadinoutfbi_4_int"
						local name = "agents_idle_b_andreas"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false) end)
					menu.action(animother, "Standing", {}, "", function()
						local dict = "mpcas6_ext-14"
						local name = "csb_agatha_dual-14"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false) end)
					menu.action(animother, "Hangout", {}, "", function()
						local dict = "anim@amb@casino@hangout@ped_female@stand@02a@base"
						local name = "base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false) end)
					menu.action(animother, "Calling", {}, "", function()
						local dict = "amb@code_human_wander_mobile@female@base"
						local name = "static"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animother, "Guard Standing", {}, "", function()
						local dict = "amb@world_human_stand_guard@male@base"
						local name = "base"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animother, "Texting", {}, "", function()
						local dict = "move_characters@sandy@texting"
						local name = "sandy_text_loop_a"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)
					menu.action(animother, "Mime", {}, "", function()
						local dict = "anim@temp_trailer@"
						local name = "p3_ver1_amanda"
						while not STREAMING.HAS_ANIM_DICT_LOADED(dict) do 
							STREAMING.REQUEST_ANIM_DICT(dict)
							util.yield()
						end
						WEAPON.SET_CURRENT_PED_WEAPON(players.user_ped(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
						TASK.TASK_PLAY_ANIM(players.user_ped(), dict, name, 8.0, 8.0, -1, 1, 0, false, false, false)end)		
			menu.divider(selfoptions, "~~~> Player <~~~")
			menu.toggle_loop(selfoptions, "Refill Snacks & Armours Automatically", {}, "", function(toggled)
				STAT_SET_INT("NO_BOUGHT_YUM_SNACKS", 30)
				STAT_SET_INT("NO_BOUGHT_HEALTH_SNACKS", 15)
				STAT_SET_INT("NO_BOUGHT_EPIC_SNACKS", 15)
				STAT_SET_INT("NUMBER_OF_ORANGE_BOUGHT", 10)
				STAT_SET_INT("NUMBER_OF_BOURGE_BOUGHT", 10)
				STAT_SET_INT("CIGARETTES_BOUGHT", 10)
				STAT_SET_INT("MP_CHAR_ARMOUR_1_COUNT", 10)
				STAT_SET_INT("MP_CHAR_ARMOUR_2_COUNT", 10)
				STAT_SET_INT("MP_CHAR_ARMOUR_3_COUNT", 10)
				STAT_SET_INT("MP_CHAR_ARMOUR_4_COUNT", 10)
				STAT_SET_INT("MP_CHAR_ARMOUR_5_COUNT", 10)end)
			menu.toggle_loop(selfoptions, "Make One Snack Full Health", {}, "Whatever you use a snack, will make you full health.", function()
                for i = 1, 7 do
                    SET_FLOAT_GLOBAL(262145 + MOSFHTunables[i], 99999)
                end
				end, function()
					for i = 1, 7 do
						SET_FLOAT_GLOBAL(262145 + MOSFHTunables[i], 1)
					end end)
			menu.toggle(selfoptions, "BST Mode", {}, "BST without the Post FX and sound effects.", function(toggled)
				PLAYER.SET_PLAYER_WEAPON_DAMAGE_MODIFIER(players.user(), toggled ? 1.44 : 0.72)
				PLAYER.SET_PLAYER_MELEE_WEAPON_DAMAGE_MODIFIER(players.user(), toggled ? 2.0 : 1.0)
				PLAYER.SET_PLAYER_MELEE_WEAPON_DEFENSE_MODIFIER(players.user(), toggled ? 0.5 : 1.0)end)
			menu.toggle_loop(selfoptions, "Keep me clean", {}, "", function(toggled)
				PED.CLEAR_PED_BLOOD_DAMAGE(players.user_ped())
				PED.CLEAR_PED_WETNESS(players.user_ped())
				PED.CLEAR_PED_ENV_DIRT(players.user_ped())end)
			menu.divider(selfoptions, "~~~> Movement <~~~")
			menu.toggle_loop(selfoptions, "Reload when rolling", {}, "Reloads your weapon when doing a roll.", function()
				if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 4) and PAD.IS_CONTROL_PRESSED(22, 22) and not PED.IS_PED_SHOOTING(players.user_ped())  then --checking if player is rolling
					util.yield(900)
					WEAPON.REFILL_AMMO_INSTANTLY(players.user_ped())
				end end)
			menu.toggle_loop(selfoptions, "Modded Roll (PS3)", {}, "", function()
				STATS.STAT_SET_INT(util.joaat("MP0_SHOOTING_ABILITY"), 200, true) end)
			menu.divider(selfoptions, "~~~> Respawning <~~~")
			menu.toggle_loop(selfoptions, "Fast Respawn", {}, "", function()
				local gwobaw = memory.script_global(2672524 + 1685 + 756) -- Global_2672524.f_1685.f_756
					if PED.IS_PED_DEAD_OR_DYING(players.user_ped()) then
						GRAPHICS.ANIMPOSTFX_STOP_ALL()
						memory.write_int(gwobaw, memory.read_int(gwobaw) | 1 << 1)
					end
				end, function()
					local gwobaw = memory.script_global(2672524 + 1685 + 756)
					memory.write_int(gwobaw, memory.read_int(gwobaw) &~ (1 << 1))
				end)
		
		menu.divider(playerslist, "~~~> Custom Playerlist <~~~")
			-- [[ Custom Playerlist ]]
				local kickPlayerList <const> = {"Smart Kick", "Host Kick", "Ban Kick"}
				local KickType <const> = {smartkick = 0, hostkick = 1, bankick = 2}
				local kicktype = 0

				local crashPlayerList <const> = {"Elegant Crash"}
				local CrashType <const> = {elegant = 0}
				local crashtype = 0

				local pTPlayerList <const> = {"Remove Explosive Shit", "Disable Ghost"}
				local PtType <const> = {removeexplo = 0, disghost = 1}
				local pttype = 0

				local passivePlayerList <const> = {"Block", "Unblock"}
				local PassiveType <const> = {onpassive = 0, offpassive = 1}
				local passivetype = 0
			menu.toggle(playerslist, "Exclude Selected", {}, "", function(on_toggle)
					if on_toggle then
						excludeselected = true
					else
						excludeselected = false
					end end)
			menu.divider(playerslist, "~~~> Actions <~~~")--����
			menu.textslider_stateful(playerslist, "Kicks:", {}, "", kickPlayerList, function(index)
				if index == 1 then
					kicktype = KickType.smartkick
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("kick" .. PLAYER.GET_PLAYER_NAME(pid))
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("kick" .. PLAYER.GET_PLAYER_NAME(pid))
								end
							end
						end
				elseif index == 2 then
					kicktype = KickType.hostkick
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									if NETWORK.NETWORK_IS_HOST() then
										local name = PLAYER.GET_PLAYER_NAME(pid)
										log("Host Kick: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid)..")")
										NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
									end
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									if NETWORK.NETWORK_IS_HOST() then
										local name = PLAYER.GET_PLAYER_NAME(pid)
										log("Host Kick: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid)..")")
										NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
									end
								end
							end
						end
				elseif index == 3 then
					kicktype = KickType.bankick
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("ban" .. PLAYER.GET_PLAYER_NAME(pid))
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("ban" .. PLAYER.GET_PLAYER_NAME(pid))
								end
							end
						end
				end end)
			menu.textslider_stateful(playerslist, "Crashes:", {}, "", crashPlayerList, function(index)
				if index == 1 then
					crashtype = CrashType.elegant
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("crash" .. PLAYER.GET_PLAYER_NAME(pid))
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("crash" .. PLAYER.GET_PLAYER_NAME(pid))
								end
							end
						end
				end end)
			menu.textslider_stateful(playerslist, "PVP/Trolling:", {}, "", pTPlayerList, function(index)
				if index == 1 then
					pttype = PtType.removeexplo
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
									WEAPON.GIVE_WEAPON_TO_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
									WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0x6D544C99)
									WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xFEA23564)
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
									WEAPON.GIVE_WEAPON_TO_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
									WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0x6D544C99)
									WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xFEA23564)
								end
							end
						end
				elseif index == 2 then
					pttype = PtType.disghost
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("bounty"..PLAYER.GET_PLAYER_NAME(pid).." 1000")
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("bounty"..PLAYER.GET_PLAYER_NAME(pid).." 1000")
								end
							end
						end						
				end end)
			menu.textslider_stateful(playerslist, "Passive Mode:", {}, "", passivePlayerList, function(index)
				if index == 1 then
					passivetype = PassiveType.onpassive
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("nopassivemode"..PLAYER.GET_PLAYER_NAME(pid).." ".."on")
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("nopassivemode"..PLAYER.GET_PLAYER_NAME(pid).." ".."on")
								end
							end
						end
				elseif index == 2 then
					passivetype = PassiveType.offpassive
						for pid = 0, 31 do
							if excludeselected then
								if pid ~= players.user() and not selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("nopassivemode"..PLAYER.GET_PLAYER_NAME(pid).." ".."off")
								end
							else
								if pid ~= players.user() and selectedplayer[pid] and players.exists(pid) then
									menu.trigger_commands("nopassivemode"..PLAYER.GET_PLAYER_NAME(pid).." ".."off")
								end
							end
						end						
				end end)
			menu.divider(playerslist, "~~~> Players <~~~")
			players.dispatch_on_join()

		menu.divider(onlineoptions, "~~~> Online Options <~~~")
			friendlist = menu.list(onlineoptions, "Socialclub Friendlist", {}, "", function(); end)
				menu.divider(friendlist, "~~~> Your Socialclub Friends <~~~")
					for i = 0 , get_friend_count() do
						local name = get_frined_name(i)
						if name == "*****" then goto yes end
						gen_fren_funcs(name)
						::yes::
					end
			spoofing = menu.list(onlineoptions, "Spoofing", {}, "", function(); end)
				menu.divider(spoofing, "~~~> Spoofing <~~~")
					-- [[ Spoofing ]]
						local spoofingList <const> = {"Queue #1", "Queue #2", "Queue #3", "Queue #4", "Queue #5", "Off"}
						local SpoofingType <const> = {queue1 = 0, queue2 = 1, queue3 = 2, queue4 = 3, queue5 = 4, queueoff = 5}
						local spoofingtype = 0
					menu.textslider_stateful(spoofing, "Spoof Host Token:", {}, "", spoofingList, function(index)
						if index == 1 then
							spoofingtype = SpoofingType.queue1
								menu.trigger_commands("spoofedhosttoken".." ".."0000000000000001")
								menu.trigger_commands("hosttokenspoofing".." ".."on")
						elseif index == 2 then
							spoofingtype = SpoofingType.queue2
								menu.trigger_commands("spoofedhosttoken".." ".."0000000000000002")
								menu.trigger_commands("hosttokenspoofing".." ".."on")
						elseif index == 3 then
							spoofingtype = SpoofingType.queue3
								menu.trigger_commands("spoofedhosttoken".." ".."0000000000000003")
								menu.trigger_commands("hosttokenspoofing".." ".."on")
						elseif index == 4 then
							spoofingtype = SpoofingType.queue4
								menu.trigger_commands("spoofedhosttoken".." ".."0000000000000004")
								menu.trigger_commands("hosttokenspoofing".." ".."on")
						elseif index == 5 then
							spoofingtype = SpoofingType.queue5
								menu.trigger_commands("spoofedhosttoken".." ".."0000000000000005")
								menu.trigger_commands("hosttokenspoofing".." ".."on")
						elseif index == 6 then
							spoofingtype = SpoofingType.queueoff
								menu.trigger_commands("hosttokenspoofing".." ".."off")
						end	end)

			translater = menu.list(onlineoptions, "Translater", {}, "", function(); end)
				menu.divider(translater, "~~~> Translater <~~~")
				menu.toggle(translater, "On", {}, "Turns translating on/off", function(on)
					do_translate = on end, false)
				menu.toggle(translater, "Only translate foreign game lang", {}, "Only translates messages from users with a different game language, thus saving API calls. You should leave this on to prevent the chance of Google temporarily blocking your requests.", function(on)
					only_translate_foreign = on end, true)
				local outgoing_list = menu.list(translater, "Send translation", {"nexttranslateout"}, "Send a translated, outgoing chat")
					outgoing_list:divider("Select lang to translate to")
					for lang_index, lang in pairs(language_display_names_by_enum) do
						local cmd = "translateto" .. string.lower(lang):gsub(' ', ''):gsub('%(', ''):gsub('%)', '')
						outgoing_list:action(lang, {cmd}, "", function()
							util.toast("Enter text to translate")
							menu.show_command_box(cmd .. " ")
						end, function(entry)
							if string.len(entry) > 254 then 
								util.toast("That text is too long to be sent in chat, nerd")
								return 
							end
							util.toast("Translating...")
							google_translate(entry, language_codes_by_enum[lang_index], players.user(), true)
						end)end
						local whitelist_list = menu.list(translater, "Translation whitelist", {}, "Only translate languages toggled on in this list")
						for id, iso_code in pairs(language_codes_by_enum) do
							whitelist_list:toggle(language_display_names_by_enum[id], {}, "", function(on)
								whitelisted_langs[iso_code] = on
							end, true)end
					chat.on_message(function(sender, reserved, text, team_chat, networked, is_auto)
						if do_translate and networked then
							local encoded_text = encode_for_web(text)
							local player_lang = language_codes_by_enum[players.get_language(sender)]
							if (only_translate_foreign and player_lang == my_lang) then
								return
							end
							if not debug then 
								if players.user() == sender then 
									return 
								end
							end
							-- credit to the original chat translator for the api code
							google_translate(encoded_text, my_lang, sender, false)
						end end)
			paboptions = menu.list(onlineoptions, "Protections & Blocks", {}, "", function(); end)
				menu.divider(paboptions, "~~~> Protections & Blocks <~~~")
				menu.list_select(paboptions, "Jammer Delay", {}, "The speed in which your name will flicker at for orbital cannon users.", {"Slow", "Medium", "Fast"}, 3, function(index, value)
					switch value do
						case "Slow":
							orb_delay = 100
							break
						case "Medium":
							orb_delay = 500
							break
						case "Fast":
							orb_delay = 1000
							break
						end end)
				annoy_tgl = menu.toggle_loop(paboptions, "Enable Orbital Jammer", {}, "", function()
					for _, pid in ipairs(players.list(false, true, true)) do
						if IsPlayerUsingOrbitalCannon(pid) then
							NETWORK._SET_RELATIONSHIP_TO_PLAYER(pid, true)
							util.yield(orb_delay)
							NETWORK._SET_RELATIONSHIP_TO_PLAYER(pid, false)
							util.yield(orb_delay)
						else
							NETWORK._SET_RELATIONSHIP_TO_PLAYER(pid, false)
						end
					end
					end, function()
						for _, pid in ipairs(players.list(false, true, true)) do
							NETWORK._SET_RELATIONSHIP_TO_PLAYER(pid, false)
						end end)
				menu.toggle_loop(paboptions, "Orbital Cannon Detection", {}, "Tells you when anyone starts using the orbital cannon", function()
					local playerList = players.list(false, true, true)
					for i = 1, #playerList do
						local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
						if TASK.GET_IS_TASK_ACTIVE(ped, 135) and ENTITY.GET_ENTITY_SPEED(ped) == 0 then
							local pos = NETWORK._NETWORK_GET_PLAYER_COORDS(playerList[i])
							for j = 1, #orbitalTableCords do
								if roundDecimals(pos.x, 1) == roundDecimals(orbitalTableCords[j].x, 1) and roundDecimals(pos.y, 1) == roundDecimals(orbitalTableCords[j].y, 1) and roundDecimals(pos.z, 1) == roundDecimals(orbitalTableCords[j].z, 1) then
									--Assistant("> "..players.get_name(playerList[i]).." is using the orbital cannon.",colors.red)
									util.toast("[Mira] <3\n".."> "..players.get_name(playerList[i]).." is using the orbital cannon.")
									HUD.FLASH_MINIMAP_DISPLAY_WITH_COLOR(hud_rgb_colors[hud_rgb_index])
									hud_rgb_index = hud_rgb_index + 1
										if hud_rgb_index == 4 then
											hud_rgb_index = 1
										end
									util.yield(250)
								end
							end
						end
					end end)
				menu.toggle_loop(paboptions, "Orbital Cannon Detection (Only Notify)", {}, "Tells you when anyone starts using the orbital cannon", function()
					local playerList = players.list(false, true, true)
					for i = 1, #playerList do
						local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(playerList[i])
						if TASK.GET_IS_TASK_ACTIVE(ped, 135) and ENTITY.GET_ENTITY_SPEED(ped) == 0 then
							local pos = NETWORK._NETWORK_GET_PLAYER_COORDS(playerList[i])
							for j = 1, #orbitalTableCords do
								if roundDecimals(pos.x, 1) == roundDecimals(orbitalTableCords[j].x, 1) and roundDecimals(pos.y, 1) == roundDecimals(orbitalTableCords[j].y, 1) and roundDecimals(pos.z, 1) == roundDecimals(orbitalTableCords[j].z, 1) then
									--Assistant("> "..players.get_name(playerList[i]).." is using the orbital cannon.",colors.red)
									util.toast("[Mira] <3\n".."> "..players.get_name(playerList[i]).." is using the orbital cannon.")
									util.yield(250)
								end
							end
						end
					end end)
				menu.divider(paboptions, "~~~> Blocks <~~~")
				menu.toggle_loop(paboptions, "Block Orbital Cannon Room", {}, "", function()
					local mdl = util.joaat("h4_prop_h4_garage_door_01a")
					RequestModel(mdl)
					if orb_obj == nil or not ENTITY.DOES_ENTITY_EXIST(orb_obj) then
						orb_obj = entities.create_object(mdl, v3(335.9, 4833.9, -59.0))
						entities.set_can_migrate(orb_obj, false)
						ENTITY.SET_ENTITY_HEADING(orb_obj, 125.0)
						ENTITY.FREEZE_ENTITY_POSITION(orb_obj, true)
						ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(orb_obj, players.user_ped(), false)
						ENTITY.SET_ENTITY_NO_COLLISION_ENTITY(players.user_ped(), orb_obj, false)
					end
						util.yield(50)
					end, function()
						if orb_obj != nil then
							entities.delete(orb_obj)
						end end)
				menu.toggle(paboptions, "Block Scripthost Migration", {}, "Only works when you are the host.", function(on)
					if util.is_session_started() and NETWORK.NETWORK_IS_HOST() then
						NETWORK.NETWORK_PREVENT_SCRIPT_HOST_MIGRATION()
						--util.toast("[Mira] <3\n".."> Script Host Migration blocked.")
					end end)
				menu.toggle(paboptions, "Block Join (Session Spoof)", {}, "", function(on_toggle)
					if on_toggle then
						menu.trigger_commands("spoofsession".." ".."fake")
						menu.trigger_commands("spoofedhostrid".." ".."1337")
						menu.trigger_commands("spoofhost".." ".."on")
						util.toast("[Mira] <3\n".."> I have marked your session as fake so other modders can't join you.")
					else
						menu.trigger_commands("spoofsession".." ".."off")
						menu.trigger_commands("spoofhost".." ".."off")
						util.toast("[Mira] <3\n".."> I have turned off the block you can now rejoin.")
					end end)
			terminaloptions = menu.list(onlineoptions, "Remote Access Apps", {}, "Based on Heist Control Stuff", function(); end)
				menu.divider(terminaloptions, "~~~> Remote Access Apps <~~~")
				menu.action(terminaloptions, "(Arcade) Master Control Terminal", {}, "", function()
					START_SCRIPT("CEO", "apparcadebusinesshub")end)
				menu.action(terminaloptions, "(Hangar) Free Trade Shipping Co.", {}, "", function()
					START_SCRIPT("CEO", "appsmuggler")end)
				menu.action(terminaloptions, "(Bunker) Disruption Logistics", {}, "", function()
					START_SCRIPT("CEO", "appbunkerbusiness")end)
				menu.action(terminaloptions, "(Agency) F. Clinton & Partner", {}, "", function()
					START_SCRIPT("CEO", "appfixersecurity")end)
				menu.action(terminaloptions, "(Terrorbyte) Touchscreen Terminal", {}, "", function()
					START_SCRIPT("CEO", "apphackertruck")end)
				menu.action(terminaloptions, "(Avenger) San Andreas Mercenaries Terminal", {}, "", function()
					START_SCRIPT("CEO", "appavengeroperations")end)
				menu.action(terminaloptions, "(Only MC) Biker Business", {}, "", function()
					START_SCRIPT("MC", "appbikerbusiness")end)
				menu.action(terminaloptions, "Nightclub", {}, "", function()
					START_SCRIPT("CEO", "appbusinesshub")end)
			recoveryoptions = menu.list(onlineoptions, "Recovery Options", {}, "", function(); end)
				menu.divider(recoveryoptions, "~~~> Recovery Options <~~~")
				bountyloop = menu.list(recoveryoptions, "Bounty Loop", {}, "", function(); end)
					menu.divider(bountyloop, "~~~> Bounty Loop <~~~")
					menu.slider(bountyloop, "Bounty Amount", {}, "", 0, 10000, 10000, 1, function(s)
						infibounty_amt = s end)
					menu.toggle_loop(bountyloop, "Place Infinite Bounty", {}, "", function(click_type)
						menu.trigger_commands("bountyall" .. " " .. tostring(infibounty_amt))
						util.yield(60000)end)
				menu.toggle_loop(recoveryoptions, "Auto Black Jack", {}, "", function()
					if not (isHelpMessageBeingDisplayed('BJACK_BET') or isHelpMessageBeingDisplayed('BJACK_TURN') or isHelpMessageBeingDisplayed('BJACK_TURN_D') or isHelpMessageBeingDisplayed('BJACK_TURN_S')) then return end
					if isHelpMessageBeingDisplayed('BJACK_BET') then
						PAD._SET_CONTROL_NORMAL(2, 204, 1) --max bet
						PAD._SET_CONTROL_NORMAL(2, 201, 1) --bet
					else
						PAD._SET_CONTROL_NORMAL(2, 203, 1) --pass
					end end)
			menu.divider(onlineoptions, "~~~> Requests <~~~")
			-- [[ Requests ]]
				local RequestsType <const> = {"MOC", "Avenger", "Terrorbyte", "Kosatka", "Acid Lab"}
				local requestsType <const> = {moc = 0, avenger = 1, terrorbyte = 2, kosatka = 3, acidlab = 4}
				local requeststype = 0
			menu.textslider_stateful(onlineoptions, "Request:", {}, "", RequestsType, function(index)
				if index == 1 then
					requeststype = requestsType.moc
						SET_INT_GLOBAL(2738587 + 930, 1)
				elseif index == 2 then
					requeststype = requestsType.avenger
						SET_INT_GLOBAL(2738587 + 938, 1)
				elseif index == 3 then
					requeststype = requestsType.terrorbyte
						SET_INT_GLOBAL(2738587 + 943, 1)
				elseif index == 4 then
					requeststype = requestsType.kosatka
						SET_INT_GLOBAL(2738587 + 960, 1)
				elseif index == 5 then
					requeststype = requestsType.acidlab
						SET_INT_GLOBAL(2738587 + 944, 1)
				end	end)
			menu.divider(onlineoptions, "~~~> Trolling <~~~")
			menu.action(onlineoptions, "Real localized \"DOX\"", {"dox"}, "", function(on_click)
				chat.send_message("${name}: ${ip} | ${geoip.city}, ${geoip.region}, ${geoip.country}", false, true, true)end)

		menu.divider(weaponsoptions, "~~~> Weapon Options <~~~")
			weaponattachments = menu.list(weaponsoptions, "Weapon Attachment Manager", {}, "", function(); end)
				menu.divider(weaponattachments, "---> Weapon Attachment Manager <---")
				menu.action(weaponattachments, "Give Ammo", {}, "(Not working with special ammo)", function(on_click)
					local curr_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
						WEAPON.ADD_AMMO_TO_PED(PLAYER.GET_PLAYER_PED(players.user()), curr_equipped_weapon, 10)end)	
				menu.action(weaponattachments, "Give All Attachments", {}, "Give all attachments from your current weapon", function(on_click)
					local curr_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
					for key, value in pairs(attachments_table) do
						WEAPON.GIVE_WEAPON_COMPONENT_TO_PED(PLAYER.GET_PLAYER_PED(players.user()), curr_equipped_weapon, key)
					end end)
				menu.action(weaponattachments, "Remove All Attachments", {}, "Removes all attachments from your current weapon", function(on_click)
					local curr_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
					for key, value in pairs(attachments_table) do
						WEAPON.REMOVE_WEAPON_COMPONENT_FROM_PED(PLAYER.GET_PLAYER_PED(players.user()), curr_equipped_weapon, key)
					end end)
				attachment_tab = menu.list(weaponattachments, "Add Attachments", {}, "Add attachments to your current weapon")
					for key, value in pairs(attachments_table) do
						local curr_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
						if WEAPON.DOES_WEAPON_TAKE_WEAPON_COMPONENT(curr_equipped_weapon, key) == true then --done
							--util.toast(curr_equipped_weapon .. " takes " .. key .. " as attachment") --done
							menu.action(attachment_tab,value,{value},"Attach " .. value .. "to your current weapon",function(on_click)
								WEAPON.GIVE_WEAPON_COMPONENT_TO_PED(PLAYER.GET_PLAYER_PED(players.user()), curr_equipped_weapon, key) --done
								--util.toast("Your Weapon '" .. curr_equipped_weapon .. "' should now have the attachment '" .. key) --done
							end)
						end
					end
			menu.divider(weaponsoptions, "~~~> Buffs <~~~")
			menu.toggle_loop(weaponsoptions, "Double Tap", {""}, "", function()
				if PED.IS_PED_SHOOTING(players.user_ped()) then
					PED.FORCE_PED_AI_AND_ANIMATION_UPDATE(players.user_ped())
				end end)
			menu.toggle_loop(weaponsoptions, "Bypass Imani Tech Anti-Lockon", {""}, "", function()
				for players.list_except() as pid do
					local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
					local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped)
					if not PED.IS_PED_IN_ANY_VEHICLE(ped) then 
						continue 
					end
					if memory.read_byte(entities.handle_to_pointer(vehicle) + 0xA9E) == 0 then
						memory.write_byte((entities.handle_to_pointer(vehicle) + 0xA9E), 1) 
					end
				end end)
			menu.toggle_loop(weaponsoptions, "ESP While Aiming", {""}, "", function()
				if PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
					menu.trigger_command(menu.ref_by_path("World>Inhabitants>Player ESP>Bone ESP>Low Latency Rendering"))
				else
					menu.trigger_command(menu.ref_by_path("World>Inhabitants>Player ESP>Bone ESP>Disabled"))
				end
				end, function()
					menu.trigger_command(menu.ref_by_path("World>Inhabitants>Player ESP>Bone ESP>Disabled"))
				end)
			menu.toggle_loop(weaponsoptions, "Inf. Lock-on Range", {""}, "Homing missles and auto aim", function()
				PLAYER.SET_PLAYER_LOCKON_RANGE_OVERRIDE(players.user(), 99999999.0)end)
			menu.toggle(weaponsoptions, "Better Precision Rifle", {}, "", function(on_toggle)
				if on_toggle then
					menu.trigger_commands("damagemultiplier".." ".."1.60")
					menu.trigger_commands("rangemultiplier".." ".."1.50")
				else
					menu.trigger_commands("damagemultiplier".." ".."1.00")
					menu.trigger_commands("rangemultiplier".." ".."1.00")
				end end)

		menu.divider(vehicleoptions, "~~~> Vehicle Options <~~~")
			-- [[ Buffing Settings ]]
				local Lazerbuffing <const> = {"Modifyed Cannon", "Normal Cannon"}
				local LazerType <const> = {modifyed = 0, normal = 1}
				local lazerttype = 0

				local B11buffing <const> = {"Modifyed Cannon", "Normal Cannon"}
				local B11Type <const> = {modifyed = 0, normal = 1}
				local b11ttype = 0

				local Chernobuffing <const> = {"Shoot together", "Lock-On Range"}
				local ChernoType <const> = {modifyed = 0, modifyed1 = 1}
				local chernottype = 0
			oldgtaoptions = menu.list(vehicleoptions, "Vehicle Modifyer", {}, "Some features to get old things back.", function(); end)
				menu.divider(oldgtaoptions, "~~~> Vehicle Modifyer <~~~")
				menu.textslider_stateful(oldgtaoptions, "P-996 Lazer:", {}, "", Lazerbuffing, function(index)
					if index == 1 then
						lazerttype = LazerType.modifyed
							memory.write_int(vehicle_data_t.lazer_t.p99_explosive_type,0)
							memory.write_float(vehicle_data_t.lazer_t.alter_wait_time,-1)
							memory.write_float(vehicle_data_t.lazer_t.shoot_between_time,0.03999999911)
							util.toast("Done")
					elseif index == 2 then
						lazerttype = LazerType.normal
							memory.write_int(vehicle_data_t.lazer_t.p99_explosive_type,85)
							memory.write_float(vehicle_data_t.lazer_t.alter_wait_time,0.125)
							memory.write_float(vehicle_data_t.lazer_t.shoot_between_time,0.125)
							util.toast("Done")
					end	end)
				menu.textslider_stateful(oldgtaoptions, "B-11 Strikeforce:", {}, "", B11buffing, function(index)
					if index == 1 then
						b11ttype = B11Type.modifyed
							if is_using_vehicle() then
								local vehicle_weapon_info_ptr <const> = get_vehicle_weapon_info()
								if vehicle_weapon_info_ptr ~= 0 then
									memory.write_float(vehicle_weapon_info_ptr+0x13C,0)
									memory.write_float(vehicle_weapon_info_ptr+0x150,0)
									memory.write_int(vehicle_weapon_info_ptr+0x24,0)
									memory.write_float(vehicle_weapon_info_ptr+0x028C,1000)
									util.toast("Done")
								end
							else
								util.toast("Get in the car first.")
							end
					elseif index == 2 then
						b11ttype = B11Type.normal
							if is_using_vehicle() then
								local vehicle_weapon_info_ptr <const> = get_vehicle_weapon_info()
								if vehicle_weapon_info_ptr ~= 0 then
									memory.write_float(vehicle_weapon_info_ptr+0x13C,0.125)
									memory.write_float(vehicle_weapon_info_ptr+0x150,0.125)
									memory.write_int(vehicle_weapon_info_ptr+0x24,57)
									memory.write_float(vehicle_weapon_info_ptr+0x028C,300)
									util.toast("Done")
								end
							else
								util.toast("Get in the car first.")
							end
					end	end)
				menu.divider(oldgtaoptions, "~~~> Other Vehicles <~~~")
				menu.textslider_stateful(oldgtaoptions, "Chernobog:", {}, "", Chernobuffing, function(index)
					if index == 1 then
						chernottype = ChernoType.modifyed
							if is_using_vehicle() then
								local vehicle_weapon_info_ptr <const> = get_vehicle_weapon_info()
								if vehicle_weapon_info_ptr ~= 0 then
									memory.write_float(vehicle_weapon_info_ptr+0x13C,0)
									memory.write_float(vehicle_weapon_info_ptr+0x150,0)
									memory.write_int(vehicle_weapon_info_ptr+0x24,0)
									memory.write_float(vehicle_weapon_info_ptr+0x128,0)
									memory.write_float(vehicle_weapon_info_ptr+0x12C,0)
									util.toast("Done")
								end
							else
								util.toast("Get in the car first.")
							end
					elseif index == 2 then
						chernottype = ChernoType.modifyed1
							if is_using_vehicle() then
								local vehicle_weapon_info_ptr <const> = get_vehicle_weapon_info()
								if vehicle_weapon_info_ptr ~= 0 then
									memory.write_float(vehicle_weapon_info_ptr+0x288,9999)
									util.toast("Done")
								end
							else
								util.toast("Get in the car first.")
							end
					end	end)
				menu.action(oldgtaoptions, "Modify every Vehicle Weapon", {}, "Modifys all vehicle weapons u want.", function(on_toggle)
						if is_using_vehicle() then
							local vehicle_weapon_info_ptr <const> = get_vehicle_weapon_info()
							if vehicle_weapon_info_ptr ~= 0 then
								memory.write_float(vehicle_weapon_info_ptr+0x13C,0)
								memory.write_float(vehicle_weapon_info_ptr+0x150,0)
								memory.write_int(vehicle_weapon_info_ptr+0x24,0)
								memory.write_float(vehicle_weapon_info_ptr+0x028C,2000)
								util.toast("[  "..get_veh_name().."  ]".." Done")
							end
						else
							util.toast("Get in the car first.")
						end end)
			menu.divider(vehicleoptions, "~~~> Other Options <~~~")
			menu.action(vehicleoptions, "Apply Drift Ability", {}, "", function(toggle)
				if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entities.get_user_vehicle_as_handle(pid)) then
					NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entities.get_user_vehicle_as_handle(pid))  
				end
				ENTITY.SET_ENTITY_MAX_SPEED(entities.get_user_vehicle_as_handle(), 30)
				VEHICLE.MODIFY_VEHICLE_TOP_SPEED(entities.get_user_vehicle_as_handle(), 200)end)
			menu.toggle(vehicleoptions, "Stance [Only LS Tuners Cars]", {}, "", function(toggle)
				VEHICLE._SET_REDUCE_DRIFT_VEHICLE_SUSPENSION(players_car, toggle)end)
			menu.toggle_loop(vehicleoptions, "Keep car clean", {}, "", function(toggled)
				VEHICLE.SET_VEHICLE_DIRT_LEVEL(entities.get_user_vehicle_as_handle(), 0.0)end)
			menu.toggle_loop(vehicleoptions, "Vehicle Godmode", {}, "", function(toggled)
				ENTITY.SET_ENTITY_PROOFS(players_car, true, true, true, true, true, 0, 0, true)
				end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(player), false, false, false, false, false, 0, 0, false)end)
			menu.divider(vehicleoptions, "~~~> Helicopter & Plane Options <~~~")
			menu.action(vehicleoptions, "Disable Auto-Stablization (Broken atm)", {}, "", function ()
				local CflyingHandling = get_sub_handling_types(entities.get_user_vehicle_as_handle(), 1)
				if CflyingHandling then
					for _, offset in pairs(better_heli_handling_offsets) do
						memory.write_float(CflyingHandling + offset, 0)
					end
					util.toast("Auto-Stablization off.")
				end end)
			menu.toggle_loop(vehicleoptions, "Chaff (Controller Support)", {}, "Key: D-Pad Left", function(toggled)
				if PAD.IS_CONTROL_PRESSED(1, 189) then
					menu.trigger_commands("deploychaff")
				end util.yield() end)
			menu.toggle_loop(vehicleoptions, "Flares (Controller Support)", {}, "Key: D-Pad Left", function(toggled)
				if PAD.IS_CONTROL_PRESSED(1, 189) then
					menu.trigger_commands("deployflares")
				end util.yield() end)
			menu.toggle_loop(vehicleoptions, "Chaff & Flares (Controller Support)", {}, "Key: D-Pad Left", function(toggled)
				if PAD.IS_CONTROL_PRESSED(1, 189) then
					menu.trigger_commands("deployboth")
				end util.yield() end)
		
		menu.divider(miscoptions, "~~~> Misc Options <~~~")
			teleport = menu.list(miscoptions, "Teleport Options", {}, "", function(); end)
				menu.divider(teleport, "~~~> Teleport Options <~~~")
				for index, data in interiors do
					local location_name = data[1]
					local location_coords = data[2]
				menu.action(teleport, location_name, {}, "", function()
					menu.trigger_commands("otr".." ".."on")
					menu.trigger_commands("invisibility".." ".."on")
					util.yield(1000)
					ENTITY.SET_ENTITY_COORDS_NO_OFFSET(players.user_ped(), location_coords.x, location_coords.y, location_coords.z, false, false, false)
					util.yield(100)
					menu.trigger_commands("otr".." ".."off")
					menu.trigger_commands("invisibility".." ".."off")end)end
			cameraoptions = menu.list(miscoptions, "Camera Options", {}, "", function(); end)
				menu.divider(cameraoptions, "~~~> Camera Options <~~~")
				menu.toggle(cameraoptions, "FOV Tryhard FP", {}, "", function(on_toggle)
					if on_toggle then
						menu.trigger_commands("fovfponfoot".." ".."60")
						menu.trigger_commands("fovaiming".." ".."60")
					else
						menu.trigger_commands("fovfponfoot".." ".."-1")
						menu.trigger_commands("fovaiming".." ".."-1")
					end end)
				menu.toggle(cameraoptions, "FOV Dogfight FP", {}, "", function(on_toggle)
					if on_toggle then
						menu.trigger_commands("fovfpinveh".." ".."75")
					else
						menu.trigger_commands("fovfpinveh".." ".."-1")
					end end)
			funnyoptions = menu.list(miscoptions, "Funny Options", {}, "", function(); end)
				menu.divider(funnyoptions, "~~~> Funny Options <~~~")
				menu.action(funnyoptions, "Cum", {}, "", function()
					local ptfx_asset = "scr_indep_fireworks"
					local effect_name = "scr_indep_firework_trailburst"
					request_ptfx_asset(ptfx_asset)
					GRAPHICS.USE_PARTICLE_FX_ASSET(ptfx_asset)
					GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(effect_name, players.user_ped(), 0.0, 0.0, -0.3, -90.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)--90
					for i=1, 10 do 
						local coords = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, i, 0.0)
						FIRE.ADD_EXPLOSION(coords['x'], coords['y'], coords['z'], 67, 0.0, false, false, 0.0, true)
					end end)
				menu.action(funnyoptions, "Massive shit", {}, "Make a massive shit", function()
					local c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
					c.z = c.z -1
					while not STREAMING.HAS_ANIM_DICT_LOADED(agroup) do 
						STREAMING.REQUEST_ANIM_DICT(agroup)
						util.yield()
					end
					TASK.TASK_PLAY_ANIM(player, agroup, anim1, 8.0, 8.0, 3000, -1, 0, 0, false, false, false)
					util.yield(1000)
					entities.create_object(mshit, c)end)
				menu.action(funnyoptions, "Normal shit", {}, "Make a normale sized shit", function()
					local c = ENTITY.GET_ENTITY_COORDS(players.user_ped())
					c.z = c.z -1
					while not STREAMING.HAS_ANIM_DICT_LOADED(agroup) do 
						STREAMING.REQUEST_ANIM_DICT(agroup)
						util.yield()
					end
					TASK.TASK_PLAY_ANIM(player, agroup, anim1, 8.0, 8.0, 3000, 0, 0, false, false, false)
					util.yield(1000)
					entities.create_object(rshit, c)end)
				menu.toggle_loop(funnyoptions, "Hands Up", {}, "Press: X", function(toggled)
					if PAD.IS_CONTROL_PRESSED(1, 323) then
						while not STREAMING.HAS_ANIM_DICT_LOADED("random@mugging3") do
							STREAMING.REQUEST_ANIM_DICT("random@mugging3")
							util.yield(100)
						end
						if not ENTITY.IS_ENTITY_PLAYING_ANIM(PLAYER.PLAYER_PED_ID(), "random@mugging3", "handsup_standing_base", 3) then
							--WEAPON.SET_CURRENT_PED_WEAPON(PLAYER.PLAYER_PED_ID(), MISC.GET_HASH_KEY("WEAPON_UNARMED"), true)
							TASK.TASK_PLAY_ANIM(PLAYER.PLAYER_PED_ID(), "random@mugging3", "handsup_standing_base", 3, 3, -1, 51, 0, false, false, false)
							STREAMING.REMOVE_ANIM_DICT("random@mugging3")
							PED.SET_ENABLE_HANDCUFFS(PLAYER.PLAYER_PED_ID(), true)
						end
					end
					if PAD.IS_CONTROL_RELEASED(1, 323) and ENTITY.IS_ENTITY_PLAYING_ANIM(PLAYER.PLAYER_PED_ID(), "random@mugging3", "handsup_standing_base", 3) then
						TASK.CLEAR_PED_SECONDARY_TASK(PLAYER.PLAYER_PED_ID())
						PED.SET_ENABLE_HANDCUFFS(PLAYER.PLAYER_PED_ID(), false)
					end
					util.yield()end)
			firework = menu.list(miscoptions, "Firework (PS3)", {}, "", function(); end)
				menu.divider(firework, "~~~> Firework Rocket <~~~")
				menu.action(firework, "Place Firework Rocket", {}, "", function(click_type)
					local animlib = "anim@mp_fireworks"
					local ptfx_asset = "scr_indep_fireworks"
					local anim_name = "place_firework_1_rocket"
					local effect_name = "scr_indep_firework_starburst"
					local prop_asset = util.joaat("ind_prop_firework_01")
						request_anim_dict(animlib)
					local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.52, 0.0)
					local ped = players.user_ped()
						ENTITY.FREEZE_ENTITY_POSITION(ped, true)
						TASK.TASK_PLAY_ANIM(ped, animlib, anim_name, -1, -8.0, 3000, 0, 0, false, false, false)
						util.yield(1500)
					local firework_rocket = entities.create_object(prop_asset, pos, true, false, false)
					local firework_rocket_pos = ENTITY.GET_ENTITY_COORDS(firework_rocket)
						OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(firework_rocket)
						ENTITY.FREEZE_ENTITY_POSITION(ped, false)
						util.yield(1000)
						ENTITY.FREEZE_ENTITY_POSITION(firework_rocket, true)
						placed_firework_rockets[#placed_firework_rockets + 1] = firework_rocket end)
				menu.action(firework, "Start", {}, "", function(click_type)
					if #placed_firework_rockets == 0 then 
						util.toast("Place some fireworks first!")
					return 
					end
					local ptfx_asset = "scr_indep_fireworks"
					local effect_name = "scr_indep_firework_starburst"
					request_ptfx_asset(ptfx_asset)
					for i=1, 1 do
					for k,rocket in pairs(placed_firework_rockets) do 
						GRAPHICS.USE_PARTICLE_FX_ASSET(ptfx_asset)
						GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(effect_name, rocket, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
						util.yield(1000)
					end
					end
					for k,rocket in pairs(placed_firework_rockets) do 
						entities.delete_by_handle(rocket)
						placed_firework_rockets[rocket] = nil
					end end)
				menu.divider(firework, "~~~> Firework Cone <~~~")
				menu.action(firework, "Place Firework Cone", {}, "", function(click_type)
					local animlib = "anim@mp_fireworks"
					local ptfx_asset = "scr_indep_fireworks"
					local anim_name = "place_firework_2_cylinder"
					local effect_name = "scr_indep_firework_shotburst"
					local prop_asset = util.joaat("ind_prop_firework_02")
						request_anim_dict(animlib)
					local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.52, 0.0)
					local ped = players.user_ped()
						ENTITY.FREEZE_ENTITY_POSITION(ped, true)
						TASK.TASK_PLAY_ANIM(ped, animlib, anim_name, -1, -8.0, 3000, 0, 0, false, false, false)
						util.yield(1500)
					local firework_cone = entities.create_object(prop_asset, pos, true, false, false)
					local firework_cone_pos = ENTITY.GET_ENTITY_COORDS(firework_cone)
						OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(firework_cone)
						ENTITY.FREEZE_ENTITY_POSITION(ped, false)
						util.yield(1000)
						ENTITY.FREEZE_ENTITY_POSITION(firework_cone, true)
						placed_firework_cones[#placed_firework_cones + 1] = firework_cone end)
				menu.action(firework, "Start", {}, "", function(click_type)
					if #placed_firework_cones == 0 then 
						util.toast("Place some fireworks first!")
					return 
					end
					local ptfx_asset = "scr_indep_fireworks"
					local effect_name = "scr_indep_firework_shotburst"
					request_ptfx_asset(ptfx_asset)
					for i=1, 25 do
					for k,cone in pairs(placed_firework_cones) do 
						GRAPHICS.USE_PARTICLE_FX_ASSET(ptfx_asset)
						GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(effect_name, cone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
						util.yield(800)
					end
					end
					for k,cone in pairs(placed_firework_cones) do 
						entities.delete_by_handle(cone)
						placed_firework_cones[cone] = nil
					end end)
				menu.divider(firework, "~~~> Firework Fontain <~~~")		
				menu.action(firework, "Place Firework Fontain", {}, "", function(click_type)
					local animlib = "anim@mp_fireworks"
					local ptfx_asset = "scr_indep_fireworks"
					local anim_name = "place_firework_2_cylinder"
					local effect_name = "scr_indep_firework_fountain"
					local prop_asset = util.joaat("ind_prop_firework_04")
						request_anim_dict(animlib)
					local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.52, 0.0)
					local ped = players.user_ped()
						ENTITY.FREEZE_ENTITY_POSITION(ped, true)
						TASK.TASK_PLAY_ANIM(ped, animlib, anim_name, -1, -8.0, 3000, 0, 0, false, false, false)
						util.yield(1500)
					local firework_fontain = entities.create_object(prop_asset, pos, true, false, false)
					local firework_fontain_pos = ENTITY.GET_ENTITY_COORDS(firework_fontain)
						OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(firework_fontain)
						ENTITY.FREEZE_ENTITY_POSITION(ped, false)
						util.yield(1000)
						ENTITY.FREEZE_ENTITY_POSITION(firework_fontain, true)
						placed_firework_fontains[#placed_firework_fontains + 1] = firework_fontain end)
				menu.action(firework, "Start", {}, "", function(click_type)
					if #placed_firework_fontains == 0 then 
						util.toast("Place some fireworks first!")
					return 
					end
					local ptfx_asset = "scr_indep_fireworks"
					local effect_name = "scr_indep_firework_fountain"
					request_ptfx_asset(ptfx_asset)
					for i=1, 25 do
					for k,fontain in pairs(placed_firework_fontains) do 
						GRAPHICS.USE_PARTICLE_FX_ASSET(ptfx_asset)
						GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(effect_name, fontain, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
						util.yield(600)
					end
					end
					for k,fontain in pairs(placed_firework_fontains) do 
						entities.delete_by_handle(fontain)
						placed_firework_fontains[fontain] = nil
					end end)
				menu.divider(firework, "~~~> Firework Box <~~~")
				menu.action(firework, "Place Firework Box", {}, "", function(click_type)
					local animlib = "anim@mp_fireworks"
					local ptfx_asset = "scr_indep_fireworks"
					local anim_name = "place_firework_3_box"
					local effect_name = "scr_indep_firework_trailburst"
					local prop_asset = util.joaat("ind_prop_firework_03")
						request_anim_dict(animlib)
					local pos = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(players.user_ped(), 0.0, 0.52, 0.0)
					local ped = players.user_ped()
						ENTITY.FREEZE_ENTITY_POSITION(ped, true)
						TASK.TASK_PLAY_ANIM(ped, animlib, anim_name, -1, -8.0, 3000, 0, 0, false, false, false)
						util.yield(1500)
					local firework_box = entities.create_object(prop_asset, pos, true, false, false)
					local firework_box_pos = ENTITY.GET_ENTITY_COORDS(firework_box)
						OBJECT.PLACE_OBJECT_ON_GROUND_PROPERLY(firework_box)
						ENTITY.FREEZE_ENTITY_POSITION(ped, false)
						util.yield(1000)
						ENTITY.FREEZE_ENTITY_POSITION(firework_box, true)
						placed_firework_boxes[#placed_firework_boxes + 1] = firework_box end)
				menu.action(firework, "Start", {}, "", function(click_type)
					if #placed_firework_boxes == 0 then 
						util.toast("Place some fireworks first!")
					return 
					end
					local ptfx_asset = "scr_indep_fireworks"
					local effect_name = "scr_indep_firework_trailburst"
					request_ptfx_asset(ptfx_asset)
					for i=1, 32 do
					for k,box in pairs(placed_firework_boxes) do 
						GRAPHICS.USE_PARTICLE_FX_ASSET(ptfx_asset)
						GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_ON_ENTITY(effect_name, box, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, 0.0)
						util.yield(450)
					end
					end
					for k,box in pairs(placed_firework_boxes) do 
						entities.delete_by_handle(box)
						placed_firework_boxes[box] = nil
					end end)
			menu.action(miscoptions, "Custom Fake Banner", {"banner"}, "", function(on_click) menu.show_command_box("banner ") end, function(text)
				custom_alert(text)end)
			menu.divider(miscoptions, "~~~> Game Features <~~~")
			menu.toggle_loop(miscoptions, "Auto Accept", {}, "Auto accepts join screens.", function(on_toggle)
				local message_hash = HUD._GET_WARNING_MESSAGE_TITLE_HASH()
				    if message_hash == 15890625 or message_hash == -587688989 then
						PAD._SET_CONTROL_NORMAL(2, 201, 1.0)
					util.yield(50)
				end end)
			menu.toggle_loop(miscoptions, "Voice Chat", {}, "Detects who is talking in game chat.", function ()
				for players.list_except() as pid do
					if NETWORK.NETWORK_IS_PLAYER_TALKING(pid) then
						util.toast("[Mira] <3\n".."> "..players.get_name(pid).." is talking in Voice Chat.")
						log("Voice Chat: (Playername: "..players.get_name(pid).." / RID: "..players.get_rockstar_id(pid))
					end
				end end)

		menu.divider(settings, "~~~> Customizations <~~~")
			watermark = menu.list(settings, "Watermark", {}, "", function(); end)
				menu.divider(watermark, "~~~> Watermark <~~~")
				local pos_settings = menu.list(watermark, "Position", {}, "", function(); end)
				menu.slider(pos_settings, "X position", {"watermark-x"}, "Move the watermark in the x position", -100000, 100000, x * 10000, 1, function(x_)
					x = x_ / 10000 end)
				menu.slider(pos_settings, "Y position", {"watermark-y"}, "Move the watermark in the y position", -100000, 100000, y * 10000, 1, function(y_)
					y = y_ / 10000 end)
				menu.slider(pos_settings, "Add X", {"watermark-addx"}, "Add x ammount to the background", -100000, 100000, add_x * 10000, 1, function(x_)
					add_x = x_ / 10000 end)
				menu.slider(pos_settings, "Add Y", {"watermark-addy"}, "Add y ammount to the background", -100000, 100000, add_y * 10000, 1, function(y_)
					add_y = y_ / 10000 end)
				local color_settings = menu.list(watermark, "Colors", {}, "", function(); end)
				local rgb_background = menu.colour(color_settings, "Background Color", {"watermark-bg_color"}, "Select background color", bg_color, true, function(col)
					bg_color = col end)
				local rgb_text = menu.colour(color_settings, "Text Color", {"watermark-tx_color"}, "Select text color", tx_color, true, function(col)
					tx_color = col end)
				menu.divider(watermark, "~~~> Settings <~~~")
				menu.list_select(watermark, "First Label", {}, "Change the first label in the watermak", {"Disable", "Aurora", "Version", "Femboy Edition", "UwU"}, show_firstl, function (val)
					show_firstl = val end)
				menu.toggle(watermark, "Name", {}, "Show the name in the watermark", function(val)
					show_name = val end, show_name)
				menu.toggle(watermark, "Rockstar ID", {}, "Show the Rockstar ID in the watermark", function(val)
					show_rid = val end, show_rid)
				menu.toggle(watermark, "Session Code", {}, "Show the Session Code in the watermark", function(val)
					show_sessioncode = val end, show_sessioncode)
				menu.toggle(watermark, "GTA Version", {}, "Show the GTA Version in the watermark", function(val)
					show_gtaversion = val end, show_gtaversion)
				--[[menu.toggle(watermark, "Player Count", {}, "Show the name in the watermark", function(val)
					show_players = val end, show_players)]]
				menu.toggle(watermark, "Time", {}, "Show the name in the watermark", function(val)
					show_time = val end, show_time)
				menu.divider(watermark, "~~~> Enabler <~~~")
				menu.toggle_loop(watermark, "Enable Watermark", {}, "Enable/Disable Watermark", function()
					if menu.is_in_screenshot_mode() then return end
						local wm_text = (show_firstl == 2 and "Aurora" or show_firstl == 5 and "UwU" or show_firstl == 4 and "Femboy Edition" or show_firstl == 3 and utils.editions[utils.edition+1] or "") .. (show_name and " | ".. SOCIALCLUB._SC_GET_NICKNAME() or "") .. (show_rid and " | ".. players.get_rockstar_id(players.user()) or "") .. (show_sessioncode and " | Session Code: ".. get_session_code_for_user() or "") .. (show_gtaversion and " | ".. NETWORK._GET_ONLINE_VERSION() or "") .. (show_players and NETWORK.NETWORK_IS_SESSION_STARTED() and " | Players: "..#players.list(true, true, true) or "") .. (show_time and os.date(" | %H:%M:%S ") or "")
						local tx_size = directx.get_text_size(wm_text, 0.5)
						directx.draw_rect(x + add_x * 0.5, y, -(tx_size + 0.0105 + add_x), 0.025 + add_y, bg_color)
						directx.draw_texture(icon, 0.0055, 0.0055, 0.5, 0.5, x - tx_size - 0.0055, y + 0.013, 0, {["r"] = 1.0,["g"] = 1.0,["b"] = 1.0,["a"] = 1.0})
						directx.draw_text(x, y + 0.004, wm_text, ALIGN_TOP_RIGHT, 0.5, tx_color, false) end)
			nametag = menu.list(settings, "Change Nametag Color", {}, "", function(); end)
				menu.list_select(nametag, "Color", {}, "", colors, chatColor, function(color)
					chatColor = color end)
				menu.toggle_loop(nametag, "Change Nametag Color", {}, "", function()
					HUD._OVERRIDE_MULTIPLAYER_CHAT_COLOUR(1, chatColor)
					end, function()
					HUD._OVERRIDE_MULTIPLAYER_CHAT_COLOUR(0, chatColor)end)
			menu.divider(settings, "~~~> Settings <~~~")
			-- [[ Delete Log ]]
				local LogDelete <const> = {"Playerhistory", "General Log"}
				local LogDeleteType <const> = {log1 = 0, log2 = 1}
				local LogDeletetype = 0
			menu.textslider_stateful(settings, "Delete Log:", {}, "", LogDelete, function(index)
					if index == 1 then
						LogDeletetype = LogDeleteType.log1
							io.remove(HistoryFile)
					elseif index == 2 then
						LogDeletetype = LogDeleteType.log2
							io.remove(LogFile)
					end	end)
			menu.action(settings, "Open Aurora Folder", {}, "", function()
				util.open_folder(filesystem.scripts_dir() .. "lib\\AuroraScript\\") end)
			menu.action(settings, "Restart Script", {"restartaurora"}, "Restarts the script to clean the errors.", function()
				util.restart_script()end)

		menu.divider(credits, "~~~> Credits <~~~")
		menu.readonly(credits, "Developer: ", DevName)
		menu.readonly(credits, "Script Version: ", Version)
		menu.readonly(credits, "GTA Online Version:", GTAOVersion)
		menu.readonly(credits, "Game Version:", GameVersion)

		menu.divider(credits, "~~~> Socials <~~~")
		menu.hyperlink(credits, "Multigaming Discord", "https://discord.gg/bHpvhazv7T")
		menu.hyperlink(credits, "GitHub (I3lackExo)", "https://github.com/I3lackExo")
		--menu.hyperlink(credits, "NordVPN Tracker", "https://github.com/I3lackExo/NordVPN-Tracker")

		-- [[ Playerlist Options ]]
			GenerateFeatures = function(pid)
			menu.divider(menu.player_root(pid), "~~~> "..Name.." <~~~")
				menu.action(menu.player_root(pid), "Send Private Message", {"pm"}, "Send a message to a player and the other players can�t see it.", function()
					menu.show_command_box("pm" .. players.get_name(pid) ..  " ")
					end, function(message)
						if #message == 0 then 
							util.toast("[Mira] <3\n".."The message was blank.")
							return 
						end
						local from_msg = "[To you] " .. message
						local to_msg = "[To " .. players.get_name(pid) .. "] " .. message
						if string.len(from_msg) > 254 or string.len(to_msg) > 254 then 
							util.toast("[Mira] <3\n".."PM too long!")
						else
							chat.send_targeted_message(pid, players.user(), from_msg, true)
							chat.send_message(to_msg, true, true, false)
						end end)
				--[[menu.action(menu.player_root(pid), "Remove Godmode from Speedo", {}, "Turns off the godmode of the Speedo that was previously glitched.", function()
					local vehicle = get_player_veh(pid,true)
					if vehicle then	
						ENTITY.SET_ENTITY_INVINCIBLE(vehicle, false) 
						util.toast("[Mira] <3\n".."> (Target: "..PLAYER.GET_PLAYER_NAME(pid)..")".." his/her Speedo should not be in Godmode anymore.")
					end end)]]
				--[[menu.toggle_loop(menu.player_root(pid), "Remove Vehicle Godmode", {}, "", function()
					local vehicle = get_player_veh(pid,true)
					if vehicle then	
						ENTITY.SET_ENTITY_INVINCIBLE(vehicle, false) 
					end end)]]
				menu.toggle_loop(menu.player_root(pid), "Give Vehicle Godmode", {}, "", function(toggled)
					ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)), true, true, true, true, true, 0, 0, true)
					end, function() ENTITY.SET_ENTITY_PROOFS(PED.GET_VEHICLE_PED_IS_IN(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)), false, false, false, false, false, 0, 0, false)
					end)

			recovery = menu.list(menu.player_root(pid), "Recovery Options", {}, "", function(); end)
				menu.divider(recovery, "~~~> Recovery Options <~~~")
				rploop = menu.list(recovery, "RP Loop", {}, "", function(); end)
					menu.divider(rploop, "~~~> RP Loop <~~~")
					menu.slider(rploop, "Stop At Level...", {}, "", 1, 8000, 120, 1, function(val)
						levelPly = val end)
					menu.slider(rploop, "Loop Delay", {}, "", 0, 2500, 0, 10, function(val)
						delayPly = val end)
					menu.toggle_loop(rploop, "Enable Loop", {}, "", function()
						if players.get_rank(pid) >= levelPly then 
							util.toast(players.get_name(pid).."is already at or above level "..levelPly..". :)")
							menu.value = false
							return 
						end
						repeat
							for i = 21, 24 do
								if players.get_rank(pid) >= levelPly then break end
								util.trigger_script_event(1 << pid, {968269233, players.user(), 4, i, 1, 1, 1})
								util.trigger_script_event(1 << pid, {968269233, players.user(), 8, -1, 1, 1, 1})
								if delayPly > 0 then
									util.yield(delayPly)
								end
							end
							util.yield()
						until players.get_rank(pid) >= levelPly or not menu.value
						if players.get_rank(pid) >= levelPly then 
							util.toast(players.get_name(pid).." is now at level "..levelPly..". :)")
							menu.value = false
							util.yield()
							util.yield()
							return 
						end end)

			trolling = menu.list(menu.player_root(pid), "Trolling Options", {}, "", function(); end)
				menu.divider(trolling, "~~~> Meteor Script [2Take1] <~~~")
				menu.action(trolling, "Send to Gas Chamber", {}, "", function()
						--TASK.CLEAR_PED_TASKS_IMMEDIATELY(players.user_ped(pid))
						local object = object.create_object(959275690, player.get_player_coords(pid) - v3(0, 0, 0), true, false)
						fire.add_explosion(player.get_player_coords(pid), 21, 1, 0, 0, pid)
						fire.add_explosion(player.get_player_coords(pid), 21, 1, 0, 0, pid)
						fire.add_explosion(player.get_player_coords(pid), 21, 1, 0, 0, pid)
						fire.add_explosion(player.get_player_coords(pid), 21, 1, 0, 0, pid)
						fire.add_explosion(player.get_player_coords(pid), 21, 1, 0, 0, pid)
						util.yield(15000)
						entities.delete_by_handle(object)end)
				menu.action(trolling, "Atomize", {}, "", function()
						for i = 1, 30 do
							local pos = players.get_position(pid)
							FIRE.ADD_EXPLOSION(pos.x + math.random(-2, 2), pos.y + math.random(-2, 2), pos.z + math.random(-2, 2), 70, 1, true, false, 0.2, false)
							util.yield(math.random(0, 1))
						end end)
				menu.divider(trolling, "~~~> CRWX Script [2Take1] <~~~")
				menu.action(trolling, "Send Orb", {"orb"}, "", function()
						graphics.set_next_ptfx_asset("scr_xm_orbital")
						while not graphics.has_named_ptfx_asset_loaded("scr_xm_orbital") do
							graphics.request_named_ptfx_asset("scr_xm_orbital")
							util.yield(0)
						end
						audio.play_sound_from_coord(1, "DLC_XM_Explosions_Orbital_Cannon", player.get_player_coords(pid), 0, true, 0, false)
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						graphics.start_networked_ptfx_non_looped_at_coord("scr_xm_orbital_blast", player.get_player_coords(pid), v3(0, 180, 0), 1, true, true, true)end)
				menu.action(trolling, "Fling vehicles at player", {}, "", function()
						local p_c = players.get_position(pid)
							for _, v in pairs(entities.get_all_vehicles_as_handles()) do 
								if not PED.IS_PED_A_PLAYER(VEHICLE.GET_PED_IN_VEHICLE_SEAT(v, -1, false)) then 
									local v_c = ENTITY.GET_ENTITY_COORDS(v)
									local c = {}
									c.x = (p_c.x - v_c.x)*2
									c.y = (p_c.y - v_c.y )*2
									c.z = (p_c.z - v_c.z)*2
									ENTITY.APPLY_FORCE_TO_ENTITY(v, 1, c.x, c.y, c.z, 0, 0, 0, 0, false, false, true, false, false)
								end
							end end)
				menu.toggle(trolling, "Spam Cargoplanes", {}, "", function(on)
						if on then
							local pos = player.get_player_coords(pid)
							local veh_hash = 0x15F27762
							STREAMING.REQUEST_MODEL(veh_hash)
							while (not STREAMING.HAS_MODEL_LOADED(veh_hash)) do
							util.yield(10)
							end
							local tableOfVehicles = {}
							for i = 1, 75 do
							  tableOfVehicles[#tableOfVehicles + 1] = vehicle.create_vehicle(veh_hash, pos, pos.z, true, false)
							end
							util.yield(1000)
							for i = 1, #tableOfVehicles do
							  entities.delete_by_handle(tableOfVehicles[i])
							end
							tableOfVehicles = {}
							STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED(veh_hash)
							end
						return HANDLER_CONTINUE end)
				menu.divider(trolling, "~~~> Trolling Options <~~~")
				menu.action(trolling, "Disable Ghost", {"ptghost"}, "", function(on)
					util.toast("[Mira] <3\n".."> Please wait, while I transfer the bounty. (Target: "..PLAYER.GET_PLAYER_NAME(pid)..")")
					menu.trigger_commands("bounty"..PLAYER.GET_PLAYER_NAME(pid).." 1000")
					util.yield(10500)
					util.toast("[Mira] <3\n".."> Transfer completed. (Target: "..PLAYER.GET_PLAYER_NAME(pid)..")")end)
				menu.action(trolling, "Remove Explosive Shit", {}, "", function(on)
					WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
					WEAPON.GIVE_WEAPON_TO_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
					WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0x6D544C99)
					WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xFEA23564)
					--Assistant("> I removed explosive sniper from " .. PLAYER.GET_PLAYER_NAME(pid), colors.green)end)
					util.toast("[Mira] <3\n".."> I removed explosive shit from "..PLAYER.GET_PLAYER_NAME(pid))end)
				menu.toggle_loop(trolling, "Remove Explosive Shit (Loop)", {}, "", function(on)
					WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xA914799)
					WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0x6D544C99)
					WEAPON.REMOVE_WEAPON_FROM_PED(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid), 0xFEA23564)end)		
				menu.toggle_loop(trolling, "Lock On Sound", {""}, "", function()
					local ped = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
					local vehicle = PED.GET_VEHICLE_PED_IS_IN(ped, false)
					if not PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
						util.toast(lang.get_localised(1067523721):gsub("{}", players.get_name(pid)))
						lockon.value = false
						return 
					end
					VEHICLE.SET_VEHICLE_HOMING_LOCKEDONTO_STATE(vehicle, 1)end)
			
			--[[menu.action(menu.player_root(pid), "Invite to CEO/MC", {"ceoinvite"}, "Invite player to your current organization (SecuroServ CEO or Motorcycle Club)", function(on)
				if players.get_org_type(players.user()) == -1 then
					util.toast("[Mira] <3\n".."> Cannot send invite until you create an organization (ServoServ CEO or Motorcycle Club)")
					return end

					util.trigger_script_event(1 << pid, {-245642440, players.user(), 4, 10000, 0, 0, 0, 0, memory.read_int(memory.script_global(1924276 + 9)), memory.read_int(memory.script_global(1924276 + 10)),})end)]]

			-- [[ Kicks & Crashes ]]
				local PMKicks <const> = {"Host Kick", "Orbital Host Kick"}
				local PmKicksType <const> = {hostkick = 0, orbitalkick = 1}
				local PmKickstype = 0

				local PMCrashes <const> = {"Mother Nature", "AI Generated"}
				local PmCrashesType <const> = {crash1 = 0, crash2 = 1}
				local PmCrashestype = 0
			menu.textslider_stateful(menu.player_root(pid), "Kicks:", {}, "", PMKicks, function(index)
				if index == 1 then
					PmKickstype = PmKicksType.hostkick
						if NETWORK.NETWORK_IS_HOST() then
							local name = PLAYER.GET_PLAYER_NAME(pid)
							log("Host Kick: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid)..")")
							NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
						end
				elseif index == 2 then
					PmKickstype = PmKicksType.orbitalkick
						if NETWORK.NETWORK_IS_HOST() then
							local ip = players.get_connect_ip(pid)
							local name = PLAYER.GET_PLAYER_NAME(pid)
							log("Orbital Kick: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid)..")")
							graphics.set_next_ptfx_asset("scr_xm_orbital")
							while not graphics.has_named_ptfx_asset_loaded("scr_xm_orbital") do
								graphics.request_named_ptfx_asset("scr_xm_orbital")
								util.yield(0)
							end
							audio.play_sound_from_coord(1, "DLC_XM_Explosions_Orbital_Cannon", player.get_player_coords(pid), 0, true, 0, false)
							fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
							fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
							fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
							fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
							fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
							fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
							graphics.start_networked_ptfx_non_looped_at_coord("scr_xm_orbital_blast", player.get_player_coords(pid), v3(0, 180, 0), 1, true, true, true)
							util.yield(500)
							NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
						end
				end	end)
			menu.textslider_stateful(menu.player_root(pid), "Crashes:", {}, "", PMCrashes, function(index)
				if index == 1 then
					PmCrashestype = PmCrashesType.crash1
						local user = PLAYER.GET_PLAYER_PED(players.user())
						local model = util.joaat("h4_prop_bush_mang_ad")
						local pos = players.get_position(pid)
						local oldPos = players.get_position(players.user())
						BlockSyncs(pid, function()
							util.yield(100)
							ENTITY.SET_ENTITY_VISIBLE(user, false)
							ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
							PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
							PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
							util.yield(500)
							PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
							util.yield(2500)
							TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
							for i = 1, 5 do
								util.spoof_script("freemode", SYSTEM.WAIT)
							end
							ENTITY.SET_ENTITY_HEALTH(user, 0)
							NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
							ENTITY.SET_ENTITY_VISIBLE(user, true)
						end)
				elseif index == 2 then
					PmCrashestype = PmCrashesType.crash2
						local player_position = players.get_position(pid)
						local joaat_hash = util.joaat("prop_fragtest_cnst_04")
						util.request_model(joaat_hash)
						local object_handle = entities.create_object(joaat_hash, player_position)
						OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object_handle, 3, false)
						util.yield(1000)
						entities.delete_by_handle(object_handle)
				end	end)
			menu.action(menu.player_root(pid), "Save Playerdata", {"save"}, "", function(on)
				local ip = players.get_connect_ip(pid)
				local name = PLAYER.GET_PLAYER_NAME(pid)
				history("Saved Playerdata: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid).." / IP: "..string.format("%i.%i.%i.%i)", ip >> 24 & 255, ip >> 16 & 255, ip >> 8 & 255, ip & 255))
				util.toast("[Mira] <3\n".."> I have saved you all the important data of the player ("..name..").")end)end

			local InitialPlayersList = players.list(true, true, true)
				for i=1, #InitialPlayersList do
    				GenerateFeatures(InitialPlayersList[i])
				end
				InitialPlayersList = nil
				players.on_join(GenerateFeatures)

	-- [[ End ]]
		util.on_stop(function()
			util.toast("[Mira] <3\n".."> Bye "..SOCIALCLUB._SC_GET_NICKNAME().."!")end)

		util.create_tick_handler(function()
		if TASK.GET_IS_TASK_ACTIVE(players.user_ped(), 2) then --when exiting a car
			setCarOptions(false)end
		local carCheck = entities.get_user_vehicle_as_handle()
		if players_car != carCheck then
			players_car = carCheck
			setCarOptions(true)end end)	
		while true do
			if menu.is_open() == true then
				local current_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
					if current_equipped_weapon == last_equipped_weapon then
					else
						last_equipped_weapon = current_equipped_weapon
						menu.delete(attachment_tab)
						attachment_tab = menu.list(weaponattachments,"Attachments",{},"See available attachments for your equipped weapon")
						for key, value in pairs(attachments_table) do
							local curr_equipped_weapon = WEAPON.GET_SELECTED_PED_WEAPON(PLAYER.GET_PLAYER_PED(players.user()))
							if WEAPON.DOES_WEAPON_TAKE_WEAPON_COMPONENT(curr_equipped_weapon, key) == true then
								menu.action(attachment_tab,value,{value},"Attach " .. value .. "to your current weapon",function(on_click)
										WEAPON.GIVE_WEAPON_COMPONENT_TO_PED(PLAYER.GET_PLAYER_PED(players.user()),curr_equipped_weapon,key)
								end)
							end
						end
					end
			end
			util.yield() end

----------------------------------------------------------------------------------------------------------
	-- Link: https://forge.plebmasters.de/objects?search=firework
	-- Rocket = ind_prop_firework_01 - scr_indep_firework_starburst - place_firework_1_rocket
	-- Cone = ind_prop_firework_02 - scr_indep_firework_shotburst - place_firework_2_cylinder
	-- Box = ind_prop_firework_03 - scr_indep_firework_trailburst - place_firework_3_box
	-- Fontain = ind_prop_firework_04 - scr_indep_firework_fountain - place_firework_2_cylinder
----------------------------------------------------------------------------------------------------------
-- [[ Backups ]]

	-- [[ Notification ]]
		--[[local scriptdir = filesystem.scripts_dir()
			local racDir = scriptdir .. "lib\\C4tScripts\\"
				if not filesystem.exists(racDir) then
					filesystem.mkdir(racDir)
				end
				if not filesystem.exists(racDir) then
					util.toast("resource directory not found")
				else
					util.register_file(racDir .. "Resource_Pack.ytd")
				end
		function Developer(message, color) -- Main picture
			HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(color)
				local picture
					if not filesystem.exists(racDir) then
						picture = "CHAR_SOCIAL_CLUB"
					else
						picture = "Resource_Pack"
					end
			GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(picture, 1)
				while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(picture) do
					util.yield()
				end
			util.BEGIN_TEXT_COMMAND_THEFEED_POST(message)
				if color == colors.green or color == colors.red then
					subtitle = colorcodes.small.."~w~> [MiradeliaX Dev.]"
				elseif color == colors.black then
					subtitle = colorcodes.small.."~w~> [MiradeliaX Dev.]"
				else
					subtitle = colorcodes.small.."~w~> [MiradeliaX Dev.]"
				end
			HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(picture, "Developer", true, 1, colorcodes.middle.."xX-LulzSecC4t-Xx", subtitle)

			HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)end
		function Assistant(message, color) -- Mira picture
			HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(color)
				local picture
					if not filesystem.exists(racDir) then
						picture = "CHAR_SOCIAL_CLUB"
					else
						picture = "Resource_Pack"
					end
			GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(picture, 1)
				while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(picture) do
					util.yield()
				end
			util.BEGIN_TEXT_COMMAND_THEFEED_POST(message)
				if color == colors.green or color == colors.red then
					subtitle = colorcodes.small.."~w~> [MiradeliaX Assistant]"
				elseif color == colors.black then
					subtitle = colorcodes.small.."~w~> [MiradeliaX Assistant]"
				else
					subtitle = colorcodes.small.."~w~> [MiradeliaX Assistant]"
				end
			HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(picture, "Mira", true, 1, colorcodes.middle.."Mira", subtitle)

			HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)end
		function AssistantRAC(message, color) -- Mira picture
			HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(color)
				local picture
					if not filesystem.exists(racDir) then
						picture = "CHAR_SOCIAL_CLUB"
					else
						picture = "Resource_Pack"
					end
			GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(picture, 1)
				while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(picture) do
					util.yield()
				end
			util.BEGIN_TEXT_COMMAND_THEFEED_POST(message)
				if color == colors.green or color == colors.red then
					subtitle = colorcodes.small.."~w~> [Rockstar Protection]"
				elseif color == colors.black then
					subtitle = colorcodes.small.."~w~> [Rockstar Protection]"
				else
					subtitle = colorcodes.small.."~w~> [Rockstar Protection]"
				end
			HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(picture, "Mira", true, 1, colorcodes.middle.."Mira", subtitle)

			HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false)end
		function GoogleAPI(message, color) --> GoogleAPI logo
		    HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(color)
				local picture
					if not filesystem.exists(racDir) then
						picture = "CHAR_SOCIAL_CLUB"
					else
						picture = "Resource_Pack"
					end
		    GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(picture, 1)
				while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(picture) do
					util.yield()
				end
		    util.BEGIN_TEXT_COMMAND_THEFEED_POST(message)
				if color == colors.green or color == colors.red then
					subtitle = colorcodes.small.."~u~GoogleAPI Translater"
				elseif color == colors.black then
					subtitle = colorcodes.small.."~c~GoogleAPI Translater"
				else
					subtitle = colorcodes.small.."~c~GoogleAPI Translater"
				end
		    HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(picture, "GoogleAPI", true, 4, colorcodes.middle.."GoogleAPI", subtitle)

		    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false) end
		function Multigaming(message, color) --> Multigaming logo
		    HUD._THEFEED_SET_NEXT_POST_BACKGROUND_COLOR(color)
				local picture
					if not filesystem.exists(racDir) then
						picture = "CHAR_SOCIAL_CLUB"
					else
						picture = "Resource_Pack"
					end
		    GRAPHICS.REQUEST_STREAMED_TEXTURE_DICT(picture, 1)
				while not GRAPHICS.HAS_STREAMED_TEXTURE_DICT_LOADED(picture) do
					util.yield()
				end
		    util.BEGIN_TEXT_COMMAND_THEFEED_POST(message)
				if color == colors.green or color == colors.red then
					subtitle = colorcodes.small.."~w~> [Multigaming Discord]"
				elseif color == colors.black then
					subtitle = colorcodes.small.."~w~> [Multigaming Discord]"
				else
					subtitle = colorcodes.small.."~w~> [Multigaming Discord]"
				end
		    HUD.END_TEXT_COMMAND_THEFEED_POST_MESSAGETEXT(picture, "Multigaming", true, 4, colorcodes.middle.."Discord Invite", subtitle)

		    HUD.END_TEXT_COMMAND_THEFEED_POST_TICKER(true, false) end--]]

	-- [[ Animation List ]]
		--[[<Anim dict="anim@amb@clubhouse@boardroom@crew@male@var_c@base@" name="idle_a" />
		<Anim dict="anim@amb@clubhouse@boardroom@crew@female@var_c@base_r@" name="base" />
		<Anim dict="anim@amb@office@boardroom@crew@female@var_b@base@" name="base" />
		<Anim dict="amb@world_human_leaning@female@wall@back@holding_elbow@base" name="base" />
		<Anim dict="anim@amb@office@seating@female@var_a@base@" name="idle_b" />
		<Anim dict="anim@amb@office@seating@female@var_b@base@" name="idle_a" />
		<Anim dict="anim_heist@arcade_combined@" name="world_human_hang_out_street@_male_a@_idle_a_idle_c" />
		<Anim dict="anim@amb@office@seating@male@var_c@base@" name="idle_c" />
		<Anim dict="anim@amb@clubhouse@mini@darts@" name="wait_idle" />
		<Anim dict="club_intro-100" name="csb_tonyprince_dual-100" />
		<Anim dict="club_intro-101" name="mp_m_freemode_01_dual-101" />
		<Anim dict="missheistdockssetup1ig_10@idle_b" name="talk_pipe_b_worker2" />
		<Anim dict="missheistdockssetup1ig_10@idle_d" name="talk_pipe_d_worker2" />
		<Anim dict="missheist_jewel_setup" name="idle_storeclerk" />
		<Anim dict="amb@world_human_hang_out_street@female_hold_arm@idle_a" name="idle_a" />
		<Anim dict="amb@world_human_hang_out_street@female_hold_arm@idle_a" name="idle_b" />
		<Anim dict="amb@world_human_hang_out_street@female_hold_arm@idle_a" name="idle_c" />
		<Anim dict="amb@world_human_leaning@female@smoke@idle_a" name="idle_c" />
		<Anim dict="amb@world_human_leaning@female@smoke@idle_a" name="idle_a" />
		<Anim dict="amb@world_human_leaning@female@wall@back@holding_elbow@idle_a" name="idle_a" />
		<Anim dict="amb@world_human_picnic@female@idle_a" name="idle_b" />
		<Anim dict="amb@world_human_picnic@female@idle_a" name="idle_c" />
		<Anim dict="amb@world_human_seat_steps@female@hands_by_sides@idle_a" name="idle_a" />
		<Anim dict="amb@world_human_seat_wall@female@hands_by_sides@idle_a" name="idle_c" />
		<Anim dict="anim@amb@nightclub@dancers@crowddance_groups@" name="hi_dance_crowd_09_v1_female^3" />
		<Anim dict="anim@amb@nightclub@peds@" name="mini_strip_club_lap_dance_ld_girl_a_song_a_p1" />
		<Anim dict="anim@mp_yacht@shower@female@" name="shower_idle_a" />
		<Anim dict="anim_casino_a@amb@casino@peds@" name="amb_world_human_hang_out_street_female_hold_arm_idle_b" />
		<Anim dict="random@street_race" name="_car_a_flirt_girl" />
		<Anim dict="bs_2a_mcs_10-2" name="csb_stripper_01_dual-2" />
		<Anim dict="move_f@sexy@a" name="idle" />
		<Anim dict="switch@michael@sitting_on_car_bonnet" name="sitting_on_car_bonnet_loop" />
		<Anim dict="amb@world_human_hang_out_street@female_hold_arm@base" name="base" />
		<Anim dict="anim@amb@casino@hangout@ped_female@stand@03a@base" name="base" />
		<Anim dict="anim@amb@casino@hangout@ped_female@stand@03b@base" name="base" />
		<Anim dict="amb@world_human_seat_wall@male@hands_in_lap@base" name="base" />
		<Anim dict="amb@world_human_seat_wall_eating@female@sandwich_right_hand@base" name="base" />
		<Anim dict="amb@world_human_seat_wall_eating@female@sandwich_right_hand@idle_a" name="idle_a" />
		<Anim dict="amb@world_human_prostitute@crackhooker@idle_a" name="idle_b" />
		<Anim dict="anim@amb@business@bgen@bgen_no_work@" name="sit_phone_phonepickup-noworkfemale" />
		<Anim dict="anim@amb@business@bgen@bgen_no_work@" name="sit_phone_phonepickup_nowork" />
		<Anim dict="anim@amb@business@bgen@bgen_no_work@" name="sit_phone_phoneputdown_fallasleep_nowork" />
		<Anim dict="cellphone@self@franklin@" name="peace" />
		<Anim dict="armenian_1_int-0" name="a_f_y_beach_01^2-0" />
		<Anim dict="armenian_1_int-0" name="a_m_y_surfer_01-0" />
		<Anim dict="armenian_1_int-0" name="cs_drfriedlander_dual-0" />
		<Anim dict="amb@world_human_prostitute@cokehead@base" name="base" />
		<Anim dict="amb@world_human_prostitute@french@base" name="base" />
		<Anim dict="amb@world_human_prostitute@hooker@base" name="base" />
		<Anim dict="mp_move@prostitute@f@cokehead" name="idle" />
		<Anim dict="mp_move@prostitute@f@hooker" name="idle" />
		<Anim dict="mp_move@prostitute@m@hooker" name="idle" />]]
	
	-- [[ Soundspam ]]
		--[[soundspam = menu.list(trolling, "Sound Spam", {}, "")
				menu.toggle_loop(soundspam, "SMS Spam", {}, "", function()
					util.trigger_script_event(1 << pid, {1670832796, pid, math.random(-2147483647, 2147483647)})end)
				menu.toggle_loop(soundspam, "Interior Invite", {}, "", function()
					util.trigger_script_event(1 << pid, {1111927333, pid, math.random(1, 6)})end)
				menu.toggle_loop(soundspam, "Invite Notification", {}, "", function()
					util.trigger_script_event(1 << pid, {-668341698, pid, math.random(1, 150), -1, -1})end)
				menu.toggle_loop(soundspam, "Collected Checkpoint", {}, "", function()
					util.trigger_script_event(1 << pid, {-1529596656, pid, -547323955, 0, 0, 0, 0, 0, 0, 0, pid, 0, 0, 0})
					util.yield(25)end)
				menu.toggle_loop(soundspam, "Character Notification", {}, "", function()
					util.trigger_script_event(1 << pid, {-634789188, pid, math.random(0, 178), 0, 0, 0})end)
				menu.toggle_loop(soundspam, "Error Notification", {}, "", function()
					util.trigger_script_event(1 << pid, {-1251171789, pid, math.random(-2147483647, 2147483647)})end)]]

	--[[ Nightclub Popularity ]]
		--[[menu.toggle_loop(recoveryoptions, "Nightclub Popularity", {}, "Keeps the Nightclub Popularity at max", function ()
			if util.is_session_started() then
				local ncpop = math.floor(STAT_GET_INT("CLUB_POPULARITY") / 10)
				if ncpop < 100 then
					menu.trigger_commands("clubpopularity 100")
					util.yield(250)
				end
			end end)]]

	-- [[ Get own Bounty ]]
		--[[menu.toggle_loop(bountyoptions, "Auto Claim Bounties", {}, "Automatically claims bounties that are placed on you.", function ()
				local bounty = players.get_bounty(players.user())
					if bounty != nil then
						repeat
							menu.trigger_commands("removebounty")
							util.yield(1000)
							bounty = players.get_bounty(players.user())
						until bounty == nil
						util.toast("[Mira] <3\n".."> Bounty has been claimed.")
					end end)]]

	-- [[ Kicks & Crashes ]]
		--[[crash = menu.list(menu.player_root(pid), "Kicks & Crashes", {}, "", function(); end)
				menu.divider(crash, "~~~> Basic Kicks <~~~")
				menu.action(crash, "Host Kick", {"host"}, "", function()
					--menu.trigger_commands("timeout"..PLAYER.GET_PLAYER_NAME(pid).." ".."on")
					if NETWORK.NETWORK_IS_HOST() then
						local name = PLAYER.GET_PLAYER_NAME(pid)
						log("Host Kick: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid)..")")
						NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
					end end)
				menu.action(crash, "Orbital Host Kick", {"orbhost"}, "", function()
					--menu.trigger_commands("timeout"..PLAYER.GET_PLAYER_NAME(pid).." ".."on")
					if NETWORK.NETWORK_IS_HOST() then
						local ip = players.get_connect_ip(pid)
						local name = PLAYER.GET_PLAYER_NAME(pid)
						log("Host Kick: (Playername: "..name.." / RID: "..players.get_rockstar_id(pid)..")")
						graphics.set_next_ptfx_asset("scr_xm_orbital")
						while not graphics.has_named_ptfx_asset_loaded("scr_xm_orbital") do
							graphics.request_named_ptfx_asset("scr_xm_orbital")
							util.yield(0)
						end
						audio.play_sound_from_coord(1, "DLC_XM_Explosions_Orbital_Cannon", player.get_player_coords(pid), 0, true, 0, false)
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						fire.add_explosion(player.get_player_coords(pid), 59, 1000000, 1, 1, 0, false, player.get_player_ped(player.player_id()))
						graphics.start_networked_ptfx_non_looped_at_coord("scr_xm_orbital_blast", player.get_player_coords(pid), v3(0, 180, 0), 1, true, true, true)
						util.yield(500)
						NETWORK.NETWORK_SESSION_KICK_PLAYER(pid)
					end end)
				menu.divider(crash, "~~~> Crashes <~~~")
				menu.action(crash, "Broken World Crash", {"ptbwc"}, "The crash remains after leaving the lobby.", function()
					local pos = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid))
					local hakuchou = util.joaat("hakuchou2")
    
					STREAMING.REQUEST_MODEL(hakuchou)
					while not STREAMING.HAS_MODEL_LOADED(hakuchou) do
						util.yield()
					end
    
					local vehicle = entities.create_vehicle(hakuchou, pos, 0)
					VEHICLE.SET_VEHICLE_MOD(vehicle, 34, 3, false)
					util.yield(1000)
					entities.delete_by_handle(vehicle)end)
				menu.action(crash, "AI Generated Crash", {"ptai"}, "Most mod menus will block this.", function()
					local player_position = players.get_position(pid)
					local joaat_hash = util.joaat("prop_fragtest_cnst_04")
					util.request_model(joaat_hash)
					local object_handle = entities.create_object(joaat_hash, player_position)
					OBJECT.BREAK_OBJECT_FRAGMENT_CHILD(object_handle, 3, false)
					util.yield(1000)
					entities.delete_by_handle(object_handle)end)
				menu.action(crash, "Mother Nature Crash", {"ptmncrash"}, "Most mod menus will block this.", function()
					local user = PLAYER.GET_PLAYER_PED(players.user())
					local model = util.joaat("h4_prop_bush_mang_ad")
					local pos = players.get_position(pid)
					local oldPos = players.get_position(players.user())
					BlockSyncs(pid, function()
						util.yield(100)
						ENTITY.SET_ENTITY_VISIBLE(user, false)
						ENTITY.SET_ENTITY_COORDS_NO_OFFSET(user, pos.x, pos.y, pos.z, false, false, false)
						PLAYER.SET_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user(), model)
						PED.SET_PED_COMPONENT_VARIATION(user, 5, 8, 0, 0)
						util.yield(500)
						PLAYER.CLEAR_PLAYER_PARACHUTE_PACK_MODEL_OVERRIDE(players.user())
						util.yield(2500)
						TASK.CLEAR_PED_TASKS_IMMEDIATELY(user)
						for i = 1, 5 do
							util.spoof_script("freemode", SYSTEM.WAIT)
						end
						ENTITY.SET_ENTITY_HEALTH(user, 0)
						NETWORK.NETWORK_RESURRECT_LOCAL_PLAYER(oldPos.x, oldPos.y, oldPos.z, 0, false, false, 0)
						ENTITY.SET_ENTITY_VISIBLE(user, true)
					end)end)]]

	-- [[ Info ]]
		--local host = players.get_host(pidlist)
		--local scripthost = players.get_script_host()
		--local playername = players.get_name(pidlist)
		--local rid = players.get_rockstar_id(pidlist)
		--local vpn = players.is_using_vpn()
		--local ip = players.get_ip()
		--local ipport = players.get_port()
		--local connectedip = players.get_connect_ip()
		--local connectedipport = players.get_connect_port()
		--local lanip = players.get_lan_ip()
		--local lanipport = players.get_lan_port()
		--local hosttoken = players.get_host_token()