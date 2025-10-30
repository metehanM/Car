--[[
	Advanced Car Chassis System - Quick Setup
	
	Bu script hem araç modelini oluşturur hem de chassis sistemini otomatik olarak ekler.
	Tek tuşla tamamen çalışır bir araç sistemi kurar!
	
	KULLANIM:
	1. src klasörünü ReplicatedStorage'a koyun
	2. Bu script'i ServerScriptService'e koyun
	3. Oyunu başlatın (F5)
	4. Araç otomatik olarak oluşturulacak ve çalışmaya başlayacak!
]]

local QuickSetup = {}

-- Servisler
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ServerStorage = game:GetService("ServerStorage")

--[[
	Modül dosyalarını oluşturur (eğer yoksa)
]]
function QuickSetup.EnsureModulesExist()
	-- src klasörünü bul veya oluştur
	local srcFolder = ReplicatedStorage:FindFirstChild("src")
	
	if not srcFolder then
		-- src klasörünü workspace'den kopyalamayı dene
		local workspaceSrc = script.Parent.Parent:FindFirstChild("src")
		if workspaceSrc then
			srcFolder = workspaceSrc:Clone()
			srcFolder.Parent = ReplicatedStorage
			print("✅ src klasörü ReplicatedStorage'a kopyalandı")
		else
			warn("⚠️ src klasörü bulunamadı! Modülleri manuel olarak eklemeniz gerekebilir.")
			return false
		end
	end
	
	return true
end

--[[
	Araç modeli oluşturur ve chassis sistemini ekler
]]
function QuickSetup.CreateCompleteCarSystem(carType, position)
	carType = carType or "Basic"
	position = position or Vector3.new(0, 10, 0)
	
	print("🚗 ================================")
	print("🚗 Tam Sistem Kurulumu Başlıyor...")
	print("🚗 Araç Tipi: " .. carType)
	print("🚗 ================================")
	
	-- Modüllerin varlığını kontrol et
	if not QuickSetup.EnsureModulesExist() then
		error("❌ src modülleri bulunamadı!")
	end
	
	-- Model konfigürasyonunu hazırla
	local configs = {
		Basic = {
			Name = "BasicCar",
			ChassisSize = Vector3.new(10, 3, 5),
			ChassisColor = Color3.fromRGB(70, 130, 180),
			WheelRadius = 1.5,
			WheelWidth = 1,
			Wheelbase = 8,
			TrackWidth = 6,
		},
		Performance = {
			Name = "PerformanceCar",
			ChassisSize = Vector3.new(8, 2.5, 4.5),
			ChassisColor = Color3.fromRGB(255, 50, 50),
			WheelRadius = 1.3,
			WheelWidth = 1.2,
			Wheelbase = 7,
			TrackWidth = 7,
		},
		OffRoad = {
			Name = "OffRoadVehicle",
			ChassisSize = Vector3.new(9, 4, 6),
			ChassisColor = Color3.fromRGB(100, 150, 80),
			WheelRadius = 2,
			WheelWidth = 1.5,
			Wheelbase = 9,
			TrackWidth = 8,
		},
		Racing = {
			Name = "RacingCar",
			ChassisSize = Vector3.new(7, 2, 4),
			ChassisColor = Color3.fromRGB(255, 200, 0),
			WheelRadius = 1.2,
			WheelWidth = 1.5,
			Wheelbase = 6.5,
			TrackWidth = 7.5,
		},
	}
	
	local config = configs[carType] or configs.Basic
	config.AddDetails = true
	
	-- Araç modelini oluştur
	local carModel = QuickSetup.BuildCarModel(config, position)
	
	-- Chassis sistemini ekle
	QuickSetup.AddChassisSystem(carModel)
	
	print("✅ ================================")
	print("✅ Tam Sistem Kurulumu Tamamlandı!")
	print("✅ Araç: " .. carModel.Name)
	print("✅ ================================")
	print("🎮 Kontroller:")
	print("   W/S - İleri/Geri")
	print("   A/D - Sola/Sağa")
	print("   Space - El Freni")
	
	return carModel
end

