--[[
	Advanced Car Chassis System - Example Usage
	
	Bu dosya sistemin nasıl kullanılacağını gösterir.
	Kendi araç modelinizi oluşturmak için bu örnekleri kullanabilirsiniz.
]]

local ChassisCore = require(game.ReplicatedStorage.CarSystem.src.ChassisCore)
local Config = require(game.ReplicatedStorage.CarSystem.src.Config)

-- ============================================
-- ÖRNEK 1: Temel Kullanım
-- ============================================

local function CreateBasicCar()
	-- Workspace'te araç modelini al
	local carModel = workspace:FindFirstChild("MyCar")
	
	if not carModel then
		warn("Araç modeli bulunamadı!")
		return
	end
	
	-- Chassis oluştur
	local chassis = ChassisCore.new(carModel, Config)
	
	-- Başlat
	chassis:Initialize()
	chassis:Start()
	
	print("✅ Temel araç oluşturuldu!")
	
	return chassis
end

-- ============================================
-- ÖRNEK 2: Özel Konfigürasyonla Araç
-- ============================================

local function CreateCustomCar()
	local carModel = workspace:FindFirstChild("MyCar")
	
	-- Özel konfigürasyon oluştur
	local customConfig = {
		Engine = {
			Type = "Electric",
			MaxPower = 600,  -- Daha güçlü motor
			MaxTorque = 800,
			RedlineRPM = 10000,
			DriveType = "AWD",
			AWDBalance = 0.5,  -- Dengeli güç dağılımı
			AutomaticTransmission = true,
			-- Diğer varsayılan ayarlar Config'den alınır
		},
		Suspension = Config.Suspension,
		Wheels = Config.Wheels,
		Steering = Config.Steering,
		Brakes = Config.Brakes,
		Aerodynamics = Config.Aerodynamics,
		Chassis = Config.Chassis,
		Controls = Config.Controls,
		Performance = Config.Performance,
		Sound = Config.Sound,
		Debug = Config.Debug,
	}
	
	local chassis = ChassisCore.new(carModel, customConfig)
	chassis:Initialize()
	chassis:Start()
	
	print("✅ Özel konfigürasyonlu araç oluşturuldu!")
	
	return chassis
end

-- ============================================
-- ÖRNEK 3: Performans Arabası
-- ============================================

local function CreatePerformanceCar()
	local carModel = workspace:FindFirstChild("PerformanceCar")
	
	local performanceConfig = {
		Engine = {
			Type = "Turbocharged",
			MaxPower = 800,
			MaxTorque = 900,
			RedlineRPM = 8500,
			IdleRPM = 1000,
			TorqueCurve = {
				[0] = 0.2,
				[1500] = 0.4,
				[3000] = 0.7,
				[4500] = 1.0,
				[6000] = 0.95,
				[7500] = 0.85,
				[8500] = 0.7,
			},
			Gears = {
				Reverse = -0.35,
				[1] = 0.35,
				[2] = 0.5,
				[3] = 0.7,
				[4] = 0.9,
				[5] = 1.1,
				[6] = 1.3,
				[7] = 1.5,  -- Ekstra vites
			},
			ShiftUpRPM = 8000,
			ShiftDownRPM = 3000,
			AutomaticTransmission = true,
			DifferentialRatio = 3.8,
			DriveType = "RWD",  -- Arka çekiş (drift için)
		},
		Suspension = {
			SpringStiffness = 35000,  -- Daha sert süspansiyon
			SpringDamping = 3500,
			SpringLength = 1.8,
			MaxCompression = 1.2,
			FrontRearRatio = 1.15,
			AntiRollForce = 7000,
		},
		Wheels = {
			Radius = 1.6,
			Width = 1.2,
			Mass = 25,
			GripMultiplier = 2.0,  -- Daha iyi tutunma
			Friction = {
				Forward = 1.5,
				Lateral = 1.8,
			},
			SlipThreshold = 0.25,
			AeroDrag = 0.25,
		},
		Steering = {
			MaxAngle = 30,  -- Daha az direksiyon açısı (yarış için)
			Sensitivity = 1.2,
			TurnSpeed = 4,
			SpeedSensitivity = true,
			SpeedReductionFactor = 0.6,
			UseAckermann = true,
			AckermannFactor = 0.4,
			ReturnToCenter = true,
			ReturnSpeed = 6,
		},
		Brakes = {
			BrakeForce = 25000,  -- Güçlü frenler
			HandbrakeForce = 35000,
			HandbrakeRearOnly = true,
			FrontBrakeBias = 0.7,
			ABS = true,
			ABSPulseRate = 15,
		},
		Aerodynamics = {
			DragCoefficient = 0.28,  -- Aerodinamik tasarım
			DownforceMultiplier = 2.0,  -- Güçlü downforce
			FrontDownforce = 0.35,
			RearDownforce = 0.65,
		},
		Chassis = Config.Chassis,
		Controls = Config.Controls,
		Performance = {
			UpdateRate = 60,
			HighPrecisionPhysics = true,
			WheelRaycastCount = 3,  -- Daha hassas
		},
		Sound = Config.Sound,
		Debug = Config.Debug,
	}
	
	local chassis = ChassisCore.new(carModel, performanceConfig)
	chassis:Initialize()
	chassis:Start()
	
	print("✅ Performans arabası oluşturuldu! 🏎️")
	
	return chassis
