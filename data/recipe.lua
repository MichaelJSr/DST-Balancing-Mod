local TECH = GLOBAL.TECH
local CHARACTER_INGREDIENT = GLOBAL.CHARACTER_INGREDIENT

AddRecipe2("nightmare_timepiece", {Ingredient("thulecite", 1), Ingredient("nightmarefuel", 1)},	TECH.ANCIENT_TWO, {nounlock=true})

AddRecipe2("trunkvest_summer", {Ingredient("trunk_summer", 1), Ingredient("silk", 4)}, TECH.SCIENCE_TWO)

AddRecipe2("nightlight", {Ingredient("goldnugget", 4), Ingredient("nightmarefuel", 2), Ingredient("redgem", 1)}, TECH.MAGIC_TWO, {placer="nightlight_placer"})

AddRecipe2("purpleamulet", {Ingredient("goldnugget", 6), Ingredient("nightmarefuel", 4),Ingredient("purplegem", 1)}, TECH.MAGIC_THREE)

AddRecipe2("wall_hay_item",	{Ingredient("cutgrass", 4), Ingredient("twigs", 2)}, TECH.SCIENCE_ONE, {numtogive=6})

AddRecipe2("hawaiianshirt", {Ingredient("papyrus", 2), Ingredient("silk", 3), Ingredient("cactus_flower", 3)}, TECH.SCIENCE_TWO)

AddRecipe2("tillweedsalve",	{Ingredient("tillweed", 3), Ingredient("petals", 2), Ingredient("charcoal", 1)}, TECH.SCIENCE_TWO)

AddRecipe2("firestaff",	{Ingredient("spear", 1), Ingredient("redgem", 1)}, TECH.MAGIC_THREE)

AddRecipe2("icehat", {Ingredient("rope", 4), Ingredient("ice", 10)}, TECH.SCIENCE_TWO)

AddRecipe2("brush",	{Ingredient("steelwool", 1), Ingredient("twigs", 2), Ingredient("goldnugget", 2)}, TECH.SCIENCE_TWO)

AddRecipe2("saltlick",	{Ingredient("boards", 2), Ingredient("saltrock", 4)}, TECH.SCIENCE_TWO, {placer="saltlick_placer"})

AddRecipe2("trap_teeth", {Ingredient("log", 1), Ingredient("rope", 1), Ingredient("houndstooth", 3)}, TECH.SCIENCE_TWO)

-- Refine
AddRecipe2("boneshard", {Ingredient("houndstooth", 10)}, TECH.SCIENCE_ONE)

-- Blowdarts
AddRecipe2("blowdart_pipe",	{Ingredient("cutreeds", 2), Ingredient("houndstooth", GetModConfigData("DartAmount")), Ingredient("feather_robin_winter", 1)}, TECH.SCIENCE_TWO, {numtogive=GetModConfigData("DartAmount")})
AddRecipe2("blowdart_fire", {Ingredient("cutreeds", 2), Ingredient("charcoal", GetModConfigData("DartAmount")), Ingredient("feather_robin", 1)}, TECH.SCIENCE_TWO, {numtogive=GetModConfigData("DartAmount")})
AddRecipe2("blowdart_yellow", {Ingredient("cutreeds", 2), Ingredient("goldnugget", GetModConfigData("DartAmount")), Ingredient("feather_canary", 1)}, TECH.SCIENCE_TWO, {numtogive=GetModConfigData("DartAmount")})
AddRecipe2("blowdart_sleep", {Ingredient("cutreeds", 2), Ingredient("stinger", GetModConfigData("DartAmount")), Ingredient("feather_crow", 1)}, TECH.SCIENCE_TWO, {numtogive=GetModConfigData("DartAmount")})

