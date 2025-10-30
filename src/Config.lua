--[[
	Advanced Car Chassis System - Configuration Module
	
	Bu dosya tüm araç parametrelerini içerir.
	Araç davranışını özelleştirmek için bu değerleri değiştirin.
]]

local Config = {}

-- ========================================
-- MOTOR AYARLARI
-- ========================================
Config.Engine = {
	-- Motor tipi: "Naturally_Aspirated", "Turbocharged", "Supercharged", "Electric"
	Type = "Turbocharged",
	
	-- Motor gücü (horsepower)
	MaxPower = 400,
	
	-- Maksimum tork (Newton-meter)
	MaxTorque = 500,
	
	-- Motor devir limiti (RPM)
	RedlineRPM = 7000,
	IdleRPM = 800,
	
	-- Tork eğrisi (RPM -> Tork çarpanı)
	TorqueCurve = {
		[0] = 0.3,
		[1000] = 0.5,
		[2000] = 0.7,
		[3000] = 0.85,
		[4000] = 1.0,    -- Maksimum tork noktası
		[5000] = 0.95,
		[6000] = 0.85,
		[7000] = 0.7,
	},
	
	-- Vites oranları (daha yüksek = daha fazla hız, daha az tork)
	Gears = {
		Reverse = -0.3,
		[1] = 0.4,
		[2] = 0.6,
		[3] = 0.8,
		[4] = 1.0,
		[5] = 1.2,
		[6] = 1.4,
	},
	
	-- Vites değiştirme RPM limitleri
	ShiftUpRPM = 6500,
	ShiftDownRPM = 2500,
	
	-- Otomatik vites (true/false)
	AutomaticTransmission = true,
	
	-- Diferansiyel oranı
	DifferentialRatio = 3.5,
	
	-- Güç aktarım sistemi: "AWD" (4 tekerlek), "FWD" (ön), "RWD" (arka)
	DriveType = "AWD",
	
	-- AWD için güç dağılımı (0-1 arası, 0 = sadece arka, 1 = sadece ön)
	AWDBalance = 0.4,  -- %40 ön, %60 arka
}

-- ========================================
-- SÜSPANSIYON AYARLARI
-- ========================================
Config.Suspension = {
	-- Yay sertliği (daha yüksek = daha sert)
	SpringStiffness = 25000,
	
	-- Sönümleme (damping) - hareketin yavaşlatılması
	SpringDamping = 2500,
	
	-- Süspansiyon uzunluğu (studs cinsinden)
	SpringLength = 2,
	
	-- Maksimum sıkışma mesafesi
	MaxCompression = 1.5,
	
	-- Ön/arka süspansiyon oranı (1.0 = eşit)
	FrontRearRatio = 1.1,  -- Ön biraz daha sert
	
	-- Anti-roll bar (yanal dengeleme) gücü
	AntiRollForce = 5000,
}

-- ========================================
-- TEKERLEK AYARLARI
-- ========================================
Config.Wheels = {
	-- Tekerlek yarıçapı (studs)
	Radius = 1.5,
	
	-- Tekerlek genişliği (studs)
	Width = 1,
	
	-- Tekerlek kütlesi (kg)
	Mass = 20,
	
	-- Yol tutuş katsayısı (daha yüksek = daha iyi kavrama)
	GripMultiplier = 1.5,
	
	-- Sürtünme katsayıları
	Friction = {
		Forward = 1.2,   -- İleri/geri hareket sürtünmesi
		Lateral = 1.5,   -- Yanal (dönüş) sürtünmesi
	},
	
	-- Kayma toleransı (0-1 arası)
	SlipThreshold = 0.3,
	
	-- Tekerlek aerodinamiği
	AeroDrag = 0.3,
}

