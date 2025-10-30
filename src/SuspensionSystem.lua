--[[
	Advanced Car Chassis System - Suspension System Module
	
	Bu modül gerçekçi süspansiyon fiziğini simüle eder.
	Yay, sönümleme ve anti-roll bar özellikleri içerir.
]]

local SuspensionSystem = {}
SuspensionSystem.__index = SuspensionSystem

local RunService = game:GetService("RunService")

--[[
	Yeni bir süspansiyon sistemi oluşturur
	@param chassis: BasePart - Ana araç gövdesi
	@param wheelSystem: WheelSystem - Tekerlek sistemi
	@param config: table - Konfigürasyon
	@return SuspensionSystem instance
]]
function SuspensionSystem.new(chassis, wheelSystem, config)
	local self = setmetatable({}, SuspensionSystem)
	
	self.Chassis = chassis
	self.WheelSystem = wheelSystem
	self.Config = config.Suspension
	
	-- Süspansiyon durumları
	self.Springs = {}
	
	-- Her tekerlek için süspansiyon oluştur
	for i, wheel in ipairs(wheelSystem.Wheels) do
		local spring = self:CreateSpring(wheel, i)
		table.insert(self.Springs, spring)
	end
	
	print("⚙️ Süspansiyon sistemi yüklendi")
	
	return self
end

