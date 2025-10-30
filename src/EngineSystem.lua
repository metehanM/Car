--[[
	Advanced Car Chassis System - Engine System Module
	
	Bu modül motor simülasyonu, tork eğrisi ve vites değiştirmeyi yönetir.
]]

local EngineSystem = {}
EngineSystem.__index = EngineSystem

--[[
	Yeni bir motor sistemi oluşturur
	@param config: table - Konfigürasyon
	@return EngineSystem instance
]]
function EngineSystem.new(config)
	local self = setmetatable({}, EngineSystem)
	
	self.Config = config.Engine
	
	-- Motor durumu
	self.CurrentRPM = self.Config.IdleRPM
	self.TargetRPM = self.Config.IdleRPM
	self.CurrentGear = 1
	self.IsReverse = false
	self.Throttle = 0
	
	-- Motor çıktıları
	self.OutputTorque = 0
	self.OutputPower = 0
	
	-- Vites değiştirme
	self.LastShiftTime = 0
	self.ShiftCooldown = 0.5  -- Saniye
	
	print("🔧 Motor sistemi yüklendi - " .. self.Config.Type)
	
	return self
end

--[[
	Motor sistemini günceller
	@param deltaTime: number
	@param throttleInput: number - Gaz pedalı (-1 ile 1 arası)
	@param vehicleSpeed: number - Araç hızı (studs/s)
	@return number - Tekerlek gücü (Newton)
]]
function EngineSystem:Update(deltaTime, throttleInput, vehicleSpeed)
	self.Throttle = math.clamp(throttleInput, -1, 1)
	
	-- Geri vites kontrolü
	if self.Throttle < 0 then
		self.IsReverse = true
		self.CurrentGear = 0  -- Reverse
		self.Throttle = math.abs(self.Throttle)
	elseif self.IsReverse and self.Throttle > 0 and vehicleSpeed < 1 then
		-- Geri vitesten ileri vitese geçiş
		self.IsReverse = false
		self.CurrentGear = 1
	end
	
	-- Otomatik vites
	if self.Config.AutomaticTransmission and not self.IsReverse then
		self:AutoShift(vehicleSpeed)
	end
	
	-- Hedef RPM'i hesapla
	self:CalculateRPM(vehicleSpeed, deltaTime)
	
	-- Tork ve güç hesapla
	self:CalculateTorqueAndPower()
	
	-- Tekerlek çıkış gücünü hesapla
	local wheelPower = self:CalculateWheelPower()
	
	return wheelPower
end

--[[
	Motor RPM'ini hesaplar ve günceller
	@param vehicleSpeed: number - Araç hızı
	@param deltaTime: number
]]
function EngineSystem:CalculateRPM(vehicleSpeed, deltaTime)
	-- Mevcut vites oranı
	local gearRatio = self:GetCurrentGearRatio()
	local differentialRatio = self.Config.DifferentialRatio
	
	-- Tekerlek hızından motor RPM'i hesapla
	-- Bu basitleştirilmiş bir hesaplama, gerçek araba simülasyonları daha karmaşık
	local wheelRPM = (vehicleSpeed * 60) / (2 * math.pi * 1.5)  -- 1.5 = tekerlek yarıçapı
	local engineRPM = wheelRPM * gearRatio * differentialRatio
	
	-- Throttle etkisi
	local throttleRPM = self.Config.IdleRPM + (self.Config.RedlineRPM - self.Config.IdleRPM) * self.Throttle
	
	-- Hedef RPM
	if self.Throttle > 0 then
		self.TargetRPM = math.max(engineRPM, throttleRPM)
	else
		self.TargetRPM = math.max(engineRPM, self.Config.IdleRPM)
	end
	
	-- RPM limitleyici
	self.TargetRPM = math.clamp(self.TargetRPM, self.Config.IdleRPM, self.Config.RedlineRPM)
	
	-- Yumuşak RPM geçişi
	local rpmChangeRate = 3000 * self.Throttle  -- RPM/saniye
	if self.CurrentRPM < self.TargetRPM then
		self.CurrentRPM = math.min(self.CurrentRPM + rpmChangeRate * deltaTime, self.TargetRPM)
	else
		self.CurrentRPM = math.max(self.CurrentRPM - rpmChangeRate * deltaTime * 0.5, self.TargetRPM)
	end
end

--[[
	Tork ve güç hesaplar
]]
function EngineSystem:CalculateTorqueAndPower()
	-- Tork eğrisinden değer al
	local torqueMultiplier = self:GetTorqueMultiplier(self.CurrentRPM)
	
	-- Maksimum tork
	local maxTorque = self.Config.MaxTorque
	
	-- Mevcut tork
	self.OutputTorque = maxTorque * torqueMultiplier * self.Throttle
	
	-- Güç hesapla (P = T × ω, burada ω = RPM × 2π / 60)
	local omega = (self.CurrentRPM * 2 * math.pi) / 60
	self.OutputPower = self.OutputTorque * omega
end

