--[[
	Advanced Car Chassis System - Steering System Module
	
	Bu modül direksiyon kontrolü ve Ackermann geometrisini yönetir.
]]

local SteeringSystem = {}
SteeringSystem.__index = SteeringSystem

--[[
	Yeni bir direksiyon sistemi oluşturur
	@param wheelSystem: WheelSystem - Tekerlek sistemi
	@param config: table - Konfigürasyon
	@return SteeringSystem instance
]]
function SteeringSystem.new(wheelSystem, config)
	local self = setmetatable({}, SteeringSystem)
	
	self.WheelSystem = wheelSystem
	self.Config = config.Steering
	
	-- Direksiyon durumu
	self.CurrentAngle = 0
	self.TargetAngle = 0
	self.SteeringInput = 0
	
	-- Ön tekerlekler (genellikle sadece ön tekerlekler direksiyon yapar)
	self.FrontWheels = wheelSystem:GetFrontWheels()
	
	-- Her ön tekerlek için HingeConstraint oluştur
	self:SetupSteeringConstraints()
	
	print("🎯 Direksiyon sistemi yüklendi")
	
	return self
end

--[[
	Direksiyon constraint'lerini oluşturur
]]
function SteeringSystem:SetupSteeringConstraints()
	for i, wheel in ipairs(self.FrontWheels) do
		local wheelPart = wheel.Part
		
		-- Direksiyon için attachment (tekerlek merkezinde, Y ekseni etrafında dönecek)
		local steeringAttachment = Instance.new("Attachment")
		steeringAttachment.Name = "SteeringAttachment_" .. i
		steeringAttachment.Position = Vector3.new(0, 0, 0)
		steeringAttachment.Orientation = Vector3.new(0, 0, 0)
		steeringAttachment.Parent = wheelPart
		
		-- Üst attachment (chassis'e bağlı)
		local upperAttachment = wheelPart.Parent:FindFirstChild("SuspensionUpper_" .. i)
		if not upperAttachment then
			upperAttachment = Instance.new("Attachment")
			upperAttachment.Name = "SteeringUpper_" .. i
			upperAttachment.Position = Vector3.new(
				wheelPart.Position.X - wheelPart.Parent.PrimaryPart.Position.X,
				0,
				wheelPart.Position.Z - wheelPart.Parent.PrimaryPart.Position.Z
			)
			upperAttachment.Parent = wheelPart.Parent.PrimaryPart
		end
		
		-- HingeConstraint for steering
		local hinge = Instance.new("HingeConstraint")
		hinge.Name = "SteeringHinge_" .. i
		hinge.Attachment0 = upperAttachment
		hinge.Attachment1 = steeringAttachment
		
		-- Hinge ayarları
		hinge.ActuatorType = Enum.ActuatorType.Servo
		hinge.AngularVelocity = 0
		hinge.ServoMaxTorque = 100000
		hinge.TargetAngle = 0
		hinge.LimitsEnabled = true
		hinge.LowerAngle = -self.Config.MaxAngle
		hinge.UpperAngle = self.Config.MaxAngle
		
		hinge.Parent = wheelPart.Parent.PrimaryPart
		
		-- Tekerleğe hinge referansı ekle
		wheel.SteeringHinge = hinge
	end
end

--[[
	Direksiyon sistemini günceller
	@param deltaTime: number
	@param steeringInput: number - Direksiyon girişi (-1 ile 1 arası)
	@param vehicleSpeed: number - Araç hızı (studs/s)
]]
function SteeringSystem:Update(deltaTime, steeringInput, vehicleSpeed)
	self.SteeringInput = math.clamp(steeringInput, -1, 1)
	
	-- Hız bazlı direksiyon azaltma
	local speedFactor = 1.0
	if self.Config.SpeedSensitivity then
		-- Yüksek hızda daha az direksiyon
		local speedRatio = math.clamp(vehicleSpeed / 50, 0, 1)  -- 50 studs/s üzerinde etki
		speedFactor = 1 - (speedRatio * self.Config.SpeedReductionFactor)
	end
	
	-- Hedef açı
	self.TargetAngle = self.SteeringInput * self.Config.MaxAngle * speedFactor * self.Config.Sensitivity
	
	-- Yumuşak geçiş
	local angleChangeRate = self.Config.TurnSpeed * self.Config.MaxAngle
	if math.abs(self.CurrentAngle - self.TargetAngle) > 0.1 then
		if self.CurrentAngle < self.TargetAngle then
			self.CurrentAngle = math.min(self.CurrentAngle + angleChangeRate * deltaTime, self.TargetAngle)
		else
			self.CurrentAngle = math.max(self.CurrentAngle - angleChangeRate * deltaTime, self.TargetAngle)
		end
	else
		self.CurrentAngle = self.TargetAngle
	end
	
	-- Merkeze dönüş (input yoksa)
	if self.Config.ReturnToCenter and self.SteeringInput == 0 then
		if math.abs(self.CurrentAngle) > 0.5 then
			local returnRate = self.Config.ReturnSpeed * self.Config.MaxAngle
			if self.CurrentAngle > 0 then
				self.CurrentAngle = math.max(self.CurrentAngle - returnRate * deltaTime, 0)
			else
				self.CurrentAngle = math.min(self.CurrentAngle + returnRate * deltaTime, 0)
			end
		else
			self.CurrentAngle = 0
		end
	end
	
	-- Ackermann geometrisi uygula
	if self.Config.UseAckermann then
		self:ApplyAckermannSteering()
	else
		-- Basit direksiyon (her iki tekerlek aynı açıda)
		self:ApplySimpleSteering()
	end
end

--[[
	Basit direksiyon uygular (her iki tekerlek aynı açı)
]]
function SteeringSystem:ApplySimpleSteering()
	for _, wheel in ipairs(self.FrontWheels) do
		if wheel.SteeringHinge then
			wheel.SteeringHinge.TargetAngle = self.CurrentAngle
		end
	end
end

--[[
	Ackermann direksiyon geometrisi uygular
	İç tekerlek daha fazla, dış tekerlek daha az döner (gerçekçi dönüş)
]]
function SteeringSystem:ApplyAckermannSteering()
	if #self.FrontWheels < 2 then
		return
	end
	
	local leftWheel = self.FrontWheels[1]
	local rightWheel = self.FrontWheels[2]
	
	-- Tekerlekler arası mesafe (track width)
	local trackWidth = math.abs(leftWheel.Part.Position.X - rightWheel.Part.Position.X)
	
	-- Dingil mesafesi (wheelbase) - yaklaşık
	local wheelbase = 8  -- Bu değer araç modelinize göre ayarlanmalı
	
	-- Ackermann faktörü
	local ackermannFactor = self.Config.AckermannFactor
	
	if self.CurrentAngle ~= 0 then
		-- Dönüş yarıçapı
		local turnRadius = wheelbase / math.tan(math.rad(math.abs(self.CurrentAngle)))
		
		-- İç ve dış tekerlek açıları
		local innerRadius = turnRadius - (trackWidth / 2)
		local outerRadius = turnRadius + (trackWidth / 2)
		
		local innerAngle = math.deg(math.atan(wheelbase / innerRadius))
		local outerAngle = math.deg(math.atan(wheelbase / outerRadius))
		
		-- Faktör uygula (tam Ackermann için 1.0, basit için 0.0)
		local angleRange = innerAngle - outerAngle
		
		if self.CurrentAngle > 0 then
			-- Sağa dönüş (sol iç, sağ dış)
			leftWheel.SteeringHinge.TargetAngle = self.CurrentAngle + (angleRange * ackermannFactor / 2)
			rightWheel.SteeringHinge.TargetAngle = self.CurrentAngle - (angleRange * ackermannFactor / 2)
		else
			-- Sola dönüş (sağ iç, sol dış)
			leftWheel.SteeringHinge.TargetAngle = self.CurrentAngle - (angleRange * ackermannFactor / 2)
			rightWheel.SteeringHinge.TargetAngle = self.CurrentAngle + (angleRange * ackermannFactor / 2)
		end
	else
		-- Düz
		leftWheel.SteeringHinge.TargetAngle = 0
		rightWheel.SteeringHinge.TargetAngle = 0
	end
end

--[[
	Mevcut direksiyon açısını döndürür
	@return number - Derece cinsinden açı
]]
function SteeringSystem:GetCurrentAngle()
	return self.CurrentAngle
end

--[[
	Direksiyon hassasiyetini ayarlar
	@param sensitivity: number - Yeni hassasiyet (0-2 arası önerilir)
]]
function SteeringSystem:SetSensitivity(sensitivity)
	self.Config.Sensitivity = math.clamp(sensitivity, 0.1, 3.0)
	print(string.format("🎯 Direksiyon hassasiyeti: %.1f", sensitivity))
end

--[[
	Maksimum direksiyon açısını ayarlar
	@param maxAngle: number - Maksimum açı (derece)
]]
function SteeringSystem:SetMaxAngle(maxAngle)
	self.Config.MaxAngle = math.clamp(maxAngle, 10, 60)
	
	-- Constraint limitlerini güncelle
	for _, wheel in ipairs(self.FrontWheels) do
		if wheel.SteeringHinge then
			wheel.SteeringHinge.LowerAngle = -maxAngle
			wheel.SteeringHinge.UpperAngle = maxAngle
		end
	end
	
	print(string.format("🎯 Maksimum direksiyon açısı: %.0f°", maxAngle))
end

--[[
	Sistemi temizler
]]
function SteeringSystem:Destroy()
	for _, wheel in ipairs(self.FrontWheels) do
		if wheel.SteeringHinge then
			wheel.SteeringHinge:Destroy()
			wheel.SteeringHinge = nil
		end
	end
	
	self.CurrentAngle = 0
	self.TargetAngle = 0
end

return SteeringSystem
