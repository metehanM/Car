--[[
	Advanced Car Chassis System - Core Module
	
	Bu modül araç sisteminin ana bileşenidir.
	Tüm alt sistemleri yönetir ve koordine eder.
]]

local ChassisCore = {}
ChassisCore.__index = ChassisCore

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Modülleri yükle
local Config = require(script.Parent.Config)
local WheelSystem = require(script.Parent.WheelSystem)
local SuspensionSystem = require(script.Parent.SuspensionSystem)
local EngineSystem = require(script.Parent.EngineSystem)
local SteeringSystem = require(script.Parent.SteeringSystem)
local BrakeSystem = require(script.Parent.BrakeSystem)

--[[
	Yeni bir chassis instance oluşturur
	@param carModel: Model - Araç modeli (BasePart içeren)
	@param customConfig: table - Özel konfigürasyon (opsiyonel)
	@return ChassisCore instance
]]
function ChassisCore.new(carModel, customConfig)
	local self = setmetatable({}, ChassisCore)
	
	-- Temel özellikler
	self.Model = carModel
	self.Config = customConfig or Config
	self.Active = false
	self.Initialized = false
	
	-- Araç gövdesi
	self.Chassis = carModel.PrimaryPart or carModel:FindFirstChild("Chassis") or carModel:FindFirstChildWhichIsA("BasePart")
	assert(self.Chassis, "Araç modeli bir BasePart içermelidir!")
	
	-- Fizik özellikleri
	self.Velocity = Vector3.new()
	self.AngularVelocity = Vector3.new()
	self.Speed = 0
	self.SpeedMPH = 0
	self.SpeedKMH = 0
	
	-- Kontrol inputları
	self.Inputs = {
		Throttle = 0,    -- -1 (geri) ile 1 (ileri) arası
		Steering = 0,    -- -1 (sol) ile 1 (sağ) arası
		Brake = 0,       -- 0 ile 1 arası
		Handbrake = false,
	}
	
	-- Alt sistemler
	self.Systems = {
		Engine = nil,
		Wheels = nil,
		Suspension = nil,
		Steering = nil,
		Brakes = nil,
	}
	
	-- Bağlantılar
	self.Connections = {}
	
	return self
end

--[[
	Chassis sistemini başlatır
]]
function ChassisCore:Initialize()
	if self.Initialized then
		warn("Chassis zaten başlatılmış!")
		return
	end
	
	print("🚗 Advanced Car Chassis System başlatılıyor...")
	
	-- Araç fizik ayarları
	self:SetupPhysics()
	
	-- Tekerlekleri bul ve hazırla
	local wheels = self:FindWheels()
	if #wheels == 0 then
		error("Araç modelinde tekerlek bulunamadı! 'Wheel' ismini içeren Part'lar ekleyin.")
	end
	
	-- Alt sistemleri başlat
	self.Systems.Wheels = WheelSystem.new(wheels, self.Config)
	self.Systems.Suspension = SuspensionSystem.new(self.Chassis, self.Systems.Wheels, self.Config)
	self.Systems.Engine = EngineSystem.new(self.Config)
	self.Systems.Steering = SteeringSystem.new(self.Systems.Wheels, self.Config)
	self.Systems.Brakes = BrakeSystem.new(self.Systems.Wheels, self.Config)
	
	-- Kontrolleri ayarla
	self:SetupControls()
	
	self.Initialized = true
	print("✅ Chassis sistemi başarıyla başlatıldı!")
end

--[[
	Araç fizik özelliklerini ayarlar
]]
function ChassisCore:SetupPhysics()
	local chassis = self.Chassis
	
	-- Kütle ayarla
	if chassis:IsA("BasePart") then
		chassis.CustomPhysicalProperties = PhysicalProperties.new(
			self.Config.Chassis.Mass / (chassis.Size.X * chassis.Size.Y * chassis.Size.Z),
			0.3,  -- Sürtünme
			0.5,  -- Elastikiyet
			1,    -- Sürtünme ağırlığı
			1     -- Elastikiyet ağırlığı
		)
	end
	
	-- Kütle merkezini ayarla
	local attachment = Instance.new("Attachment")
	attachment.Name = "CenterOfMass"
	attachment.Position = self.Config.Chassis.CenterOfMassOffset
	attachment.Parent = chassis
	
	-- Chassis'i sabitle (NetworkOwnership)
	if chassis:IsA("BasePart") then
		chassis:SetNetworkOwner(nil)
	end