--[[
	Tork eğrisinden RPM'e göre çarpanı döndürür
	@param rpm: number
	@return number - Tork çarpanı (0-1 arası)
]]
function EngineSystem:GetTorqueMultiplier(rpm)
	local curve = self.Config.TorqueCurve
	
	-- En yakın iki RPM noktasını bul ve interpolasyon yap
	local rpmPoints = {}
	for rpmValue, _ in pairs(curve) do
		table.insert(rpmPoints, rpmValue)
	end
	table.sort(rpmPoints)
	
	-- Sınırlar dışında
	if rpm <= rpmPoints[1] then
		return curve[rpmPoints[1]]
	end
	if rpm >= rpmPoints[#rpmPoints] then
		return curve[rpmPoints[#rpmPoints]]
	end
	
	-- İki nokta arasında interpolasyon
	for i = 1, #rpmPoints - 1 do
		local rpm1 = rpmPoints[i]
		local rpm2 = rpmPoints[i + 1]
		
		if rpm >= rpm1 and rpm <= rpm2 then
			local t = (rpm - rpm1) / (rpm2 - rpm1)
			local mult1 = curve[rpm1]
			local mult2 = curve[rpm2]
			return mult1 + (mult2 - mult1) * t
		end
	end
	
	return 1.0
end

--[[
	Tekerlek çıkış gücünü hesaplar (Newton)
	@return number
]]
function EngineSystem:CalculateWheelPower()
	if self.Throttle == 0 then
		return 0
	end
	
	-- Vites oranı
	local gearRatio = self:GetCurrentGearRatio()
	local differentialRatio = self.Config.DifferentialRatio
	
	-- Toplam oran
	local totalRatio = gearRatio * differentialRatio
	
	-- Tork çıktısı (tekerleklerde)
	local wheelTorque = self.OutputTorque * totalRatio
	
	-- Kuvvet (F = T / r)
	local wheelRadius = 1.5  -- Config'den alınabilir
	local force = wheelTorque / wheelRadius
	
	return force
end

--[[
	Mevcut vites oranını döndürür
	@return number
]]
function EngineSystem:GetCurrentGearRatio()
	if self.IsReverse then
		return self.Config.Gears.Reverse
	else
		return self.Config.Gears[self.CurrentGear] or 1.0
	end
end

--[[
	Otomatik vites değiştirme
	@param vehicleSpeed: number
]]
function EngineSystem:AutoShift(vehicleSpeed)
	local currentTime = tick()
	
	-- Cooldown kontrolü
	if currentTime - self.LastShiftTime < self.ShiftCooldown then
		return
	end
	
	-- Vites yükselt (shift up)
	if self.CurrentRPM >= self.Config.ShiftUpRPM and self.CurrentGear < #self.Config.Gears then
		self:ShiftUp()
	
	-- Vites düşür (shift down)
	elseif self.CurrentRPM <= self.Config.ShiftDownRPM and self.CurrentGear > 1 and vehicleSpeed > 5 then
		self:ShiftDown()
	end
end

--[[
	Vites yükseltir
]]
function EngineSystem:ShiftUp()
	if self.IsReverse then
		return
	end
	
	if self.CurrentGear < #self.Config.Gears then
		self.CurrentGear = self.CurrentGear + 1
		self.LastShiftTime = tick()
		
		-- RPM düşürme (vites değiştirme etkisi)
		self.CurrentRPM = self.CurrentRPM * 0.7
		
		print(string.format("⬆️ Vites yükseltildi: %d", self.CurrentGear))
	end
end

--[[
	Vites düşürür
]]
function EngineSystem:ShiftDown()
	if self.IsReverse then
		return
	end
	
	if self.CurrentGear > 1 then
		self.CurrentGear = self.CurrentGear - 1
		self.LastShiftTime = tick()
		
		-- RPM artırma
		self.CurrentRPM = math.min(self.CurrentRPM * 1.4, self.Config.RedlineRPM)
		
		print(string.format("⬇️ Vites düşürüldü: %d", self.CurrentGear))
	end
end

--[[
	Motor bilgilerini döndürür
	@return table
]]
function EngineSystem:GetInfo()
	return {
		RPM = math.floor(self.CurrentRPM),
		Gear = self.CurrentGear,
		IsReverse = self.IsReverse,
		Throttle = self.Throttle,
		Torque = math.floor(self.OutputTorque),
		Power = math.floor(self.OutputPower / 745.7),  -- Watt'tan HP'ye
	}
end

--[[
	Motor sesini hesaplar (ses sistemi için)
	@return number - Pitch değeri
]]
function EngineSystem:GetSoundPitch()
	local minPitch = 0.5
	local maxPitch = 2.5
	
	local rpmRatio = (self.CurrentRPM - self.Config.IdleRPM) / (self.Config.RedlineRPM - self.Config.IdleRPM)
	local pitch = minPitch + (maxPitch - minPitch) * rpmRatio
	
	return math.clamp(pitch, minPitch, maxPitch)
end

--[[
	Sistemi temizler
]]
function EngineSystem:Destroy()
	-- Motor sistemi için özel temizlik gerekmez
	self.Throttle = 0
	self.CurrentRPM = self.Config.IdleRPM
end

return EngineSystem