--[[
	Araç modelini oluşturur
]]
function QuickSetup.BuildCarModel(config, position)
	position = position or Vector3.new(0, 10, 0)
	
	print("🏗️ Araç modeli oluşturuluyor...")
	
	-- Model container
	local carModel = Instance.new("Model")
	carModel.Name = config.Name
	carModel.Parent = workspace
	
	-- Chassis
	local chassis = Instance.new("Part")
	chassis.Name = "Chassis"
	chassis.Size = config.ChassisSize
	chassis.Position = position
	chassis.Color = config.ChassisColor
	chassis.Material = Enum.Material.SmoothPlastic
	chassis.Anchored = false
	chassis.CanCollide = true
	chassis.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
	chassis.Parent = carModel
	carModel.PrimaryPart = chassis
	
	print("  ✅ Chassis: " .. tostring(chassis.Size))
	
	-- Tekerlekler
	local wheelPositions = {
		{name = "WheelFL", x = -config.TrackWidth/2, z = config.Wheelbase/2},
		{name = "WheelFR", x = config.TrackWidth/2, z = config.Wheelbase/2},
		{name = "WheelRL", x = -config.TrackWidth/2, z = -config.Wheelbase/2},
		{name = "WheelRR", x = config.TrackWidth/2, z = -config.Wheelbase/2},
	}
	
	for _, pos in ipairs(wheelPositions) do
		local wheel = Instance.new("Part")
		wheel.Name = pos.name
		wheel.Size = Vector3.new(config.WheelWidth, config.WheelRadius * 2, config.WheelRadius * 2)
		wheel.Shape = Enum.PartType.Cylinder
		wheel.Color = Color3.fromRGB(30, 30, 30)
		wheel.Material = Enum.Material.SmoothPlastic
		wheel.Anchored = false
		wheel.CanCollide = true
		wheel.Orientation = Vector3.new(0, 0, 90)
		
		local yOffset = -(config.ChassisSize.Y/2) - 0.5
		wheel.Position = chassis.Position + Vector3.new(pos.x, yOffset, pos.z)
		
		wheel.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.9, 0.3, 1, 1)
		wheel.Parent = carModel
		
		print("  ✅ " .. pos.name)
	end
	
	-- Görsel detaylar
	if config.AddDetails then
		-- Ön cam
		local windshield = Instance.new("Part")
		windshield.Name = "Windshield"
		windshield.Size = Vector3.new(config.ChassisSize.X * 0.8, 2, 0.2)
		windshield.Position = chassis.Position + Vector3.new(0, config.ChassisSize.Y/2 + 1, config.ChassisSize.Z/4)
		windshield.Orientation = Vector3.new(-20, 0, 0)
		windshield.Color = Color3.fromRGB(150, 200, 255)
		windshield.Material = Enum.Material.Glass
		windshield.Transparency = 0.5
		windshield.CanCollide = false
		windshield.Anchored = false
		windshield.Parent = carModel
		
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = chassis
		weld.Part1 = windshield
		weld.Parent = windshield
		
		-- Farlar
		for i, xOffset in ipairs({-config.ChassisSize.X/3, config.ChassisSize.X/3}) do
			local headlight = Instance.new("Part")
			headlight.Name = "Headlight" .. i
			headlight.Size = Vector3.new(1, 0.5, 0.3)
			headlight.Position = chassis.Position + Vector3.new(xOffset, 0, config.ChassisSize.Z/2 + 0.15)
			headlight.Color = Color3.fromRGB(255, 255, 200)
			headlight.Material = Enum.Material.Neon
			headlight.CanCollide = false
			headlight.Anchored = false
			headlight.Parent = carModel
			
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = chassis
			weld.Part1 = headlight
			weld.Parent = headlight
			
			local light = Instance.new("SpotLight")
			light.Brightness = 5
			light.Range = 60
			light.Angle = 90
			light.Face = Enum.NormalId.Front
			light.Parent = headlight
		end
		
		print("  ✅ Görsel detaylar eklendi")
	end
	
	return carModel
end

--[[
	Chassis sistemini araca ekler
]]
function QuickSetup.AddChassisSystem(carModel)
	print("⚙️ Chassis sistemi ekleniyor...")
	
	-- src klasörünü bul
	local srcFolder = ReplicatedStorage:FindFirstChild("src")
	if not srcFolder then
		error("❌ src klasörü ReplicatedStorage'da bulunamadı!")
	end
	
	-- src'yi araca kopyala
	local srcCopy = srcFolder:Clone()
	srcCopy.Parent = carModel
	
	-- Main script'i oluştur
	local mainScript = Instance.new("Script")
	mainScript.Name = "Main"
	mainScript.Source = [[
-- Advanced Car Chassis System - Auto-generated Main Script

local ChassisCore = require(script.Parent.src.ChassisCore)
local Config = require(script.Parent.src.Config)

local carModel = script.Parent
wait(0.5)

print("🚗 ====================================")
print("🚗 Advanced Car Chassis System")
print("🚗 Araç yükleniyor: " .. carModel.Name)
print("🚗 ====================================")

local chassis = ChassisCore.new(carModel, Config)
chassis:Initialize()
chassis:Start()

carModel.AncestryChanged:Connect(function()
	if not carModel:IsDescendantOf(game) then
		chassis:Destroy()
		print("🗑️ Araç silindi, chassis temizlendi")
	end
end)

print("✅ Araç sistemi başarıyla yüklendi!")
print("🎮 Kontroller: W/S - Gaz/Fren | A/D - Direksiyon | Space - El Freni")
]]
	mainScript.Parent = carModel
	
	print("  ✅ src modülleri eklendi")
	print("  ✅ Main script oluşturuldu")
	print("  ✅ Chassis sistemi hazır!")
end

--[[
	Birden fazla araç oluşturur (test için)
]]
function QuickSetup.CreateMultipleCars()
	print("🚗 Birden fazla araç oluşturuluyor...")
	
	local carTypes = {"Basic", "Performance", "OffRoad", "Racing"}
	local spacing = 20
	
	for i, carType in ipairs(carTypes) do
		local position = Vector3.new((i - 1) * spacing, 10, 0)
		QuickSetup.CreateCompleteCarSystem(carType, position)
		wait(0.5)
	end
	
	print("✅ Tüm araçlar oluşturuldu!")
end

-- ============================================
-- OTOMATİK KURULUM
-- ============================================

wait(1)

print("🎬 ================================")
print("🎬 Quick Setup Başlatılıyor...")
print("🎬 ================================")

-- Hangi modda çalıştırmak istediğinizi seçin:
local setupMode = "Single"  -- "Single", "Multiple"
local carType = "Basic"     -- "Basic", "Performance", "OffRoad", "Racing"

if setupMode == "Multiple" then
	-- Birden fazla araç oluştur (test/demo için)
	QuickSetup.CreateMultipleCars()
else
	-- Tek araç oluştur
	QuickSetup.CreateCompleteCarSystem(carType, Vector3.new(0, 10, 0))
end

print("🎉 ================================")
print("🎉 Kurulum Tamamlandı!")
print("🎉 Oyunu test edebilirsiniz!")
print("🎉 ================================")

return QuickSetup
