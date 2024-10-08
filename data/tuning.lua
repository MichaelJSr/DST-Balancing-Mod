--Misc
TUNING.EXPERIMENTALCONFIG = GetModConfigData("experimental")

--Handheld
TUNING.MULTITOOL_AXE_PICKAXE_EFFICIENCY = 1.66
TUNING.WATERPROOFNESS_UMBRELLA = GetModConfigData("umbrellaproof")

--Body
TUNING.ARMORSLURPER_SLOW_HUNGER = 0.3
TUNING.ARMORDRAGONFLY = GetModConfigData("scalemaildurability")
TUNING.ARMORDRAGONFLY_ABSORPTION = GetModConfigData("scalemailabsorption")
TUNING.ARMOR_SANITY = 666
TUNING.REFLECTIVEVEST_PERISHTIME = TUNING.TOTAL_DAY_TIME * 12
TUNING.SWEATERVEST_PERISHTIME = TUNING.TOTAL_DAY_TIME * 15
TUNING.FRESTOVERHEATRATE = GetModConfigData("frestoverheatrate")
TUNING.ARMORSNURTLESHELL = GetModConfigData("snurtleshelldurability")
TUNING.ORANGEAMULET_USES = GetModConfigData("orangeamuletdurability")
TUNING.ORANGEAMULET_RANGE = GetModConfigData("orangeamuletrange")
TUNING.ORANGEAMULET_ICD = GetModConfigData("orangeamuleticd")

--Containers
TUNING.DRAGONFLYCHESTCOLUMNS = GetModConfigData("dragonflychestcolumns")
TUNING.DRAGONFLYCHESTROWS = GetModConfigData("dragonflychestrows")
TUNING.MINOTAURCHESTCOLUMNS = GetModConfigData("minotaurchestcolumns")
TUNING.MINOTAURCHESTROWS = GetModConfigData("minotaurchestrows")
TUNING.SNURTLESHELLCOLUMNS = GetModConfigData("snurtleshellcolumns")
TUNING.SNURTLESHELLROWS = GetModConfigData("snurtleshellrows")

--Hat
TUNING.ARMOR_BEEHAT_ABSORPTION = GetModConfigData("beehatabsorption")
TUNING.SPIDERHAT_PERISHTIME = 8 * TUNING.SEG_TIME
TUNING.WATERPROOFNESS_RAINHAT = GetModConfigData("rainhatproof")
TUNING.WATERPROOFNESS_COOKIEHAT = GetModConfigData("cookiehatproof")

--Structures
TUNING.TRAP_TEETH_USES = 20
TUNING.NIGHTLIGHT_FUEL_MAX = TUNING.TOTAL_DAY_TIME * 3
TUNING.NIGHTLIGHT_FUEL_START = TUNING.TOTAL_DAY_TIME
TUNING.EYETURRET_ATTACK_PERIOD = 1
TUNING.EYETURRET_RANGE = 20
TUNING.EYETURRET_REGEN = 24
TUNING.POTFERNSANITY = GetModConfigData("potfernsanity")
TUNING.POTSUCCSANITY = GetModConfigData("potsuccsanity")

--Hay Walls
TUNING.REPAIR_STICK_HEALTH = GetModConfigData("HealthHayWalls")/3
TUNING.REPAIR_CUTGRASS_HEALTH = GetModConfigData("HealthHayWalls")/3
TUNING.HAYWALL_HEALTH = GetModConfigData("HealthHayWalls")
--Wood Walls
TUNING.REPAIR_LOGS_HEALTH = GetModConfigData("HealthWoodWalls")/4
TUNING.REPAIR_BOARDS_HEALTH = GetModConfigData("HealthWoodWalls")
TUNING.WOODWALL_HEALTH = GetModConfigData("HealthWoodWalls")
--Stone Walls
TUNING.REPAIR_ROCKS_HEALTH = (3 * GetModConfigData("HealthStoneWalls"))/8
TUNING.REPAIR_CUTSTONE_HEALTH = GetModConfigData("HealthStoneWalls")
TUNING.STONEWALL_HEALTH = GetModConfigData("HealthStoneWalls")
--Thulecite Walls
TUNING.REPAIR_THULECITE_PIECES_HEALTH = GetModConfigData("HealthRuinsWalls")/16
TUNING.REPAIR_THULECITE_HEALTH = (3 * GetModConfigData("HealthRuinsWalls"))/8
TUNING.RUINSWALL_HEALTH = GetModConfigData("HealthRuinsWalls")
--Moonrock Walls
TUNING.REPAIR_MOONROCK_NUGGET_HEALTH = (3 * GetModConfigData("HealthMoonrockWalls"))/8
TUNING.REPAIR_MOONROCK_CRATER_HEALTH = GetModConfigData("HealthMoonrockWalls")
TUNING.MOONROCKWALL_HEALTH = GetModConfigData("HealthMoonrockWalls")