end

--[[
	Tekerlekleri bulur ve döndürür
	@return table - Tekerlek Part'ları
]]
function ChassisCore:FindWheels()
	local wheels = {}
	
	-- Model içindeki tüm Part'ları tara
	for _, part in ipairs(self.Model:GetDescendants()) do
		if part:IsA("BasePart") and string.match(part.Name:lower(), "wheel") then
			table.insert(wheels, part)
		end
	end
	
	-- Tekerlekleri pozisyona göre sırala (ön-sol, ön-sağ, arka-sol, arka-sağ)
	table.sort(wheels, function(a, b)
		if math.abs(a.Position.Z - b.Position.Z) > 1 then
			return a.Position.Z < b.Position.Z  -- Önce ön tekerlekler
		else
			return a.Position.X < b.Position.X  -- Sonra sol tekerlekler
		end
	end)
	
	return wheels
end

--[[
	Kontrol sistemini ayarlar
]]
function ChassisCore:SetupControls()
	local config = self.Config.Controls
	
	-- Klavye inputları
	table.insert(self.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		self:HandleInput(input, true)
	end))
	
	table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		self:HandleInput(input, false)
	end))
end

--[[
	Input'ları işler
	@param input: InputObject
	@param began: boolean - Input başladı mı (true) yoksa bitti mi (false)
]]
function ChassisCore:HandleInput(input, began)
	local config = self.Config.Controls
	
	if input.KeyCode == config.Throttle then
		self.Inputs.Throttle = began and 1 or 0
	elseif input.KeyCode == config.Brake then
		if began then
			self.Inputs.Throttle = -1
		else
			self.Inputs.Throttle = self.Inputs.Throttle == -1 and 0 or self.Inputs.Throttle
		end
	elseif input.KeyCode == config.SteerLeft then
		self.Inputs.Steering = began and -1 or 0
	elseif input.KeyCode == config.SteerRight then
		self.Inputs.Steering = began and 1 or 0
	elseif input.KeyCode == config.Handbrake then
		self.Inputs.Handbrake = began
	elseif input.KeyCode == config.ShiftUp then
		if began then
			self.Systems.Engine:ShiftUp()
		end
	elseif input.KeyCode == config.ShiftDown then
		if began then
			self.Systems.Engine:ShiftDown()
		end
	end
end

--[[
	Chassis'i başlatır (fizik hesaplamalarını başlatır)
]]
function ChassisCore:Start()
	if not self.Initialized then
		self:Initialize()
	end
	
	if self.Active then
		warn("Chassis zaten aktif!")
		return
	end
	
	self.Active = true
	
	-- Ana güncelleme döngüsü
	table.insert(self.Connections, RunService.Heartbeat:Connect(function(deltaTime)
		if self.Active then
			self:Update(deltaTime)
		end
	end))
	
	print("🏁 Araç başlatıldı ve sürüşe hazır!")
end

--[[
	Ana güncelleme fonksiyonu (her frame çağrılır)
	@param deltaTime: number - Son frame'den beri geçen süre
]]
function ChassisCore:Update(deltaTime)
	-- Hız hesapla
	self.Velocity = self.Chassis.AssemblyLinearVelocity
	self.AngularVelocity = self.Chassis.AssemblyAngularVelocity
	self.Speed = self.Velocity.Magnitude
	self.SpeedMPH = self.Speed * 2.237
	self.SpeedKMH = self.Speed * 3.6
	
	-- Motor sistemini güncelle
	local engineOutput = self.Systems.Engine:Update(deltaTime, self.Inputs.Throttle, self.Speed)
	
	-- Direksiyon sistemini güncelle
	self.Systems.Steering:Update(deltaTime, self.Inputs.Steering, self.Speed)
	
	-- Fren sistemini güncelle
	local brakeInput = (self.Inputs.Throttle < 0) and 1 or self.Inputs.Brake
	self.Systems.Brakes:Update(brakeInput, self.Inputs.Handbrake)
	
	-- Süspansiyon sistemini güncelle
	self.Systems.Suspension:Update(deltaTime)
	
	-- Motor gücünü tekerleklere uygula
	self:ApplyPower(engineOutput)
	
	-- Aerodinamik kuvvetleri uygula
	self:ApplyAerodynamics()
	
	-- Debug
	if self.Config.Debug.Enabled then
		self:DrawDebug()
	end
