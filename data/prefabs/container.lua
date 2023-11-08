local containers = GLOBAL.require("containers")
containers.MAXITEMSLOTS = 100

-- WIDGET: {COLUMNS, ROWS, NUMSLOTS, STACKS, ONSIDE, TYPE, OPENLIMIT, POS}
local backpackSizes =
{
	["vest"] = {2, 2, 4, true, true, "pack", 1, nil},
	["dragonflychestNew"] = {4, 4, 16, true, false, "chest", nil, GLOBAL.Vector3(0, 200, 0)},
	["minotaurchestNew"] = {5, 5, 25, true, false, "chest", nil, GLOBAL.Vector3(0, 200, 0)},
}

local function IndentBy(dimSize)
	local imageDim = 1
	
	if dimSize >= 6 then
		imageDim = 6
	elseif dimSize >= 3 then
		imageDim = 3
	end
	
	return (dimSize - imageDim) * 64
end

-- Calculates spacing based on size
local function UpdateContainerSize(container, columns, rows, numSlots)
	container.widget = {}
	container.widget.slotpos = {}
	
	local curSlots = numSlots
	for x = 1, columns, 1 do
		for y = 1, rows, 1 do
			curSlots = curSlots - 1
			table.insert(container.widget.slotpos, GLOBAL.Vector3(
			(-75 * x) + (15.5 * columns) + IndentBy(columns),
			(75 * y) - (20 * rows) - IndentBy(rows),
			0))
			if curSlots <= 0 then
				break
			end
		end
	end

	container.widget.bgatlas = "images/backpacks.xml"
	container.widget.bgimage = columns.."x"..rows..".tex"
	container.widget.pos = GLOBAL.Vector3(-10.5 * columns - IndentBy(columns) / 2, -10 * rows + IndentBy(rows) / 4, 0)
end

