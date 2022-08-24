local function RemoveLoot(inst, loot)
   for key, value in pairs(inst.components.lootdropper.loot) do
	   if value == loot then
		   inst.components.lootdropper.loot[key] = nil
		end
	end
end


-- POISON BIRCHNUTS
local function UpdatePoisonGuard(self)
	local _StartMonster = self.StartMonster
	self.StartMonster = function(starttime)
		_StartMonster(starttime)
		if self.inst.components.lootdropper ~= nil then
			for i = 2, 1, -1 do
				self.inst.components.lootdropper:AddChanceLoot("livinglog", 1.0)
			end
			for i = 24, 1, -1 do
				self.inst.components.lootdropper:AddChanceLoot("acorn", 1.0)
			end
		end
	end
end
AddComponentPostInit("deciduoustreeupdater", UpdatePoisonGuard)


-- LAVAE PET
local function OnHungerDeltaLavaePet(inst, data)
	if inst.components.heater ~= nil then
		--Adjust heat and light put off.
		inst.components.heater.heat = Lerp(15, 100, data.newpercent)
		inst.Light:SetRadius(Lerp(.33, 1, data.newpercent))
		inst.Light:SetIntensity(Lerp(.25, .75, data.newpercent))
	end
	
	-- Added a sanity aura that lerps based on hunger
	if inst.components.hunger:GetPercent() <= 0.75 then
		inst.components.sanityaura.aura = Lerp(-TUNING.SANITYAURA_LARGE, 0, data.newpercent)
	else
		inst.components.sanityaura.aura = 0
	end
end

local function UpdateLavaePet(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.freezable ~= nil then
		inst:RemoveComponent("freezable")
	end
	if inst.components.propagator ~= nil then
		inst:RemoveComponent("propagator")
	end
	if inst.components.combat ~= nil then
		inst:RemoveComponent("combat")
	end
	
	if inst.components.sanityaura == nil then
		inst:AddComponent("sanityaura")
		inst.components.sanityaura.aura = 0
		inst:ListenForEvent("hungerdelta", OnHungerDeltaLavaePet)
	end
end
AddPrefabPostInit("lavae_pet", UpdateLavaePet)


-- SPIDER QUEEN
local function UpdateSpiderQueen(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.lootdropper ~= nil then
		RemoveLoot(inst, "spiderhat")
		inst.components.lootdropper:AddChanceLoot("spiderhat", 0.4)
	end
end
AddPrefabPostInit("spiderqueen", UpdateSpiderQueen)

-- LEIF
local function UpdateLeif(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.lootdropper ~= nil then
      _SetLeifScale = inst.SetLeifScale
      inst.SetLeifScale = function(inst, scale)
         if _SetLeifScale ~= nil then
            _SetLeifScale(inst, scale)
         end
         local newLoot = {}
         for i = 1, (scale * 6.5), 1 do
            table.insert(newLoot, "livinglog")
            if i % 2 == 0 then
               table.insert(newLoot, "plantmeat")
            end
         end
         inst.components.lootdropper:SetLoot(newLoot)
      end
	end
end
AddPrefabPostInit("leif", UpdateLeif)

-- BEES
local function UpdateBees(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:SetLoot(nil)
		inst.components.lootdropper:AddChanceLoot("stinger", 0.25)
		inst.components.lootdropper:AddChanceLoot("honey", 0.25)
	end
end
AddPrefabPostInit("bee", UpdateBees)
AddPrefabPostInit("killerbee", UpdateBees)

-- ROCK LOBSTERS
AddPrefabPostInit("rocky", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.lootdropper ~= nil then
		local loot = {"rocks", "rocks", "rocks", "rocks", "rocks", "rocks",
			"flint", "flint", "flint", "flint", "flint", "flint",
			"meat", "meat", "meat"}
		inst.components.lootdropper:SetLoot(loot)
	end
end)

-- SPITTER SPIDER
AddPrefabPostInit("spider_spitter", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
    end
	
	if inst.components.lootdropper ~= nil then
		local loot = {"phlegm"}
		inst.components.lootdropper:SetLoot(loot)
		inst.components.lootdropper:AddRandomLoot("monstermeat", 1)
		inst.components.lootdropper:AddRandomLoot("silk", .5)
		inst.components.lootdropper:AddRandomLoot("spidergland", .5)
		inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
		inst.components.lootdropper.numrandomloot = 1
	end
end)

-- SHATTERED SPIDER
AddPrefabPostInit("spider_moon", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
    end
	
	if inst.components.combat ~= nil then
		inst.components.combat:SetAttackPeriod(2.5)
		inst.components.combat:SetRange(TUNING.SPIDER_WARRIOR_ATTACK_RANGE * 1.25, TUNING.SPIDER_WARRIOR_HIT_RANGE)
	end
	
	if inst.components.lootdropper ~= nil then
		local loot = {"moonglass"}
		inst.components.lootdropper:SetLoot(loot)
		inst.components.lootdropper:AddRandomLoot("monstermeat", 1)
		inst.components.lootdropper:AddRandomLoot("silk", .5)
		inst.components.lootdropper:AddRandomLoot("spidergland", .5)
		inst.components.lootdropper:AddRandomHauntedLoot("spidergland", 1)
		inst.components.lootdropper.numrandomloot = 1
	end
end)

-- MUTATED PENGUIN
AddPrefabPostInit("mutated_penguin", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
    end
	
	if inst.components.lootdropper ~= nil then
		inst.components.lootdropper:AddChanceLoot("monstermeat", 0.25)
		inst.components.lootdropper:AddChanceLoot("ice", 0.5)
		inst.components.lootdropper:AddChanceLoot("ice", 0.5)
		inst.components.lootdropper:AddChanceLoot("ice", 0.5)
		inst.components.lootdropper:AddChanceLoot("ice", 0.5)
		inst.components.lootdropper:AddChanceLoot("ice", 0.5)
	end
end)

-- CRABKING
AddPrefabPostInit("crabking_feeze", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
    end

	inst:ListenForEvent("endspell", function()
		local pos = GLOBAL.Vector3(inst.Transform:GetWorldPosition())
		local range = inst.crab and inst.crab:IsValid() and (TUNING.CRABKING_FREEZE_RANGE * (0.75 + GLOBAL.Remap(inst.crab.countgems(inst.crab).blue,0,9,0,2.25)) / 2)
		local ents = GLOBAL.TheSim:FindEntities(pos.x, pos.y, pos.z, range)
		for _, target in pairs(ents) do
			if target.components.freezable ~= nil and target.components.health ~= nil then
				target.components.freezable:Thaw(TUNING.CRABKING_CAST_TIME_FREEZE + 2)
				target.components.health:DoDelta(-inst.crab.countgems(inst.crab).blue * 5, false)
			end
		end
	end)
end)