end

--[[
	Motor gücünü tekerleklere uygular
	@param power: number - Motor çıkış gücü
]]
function ChassisCore:ApplyPower(power)
	local driveType = self.Config.Engine.DriveType
	local wheels = self.Systems.Wheels.Wheels
	
	if driveType == "FWD" then
		-- Önden çekiş
		for i = 1, 2 do
			wheels[i]:ApplyPower(power)
		end
	elseif driveType == "RWD" then
		-- Arkadan itiş
		for i = 3, 4 do
			wheels[i]:ApplyPower(power)
		end
	elseif driveType == "AWD" then
		-- 4 tekerlek çekiş
		local frontPower = power * self.Config.Engine.AWDBalance
		local rearPower = power * (1 - self.Config.Engine.AWDBalance)
		
		wheels[1]:ApplyPower(frontPower)
		wheels[2]:ApplyPower(frontPower)
		wheels[3]:ApplyPower(rearPower)
		wheels[4]:ApplyPower(rearPower)
	end
end

--[[
	Aerodinamik kuvvetleri uygular
]]
function ChassisCore:ApplyAerodynamics()
	local speed = self.Speed
	local chassis = self.Chassis
	local config = self.Config.Aerodynamics
	
	-- Hava direnci
	local dragForce = -self.Velocity.Unit * (speed * speed * config.DragCoefficient)
	
	-- Downforce (basınç kuvveti)
	local downforce = -chassis.CFrame.UpVector * (speed * speed * config.DownforceMultiplier)
	
	-- Kuvvetleri uygula
	chassis:ApplyImpulse(dragForce * chassis.AssemblyMass * 0.01)
	chassis:ApplyImpulse(downforce * chassis.AssemblyMass * 0.01)
end

--[[
	Debug görsellerini çizer
]]
function ChassisCore:DrawDebug()
	if self.Config.Debug.ShowCenterOfMass then
		-- Kütle merkezini göster
		local com = self.Chassis.CFrame:PointToWorldSpace(self.Config.Chassis.CenterOfMassOffset)
		-- Debug görselleştirme (opsiyonel)
	end
	
	if self.Config.Debug.PrintSpeed then
		print(string.format("Hız: %.1f km/h (%.1f mph)", self.SpeedKMH, self.SpeedMPH))
	end
	
	if self.Config.Debug.PrintRPM then
		print(string.format("RPM: %.0f", self.Systems.Engine.CurrentRPM))
	end
	
	if self.Config.Debug.PrintGear then
		print(string.format("Vites: %d", self.Systems.Engine.CurrentGear))
	end
end

--[[
	Chassis'i durdurur
]]
function ChassisCore:Stop()
	self.Active = false
	
	-- Tüm bağlantıları kes
	for _, connection in ipairs(self.Connections) do
		connection:Disconnect()
	end
	self.Connections = {}
	
	print("🛑 Araç durduruldu")
end

--[[
	Chassis'i yok eder
]]
function ChassisCore:Destroy()
	self:Stop()
	
	-- Alt sistemleri temizle
	for _, system in pairs(self.Systems) do
		if system and system.Destroy then
			system:Destroy()
		end
	end
	
	self.Systems = {}
	self.Model = nil
	self.Chassis = nil
	
	print("🗑️ Chassis sistemi temizlendi")
end

return ChassisCore