--Change size of Backpacks
local _widgetsetup = containers.widgetsetup
containers.widgetsetup = function(container, wName, data)
	_widgetsetup(container, wName, data)
	local updated = false

	if backpackSizes[wName] ~= nil then
		UpdateContainerSize(container, backpackSizes[wName][1], backpackSizes[wName][2], backpackSizes[wName][3])
		container.acceptsstacks = backpackSizes[wName][4]
		container.issidewidget = backpackSizes[wName][5]
		container.type = backpackSizes[wName][6]
		container.openlimit = backpackSizes[wName][7]
		if backpackSizes[wName][8] ~= nil then
			container.widget.pos = backpackSizes[wName][8]
		end
		updated = true
	end

	if updated then
		container:SetNumSlots(#container.widget.slotpos)
	end
end

-- Configures containers to handle the extra slots
local function ReinitializeSlots(inst)
	if(#inst._itemspool < containers.MAXITEMSLOTS) then
		for i = #inst._itemspool + 1, containers.MAXITEMSLOTS do
			table.insert(inst._itemspool, GLOBAL.net_entity(inst.GUID, "container._items["..tostring(i).."]", "items["..tostring(i).."]dirty"))
		end
	end
end
AddPrefabPostInit("container_classified", ReinitializeSlots)


-- Gives the container the ability to go into an inventory if it's empty
local function CheckStatus(inst)
	if inst.components.container:IsEmpty() then
		inst.components.inventoryitem.cangoincontainer = true
	elseif not inst.components.container:IsEmpty() then
		inst.components.inventoryitem.cangoincontainer = false
	end
end

-- Adds functionality that mocks backpacks
local function OnEquipTweakBackpack(inst)
	if inst.components.equippable ~= nil then
		local _onequip = inst.components.equippable.onequipfn
		inst.components.equippable:SetOnEquip(function(inst, owner)
			_onequip(inst, owner)
			inst.components.container:Open(owner)
		end)

		local _onunequip = inst.components.equippable.onunequipfn
		inst.components.equippable:SetOnUnequip(function(inst, owner)
			_onunequip(inst, owner)
			inst.components.container:Close(owner)
		end)
	end
end

-- Makes an item into a backpack that can be stored in the inventory when empty
local function CreateContainer(inst, widget)
	inst:AddTag("backpack")
	
	if not GLOBAL.TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(widget) end
		return inst
	end

	if inst.components.inventoryitem == nil then
		inst:AddComponent("inventoryitem")
		inst.components.inventoryitem.cangoincontainer = false
	end
	if inst.components.container == nil then
		inst:AddComponent("container")
		inst.components.container:WidgetSetup(widget)
		-- setting 'inst.components.container.canbeopened = false' here makes items get deleted on leaving/going to caves
		inst.components.container.skipclosesnd = true
		inst.components.container.skipopensnd = true

		OnEquipTweakBackpack(inst)
		CheckStatus(inst)
		inst:ListenForEvent("itemget", CheckStatus)
		inst:ListenForEvent("itemlose", CheckStatus)
		
		if inst.components.burnable ~= nil then
			local _onBurnt = inst.components.burnable.onburnt
			inst.components.burnable:SetOnBurntFn(function(inst)
				if _onBurnt ~= nil then
					_onBurnt(inst)
				end
				inst.components.container:DropEverything()
				inst.components.container:Close()
				inst:Remove()
			end)
			
			local _onIgnite = inst.components.burnable.onignite
			inst.components.burnable:SetOnIgniteFn(function(inst)
				if _onIgnite ~= nil then
					_onIgnite(inst)
				end
				inst.components.container.canbeopened = false
			end)
			
			local _onExtinguish = inst.components.burnable.onextinguish
			inst.components.burnable:SetOnExtinguishFn(function(inst)
				if _onExtinguish ~= nil then
					_onExtinguish(inst)
				end
				inst.components.container.canbeopened = true
			end)
		end
		
		if inst.components.fueled ~= nil then
			local _onDepleted = inst.components.fueled.depleted
			inst.components.fueled:SetDepletedFn(function(inst)
				inst.components.container:DropEverything()
				inst.components.container:Close()
				if _onDepleted ~= nil then
				   _onDepleted(inst)
				end
			end)
		end
		if inst.components.finiteuses ~= nil then
			local _onFinished = inst.components.finiteuses.onfinished
				inst.components.finiteuses:SetOnFinished(function(inst)
				inst.components.container:DropEverything()
				inst.components.container:Close()
				if _onFinished ~= nil then
				   _onFinished(inst)
				end
			end)
		end
		if inst.components.armor ~= nil then
			local _onFinished = inst.components.armor.onfinished
			inst.components.armor.onfinished = function()
				inst.components.container:DropEverything()
				inst.components.container:Close()
				if _onFinished ~= nil then
				   _onFinished()
				end
			end
		end
		if inst.components.perishable ~= nil then
			local _onPerish = inst.components.perishable.perishfn
			inst.components.perishable:SetOnPerishFn(function(inst)
				inst.components.container:DropEverything()
				inst.components.container:Close()
				if _onPerish ~= nil then
				   _onPerish(inst)
				end
			end)
		end
	end
end

local function UpdateExistingContainer(inst, widget)
	if not GLOBAL.TheWorld.ismastersim then
		inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup(widget) end
		return inst
	end
	
	if inst.components.container ~= nil then
		inst.components.container:WidgetSetup(widget)
	end
end

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
    end
    local fx = GLOBAL.SpawnPrefab("collapse_big")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onhit(inst, worker)
    inst.AnimState:PlayAnimation("hit")
    inst.AnimState:PushAnimation("closed", false)
    if inst.components.container ~= nil then
        inst.components.container:DropEverything()
        inst.components.container:Close()
    end
end


if TUNING.DRAGONFLYCHESTCOLUMNS > 0 and TUNING.DRAGONFLYCHESTROWS > 0 then
	backpackSizes["dragonfly_sizes"] = {TUNING.DRAGONFLYCHESTCOLUMNS, TUNING.DRAGONFLYCHESTROWS, TUNING.DRAGONFLYCHESTCOLUMNS * TUNING.DRAGONFLYCHESTROWS, true, false, "chest", nil, GLOBAL.Vector3(0, 200, 0)}
	AddPrefabPostInit("dragonflychest", function(inst)
		UpdateExistingContainer(inst, "dragonfly_sizes")

		if not GLOBAL.TheWorld.ismastersim then
			return inst
		end

		if inst.components.workable ~= nil then
			inst.components.workable:SetWorkLeft(8)
		end
	end)
end

if TUNING.MINOTAURCHESTCOLUMNS > 0 and TUNING.MINOTAURCHESTROWS > 0 then
	backpackSizes["minotaur_sizes"] = {TUNING.MINOTAURCHESTCOLUMNS, TUNING.MINOTAURCHESTROWS, TUNING.MINOTAURCHESTCOLUMNS * TUNING.MINOTAURCHESTROWS, true, false, "chest", nil, GLOBAL.Vector3(0, 200, 0)}
	AddPrefabPostInit("minotaurchest", function(inst)
		UpdateExistingContainer(inst, "minotaur_sizes")

		if not GLOBAL.TheWorld.ismastersim then
			return inst
		end

		if inst.components.lootdropper == nil and inst.components.workable == nil then
			inst:AddComponent("lootdropper")
			inst:AddComponent("workable")
			inst.components.workable:SetWorkAction(GLOBAL.ACTIONS.HAMMER)
			inst.components.workable:SetWorkLeft(16)
			inst.components.workable:SetOnFinishCallback(onhammered)
			inst.components.workable:SetOnWorkCallback(onhit)
		end
	end)
end

if TUNING.SNURTLESHELLCOLUMNS > 0 and TUNING.SNURTLESHELLROWS > 0 then
	backpackSizes["snurtle_sizes"] = {TUNING.SNURTLESHELLCOLUMNS, TUNING.SNURTLESHELLROWS, TUNING.SNURTLESHELLCOLUMNS * TUNING.SNURTLESHELLROWS, true, true, "pack", 1, nil}
	AddPrefabPostInit("armorsnurtleshell", function(inst) CreateContainer(inst, "snurtle_sizes") end)
end

AddPrefabPostInit("raincoat", function(inst) CreateContainer(inst, "vest") end)
AddPrefabPostInit("trunkvest_summer", function(inst) CreateContainer(inst, "vest") end)
AddPrefabPostInit("trunkvest_winter", function(inst) CreateContainer(inst, "vest") end)
AddPrefabPostInit("reflectivevest", function(inst) CreateContainer(inst, "vest") end)