-- ========================================
-- DİREKSİYON AYARLARI
-- ========================================
Config.Steering = {
	-- Maksimum direksiyon açısı (derece)
	MaxAngle = 35,
	
	-- Direksiyon hassasiyeti (daha yüksek = daha hızlı dönüş)
	Sensitivity = 1.0,
	
	-- Direksiyon dönüş hızı
	TurnSpeed = 3,
	
	-- Hız bazlı direksiyon azaltma (yüksek hızda daha az direksiyon)
	SpeedSensitivity = true,
	SpeedReductionFactor = 0.5,  -- Yüksek hızda %50 daha az direksiyon
	
	-- Ackermann direksiyon geometrisi (gerçekçi dönüş)
	UseAckermann = true,
	AckermannFactor = 0.3,
	
	-- Direksiyon geri dönüşü (merkeze dönme)
	ReturnToCenter = true,
	ReturnSpeed = 5,
}

-- ========================================
-- FREN AYARLARI
-- ========================================
Config.Brakes = {
	-- Normal fren gücü (Newton)
	BrakeForce = 15000,
	
	-- El freni gücü
	HandbrakeForce = 25000,
	
	-- El freni sadece arka tekerleklerde (true) veya hepsinde (false)
	HandbrakeRearOnly = true,
	
	-- Ön/arka fren oranı
	FrontBrakeBias = 0.6,  -- %60 ön, %40 arka
	
	-- ABS (Anti-lock Braking System)
	ABS = true,
	ABSPulseRate = 10,  -- Saniyede kaç kez
}

-- ========================================
-- AERODİNAMİK AYARLARI
-- ========================================
Config.Aerodynamics = {
	-- Hava direnci katsayısı
	DragCoefficient = 0.35,
	
	-- Downforce (basınç kuvveti) - yüksek hızda yere basma
	DownforceMultiplier = 1.2,
	
	-- Ön/arka downforce dağılımı
	FrontDownforce = 0.4,
	RearDownforce = 0.6,
}

-- ========================================
-- ARAÇ GÖVDESİ AYARLARI
-- ========================================
Config.Chassis = {
	-- Araç kütlesi (kg)
	Mass = 1500,
	
	-- Kütle merkezi offset'i (X, Y, Z)
	CenterOfMassOffset = Vector3.new(0, -0.5, 0),
	
	-- Ağırlık dağılımı (0-1 arası, 0.5 = dengeli)
	WeightDistribution = 0.45,  -- %45 ön, %55 arka
}

-- ========================================
-- KONTROL AYARLARI
-- ========================================
Config.Controls = {
	-- Klavye tuşları
	Throttle = Enum.KeyCode.W,
	Brake = Enum.KeyCode.S,
	SteerLeft = Enum.KeyCode.A,
	SteerRight = Enum.KeyCode.D,
	Handbrake = Enum.KeyCode.Space,
	ShiftUp = Enum.KeyCode.LeftShift,
	ShiftDown = Enum.KeyCode.LeftControl,
	
	-- Gamepad desteği
	GamepadEnabled = true,
	GamepadDeadzone = 0.1,
}

-- ========================================
-- PERFORMANS AYARLARI
-- ========================================
Config.Performance = {
	-- Fizik güncelleme hızı (Heartbeat tabanlı)
	UpdateRate = 60,
	
	-- Detaylı fizik hesaplamaları (daha gerçekçi ama daha yoğun)
	HighPrecisionPhysics = true,
	
	-- Tekerlek raycast sayısı (daha fazla = daha hassas ama daha yavaş)
	WheelRaycastCount = 2,
}

-- ========================================
-- SES AYARLARI (Opsiyonel)
-- ========================================
Config.Sound = {
	Enabled = true,
	EngineSound = "rbxassetid://0",  -- Buraya ses ID'si ekleyin
	TireSquealSound = "rbxassetid://0",
	BrakeSound = "rbxassetid://0",
	
	-- Ses seviyeleri (0-1)
	EngineVolume = 0.7,
	TireVolume = 0.5,
	BrakeVolume = 0.4,
}

-- ========================================
-- DEBUG AYARLARI
-- ========================================
Config.Debug = {
	-- Debug modunu etkinleştir
	Enabled = false,
	
	-- Görsel debug çizgileri
	ShowWheelForces = false,
	ShowSuspension = false,
	ShowCenterOfMass = false,
	
	-- Konsol çıktıları
	PrintRPM = false,
	PrintSpeed = false,
	PrintGear = false,
}

return Config