--Turf
TUNING.SCALEDTURFSPEED = GetModConfigData("scaledturfspeed")
TUNING.SCALEDTURFWINTERINSULATION = GetModConfigData("scaledturfwinterinsulation")
TUNING.SCALEDTURFSMOLDER = GetModConfigData("scaledturfsmolder")
TUNING.SCALEDTURFWILDFIRE = GetModConfigData("scaledturfwildfire")
TUNING.WOODTURFSPEED = GetModConfigData("woodturfspeed")
TUNING.CARPETTURFSANITY = GetModConfigData("carpetturfsanity")
TUNING.CARPETTURFWATERPROOFNESS = GetModConfigData("carpetturfwaterproofness")
TUNING.CHECKEREDTURFSANITY = GetModConfigData("checkeredturfsanity")

--Character
TUNING.GAMEMODE_STARTING_ITEMS.DEFAULT.WAXWELL = {"waxwelljournal", "armor_sanity", "nightmarefuel", "nightmarefuel",
"nightmarefuel", "nightmarefuel", "nightmarefuel", "nightmarefuel", "nightmarefuel", "nightmarefuel"}

--[[
if TUNING.EXPERIMENTALCONFIG then
	TUNING.WORTOX_SOULHEAL_RANGE = 16
	TUNING.WORTOX_SOULSTEALER_RANGE = 16
	TUNING.WORTOX_SOULEXTRACT_RANGE = 32
end
]]
TUNING.WORTOX_MAX_SOULS = GetModConfigData("wortoxsouls")
TUNING.WORTOX_SOULHEAL_LOSS_PER_PLAYER = GetModConfigData("wortoxheal")

TUNING.WILLOW_DEBUFF_RATE = GetModConfigData("willowdebuffrate")
TUNING.WILLOW_FIRE_MULT = GetModConfigData("willowfiremult")
TUNING.BERNIE_HEAL_RATE = GetModConfigData("berniehealrate")

TUNING.WINONA_HEALTH_INCREASE = GetModConfigData("winonahealthincrease")
TUNING.WINONA_HUNGER_INCREASE = GetModConfigData("winonahungerincrease")
TUNING.WINONA_SANITY_RESIST_GRUE = GetModConfigData("winonasanityresistgrue")
TUNING.WINONA_SANITY_BUILD_STRUCTURE = GetModConfigData("winonasanitybuildstructure")
TUNING.WINONA_BONUS_DURABILITY = GetModConfigData("winonabonusdurability")
TUNING.WINONA_HUNGER_DRAIN = GetModConfigData("winonahungerdrain")

--Mobs
TUNING.ROCKY_ABSORB = GetModConfigData("rockyabsorption")
TUNING.ROCKY_HEALTH = GetModConfigData("rockyhealth")
TUNING.LAVAE_HUNGER_RATE = 25/TUNING.TOTAL_DAY_TIME
TUNING.LEIF_DAMAGE = 100
TUNING.LEIF_DAMAGE_PLAYER_PERCENT = 0.5
TUNING.DECID_MONSTER_ADDITIONAL_LOOT_CHANCE = 0.5
TUNING.BEEFALO_DOMESTICATION_LOSE_DOMESTICATION = 0
TUNING.BEE_STINGER_DROPRATE = GetModConfigData("beestingerdroprate")
TUNING.BEE_HONEY_DROPRATE = GetModConfigData("beehoneydroprate")
TUNING.SPIDER_DROPPER_HEALTH = GetModConfigData("dropperhealth")

--Other
TUNING.TILLWEEDSALVE_TICK_RATE = 2
TUNING.SADDLE_WAR_BONUS_DAMAGE = 25
TUNING.ROCK_FRUIT_REGROW =
{
	EMPTY = { BASE = 4*TUNING.DAY_TIME_DEFAULT, VAR = 4*TUNING.SEG_TIME },
	PREPICK = { BASE = 12*TUNING.SEG_TIME, VAR = 2*TUNING.SEG_TIME },
	PICK = { BASE = 2*TUNING.DAY_TIME_DEFAULT, VAR = 8*TUNING.SEG_TIME },
	CRUMBLE = { BASE = 2*TUNING.DAY_TIME_DEFAULT, VAR = 8*TUNING.SEG_TIME },
}
TUNING.SPICE_MULTIPLIERS =
{
   SPICE_SALT = {
      HEALTH = 0.5,
      SANITY = 0.5,
   },
}

--Filling
TUNING.THULECITEFILL = GetModConfigData("thulecitefill")
TUNING.NIGHTMAREFILL = GetModConfigData("nightmarefill")
TUNING.BONESHARDFILL = GetModConfigData("boneshardfill")