--[[
	Advanced Car Chassis System - Wheel System Module
	
	Bu modül tekerleklerin fiziğini ve davranışını yönetir.
]]

local WheelSystem = {}
WheelSystem.__index = WheelSystem

local Wheel = {}
Wheel.__index = Wheel

--[[
	Yeni bir tekerlek instance oluşturur
	@param wheelPart: BasePart - Tekerlek part'ı
	@param config: table - Konfigürasyon
	@return Wheel instance
]]
function Wheel.new(wheelPart, config, index)
	local self = setmetatable({}, Wheel)
	
	self.Part = wheelPart
	self.Config = config.Wheels
	self.Index = index
	
	-- Tekerlek özellikleri
	self.Radius = config.Wheels.Radius
	self.Width = config.Wheels.Width
	self.Mass = config.Wheels.Mass
	
	-- Fizik durumu
	self.AngularVelocity = 0
	self.SlipRatio = 0
	self.IsGrounded = false
	self.GroundNormal = Vector3.new(0, 1, 0)
	self.GroundMaterial = Enum.Material.Plastic
	
	-- Kuvvetler
	self.PowerForce = 0
	self.BrakeForce = 0
	self.LateralForce = 0
	
	-- Attachment ve constraint'ler
	self:SetupConstraints()
	
	return self
end

--[[
	Tekerlek constraint'lerini oluşturur
]]
function Wheel:SetupConstraints()
	local part = self.Part
	
	-- Ana attachment
	if not part:FindFirstChild("WheelAttachment") then
		local attachment = Instance.new("Attachment")
		attachment.Name = "WheelAttachment"
		attachment.Parent = part
		self.Attachment = attachment
	else
		self.Attachment = part.WheelAttachment
	end
	
	-- Güç kuvveti için VectorForce
	if not part:FindFirstChild("PowerForce") then
		local powerForce = Instance.new("VectorForce")
		powerForce.Name = "PowerForce"
		powerForce.Attachment0 = self.Attachment
		powerForce.RelativeTo = Enum.ActuatorRelativeTo.World
		powerForce.ApplyAtCenterOfMass = false
		powerForce.Force = Vector3.new()
		powerForce.Parent = part
		self.PowerForceInstance = powerForce
	else
		self.PowerForceInstance = part.PowerForce
	end
	
	-- Yanal kuvvet için VectorForce
	if not part:FindFirstChild("LateralForce") then
		local lateralForce = Instance.new("VectorForce")
		lateralForce.Name = "LateralForce"
		lateralForce.Attachment0 = self.Attachment
		lateralForce.RelativeTo = Enum.ActuatorRelativeTo.World
		lateralForce.ApplyAtCenterOfMass = false
		lateralForce.Force = Vector3.new()
		lateralForce.Parent = part
		self.LateralForceInstance = lateralForce
	else
		self.LateralForceInstance = part.LateralForce
	end
	
	-- Tekerlek fiziğini ayarla
	part.CustomPhysicalProperties = PhysicalProperties.new(
		self.Mass / (part.Size.X * part.Size.Y * part.Size.Z),
		0.7,  -- Sürtünme
		0.3,  -- Elastikiyet
		1,
		1
	)
end

--[[
	Zemin kontrolü yapar (raycast)
	@param chassis: BasePart - Ana araç gövdesi
	@return boolean, RaycastResult
]]
function Wheel:CheckGround(chassis)
	local rayOrigin = self.Part.Position
	local rayDirection = -self.Part.CFrame.UpVector * (self.Radius + 2)
	
	local raycastParams = RaycastParams.new()
	raycastParams.FilterDescendantsInstances = {chassis.Parent}
	raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	
	local result = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
	
	if result then
		self.IsGrounded = true
		self.GroundNormal = result.Normal
		self.GroundMaterial = result.Material
		return true, result
	else
		self.IsGrounded = false
		return false, nil
	end
end

--[[
	Motor gücünü tekere uygular
	@param power: number - Güç miktarı (Newton)
]]
function Wheel:ApplyPower(power)
	if not self.IsGrounded then
		self.PowerForce = 0
		self.PowerForceInstance.Force = Vector3.new()
		return
	end
	
	self.PowerForce = power
	
	-- İleri yönde güç uygula
	local forwardDirection = self.Part.CFrame.LookVector
	local force = forwardDirection * power * self.Config.GripMultiplier
	
	-- Kayma kontrolü
	local wheelSpeed = self.Part.AssemblyLinearVelocity.Magnitude
	if wheelSpeed > 1 then
		local slipFactor = math.clamp(1 - (self.SlipRatio / self.Config.SlipThreshold), 0.3, 1)
		force = force * slipFactor
	end
	
	self.PowerForceInstance.Force = force
end