--[[
	Bir tekerlek için yay (spring) oluşturur
	@param wheel: Wheel - Tekerlek instance
	@param index: number - Tekerlek index'i
	@return table - Spring data
]]
function SuspensionSystem:CreateSpring(wheel, index)
	local spring = {
		Wheel = wheel,
		Index = index,
		RestLength = self.Config.SpringLength,
		CurrentLength = self.Config.SpringLength,
		Compression = 0,
		CompressionVelocity = 0,
		LastCompression = 0,
		
		-- Ön/arka ayırımı için
		IsFront = (index <= 2),
	}
	
	-- Süspansiyon için attachment ve constraint oluştur
	local wheelPart = wheel.Part
	
	-- Üst attachment (chassis'e bağlı)
	local upperAttachment = Instance.new("Attachment")
	upperAttachment.Name = "SuspensionUpper_" .. index
	upperAttachment.Position = Vector3.new(
		wheelPart.Position.X - self.Chassis.Position.X,
		self.Config.SpringLength / 2,
		wheelPart.Position.Z - self.Chassis.Position.Z
	)
	upperAttachment.Parent = self.Chassis
	spring.UpperAttachment = upperAttachment
	
	-- Alt attachment (tekerleğe bağlı)
	local lowerAttachment = Instance.new("Attachment")
	lowerAttachment.Name = "SuspensionLower_" .. index
	lowerAttachment.Position = Vector3.new(0, 0, 0)
	lowerAttachment.Parent = wheelPart
	spring.LowerAttachment = lowerAttachment
	
	-- Spring constraint (yay davranışı için)
	local springConstraint = Instance.new("SpringConstraint")
	springConstraint.Name = "SpringConstraint_" .. index
	springConstraint.Attachment0 = upperAttachment
	springConstraint.Attachment1 = lowerAttachment
	
	-- Yay özellikleri
	local stiffness = self.Config.SpringStiffness
	if spring.IsFront then
		stiffness = stiffness * self.Config.FrontRearRatio
	end
	
	springConstraint.Stiffness = stiffness
	springConstraint.Damping = self.Config.SpringDamping
	springConstraint.FreeLength = self.Config.SpringLength
	springConstraint.MaxLength = self.Config.SpringLength + self.Config.MaxCompression
	springConstraint.MinLength = self.Config.SpringLength - self.Config.MaxCompression
	
	springConstraint.Parent = self.Chassis
	spring.Constraint = springConstraint
	
	-- VectorForce for manual spring force (opsiyonel ekstra kontrol)
	local springForce = Instance.new("VectorForce")
	springForce.Name = "SpringForce_" .. index
	springForce.Attachment0 = lowerAttachment
	springForce.RelativeTo = Enum.ActuatorRelativeTo.World
	springForce.ApplyAtCenterOfMass = false
	springForce.Force = Vector3.new()
	springForce.Parent = wheelPart
	spring.ForceInstance = springForce
	
	return spring
end

--[[
	Süspansiyon güncellemesi yapar
	@param deltaTime: number
]]
function SuspensionSystem:Update(deltaTime)
	-- Her yayı güncelle
	for _, spring in ipairs(self.Springs) do
		self:UpdateSpring(spring, deltaTime)
	end
	
	-- Anti-roll bar (yanal stabilite)
	self:ApplyAntiRoll(deltaTime)
end

--[[
	Bir yayı günceller
	@param spring: table - Spring data
	@param deltaTime: number
]]
function SuspensionSystem:UpdateSpring(spring, deltaTime)
	local wheel = spring.Wheel
	local wheelPart = wheel.Part
	
	-- Mevcut yay uzunluğunu hesapla
	local upperPos = spring.UpperAttachment.WorldPosition
	local lowerPos = spring.LowerAttachment.WorldPosition
	spring.CurrentLength = (lowerPos - upperPos).Magnitude
	
	-- Sıkışma miktarı
	spring.Compression = spring.RestLength - spring.CurrentLength
	spring.Compression = math.clamp(spring.Compression, -self.Config.MaxCompression, self.Config.MaxCompression)
	
	-- Sıkışma hızı
	spring.CompressionVelocity = (spring.Compression - spring.LastCompression) / deltaTime
	spring.LastCompression = spring.Compression
	
	-- Zemine değiyorsa yay kuvveti uygula
	if wheel.IsGrounded then
		-- Hooke Yasası: F = -kx (k: yay sabiti, x: yer değiştirme)
		local springForce = spring.Compression * self.Config.SpringStiffness
		
		-- Sönümleme kuvveti: F = -cv (c: sönümleme, v: hız)
		local dampingForce = spring.CompressionVelocity * self.Config.SpringDamping
		
		-- Toplam kuvvet
		local totalForce = springForce + dampingForce
		
		-- Yukarı yönde uygula
		local force = Vector3.new(0, totalForce, 0)
		spring.ForceInstance.Force = force
	else
		-- Havadaysa kuvvet yok
		spring.ForceInstance.Force = Vector3.new()
	end
end

--[[
	Anti-roll bar sistemini uygular (yanal dengeleme)
	Sol ve sağ tekerlekler arasındaki sıkışma farkını dengelemeye çalışır
	@param deltaTime: number
]]
function SuspensionSystem:ApplyAntiRoll(deltaTime)
	-- Ön aksam (tekerlekler 1-2)
	local frontLeft = self.Springs[1]
	local frontRight = self.Springs[2]
	
	if frontLeft.Wheel.IsGrounded and frontRight.Wheel.IsGrounded then
		local compressionDiff = frontLeft.Compression - frontRight.Compression
		local antiRollForce = compressionDiff * self.Config.AntiRollForce
		
		-- Sol tarafa ters, sağ tarafa doğru kuvvet
		frontLeft.ForceInstance.Force = frontLeft.ForceInstance.Force + Vector3.new(0, -antiRollForce, 0)
		frontRight.ForceInstance.Force = frontRight.ForceInstance.Force + Vector3.new(0, antiRollForce, 0)
	end
	
	-- Arka aksam (tekerlekler 3-4)
	local rearLeft = self.Springs[3]
	local rearRight = self.Springs[4]
	
	if rearLeft.Wheel.IsGrounded and rearRight.Wheel.IsGrounded then
		local compressionDiff = rearLeft.Compression - rearRight.Compression
		local antiRollForce = compressionDiff * self.Config.AntiRollForce
		
		rearLeft.ForceInstance.Force = rearLeft.ForceInstance.Force + Vector3.new(0, -antiRollForce, 0)
		rearRight.ForceInstance.Force = rearRight.ForceInstance.Force + Vector3.new(0, antiRollForce, 0)
	end
end

--[[
	Belirli bir yayın sıkışma miktarını döndürür
	@param index: number - Spring index
	@return number - Sıkışma miktarı (studs)
]]
function SuspensionSystem:GetCompression(index)
	if self.Springs[index] then
		return self.Springs[index].Compression
	end
	return 0
end

--[[
	Ortalama sıkışma miktarını döndürür
	@return number
]]
function SuspensionSystem:GetAverageCompression()
	local total = 0
	for _, spring in ipairs(self.Springs) do
		total = total + spring.Compression
	end
	return total / #self.Springs
end

--[[
	Ön/arka sıkışma farkını döndürür (pitch kontrolü için)
	@return number - Pozitif değer = ön daha sıkışık, negatif = arka daha sıkışık
]]
function SuspensionSystem:GetPitchCompression()
	local frontAvg = (self.Springs[1].Compression + self.Springs[2].Compression) / 2
	local rearAvg = (self.Springs[3].Compression + self.Springs[4].Compression) / 2
	return frontAvg - rearAvg
end

--[[
	Sol/sağ sıkışma farkını döndürür (roll kontrolü için)
	@return number - Pozitif değer = sol daha sıkışık, negatif = sağ daha sıkışık
]]
function SuspensionSystem:GetRollCompression()
	local leftAvg = (self.Springs[1].Compression + self.Springs[3].Compression) / 2
	local rightAvg = (self.Springs[2].Compression + self.Springs[4].Compression) / 2
	return leftAvg - rightAvg
end

--[[
	Süspansiyon yüksekliğini ayarlar (ride height)
	@param heightChange: number - Yükseklik değişimi (studs)
]]
function SuspensionSystem:AdjustHeight(heightChange)
	for _, spring in ipairs(self.Springs) do
		spring.RestLength = spring.RestLength + heightChange
		spring.Constraint.FreeLength = spring.RestLength
	end
	
	print(string.format("🔧 Süspansiyon yüksekliği %.2f stud değiştirildi", heightChange))
end

--[[
	Süspansiyon sertliğini ayarlar
	@param stiffnessMultiplier: number - Sertlik çarpanı (1.0 = varsayılan)
]]
function SuspensionSystem:AdjustStiffness(stiffnessMultiplier)
	for _, spring in ipairs(self.Springs) do
		local baseStiffness = self.Config.SpringStiffness
		if spring.IsFront then
			baseStiffness = baseStiffness * self.Config.FrontRearRatio
		end
		spring.Constraint.Stiffness = baseStiffness * stiffnessMultiplier
	end
	
	print(string.format("🔧 Süspansiyon sertliği x%.2f ayarlandı", stiffnessMultiplier))
end

--[[
	Sistemi temizler
]]
function SuspensionSystem:Destroy()
	for _, spring in ipairs(self.Springs) do
		if spring.Constraint then
			spring.Constraint:Destroy()
		end
		if spring.ForceInstance then
			spring.ForceInstance:Destroy()
		end
		if spring.UpperAttachment then
			spring.UpperAttachment:Destroy()
		end
		if spring.LowerAttachment then
			spring.LowerAttachment:Destroy()
		end
	end
	
	self.Springs = {}
end

return SuspensionSystem
