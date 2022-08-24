-- REFILLABLE
local strRefill = GLOBAL.STRINGS.ACTIONS.REPAIR ~= nil and GLOBAL.STRINGS.ACTIONS.REPAIR.GENERIC or "Repair"
local actionRefill = AddAction("REFILL", strRefill, function(act)
	if act.target ~= nil and act.target.components.refillable ~= nil then
        local material = act.invobject
        if material ~= nil and act.target.components.refillable:CanRefill(material.prefab) then
            return act.target.components.refillable:Refill(material)
        end
    end
end)
actionRefill.mount_valid = true
actionRefill.encumbered_valid = true

local function ComponentActionRefillable(inst, doer, target, actions, right)
    if right then
        if doer.replica.rider ~= nil and doer.replica.rider:IsRiding() then
            if not (target.replica.inventoryitem ~= nil and target.replica.inventoryitem:IsGrandOwner(doer)) then
                return
            end
        elseif doer.replica.inventory ~= nil and doer.replica.inventory:IsHeavyLifting() then
            return
        end
        if inst ~= nil and target ~= nil and target:HasTag("refillable") and target:HasTag(inst.prefab) then
            table.insert(actions, GLOBAL.ACTIONS.REFILL)
        end
    end
end
AddComponentAction("USEITEM", "filling", ComponentActionRefillable)
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.REFILL, "domediumaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.REFILL, "domediumaction"))