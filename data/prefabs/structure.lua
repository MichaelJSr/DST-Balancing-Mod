-- Adds a sanity aura to the given inst with the given amount
local function AddSanityAura(inst, amount)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.sanityaura == nil then
		inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = amount
	end
end


-- NIGHTLIGHT
local function UpdateNightlight(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.workable ~= nil then
		inst.components.workable:SetWorkLeft(16)
	end
	if inst.components.fueled ~= nil then
		inst.components.fueled:SetSections(5)
	end
end
AddPrefabPostInit("nightlight", UpdateNightlight)

local NightlightFlameFireLevels =
{
    {anim="level1", sound="dontstarve/common/nightlight", radius=4, intensity=0.45, falloff=0.55, colour = {253/255,179/255,179/255}, soundintensity=.1},
    {anim="level2", sound="dontstarve/common/nightlight", radius=5, intensity=0.4, falloff=0.475, colour = {253/255,179/255,179/255}, soundintensity=.3},
    {anim="level2", sound="dontstarve/common/nightlight", radius=6, intensity=0.325, falloff=0.4, colour = {253/255,179/255,179/255}, soundintensity=.6},
    {anim="level3", sound="dontstarve/common/nightlight", radius=7, intensity=0.25, falloff=0.325, colour = {253/255,179/255,179/255}, soundintensity=.8},
	-- Added a level 5 flame
	{anim="level4", sound="dontstarve/common/nightlight", radius=9, intensity=0.2, falloff=0.25, colour = {253/255,179/255,179/255}, soundintensity=1},
}

local function UpdateNightlightFlame(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.firefx ~= nil then
		inst.components.firefx.levels = NightlightFlameFireLevels
	end
end
AddPrefabPostInit("nightlight_flame", UpdateNightlightFlame)

-- SIESTA LEAN TO
local function UpdateSiestaHut(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.sleepingbag ~= nil then
		-- Changed to be the same hunger as tents
		inst.components.sleepingbag.hunger_tick = TUNING.SLEEP_HUNGER_PER_TICK
	end
end
AddPrefabPostInit("siestahut", UpdateSiestaHut)

-- POTTED FERN AND SUCCULENT
AddPrefabPostInit("pottedfern", function(inst) AddSanityAura(inst, TUNING.POTFERNSANITY/60) end)
AddPrefabPostInit("succulent_potted", function(inst) AddSanityAura(inst, TUNING.POTSUCCSANITY/60) end)