end

-- ============================================
-- ÖRNEK 4: Off-Road Araç
-- ============================================

local function CreateOffRoadVehicle()
	local carModel = workspace:FindFirstChild("OffRoadVehicle")
	
	local offRoadConfig = {
		Engine = {
			Type = "Naturally_Aspirated",
			MaxPower = 350,
			MaxTorque = 600,  -- Yüksek tork (off-road için önemli)
			RedlineRPM = 6000,
			IdleRPM = 700,
			DriveType = "AWD",
			AWDBalance = 0.35,  -- Daha fazla güç arka tekerleklerde
			AutomaticTransmission = true,
			DifferentialRatio = 4.5,  -- Yüksek oran (daha fazla tork, daha az hız)
			TorqueCurve = Config.Engine.TorqueCurve,
			Gears = Config.Engine.Gears,
			ShiftUpRPM = 5500,
			ShiftDownRPM = 2000,
		},
		Suspension = {
			SpringStiffness = 20000,  -- Daha yumuşak
			SpringDamping = 2000,
			SpringLength = 3,  -- Daha uzun (yüksek kalkınklık)
			MaxCompression = 2,  -- Daha fazla hareket
			FrontRearRatio = 1.0,
			AntiRollForce = 3000,  -- Daha az (off-road için)
		},
		Wheels = {
			Radius = 2,  -- Büyük tekerlekler
			Width = 1.5,
			Mass = 30,
			GripMultiplier = 1.3,
			Friction = {
				Forward = 1.5,
				Lateral = 1.3,
			},
			SlipThreshold = 0.4,  -- Daha fazla kayma toleransı
			AeroDrag = 0.5,
		},
		Steering = {
			MaxAngle = 40,  -- Geniş dönüş açısı
			Sensitivity = 0.8,
			TurnSpeed = 2.5,
			SpeedSensitivity = false,
			UseAckermann = true,
			AckermannFactor = 0.3,
			ReturnToCenter = true,
			ReturnSpeed = 4,
		},
		Brakes = {
			BrakeForce = 12000,
			HandbrakeForce = 20000,
			HandbrakeRearOnly = true,
			FrontBrakeBias = 0.55,
			ABS = true,
			ABSPulseRate = 8,
		},
		Aerodynamics = {
			DragCoefficient = 0.45,  -- Aerodinamik değil
			DownforceMultiplier = 0.5,
			FrontDownforce = 0.5,
			RearDownforce = 0.5,
		},
		Chassis = {
			Mass = 2000,  -- Ağır
			CenterOfMassOffset = Vector3.new(0, -0.8, 0),
			WeightDistribution = 0.5,
		},
		Controls = Config.Controls,
		Performance = Config.Performance,
		Sound = Config.Sound,
		Debug = Config.Debug,
	}
	
	local chassis = ChassisCore.new(carModel, offRoadConfig)
	chassis:Initialize()
	chassis:Start()
	
	print("✅ Off-Road araç oluşturuldu! 🚙")
	
	return chassis
