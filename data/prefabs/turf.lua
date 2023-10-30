-- TILE_ID: {SPEED, WINTER_INSULATION, SUMMER_INSULATION, SANITY_AURA, RAIN_MODIFIER,
-- HEAT_RESISTANCE, CAN_SMOLDER, WILDFIRE_PROTECTED}
local TurfEdits =
{
	-- WOODEN
	[10] = {TUNING.WOODTURFSPEED},
	-- CARPETED
	[11] = {nil, nil, nil, TUNING.CARPETTURFSANITY/60, TUNING.CARPETTURFWATERPROOFNESS},
	-- CHECKERBOARD
	[12] = {nil, nil, nil, TUNING.CHECKEREDTURFSANITY/60, nil, 0.8},
	-- SCALED
	[32] = {TUNING.SCALEDTURFSPEED, TUNING.SCALEDTURFWINTERINSULATION, nil, nil, nil, nil, TUNING.SCALEDTURFSMOLDER, TUNING.SCALEDTURFWILDFIRE},
}

-- SCALE FLOORING
local function ResetSpeedMultiplier(self)
	if self.turfedfast then
		self:RemoveExternalSpeedMultiplier(self.inst, "TurfedSpeed")
		self.turfedfast = false
	end
end

AddComponentPostInit("locomotor", function(self)
	if self.inst:HasTag("player") then
		local _UGSM = self.UpdateGroundSpeedMultiplier
		self.UpdateGroundSpeedMultiplier = function(self)
			_UGSM(self)
			local tile, data = self.inst:GetCurrentTileType()
			if data == nil or TurfEdits[tile] == nil or TurfEdits[tile][1] == nil then
				ResetSpeedMultiplier(self)
				return
			end

			local speed = TurfEdits[tile][1]
			speed = math.clamp(speed, 0.05, 8)
			self:SetExternalSpeedMultiplier(self.inst, "TurfedSpeed", speed)
			self.turfedfast = true
		end
	end
end)

AddComponentPostInit("temperature", function(self)
	local _GetInsulation = self.GetInsulation
	self.GetInsulation = function(self)
		local winterInsulation, summerInsulation = _GetInsulation(self)
		local tile, data = self.inst:GetCurrentTileType()
		if data ~= nil and TurfEdits[tile] ~= nil then
			if TurfEdits[tile][2] ~= nil then
				winterInsulation = winterInsulation + TurfEdits[tile][2]
			end
			if TurfEdits[tile][3] ~= nil then
				summerInsulation = summerInsulation + TurfEdits[tile][3]
			end
		end
		return math.max(0, winterInsulation), math.max(0, summerInsulation)
	end
end)

AddPlayerPostInit(function(inst)
	if inst.components.sanity then
		local _crfn = inst.components.sanity.custom_rate_fn
		inst.components.sanity.custom_rate_fn = function(inst)
			local ret = 0
			if _crfn then
				ret = _crfn(inst, 0)
			end
			local tile, data = inst:GetCurrentTileType()
			if data ~= nil and TurfEdits[tile] ~= nil and TurfEdits[tile][4] ~= nil then
				ret = ret + TurfEdits[tile][4]
			end
			return ret
		end
	end
end)

AddComponentPostInit("moisture", function(self)
	local _GetMoistureRate = self.GetMoistureRate
	self.GetMoistureRate = function(self)
		local oldrate = _GetMoistureRate(self)
		local tile, data = self.inst:GetCurrentTileType()
		if data ~= nil and TurfEdits[tile] ~= nil and TurfEdits[tile][5] ~= nil then
			local rate = oldrate * TurfEdits[tile][5]
			return math.max(0, rate)
		end
		return oldrate
	end
end)

AddComponentPostInit("propagator", function(self)
	local oldrate = self:GetHeatResistance()
	self.GetHeatResistance = function(self)
		local newrate = 1
		local tile, data = self.inst:GetCurrentTileType()
		if data ~= nil and TurfEdits[tile] ~= nil then
			if TurfEdits[tile][6] ~= nil then
				newrate = TurfEdits[tile][6]
			end
			if not TurfEdits[tile][7] then
				self.acceptsheat = TurfEdits[tile][7]
			end
		end
		return math.min(oldrate, newrate)
	end
end)

AddComponentPostInit("burnable", function(self)
	local _StartWildfire = self.StartWildfire
	self.StartWildfire = function(self)
		_StartWildfire(self)
		local tile, data = self.inst:GetCurrentTileType()
		if data ~= nil and TurfEdits[tile] ~= nil then
			if TurfEdits[tile][8] then
				self:StopSmoldering(-1)
			end
		end
	end
end)
