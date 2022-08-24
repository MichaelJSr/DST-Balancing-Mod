--[[
	for key, value in pairs(inst) do
		print("found member " .. key)
		print("found value ", value)
	end
]]

--[[
local rows = 1
for i = 1, numSlots - 1, 1 do
	rows = rows + 1
	local check = numSlots / rows
	if rows == numSlots then
		break
	elseif check == math.floor(check) and check <= (numSlots / 2) and check <= 12 then
		rows = check
		break
	end
end
local columns = numSlots / rows
]]

--[[
local function WinonaSG(sg)
	local old = sg.actionhandlers[(GLOBAL.ACTIONS.PICK)].deststate
	sg.actionhandlers[(GLOBAL.ACTIONS.PICK)].deststate = function(inst, action)
		return (inst.prefab == "winona" and "domediumaction") or old(inst, action)
	end
end
AddStategraphPostInit("wilson", WinonaSG)
AddStategraphPostInit("wilson_client", WinonaSG)
]]

--- VARIABLES ---
--GLOBAL.FUELTYPE.THULECITE = "THULECITE"

-- Refills the given finite use item with the given refuel value
local function RefillFiniteUses(inst, refuel)
	local uses = inst.components.finiteuses:GetUses()
	inst.components.finiteuses:SetUses(uses + refuel)
	if inst.components.finiteuses:GetPercent() > 1 then
		inst.components.finiteuses:SetPercent(1)
	end
end

-- Tweaks a finite use item so that if it has a task, it stops doing it when it reaches 0 uses
local function OnEquipTweakFiniteItem(inst)
	local _onequip = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function(inst, owner)
		_onequip(inst, owner)
		if inst.components.finiteuses:GetUses() == 0 and inst.task ~= nil then
			inst.task:Cancel()
			inst.task = nil
		end
		inst.components.fueled:StopConsuming()
	end
end

-- Gives a finite use item the ability to be refueled with the given prefab and fuel amount and fuel type
local function AllowFiniteItemRefueling(inst, fuel_type, fuel_prefab, fuel_override)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.fueled == nil then
		inst:AddComponent("fueled")
		inst.components.fueled.fueltype = fuel_type

		if fuel_prefab ~= nil then
			inst.components.fueled.CanAcceptFuelItem = function(self, item)
				return item.prefab == fuel_prefab
			end
		end
		
		inst.components.fueled.accepting = true
		inst.components.fueled:SetTakeFuelFn(function(inst, fuelvalue)
			if fuel_override ~= nil then
				RefillFiniteUses(inst, fuel_override)
			else
				RefillFiniteUses(inst, fuelvalue)
			end
		end)
		
		-- No longer gets deleted when all used up
		inst.components.finiteuses:SetOnFinished(function(inst)
			if inst.task ~= nil then
				inst.task:Cancel()
				inst.task = nil
			end
		end)
		
		OnEquipTweakFiniteItem(inst)
	end
end

-- We don't want our mock fueled armor to actually consume fuel
local function OnEquipTweakArmor(inst)
	local _onequip = inst.components.equippable.onequipfn
	inst.components.equippable.onequipfn = function(inst, owner)
		_onequip(inst, owner)
		inst.components.fueled:StopConsuming()
	end
end

-- Gives the given armor the ability to be refueled with the given prefab and fuel amount and fuel type
local function AllowArmorRefueling(inst, fuel_type, fuel_prefab, fuel_override)
    if not GLOBAL.TheWorld.ismastersim then
        return inst
    end
	
	if inst.components.fueled == nil then
		inst:AddComponent("fueled")
		inst.components.fueled.fueltype = fuel_type

		if fuel_prefab ~= nil then
			inst.components.fueled.CanAcceptFuelItem = function(self, item)
				return item.prefab == fuel_prefab
			end
		end
		
		inst.components.fueled.accepting = true
		inst.components.fueled:SetTakeFuelFn(function(inst, fuelvalue)
			if fuel_override ~= nil then
				inst.components.armor:Repair(fuel_override)
			else
				inst.components.armor:Repair(fuelvalue)
			end
		end)
		
		OnEquipTweakArmor(inst)
	end
end
