-- Update the waterproofness of an item to the given value
local function UpdateWaterProofness(inst, waterproofness)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.waterproofer ~= nil then
		inst.components.waterproofer:SetEffectiveness(waterproofness)
	end
end

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

-- Modify an item to decrease overheat damage by the given value (2 would be 100% less damage, 0.5 would be 100% more damage)
local function ModifyOverheatDamage(inst, factor)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.equippable ~= nil then
		local _OverheatHurtRate = TUNING.WILSON_HEALTH / TUNING.FREEZING_KILL_TIME
		local _onequip = inst.components.equippable.onequipfn
		inst.components.equippable:SetOnEquip(function(inst, owner)
			_onequip(inst, owner)
			if owner.components.temperature.overheathurtrate ~= nil then
				_OverheatHurtRate = owner.components.temperature.overheathurtrate
			end
			owner.components.temperature:SetOverheatHurtRate(_OverheatHurtRate / factor)
		end)

		local _onunequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnUnequip(function(inst, owner)
			_onunequip(inst, owner)
			if owner.components.temperature.overheathurtrate ~= nil then
				_OverheatHurtRate = owner.components.temperature.overheathurtrate
			end
			owner.components.temperature:SetOverheatHurtRate(_OverheatHurtRate * factor)
		end)
	end
end

-- Make an item into an armor but make it lose fuel/perish/uses when it takes damage
local function AddArmorComponent(inst, absorb_percent)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.armor == nil then
		inst:AddComponent("armor")
		inst.components.armor:InitIndestructible(absorb_percent)
		local _ontakedamage = inst.components.armor.ontakedamage
		inst.components.armor.ontakedamage = function(inst, damage_amount)
			if _ontakedamage ~= nil then
				_ontakedamage(inst, damage_amount)
			end
			if inst.components.fueled ~= nil then
				inst.components.fueled:DoUpdate(damage_amount)
			end
         if inst.components.finiteuses ~= nil then
            inst.components.finiteuses:Use(damage_amount)
         end
         if inst.components.perishable ~= nil then
            inst.components.perishable:LongUpdate(damage_amount)
         end
		end
	end
end

-- Get sanity back when taking damage
local function SanityWhenHit(inst, rate)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

   -- Event Listener for healthdelta
   local function SanityWhenHitHealthDelta(owner, data)
      if owner.components.sanity ~= nil then
         local sanity = owner.components.sanity
         if sanity then
            local sanity_change = -data.amount * rate
            sanity:DoDelta(sanity_change, false)
         end
      end
   end

	if inst.components.equippable ~= nil then
		local _onequip = inst.components.equippable.onequipfn
		inst.components.equippable:SetOnEquip(function(inst, owner)
			_onequip(inst, owner)
			owner:ListenForEvent("healthdelta", SanityWhenHitHealthDelta)
		end)

		local _onunequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnUnequip(function(inst, owner)
			_onunequip(inst, owner)
			owner:RemoveEventCallback("healthdelta", SanityWhenHitHealthDelta)
		end)
	end
end


-- LAZY FORAGER
AddPrefabPostInit("thulecite_pieces", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.filling == nil then
		inst:AddComponent("filling")
	end
end)

AddPrefabPostInit("orangeamulet", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.refillable == nil then
		inst:AddComponent("refillable")
		inst.components.refillable:AddFilling("thulecite_pieces", TUNING.THULECITEFILL, 0, 0)
	end
end)

-- BONE HELM
AddPrefabPostInit("nightmarefuel", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if TUNING.EXPERIMENTALCONFIG then
		-- Increased the fuel value by a factor of 3 so that it only takes 3 to fully power up a night light
		inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL * 3
	end
	if inst.components.filling == nil then
		inst:AddComponent("filling")
	end
end)

AddPrefabPostInit("skeletonhat", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.refillable == nil then
		inst:AddComponent("refillable")
		inst.components.refillable:AddFilling("nightmarefuel", TUNING.NIGHTMAREFILL, 0, 0)
	end
end)

-- STRIDENT TRIDENT
AddPrefabPostInit("boneshard", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.filling == nil then
		inst:AddComponent("filling")
	end
end)

AddPrefabPostInit("trident", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.refillable == nil then
		inst:AddComponent("refillable")
		inst.components.refillable:AddFilling("boneshard", TUNING.BONESHARDFILL, 10, 0)
	end
end)

-- AXE PICKAXE
local function UpdateAxePickaxe(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.tool ~= nil then
		-- Added digging, hammering, and terraforming
		inst.components.tool:SetAction(GLOBAL.ACTIONS.DIG)
		inst.components.tool:SetAction(GLOBAL.ACTIONS.HAMMER, TUNING.MULTITOOL_AXE_PICKAXE_EFFICIENCY)
		inst:AddInherentAction(GLOBAL.ACTIONS.TERRAFORM)
	end

	if inst.components.finiteuses ~= nil then
		inst.components.finiteuses:SetConsumption(GLOBAL.ACTIONS.TERRAFORM, .125)
		inst.components.finiteuses:SetConsumption(GLOBAL.ACTIONS.DIG, 1)
		inst.components.finiteuses:SetConsumption(GLOBAL.ACTIONS.HAMMER, 1)
	end
	
	if inst.components.terraformer == nil then
		inst:AddComponent("terraformer")
	end
	if inst.components.shaver == nil then
		inst:AddComponent("shaver")
	end
end
AddPrefabPostInit("multitool_axe_pickaxe", UpdateAxePickaxe)

-- COOKIE CUTTER HAT
AddPrefabPostInit("cookiecutterhat", function(inst) UpdateWaterProofness(inst, TUNING.WATERPROOFNESS_COOKIEHAT) end)

-- RAIN HAT
AddPrefabPostInit("rainhat", function(inst) UpdateWaterProofness(inst, TUNING.WATERPROOFNESS_RAINHAT) end)

-- UMBRELLA
AddPrefabPostInit("umbrella", function(inst) UpdateWaterProofness(inst, TUNING.WATERPROOFNESS_UMBRELLA) end)

-- SUMMER FREST
AddPrefabPostInit("reflectivevest", function(inst) ModifyOverheatDamage(inst, TUNING.FRESTOVERHEATRATE) end)

-- DAPPER VEST
AddPrefabPostInit("sweatervest", function(inst) SanityWhenHit(inst, 0.4) end)

-- BREEZY VEST
local function UpdateTrunkVestSummer(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.insulator ~= nil then
		-- Change the Breezy Vest to have an insulation time 60 -> 120
		inst.components.insulator:SetInsulation(TUNING.INSULATION_MED)
	end
end
AddPrefabPostInit("trunkvest_summer", UpdateTrunkVestSummer)

-- MELON HAT
AddPrefabPostInit("watermelonhat", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.perishable ~= nil then
		inst.components.perishable:SetPerishTime(TUNING.PERISH_FAST)
	end
end)

-- HIBEARNATION VEST
AddPrefabPostInit("beargervest", function(inst) AddArmorComponent(inst, 0.5) end)

-- MAGILUMINESCENCE
AddPrefabPostInit("hawaiianshirt", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.equippable ~= nil then
		inst.components.equippable.walkspeedmult = 1.2
	end
end)

-- FIRE STAFF
AddPrefabPostInit("firestaff", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.weapon ~= nil then
		inst.components.weapon:SetDamage(20)
	end
end)

-- FIRE DART
AddPrefabPostInit("blowdart_fire", function(inst)
	inst:AddTag("rangedlighter")

	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end

	if inst.components.weapon ~= nil then
		inst.components.weapon:SetDamage(50)
	end
end)