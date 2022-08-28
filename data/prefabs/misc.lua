-- SPOOK CHANCE CHANGE
AddComponentPostInit("spooked", function(self)
	self.ShouldSpook=function()
		return math.random() <= GetModConfigData("SpookChance")
	end
end)


-- MOBS WETNESS WATERBALLOON CHANGE
AddPrefabPostInitAny(function(inst)
	local oldWet = inst.GetIsWet
	function inst:GetIsWet(...)
		if inst:HasTag("modWet") then
			return true
		end
		return oldWet(self, ...)
	end
end)

local function AddWater(inst)
	inst:AddTag("modWet")
end

local function AddDry(inst)
	inst:RemoveTag("modWet")
	inst.wetDur = nil
end

local function MakeWet(inst)
	duration = GetModConfigData("waterproofness")
	maximum = duration * 5
	if inst.wetDur == nil then
		inst.wetDur = GLOBAL.GetTime() + duration
		AddWater(inst)
		inst.wetTask = inst:DoTaskInTime(duration, AddDry)
	else
		if inst.wetTask ~= nil then
			inst.wetTask:Cancel()
			inst.wetTask = nil
		end
		local newduration = math.min(inst.wetDur - GLOBAL.GetTime() + duration, maximum)
		inst.wetDur = GLOBAL.GetTime() + newduration
		AddWater(inst)
		inst.wetTask = inst:DoTaskInTime(newduration, AddDry)
	end
end

AddPrefabPostInit("waterballoon", function(inst)
	if inst.components.wateryprotection == nil then return end
	local SpreadProtectionAtPoint_old = inst.components.wateryprotection.SpreadProtectionAtPoint
	function inst.components.wateryprotection:SpreadProtectionAtPoint(x, y, z, dist, ...)
		SpreadProtectionAtPoint_old(self,x,y,z,dist,...)
		local ents = GLOBAL.TheSim:FindEntities(x, y, z, dist or 4, {"_combat"}, self.ignoretags)
		for i, v in pairs(ents) do
			if v.components.moisture == nil then
				MakeWet(v)
			end
			if inst.components.complexprojectile ~= nil and inst.components.complexprojectile.attacker ~= nil then
				local attacker = inst.components.complexprojectile.attacker
				if attacker.components.combat and attacker.components.combat:CanTarget(v) then
					v:PushEvent("attacked", { attacker = attacker, damage = 0, weapon = inst })
				end
			end
		end
	end
end)

-- Credit to Serp for the following code which saves max uses of items when it's changed
AddComponentPostInit("finiteuses", function(self)
	local old_OnSave = self.OnSave
	local function new_OnSave(self,...) 
		if old_OnSave~=nil then data = old_OnSave(self,...) else data = {} end 
		if data==nil then data = {} end
		data.total = self.total
		data.uses = self.current
		return data 
	end
	self.OnSave = new_OnSave
	local old_OnLoad = self.OnLoad
	local function new_OnLoad(self,data,...) 
		if data~=nil and data.total~=nil then 
			self.total = data.total
		end 
		if old_OnLoad~=nil then return old_OnLoad(self,data,...) end 
	end
	self.OnLoad = new_OnLoad
end)

AddComponentPostInit("armor", function(self)
	local old_OnSave = self.OnSave
	local function new_OnSave(self,...) 
		if old_OnSave~=nil then data = old_OnSave(self,...) else data = {} end 
		if data==nil then data = {} end
		data.maxcondition = self.maxcondition
		data.condition = self.condition
		return data 
	end
	self.OnSave = new_OnSave
	local old_OnLoad = self.OnLoad
	local function new_OnLoad(self,data,...) 
		if data~=nil and data.maxcondition~=nil then 
			self.maxcondition = data.maxcondition
		end 
		if old_OnLoad~=nil then return old_OnLoad(self,data,...) end 
	end
	self.OnLoad = new_OnLoad
end)

AddComponentPostInit("fueled", function(self)
	local old_OnSave = self.OnSave
	local function new_OnSave(self,...) 
		if old_OnSave~=nil then data = old_OnSave(self,...) else data = {} end 
		if data==nil then data = {} end
		data.maxfuel = self.maxfuel
		data.fuel = self.currentfuel
		return data 
	end
	self.OnSave = new_OnSave
	local old_OnLoad = self.OnLoad
	local function new_OnLoad(self,data,...) 
		if data~=nil and data.maxfuel~=nil then 
			self.maxfuel = data.maxfuel
		end 
		if old_OnLoad~=nil then return old_OnLoad(self,data,...) end 
	end
	self.OnLoad = new_OnLoad
end)

AddComponentPostInit("perishable", function(self)
	local old_OnSave = self.OnSave
	local function new_OnSave(self,...) 
		if old_OnSave~=nil then data = old_OnSave(self,...) else data = {} end 
		if data==nil then data = {} end
		data.perishtime = self.perishtime
		return data 
	end
	self.OnSave = new_OnSave
	local old_OnLoad = self.OnLoad
	local function new_OnLoad(self,data,...) 
		if data~=nil and data.perishtime~=nil then 
			self.perishtime = data.perishtime
		end 
		if old_OnLoad~=nil then return old_OnLoad(self,data,...) end 
	end
	self.OnLoad = new_OnLoad
end)