--[[
	Fren kuvvetini uygular
	@param brakeForce: number - Fren kuvveti
]]
function Wheel:ApplyBrake(brakeForce)
	if not self.IsGrounded or brakeForce == 0 then
		return
	end
	
	self.BrakeForce = brakeForce
	
	-- Hız yönünün tersine kuvvet uygula
	local velocity = self.Part.AssemblyLinearVelocity
	if velocity.Magnitude > 0.1 then
		local brakeDirection = -velocity.Unit
		local force = brakeDirection * brakeForce
		self.PowerForceInstance.Force = self.PowerForceInstance.Force + force
	end
end

--[[
	Yanal (dönüş) sürtünmesini uygular
]]
function Wheel:ApplyLateralFriction()
	if not self.IsGrounded then
		self.LateralForceInstance.Force = Vector3.new()
		return
	end
	
	local velocity = self.Part.AssemblyLinearVelocity
	local rightVector = self.Part.CFrame.RightVector
	
	-- Yanal hız bileşeni
	local lateralVelocity = velocity:Dot(rightVector)
	
	if math.abs(lateralVelocity) > 0.1 then
		-- Yanal sürtünme kuvveti
		local lateralForce = -rightVector * lateralVelocity * self.Mass * self.Config.Friction.Lateral * 50
		self.LateralForceInstance.Force = lateralForce
		
		-- Kayma oranını hesapla
		self.SlipRatio = math.abs(lateralVelocity) / math.max(velocity.Magnitude, 1)
	else
		self.LateralForceInstance.Force = Vector3.new()
		self.SlipRatio = 0
	end
end

--[[
	Tekeri döndürür (görsel)
	@param deltaTime: number
]]
function Wheel:UpdateRotation(deltaTime)
	local velocity = self.Part.AssemblyLinearVelocity
	local forwardVelocity = velocity:Dot(self.Part.CFrame.LookVector)
	
	-- RPM hesapla
	local wheelCircumference = 2 * math.pi * self.Radius
	local rotationsPerSecond = forwardVelocity / wheelCircumference
	self.AngularVelocity = rotationsPerSecond * 360 -- Dereceye çevir
	
	-- Görsel dönüşü uygula (opsiyonel - BodyGyro veya motor kullanabilirsiniz)
	-- self.Part.CFrame = self.Part.CFrame * CFrame.Angles(math.rad(self.AngularVelocity * deltaTime), 0, 0)
end

--[[
	Tekeri günceller
	@param deltaTime: number
	@param chassis: BasePart
]]
function Wheel:Update(deltaTime, chassis)
	-- Zemin kontrolü
	self:CheckGround(chassis)
	
	-- Yanal sürtünme
	self:ApplyLateralFriction()
	
	-- Görsel güncelleme
	self:UpdateRotation(deltaTime)
end

--[[
	Tekeri temizler
]]
function Wheel:Destroy()
	if self.PowerForceInstance then
		self.PowerForceInstance:Destroy()
	end
	if self.LateralForceInstance then
		self.LateralForceInstance:Destroy()
	end
end

-- ============================================
-- WHEEL SYSTEM (Tüm tekerlekleri yönetir)
-- ============================================

--[[
	Yeni bir tekerlek sistemi oluşturur
	@param wheelParts: table - Tekerlek Part'ları
	@param config: table - Konfigürasyon
	@return WheelSystem instance
]]
function WheelSystem.new(wheelParts, config)
	local self = setmetatable({}, WheelSystem)
	
	self.Config = config
	self.Wheels = {}
	
	-- Her tekerlek için Wheel instance oluştur
	for i, wheelPart in ipairs(wheelParts) do
		local wheel = Wheel.new(wheelPart, config, i)
		table.insert(self.Wheels, wheel)
	end
	
	print(string.format("🛞 %d tekerlek başarıyla yüklendi", #self.Wheels))
	
	return self
end

--[[
	Tüm tekerlekleri günceller
	@param deltaTime: number
	@param chassis: BasePart
]]
function WheelSystem:Update(deltaTime, chassis)
	for _, wheel in ipairs(self.Wheels) do
		wheel:Update(deltaTime, chassis)
	end
end

--[[
	Belirli bir tekeri döndürür
	@param index: number
	@return Wheel
]]
function WheelSystem:GetWheel(index)
	return self.Wheels[index]
end

--[[
	Ön tekerlekleri döndürür
	@return table
]]
function WheelSystem:GetFrontWheels()
	return {self.Wheels[1], self.Wheels[2]}
end

--[[
	Arka tekerlekleri döndürür
	@return table
]]
function WheelSystem:GetRearWheels()
	return {self.Wheels[3], self.Wheels[4]}
end

--[[
	Zemine değen tekerlek sayısını döndürür
	@return number
]]
function WheelSystem:GetGroundedWheelCount()
	local count = 0
	for _, wheel in ipairs(self.Wheels) do
		if wheel.IsGrounded then
			count = count + 1
		end
	end
	return count
end

--[[
	Sistemi temizler
]]
function WheelSystem:Destroy()
	for _, wheel in ipairs(self.Wheels) do
		wheel:Destroy()
	end
	self.Wheels = {}
end

return WheelSystem