-- Make the Shadow minions say 15% of sanity
AddRecipe2("shadowlumber_builder",	{Ingredient("nightmarefuel", 2), Ingredient("axe", 1), Ingredient(CHARACTER_INGREDIENT.MAX_SANITY, 0.15)}, TECH.SHADOW_TWO, {builder_tag="shadowmagic", nounlock=true})
AddRecipe2("shadowminer_builder", {Ingredient("nightmarefuel", 2), Ingredient("pickaxe", 1), Ingredient(CHARACTER_INGREDIENT.MAX_SANITY, 0.15)}, TECH.SHADOW_TWO, {builder_tag="shadowmagic", nounlock=true})
AddRecipe2("shadowdigger_builder", {Ingredient("nightmarefuel", 2), Ingredient("shovel", 1), Ingredient(CHARACTER_INGREDIENT.MAX_SANITY, 0.15)}, TECH.SHADOW_TWO, {builder_tag="shadowmagic", nounlock=true})
AddRecipe2("shadowduelist_builder", {Ingredient("nightmarefuel", 2), Ingredient("spear", 1), Ingredient(CHARACTER_INGREDIENT.MAX_SANITY, 0.25)}, TECH.SHADOW_TWO, {builder_tag="shadowmagic", nounlock=true})

-- Claustrophobia and new
AddRecipe2("minotaurchest",
	{Ingredient("thulecite", 4), Ingredient("livinglog", 4), Ingredient("moonrocknugget", 4), Ingredient("stinger", 200)},
	TECH.MAGIC_THREE,
	{placer="minotaurchest_placer", min_spacing=1.5, atlas="images/inventoryimages.xml", image="minotaurchest.tex"})
	
AddRecipe2("resurrectionstatue", {Ingredient("boards", 4), Ingredient("beardhair", 4), Ingredient(CHARACTER_INGREDIENT.HEALTH, TUNING.EFFIGY_HEALTH_PENALTY)}, TECH.MAGIC_TWO,	{placer="resurrectionstatue_placer", min_spacing=0})
AddRecipe2("cookpot", {Ingredient("cutstone", 3), Ingredient("charcoal", 6), Ingredient("twigs", 6)}, TECH.SCIENCE_ONE, {placer="cookpot_placer", min_spacing=1})
AddRecipe2("beebox", {Ingredient("boards", 2),Ingredient("honeycomb", 1),Ingredient("bee", 4)}, TECH.SCIENCE_TWO, {placer="beebox_placer", min_spacing=1})
AddRecipe2("firesuppressor", {Ingredient("gears", 2),Ingredient("ice", 15),Ingredient("transistor", 2)}, TECH.SCIENCE_TWO, {placer="firesuppressor_placer", min_spacing=0})
AddRecipe2("lightning_rod", {Ingredient("goldnugget", 4), Ingredient("cutstone", 1)}, TECH.SCIENCE_ONE, {placer="lightning_rod_placer", min_spacing=1})
AddRecipe2("pighouse", {Ingredient("boards", 4), Ingredient("cutstone", 3), Ingredient("pigskin", 4)}, TECH.SCIENCE_TWO, {placer="pighouse_placer", min_spacing=2})
AddRecipe2("rabbithouse", {Ingredient("boards", 4), Ingredient("carrot", 10), Ingredient("manrabbit_tail", 4)}, TECH.SCIENCE_TWO, {placer="rabbithouse_placer", min_spacing=2})
AddRecipe2("icebox", {Ingredient("goldnugget", 2), Ingredient("gears", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO, {placer="icebox_placer", min_spacing=1})
AddRecipe2("saltbox", {Ingredient("saltrock", 10), Ingredient("bluegem", 1), Ingredient("cutstone", 1)}, TECH.SCIENCE_TWO, {placer="saltbox_placer", min_spacing=1})
AddRecipe2("meatrack",	{Ingredient("twigs", 3),Ingredient("charcoal", 2), Ingredient("rope", 3)}, TECH.SCIENCE_ONE, {placer="meatrack_placer", min_spacing=1})