-- Labyrinth Chest Loot
pandora = require("scenarios/chest_labyrinth")
chestfunctions = require("scenarios/chestfunctions")

pandora.OnCreate = function(inst, scenariorunner)
	local items =
	{
		{
			--Body Items
			item = {"footballhat"},
			chance = 0.1,
			initfn = function(item) item.components.armor:SetCondition(math.random(item.components.armor.maxcondition * 0.33, item.components.armor.maxcondition)) end,
		},
		{
			item = "nightmarefuel",
			count = math.random(1, 3),
			chance = 0.2,
		},
		{
			item = {"redgem", "bluegem", "purplegem"},
			count = math.random(1,2),
			chance = 0.15,
		},
		{
			item = "thulecite_pieces",
			count = math.random(2, 4),
			chance = 0.4,
		},
		{
			item = "thulecite",
			count = math.random(1, 3),
			chance = 0.2,
		},
		{
			item = {"yellowgem", "orangegem", "greengem"},
			count = 1,
			chance = 0.07,
		},
		{
			--Weapon Items
			item = {"batbat"},
			chance = 0.05,
			initfn = function(item) if item.components.finiteuses ~= nil then item.components.finiteuses:SetUses(math.random(item.components.finiteuses.total * 0.3, item.components.finiteuses.total * 0.5)) end end,
		},
		{
			--Weapon Items
			item = {"firestaff", "icestaff", "multitool_axe_pickaxe"},
			chance = 0.05,
			initfn = function(item) item.components.finiteuses:SetUses(math.random(item.components.finiteuses.total * 0.3, item.components.finiteuses.total * 0.5)) end,
		},
	}

	chestfunctions.AddChestItems(inst, items)
end

-- DOCKS
AddPrefabPostInit("dock_kit", function(inst)
	local _CanDeploy = inst._custom_candeploy_fn
	inst._custom_candeploy_fn = function(inst, pt, mouseover, deployer, rotation)
		if _CanDeploy ~= nil and _CanDeploy(inst, pt, mouseover, deployer, rotation) then
			return true
		end
		
	    local tile = GLOBAL.TheWorld.Map:GetTileAtPoint(pt.x, 0, pt.z)
		if (tile == GLOBAL.WORLD_TILES.OCEAN_COASTAL_SHORE or tile == GLOBAL.WORLD_TILES.OCEAN_COASTAL
		or tile == GLOBAL.WORLD_TILES.OCEAN_SWELL or tile == GLOBAL.WORLD_TILES.OCEAN_ROUGH
		or tile == GLOBAL.WORLD_TILES.OCEAN_HAZARDOUS or tile == GLOBAL.WORLD_TILES.OCEAN_REEF) then
			local tx, ty = GLOBAL.TheWorld.Map:GetTileCoordsAtPoint(pt.x, 0, pt.z)
			local found_adjacent_safetile = false
			for x_off = -1, 1, 1 do
				for y_off = -1, 1, 1 do
					if (x_off ~= 0 or y_off ~= 0) and GLOBAL.IsLandTile(GLOBAL.TheWorld.Map:GetTile(tx + x_off, ty + y_off)) then
						found_adjacent_safetile = true
						break
					end
				end

				if found_adjacent_safetile then break end
			end

			if found_adjacent_safetile then
				local center_pt = GLOBAL.Vector3(GLOBAL.TheWorld.Map:GetTileCenterPoint(tx, ty))
				return found_adjacent_safetile and GLOBAL.TheWorld.Map:CanDeployDockAtPoint(center_pt, inst, mouseover)
			end
		end

		return false
	end
end)

-- POOP
AddPrefabPostInit("poop", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.fertilizer ~= nil then
		local _onappliedfn = inst.components.fertilizer.onappliedfn
		inst.components.fertilizer.onappliedfn = function(inst, final_use, doer, target)
			if _onappliedfn ~= nil then
				_onappliedfn(inst, final_use, doer, target)
			end
			
			if target.components.pickable ~= nil then
				target.components.pickable:ConsumeCycles(-target.components.pickable.max_cycles * 0.5)
			end
		end
	end
end)

-- GUANO
AddPrefabPostInit("guano", function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return inst
	end
	
	if inst.components.fertilizer ~= nil then
		local _onappliedfn = inst.components.fertilizer.onappliedfn
		inst.components.fertilizer.onappliedfn = function(inst, final_use, doer, target)
			if _onappliedfn ~= nil then
				_onappliedfn(inst, final_use, doer, target)
			end
			
			if target.components.pickable ~= nil then
				target.components.pickable:ConsumeCycles(-target.components.pickable.max_cycles)
			end
		end
	end
end)