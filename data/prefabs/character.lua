-- WAXWELL
local function UpdateWaxwell(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.prefab == "waxwell" then
		if inst.components.petleash ~= nil then
			-- Allow Maxwell to summon up to 6 minions
			inst.components.petleash:SetMaxPets(inst.components.petleash:GetMaxPets() + 6)
		else
			inst:AddComponent("petleash")
			-- Allow Maxwell to summon up to 6 minions
			inst.components.petleash:SetMaxPets(6)
		end
		
		-- KU_Jm5uHm2b is my (the owner's) user id, I am testing something regarding userid here
		if inst.components.sanity ~= nil and inst.userid == "KU_Jm5uHm2b" then
			inst.components.sanity.dapperness = TUNING.DAPPERNESS_HUGE
		end
	end
end
AddPlayerPostInit(UpdateWaxwell)

-- WILLOW
local function UpdateWillow(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end

	if inst.prefab == "willow" then
		local _customdamagemultfn = inst.components.combat.customdamagemultfn
		inst.components.combat.customdamagemultfn = function(inst, target, weapon, multiplier, mount)
			local mult = 1
			if _customdamagemultfn ~= nil then
				mult = _customdamagemultfn(inst, target, weapon, multiplier, mount)
			end
			
			if weapon ~= nil and (weapon:HasTag("lighter") or weapon:HasTag("rangedlighter")) then
				mult = mult * TUNING.WILLOW_FIRE_MULT
			end
			
			if target.components.health ~= nil then
				local scaled_fire_damage = math.max(300/target.components.health.maxhealth, TUNING.WILLOW_DEBUFF_RATE)
				local rate = target.components.health:GetFireDamageScale() + scaled_fire_damage
				target.components.health.GetFireDamageScale = function()
					return rate
				end
			end

			return mult
		end
	end
end
AddPlayerPostInit(UpdateWillow)

-- BERNIE
AddPrefabPostInit("bernie_inactive", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.fueled ~= nil then
		local _onequip = inst.components.equippable.onequipfn
		inst.components.equippable:SetOnEquip(function(inst, owner)
			_onequip(inst, owner)
			inst.components.fueled:StopConsuming()
		end)

		local _onunequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnUnequip(function(inst, owner)
			_onunequip(inst, owner)
			inst.components.fueled:StopConsuming()
		end)
	end
end)

AddPrefabPostInit("bernie_big", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.health ~= nil then
		inst.components.health:StartRegen(TUNING.BERNIE_HEAL_RATE, 1)
	end
end)

AddPrefabPostInit("bernie_active", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.health ~= nil then
		inst.components.health:StartRegen(TUNING.BERNIE_HEAL_RATE, 2)
	end
end)

-- WINONA
local function SanityWhenResistGrue(inst, data)
	inst.components.sanity:DoDelta(TUNING.WINONA_SANITY_RESIST_GRUE, false)
end

local function SanityWhenBuildStructure(inst, data)
	inst.components.sanity:DoDelta(TUNING.WINONA_SANITY_BUILD_STRUCTURE, false)
end

local function MoreEffectiveBuildItem(inst, data)
	if data ~= nil then
		if data.item.components.finiteuses ~= nil then
			data.item.components.finiteuses:SetPercent(TUNING.WINONA_BONUS_DURABILITY)
		end
		if data.item.components.armor ~= nil then
			data.item.components.armor:InitCondition(data.item.components.armor.maxcondition * TUNING.WINONA_BONUS_DURABILITY,
			data.item.components.armor.absorb_percent)
		end
		if data.item.components.fueled ~= nil then
			data.item.components.fueled:InitializeFuelLevel(data.item.components.fueled.maxfuel * TUNING.WINONA_BONUS_DURABILITY)
		end
		if data.item.components.perishable ~= nil then
			data.item.components.perishable:SetNewMaxPerishTime(data.item.components.perishable.perishtime * TUNING.WINONA_BONUS_DURABILITY)
		end
	end
end

local function UpdateWinona(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end

	if inst.prefab == "winona" then
		inst:AddTag("quagmire_fasthands")
		inst.components.health:SetMaxHealth(TUNING.WENDY_HEALTH + TUNING.WINONA_HEALTH_INCREASE)
		inst.components.hunger:SetMax(TUNING.WENDY_HUNGER + TUNING.WINONA_HUNGER_INCREASE)
		inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE * TUNING.WINONA_HUNGER_DRAIN)
		inst:ListenForEvent("resistedgrue", SanityWhenResistGrue)
		inst:ListenForEvent("buildstructure", SanityWhenBuildStructure)
		inst:ListenForEvent("builditem", MoreEffectiveBuildItem)
	end
end
AddPlayerPostInit(UpdateWinona)

AddComponentPostInit("locomotor", function(self)
	local _GetSpeedMultiplier = self.GetSpeedMultiplier
	self.GetSpeedMultiplier = function(self)
		return (self.inst.prefab == "winona" and math.max(_GetSpeedMultiplier(self), 0.75))
		or _GetSpeedMultiplier(self)
	end
end)