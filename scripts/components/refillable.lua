local Refillable = Class(function(self, inst)
   self.inst = inst
   self.inst:AddTag("refillable")
   self.filling = {}
end,
nil,
{})

function Refillable:AddFilling(fillerprefab, value, overmax, increasemax)
	self.filling[fillerprefab] = {value, overmax, increasemax}
	self.inst:AddTag(fillerprefab)
end

function Refillable:GetFilling()
	return self.filling
end

function Refillable:CanRefill(fillerprefab)
	return self.filling[fillerprefab] ~= nil
end

function Refillable:Refill(filler)
    if filler == nil or self.inst == nil or not self.inst:HasTag("refillable") or not filler:IsValid() or not self.inst:IsValid() or not self.inst.components.refillable:CanRefill(filler.prefab) then
        return false
    end

	-- If the user is repairing a stack, split the repair value over the stack
    local stack_repair = 1
    if self.inst.components.stackable ~= nil then
        stack_repair = math.max(1, self.inst.components.stackable:StackSize())
    end
	
    if self.inst.components.finiteuses ~= nil then
		self.inst.components.finiteuses:SetMaxUses(self.inst.components.finiteuses.total * stack_repair + self.filling[filler.prefab][3])
		self.inst.components.finiteuses:SetUses(self.inst.components.finiteuses:GetUses() * stack_repair + self.filling[filler.prefab][1])
		self.inst.components.finiteuses:SetUses(math.min(self.inst.components.finiteuses:GetUses(), self.inst.components.finiteuses.total + self.filling[filler.prefab][2]))
    elseif self.inst.components.armor ~= nil then
		self.inst.components.armor.maxcondition = self.inst.components.armor.maxcondition * stack_repair + self.filling[filler.prefab][3]
		self.inst.components.armor:SetCondition(self.inst.components.armor.condition * stack_repair + self.filling[filler.prefab][1])
		self.inst.components.armor:SetCondition(math.min(self.inst.components.armor.condition, self.inst.components.armor.maxcondition + self.filling[filler.prefab][2]))
    elseif self.inst.components.fueled ~= nil then
		self.inst.components.fueled.maxfuel = self.inst.components.fueled.maxfuel * stack_repair + self.filling[filler.prefab][3]
		self.inst.components.fueled.currentfuel = self.inst.components.fueled.currentfuel * stack_repair + self.filling[filler.prefab][1]
		self.inst.components.fueled.currentfuel = math.min(self.inst.components.fueled.currentfuel, self.inst.components.fueled.maxfuel + self.filling[filler.prefab][2])
    elseif self.inst.components.perishable ~= nil and self.inst.components.equippable ~= nil then
		self.inst.components.perishable.perishtime = self.inst.components.perishable.perishtime * stack_repair + self.filling[filler.prefab][3]
		self.inst.components.perishable.perishremainingtime = math.min(self.inst.components.perishable.perishremainingtime * stack_repair + self.filling[filler.prefab][1], self.inst.components.perishable.perishtime + self.filling[filler.prefab][2])
		self.inst.components.perishable.inst:PushEvent("perishchange", {percent = self.inst.components.perishable:GetPercent()})
    else
        return false
    end

    if filler.components.stackable ~= nil then
        filler.components.stackable:Get():Remove()
    else
        filler:Remove()
    end

    return true
end

return Refillable