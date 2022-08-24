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
	{Ingredient("thulecite", 4), Ingredient("livinglog", 4), Ingredient("moonrocknugget", 4), Ingredient("stinger", 400)},
	TECH.MAGIC_THREE,
	{placer="minotaurchest_placer", min_spacing=1.5, atlas="images/inventoryimages.xml", image="minotaurchest.tex"})