end

-- ============================================
-- ÖRNEK 5: Dinamik Ayarlar (Oyun içi değişiklikler)
-- ============================================

local function DynamicAdjustments(chassis)
	-- Süspansiyon yüksekliğini değiştir
	chassis.Systems.Suspension:AdjustHeight(0.5)  -- 0.5 stud yükselt
	
	-- Süspansiyon sertliğini değiştir
	chassis.Systems.Suspension:AdjustStiffness(1.5)  -- %150 sertlik
	
	-- Direksiyon hassasiyetini değiştir
	chassis.Systems.Steering:SetSensitivity(1.5)
	
	-- Maksimum direksiyon açısını değiştir
	chassis.Systems.Steering:SetMaxAngle(40)
	
	-- Fren kuvvetini değiştir
	chassis.Systems.Brakes:SetBrakeForce(20000)
	
	-- Fren dağılımını değiştir
	chassis.Systems.Brakes:SetBrakeBias(0.65)
	
	-- ABS'i kapat
	chassis.Systems.Brakes:SetABS(false)
	
	print("🔧 Dinamik ayarlar uygulandı!")
end

-- ============================================
-- ÖRNEK 6: Bilgi Alma ve İzleme
-- ============================================

local function MonitorCar(chassis)
	local RunService = game:GetService("RunService")
	
	RunService.Heartbeat:Connect(function()
		-- Motor bilgilerini al
		local engineInfo = chassis.Systems.Engine:GetInfo()
		
		-- Süspansiyon durumunu al
		local avgCompression = chassis.Systems.Suspension:GetAverageCompression()
		local pitchCompression = chassis.Systems.Suspension:GetPitchCompression()
		
		-- Zemine değen tekerlek sayısı
		local groundedWheels = chassis.Systems.WheelSystem:GetGroundedWheelCount()
		
		-- ABS durumu
		local absActive = chassis.Systems.Brakes:IsABSActive()
		
		-- Bu bilgileri kullanarak UI güncelleyebilir veya loglayabilirsiniz
		if chassis.Config.Debug.Enabled then
			print(string.format(
				"Hız: %.0f km/h | RPM: %d | Vites: %d | Zemin: %d/4 | ABS: %s",
				chassis.SpeedKMH,
				engineInfo.RPM,
				engineInfo.Gear,
				groundedWheels,
				absActive and "✓" or "✗"
			))
		end
	end)
end

-- ============================================
-- Test fonksiyonları
-- ============================================

-- Test etmek için istediğiniz fonksiyonu çağırın:
-- local myCar = CreateBasicCar()
-- local performanceCar = CreatePerformanceCar()
-- local offRoadVehicle = CreateOffRoadVehicle()

-- Dinamik ayarlar:
-- DynamicAdjustments(myCar)

-- İzleme:
-- MonitorCar(myCar)

print("📚 Örnek kullanım dosyası yüklendi!")
print("💡 İpucu: Yukarıdaki fonksiyonları kopyalayıp kendi scriptlerinizde kullanabilirsiniz.")

return {
	CreateBasicCar = CreateBasicCar,
	CreateCustomCar = CreateCustomCar,
	CreatePerformanceCar = CreatePerformanceCar,
	CreateOffRoadVehicle = CreateOffRoadVehicle,
	DynamicAdjustments = DynamicAdjustments,
	MonitorCar = MonitorCar,
}
