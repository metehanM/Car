--[[
	Advanced Car Chassis System - Brake System Module
	
	Bu modül normal fren ve el freni sistemini yönetir.
	ABS (Anti-lock Braking System) desteği içerir.
]]

local BrakeSystem = {}
BrakeSystem.__index = BrakeSystem

--[[
	Yeni bir fren sistemi oluşturur
	@param wheelSystem: WheelSystem - Tekerlek sistemi
	@param config: table - Konfigürasyon
	@return BrakeSystem instance
]]
function BrakeSystem.new(wheelSystem, config)
	local self = setmetatable({}, BrakeSystem)
	
	self.WheelSystem = wheelSystem
	self.Config = config.Brakes
	
	-- Fren durumu
	self.BrakeInput = 0
	self.HandbrakeActive = false
	
	-- ABS sistemi
	self.ABSActive = false
	self.ABSPulseTimer = 0
	self.ABSPulseState = false
	
	print("🛑 Fren sistemi yüklendi" .. (self.Config.ABS and " (ABS aktif)" or ""))
	
	return self
end

--[[
	Fren sistemini günceller
	@param brakeInput: number - Fren pedalı (0-1 arası)
	@param handbrakeActive: boolean - El freni aktif mi
]]
function BrakeSystem:Update(brakeInput, handbrakeActive)
	self.BrakeInput = math.clamp(brakeInput, 0, 1)
	self.HandbrakeActive = handbrakeActive
	
	-- Her tekerlek için freni uygula
	for i, wheel in ipairs(self.WheelSystem.Wheels) do
		local brakeForce = self:CalculateBrakeForce(wheel, i)
		wheel:ApplyBrake(brakeForce)
	end
end

--[[
	Belirli bir tekerlek için fren kuvvetini hesaplar
	@param wheel: Wheel - Tekerlek instance
	@param index: number - Tekerlek index'i
	@return number - Fren kuvveti (Newton)
]]
function BrakeSystem:CalculateBrakeForce(wheel, index)
	local isFront = (index <= 2)
	local isRear = not isFront
	
	local force = 0
	
	-- Normal fren
	if self.BrakeInput > 0 then
		local baseBrakeForce = self.Config.BrakeForce * self.BrakeInput
		
		-- Ön/arka fren dağılımı
		if isFront then
			force = force + (baseBrakeForce * self.Config.FrontBrakeBias)
		else
			force = force + (baseBrakeForce * (1 - self.Config.FrontBrakeBias))
		end
	end
	
	-- El freni
	if self.HandbrakeActive then
		if self.Config.HandbrakeRearOnly then
			-- Sadece arka tekerleklere
			if isRear then
				force = force + self.Config.HandbrakeForce
			end
		else
			-- Tüm tekerleklere
			force = force + self.Config.HandbrakeForce
		end
	end
	
	-- ABS sistemi
	if self.Config.ABS and force > 0 then
		force = self:ApplyABS(wheel, force)
	end
	
	return force
end

--[[
	ABS (Anti-lock Braking System) uygular
	Tekerleklerin kilitlenmesini önler
	@param wheel: Wheel - Tekerlek instance
	@param brakeForce: number - Orijinal fren kuvveti
	@return number - ABS uygulanmış fren kuvveti
]]
function BrakeSystem:ApplyABS(wheel, brakeForce)
	-- Tekerlek kayıyor mu kontrol et
	if wheel.SlipRatio > 0.2 and wheel.IsGrounded then
		-- ABS devreye girer
		self.ABSActive = true
		
		-- Pulse sistemi (fren basma-bırakma)
		self.ABSPulseTimer = self.ABSPulseTimer + (1/60)  -- Yaklaşık deltaTime
		
		local pulseDuration = 1 / self.Config.ABSPulseRate
		if self.ABSPulseTimer >= pulseDuration then
			self.ABSPulseState = not self.ABSPulseState
			self.ABSPulseTimer = 0
		end
		
		-- Pulse durumuna göre fren kuvvetini azalt
		if self.ABSPulseState then
			return brakeForce * 0.3  -- %30 güç (fren bırakılıyor)
		else
			return brakeForce * 0.8  -- %80 güç (fren basılıyor)
		end
	else
		self.ABSActive = false
		return brakeForce
	end
end

--[[
	ABS'nin aktif olup olmadığını döndürür
	@return boolean
]]
function BrakeSystem:IsABSActive()
	return self.ABSActive
end

--[[
	Fren kuvvetini ayarlar
	@param newForce: number - Yeni fren kuvveti
]]
function BrakeSystem:SetBrakeForce(newForce)
	self.Config.BrakeForce = math.max(newForce, 1000)
	print(string.format("🛑 Fren kuvveti: %.0f N", newForce))
end

--[[
	El freni kuvvetini ayarlar
	@param newForce: number - Yeni el freni kuvveti
]]
function BrakeSystem:SetHandbrakeForce(newForce)
	self.Config.HandbrakeForce = math.max(newForce, 1000)
	print(string.format("🛑 El freni kuvveti: %.0f N", newForce))
end

--[[
	Ön/arka fren dağılımını ayarlar
	@param frontBias: number - Ön fren oranı (0-1 arası)
]]
function BrakeSystem:SetBrakeBias(frontBias)
	self.Config.FrontBrakeBias = math.clamp(frontBias, 0.3, 0.8)
	print(string.format("🛑 Fren dağılımı: Ön %%%.0f / Arka %%%.0f", 
		frontBias * 100, 
		(1 - frontBias) * 100
	))
end

--[[
	ABS sistemini açar/kapatır
	@param enabled: boolean
]]
function BrakeSystem:SetABS(enabled)
	self.Config.ABS = enabled
	print(string.format("🛑 ABS: %s", enabled and "Açık" or "Kapalı"))
end

--[[
	Acil fren (tüm kuvvetle)
]]
function BrakeSystem:EmergencyBrake()
	for _, wheel in ipairs(self.WheelSystem.Wheels) do
		wheel:ApplyBrake(self.Config.BrakeForce * 2)
	end
	
	print("⚠️ ACİL FREN AKTİF!")
end

--[[
	Fren sıcaklığını simüle eder (opsiyonel gelişmiş özellik)
	Uzun süreli frenleme sonrası fren etkisini azaltabilir
]]
function BrakeSystem:SimulateBrakeHeat()
	-- Bu özellik ileride eklenebilir
	-- Fren diski sıcaklığı, fren fade etkisi vs.
end

--[[
	Sistemi temizler
]]
function BrakeSystem:Destroy()
	self.BrakeInput = 0
	self.HandbrakeActive = false
	self.ABSActive = false
end

return BrakeSystem
