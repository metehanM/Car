--[[
	Advanced Car Chassis System - Model Builder
	
	Bu script otomatik olarak bir araç modeli oluşturur.
	Roblox Studio'da bu script'i ServerScriptService'e koyun ve çalıştırın.
	
	KULLANIM:
	1. Bu script'i ServerScriptService'e ekleyin
	2. Oyunu başlatın (F5)
	3. Araç otomatik olarak Workspace'de oluşturulacak
]]

local ModelBuilder = {}

--[[
	Temel bir araç modeli oluşturur
	@param config: table - Araç yapılandırması (opsiyonel)
	@return Model - Oluşturulan araç modeli
]]
function ModelBuilder.CreateBasicCar(config)
	config = config or {}
	
	-- Varsayılan ayarlar
	local carName = config.Name or "GeneratedCar"
	local chassisSize = config.ChassisSize or Vector3.new(10, 3, 5)
	local chassisColor = config.ChassisColor or Color3.fromRGB(44, 44, 44)
	local wheelRadius = config.WheelRadius or 1.5
	local wheelWidth = config.WheelWidth or 1
	local wheelColor = config.WheelColor or Color3.fromRGB(30, 30, 30)
	local wheelbase = config.Wheelbase or 8  -- Ön-arka tekerlek mesafesi
	local trackWidth = config.TrackWidth or 6  -- Sol-sağ tekerlek mesafesi
	
	print("🏗️ Araç modeli oluşturuluyor: " .. carName)
	
	-- Ana model container
	local carModel = Instance.new("Model")
	carModel.Name = carName
	carModel.Parent = workspace
	
	-- ============================================
	-- CHASSIS (Ana Gövde)
	-- ============================================
	local chassis = Instance.new("Part")
	chassis.Name = "Chassis"
	chassis.Size = chassisSize
	chassis.Position = Vector3.new(0, 10, 0)  -- Yüksekte başlat (düşmesini sağla)
	chassis.Color = chassisColor
	chassis.Material = Enum.Material.SmoothPlastic
	chassis.Anchored = false
	chassis.CanCollide = true
	chassis.TopSurface = Enum.SurfaceType.Smooth
	chassis.BottomSurface = Enum.SurfaceType.Smooth
	
	-- Kütle ve fizik
	chassis.CustomPhysicalProperties = PhysicalProperties.new(
		0.7,  -- Density
		0.3,  -- Friction
		0.5,  -- Elasticity
		1,    -- FrictionWeight
		1     -- ElasticityWeight
	)
	
	chassis.Parent = carModel
	carModel.PrimaryPart = chassis
	
	print("  ✅ Chassis oluşturuldu")
	
	-- ============================================
	-- TEKERLEKLER
	-- ============================================
	local wheelPositions = {
		-- [isim] = {X offset, Z offset, isFront}
		WheelFL = {-trackWidth/2, wheelbase/2, true},   -- Ön Sol
		WheelFR = {trackWidth/2, wheelbase/2, true},    -- Ön Sağ
		WheelRL = {-trackWidth/2, -wheelbase/2, false}, -- Arka Sol
		WheelRR = {trackWidth/2, -wheelbase/2, false},  -- Arka Sağ
	}
	
	local wheels = {}
	
	for wheelName, pos in pairs(wheelPositions) do
		local wheel = Instance.new("Part")
		wheel.Name = wheelName
		wheel.Size = Vector3.new(wheelWidth, wheelRadius * 2, wheelRadius * 2)
		wheel.Shape = Enum.PartType.Cylinder
		wheel.Color = wheelColor
		wheel.Material = Enum.Material.SmoothPlastic
		wheel.Anchored = false
		wheel.CanCollide = true
		wheel.TopSurface = Enum.SurfaceType.Smooth
		wheel.BottomSurface = Enum.SurfaceType.Smooth
		
		-- Pozisyon (chassis'e göre)
		local xOffset = pos[1]
		local zOffset = pos[2]
		local yOffset = -(chassisSize.Y/2) - 0.5  -- Chassis'in altında
		
		wheel.Position = chassis.Position + Vector3.new(xOffset, yOffset, zOffset)
		
		-- Tekerlekleri yatay döndir (Cylinder varsayılan olarak dikey)
		wheel.Orientation = Vector3.new(0, 0, 90)
		
		-- Fizik özellikleri
		wheel.CustomPhysicalProperties = PhysicalProperties.new(
			0.7,  -- Density
			0.9,  -- Friction (yüksek - yol tutuşu için)
			0.3,  -- Elasticity
			1,
			1
		)
		
		wheel.Parent = carModel
		table.insert(wheels, wheel)
		
		print("  ✅ " .. wheelName .. " oluşturuldu")
	end
	
	-- ============================================
	-- GÖRSELLEŞTİRME (Opsiyonel Detaylar)
	-- ============================================
	
	if config.AddDetails ~= false then
		-- Ön cam
		local windshield = Instance.new("Part")
		windshield.Name = "Windshield"
		windshield.Size = Vector3.new(chassisSize.X * 0.8, 2, 0.2)
		windshield.Position = chassis.Position + Vector3.new(0, chassisSize.Y/2 + 1, chassisSize.Z/4)
		windshield.Orientation = Vector3.new(-20, 0, 0)
		windshield.Color = Color3.fromRGB(150, 200, 255)
		windshield.Material = Enum.Material.Glass
		windshield.Transparency = 0.5
		windshield.CanCollide = false
		windshield.Anchored = false
		windshield.Parent = carModel
		
		-- Weld to chassis
		local weld = Instance.new("WeldConstraint")
		weld.Part0 = chassis
		weld.Part1 = windshield
		weld.Parent = windshield
		
		print("  ✅ Ön cam eklendi")
		
		-- Ön farlar
		for i, xOffset in ipairs({-chassisSize.X/3, chassisSize.X/3}) do
			local headlight = Instance.new("Part")
			headlight.Name = "Headlight" .. i
			headlight.Size = Vector3.new(1, 0.5, 0.3)
			headlight.Position = chassis.Position + Vector3.new(xOffset, 0, chassisSize.Z/2 + 0.15)
			headlight.Color = Color3.fromRGB(255, 255, 200)
			headlight.Material = Enum.Material.Neon
			headlight.CanCollide = false
			headlight.Anchored = false
			headlight.Parent = carModel
			
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = chassis
			weld.Part1 = headlight
			weld.Parent = headlight
			
			-- Işık
			local light = Instance.new("SpotLight")
			light.Brightness = 5
			light.Range = 60
			light.Angle = 90
			light.Face = Enum.NormalId.Front
			light.Parent = headlight
		end
		
		print("  ✅ Farlar eklendi")
		
		-- Arka lambalar
		for i, xOffset in ipairs({-chassisSize.X/3, chassisSize.X/3}) do
			local taillight = Instance.new("Part")
			taillight.Name = "Taillight" .. i
			taillight.Size = Vector3.new(0.8, 0.4, 0.3)
			taillight.Position = chassis.Position + Vector3.new(xOffset, 0, -chassisSize.Z/2 - 0.15)
			taillight.Color = Color3.fromRGB(255, 0, 0)
			taillight.Material = Enum.Material.Neon
			taillight.CanCollide = false
			taillight.Anchored = false
			taillight.Parent = carModel
			
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = chassis
			weld.Part1 = taillight
			weld.Parent = taillight
		end
		
		print("  ✅ Stop lambaları eklendi")
	end
	
	-- ============================================
	-- SCRIPT'LERİ EKLE
	-- ============================================
	
	-- src klasörünü kopyala (eğer varsa)
	local srcFolder = game.ServerStorage:FindFirstChild("src") or game.ReplicatedStorage:FindFirstChild("src")
	
	if srcFolder then
		local srcCopy = srcFolder:Clone()
		srcCopy.Parent = carModel
		print("  ✅ src modülleri kopyalandı")
		
		-- Main script'i ekle
		local mainScript = game.ServerStorage:FindFirstChild("Main") or game.ReplicatedStorage:FindFirstChild("Main")
		if mainScript then
			local mainCopy = mainScript:Clone()
			mainCopy.Parent = carModel
			print("  ✅ Main script eklendi")
		else
			warn("  ⚠️ Main script bulunamadı! Manuel olarak eklemeniz gerekebilir.")
		end
	else
		warn("  ⚠️ src klasörü bulunamadı! Chassis sistemi çalışmayabilir.")
	end
	
	print("✅ Araç modeli başarıyla oluşturuldu: " .. carName)
	print("📍 Pozisyon: " .. tostring(chassis.Position))
	
	return carModel
end

--[[
	Performans arabası modeli oluşturur (spor araba)
]]
function ModelBuilder.CreatePerformanceCar()
	print("🏎️ Performans arabası oluşturuluyor...")
	
	local config = {
		Name = "PerformanceCar",
		ChassisSize = Vector3.new(8, 2.5, 4.5),
		ChassisColor = Color3.fromRGB(255, 50, 50),  -- Kırmızı
		WheelRadius = 1.3,
		WheelWidth = 1.2,
		WheelColor = Color3.fromRGB(20, 20, 20),
		Wheelbase = 7,
		TrackWidth = 7,
		AddDetails = true,
	}
	
	local car = ModelBuilder.CreateBasicCar(config)
	
	-- Spoiler ekle
	local spoiler = Instance.new("Part")
	spoiler.Name = "Spoiler"
	spoiler.Size = Vector3.new(7, 0.3, 1.5)
	spoiler.Position = car.PrimaryPart.Position + Vector3.new(0, 2, -2.5)
	spoiler.Color = Color3.fromRGB(40, 40, 40)
	spoiler.Material = Enum.Material.SmoothPlastic
	spoiler.CanCollide = false
	spoiler.Anchored = false
	spoiler.Parent = car
	
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = car.PrimaryPart
	weld.Part1 = spoiler
	weld.Parent = spoiler
	
	print("  ✅ Spoiler eklendi")
	
	return car
end

--[[
	Off-road araç modeli oluşturur (SUV/Jeep tarzı)
]]
function ModelBuilder.CreateOffRoadVehicle()
	print("🚙 Off-road araç oluşturuluyor...")
	
	local config = {
		Name = "OffRoadVehicle",
		ChassisSize = Vector3.new(9, 4, 6),
		ChassisColor = Color3.fromRGB(100, 150, 80),  -- Yeşil-kahverengi
		WheelRadius = 2,  -- Büyük tekerlekler
		WheelWidth = 1.5,
		WheelColor = Color3.fromRGB(30, 30, 30),
		Wheelbase = 9,
		TrackWidth = 8,
		AddDetails = true,
	}
	
	local car = ModelBuilder.CreateBasicCar(config)
	
	-- Tavan taşıyıcı
	local roofRack = Instance.new("Part")
	roofRack.Name = "RoofRack"
	roofRack.Size = Vector3.new(8, 0.2, 5)
	roofRack.Position = car.PrimaryPart.Position + Vector3.new(0, 2.5, 0)
	roofRack.Color = Color3.fromRGB(60, 60, 60)
	roofRack.Material = Enum.Material.Metal
	roofRack.CanCollide = false
	roofRack.Anchored = false
	roofRack.Parent = car
	
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = car.PrimaryPart
	weld.Part1 = roofRack
	weld.Parent = roofRack
	
	print("  ✅ Tavan taşıyıcı eklendi")
	
	return car
end

--[[
	Yarış arabası modeli oluşturur (formula/GT tarzı)
]]
function ModelBuilder.CreateRacingCar()
	print("🏁 Yarış arabası oluşturuluyor...")
	
	local config = {
		Name = "RacingCar",
		ChassisSize = Vector3.new(7, 2, 4),
		ChassisColor = Color3.fromRGB(255, 200, 0),  -- Sarı
		WheelRadius = 1.2,
		WheelWidth = 1.5,  -- Geniş tekerlekler
		WheelColor = Color3.fromRGB(15, 15, 15),
		Wheelbase = 6.5,
		TrackWidth = 7.5,
		AddDetails = true,
	}
	
	local car = ModelBuilder.CreateBasicCar(config)
	
	-- Büyük arka spoiler
	local spoiler = Instance.new("Part")
	spoiler.Name = "RearWing"
	spoiler.Size = Vector3.new(8, 0.3, 2)
	spoiler.Position = car.PrimaryPart.Position + Vector3.new(0, 2.5, -3)
	spoiler.Color = Color3.fromRGB(30, 30, 30)
	spoiler.Material = Enum.Material.SmoothPlastic
	spoiler.CanCollide = false
	spoiler.Anchored = false
	spoiler.Parent = car
	
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = car.PrimaryPart
	weld.Part1 = spoiler
	weld.Parent = spoiler
	
	-- Yarış numarası
	local decal = Instance.new("Decal")
	decal.Face = Enum.NormalId.Left
	decal.Texture = ""  -- Buraya özel texture ID ekleyebilirsiniz
	decal.Parent = car.PrimaryPart
	
	print("  ✅ Yarış özellikleri eklendi")
	
	return car
end

--[[
	Kamyon/ağır araç modeli oluşturur
]]
function ModelBuilder.CreateTruck()
	print("🚚 Kamyon oluşturuluyor...")
	
	local config = {
		Name = "Truck",
		ChassisSize = Vector3.new(12, 5, 7),
		ChassisColor = Color3.fromRGB(80, 80, 120),  -- Mavi-gri
		WheelRadius = 1.8,
		WheelWidth = 1.2,
		WheelColor = Color3.fromRGB(25, 25, 25),
		Wheelbase = 11,
		TrackWidth = 7,
		AddDetails = true,
	}
	
	local car = ModelBuilder.CreateBasicCar(config)
	
	-- Kargo bölümü
	local cargo = Instance.new("Part")
	cargo.Name = "CargoBed"
	cargo.Size = Vector3.new(10, 2, 5)
	cargo.Position = car.PrimaryPart.Position + Vector3.new(0, 1.5, -4)
	cargo.Color = Color3.fromRGB(60, 60, 60)
	cargo.Material = Enum.Material.Metal
	cargo.CanCollide = true
	cargo.Anchored = false
	cargo.Parent = car
	
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = car.PrimaryPart
	weld.Part1 = cargo
	weld.Parent = cargo
	
	print("  ✅ Kargo bölümü eklendi")
	
	return car
end

--[[
	Özel bir araç modeli oluşturur (tam özelleştirilebilir)
]]
function ModelBuilder.CreateCustomCar(customConfig)
	print("🎨 Özel araç oluşturuluyor...")
	
	local config = customConfig or {
		Name = "CustomCar",
		ChassisSize = Vector3.new(10, 3, 5),
		ChassisColor = Color3.fromRGB(100, 100, 255),
		WheelRadius = 1.5,
		WheelWidth = 1,
		WheelColor = Color3.fromRGB(30, 30, 30),
		Wheelbase = 8,
		TrackWidth = 6,
		AddDetails = true,
	}
	
	return ModelBuilder.CreateBasicCar(config)
end

-- ============================================
-- OTOMATİK OLUŞTURMA (Script çalıştırıldığında)
-- ============================================

-- Hangi arabayı oluşturmak istediğinizi seçin:
local carType = "Basic"  -- "Basic", "Performance", "OffRoad", "Racing", "Truck"

wait(1)  -- Oyunun yüklenmesini bekle

print("🚗 ================================")
print("🚗 Model Builder başlatılıyor...")
print("🚗 ================================")

local car
if carType == "Performance" then
	car = ModelBuilder.CreatePerformanceCar()
elseif carType == "OffRoad" then
	car = ModelBuilder.CreateOffRoadVehicle()
elseif carType == "Racing" then
	car = ModelBuilder.CreateRacingCar()
elseif carType == "Truck" then
	car = ModelBuilder.CreateTruck()
else
	car = ModelBuilder.CreateBasicCar({
		Name = "BasicCar",
		ChassisColor = Color3.fromRGB(70, 130, 180),  -- Mavi
	})
end

print("🎉 ================================")
print("🎉 Model başarıyla oluşturuldu!")
print("🎉 Araç: " .. car.Name)
print("🎉 ================================")
print("💡 İpucu: Chassis sistemini kullanmak için src klasörünü ve Main script'ini modele ekleyin.")

-- Model Builder modülünü döndür (başka scriptler için)
return ModelBuilder
