--[[
	Advanced Car Chassis System - Stylish Model Builder
	
	Modern, şık ve detaylı araç modelleri oluşturur.
	Her model profesyonel görünüm için özel tasarlanmıştır.
]]

local StylishModelBuilder = {}

--[[
	Yardımcı fonksiyon: Part'a yuvarlatılmış köşeler ekler
]]
local function AddRoundedCorners(part)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	
	-- Her yüze SurfaceGui ekle
	for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
		local surfaceGui = Instance.new("SurfaceGui")
		surfaceGui.Face = face
		surfaceGui.Parent = part
		uiCorner:Clone().Parent = surfaceGui
	end
end

--[[
	Yardımcı fonksiyon: Weld constraint oluşturur
]]
local function WeldTo(part1, part2)
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = part1
	weld.Part1 = part2
	weld.Parent = part2
	return weld
end

--[[
	Modern jant oluşturur
]]
local function CreateWheel(config, wheelName, position, chassis, carModel)
	local wheelRadius = config.WheelRadius
	local wheelWidth = config.WheelWidth
	
	-- Ana tekerlek (lastik)
	local tire = Instance.new("Part")
	tire.Name = wheelName
	tire.Size = Vector3.new(wheelWidth, wheelRadius * 2, wheelRadius * 2)
	tire.Shape = Enum.PartType.Cylinder
	tire.Color = Color3.fromRGB(30, 30, 30)
	tire.Material = Enum.Material.SmoothPlastic
	tire.Anchored = false
	tire.CanCollide = true
	tire.Orientation = Vector3.new(0, 0, 90)
	tire.Position = position
	tire.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.9, 0.3, 1, 1)
	tire.Parent = carModel
	
	-- Jant (rim)
	local rim = Instance.new("Part")
	rim.Name = wheelName .. "_Rim"
	rim.Size = Vector3.new(wheelWidth * 0.6, wheelRadius * 1.4, wheelRadius * 1.4)
	rim.Shape = Enum.PartType.Cylinder
	rim.Color = Color3.fromRGB(200, 200, 200)
	rim.Material = Enum.Material.Metal
	rim.Anchored = false
	rim.CanCollide = false
	rim.Orientation = Vector3.new(0, 0, 90)
	rim.Position = position
	rim.Parent = carModel
	WeldTo(tire, rim)
	
	-- Jant merkezi (hub cap)
	local hubcap = Instance.new("Part")
	hubcap.Name = wheelName .. "_Hubcap"
	hubcap.Size = Vector3.new(wheelWidth * 0.4, wheelRadius * 0.8, wheelRadius * 0.8)
	hubcap.Shape = Enum.PartType.Cylinder
	hubcap.Color = config.AccentColor or Color3.fromRGB(255, 100, 100)
	hubcap.Material = Enum.Material.Neon
	hubcap.Anchored = false
	hubcap.CanCollide = false
	hubcap.Orientation = Vector3.new(0, 0, 90)
	hubcap.Position = position
	hubcap.Parent = carModel
	WeldTo(tire, hubcap)
	
	return tire
end

--[[
	Modern ön ızgara (grill) oluşturur
]]
local function CreateGrill(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	local grill = Instance.new("Part")
	grill.Name = "FrontGrill"
	grill.Size = Vector3.new(chassisSize.X * 0.6, chassisSize.Y * 0.4, 0.2)
	grill.Position = chassis.Position + Vector3.new(0, -chassisSize.Y * 0.15, chassisSize.Z/2 + 0.1)
	grill.Color = Color3.fromRGB(20, 20, 20)
	grill.Material = Enum.Material.DiamondPlate
	grill.CanCollide = false
	grill.Anchored = false
	grill.Parent = carModel
	WeldTo(chassis, grill)
	
	-- Izgara çizgileri
	for i = 1, 5 do
		local grillLine = Instance.new("Part")
		grillLine.Name = "GrillLine" .. i
		grillLine.Size = Vector3.new(chassisSize.X * 0.55, 0.1, 0.1)
		grillLine.Position = grill.Position + Vector3.new(0, (i - 3) * 0.25, 0.1)
		grillLine.Color = Color3.fromRGB(100, 100, 100)
		grillLine.Material = Enum.Material.Metal
		grillLine.CanCollide = false
		grillLine.Anchored = false
		grillLine.Parent = carModel
		WeldTo(grill, grillLine)
	end
	
	return grill
end

--[[
	Yan aynalar oluşturur
]]
local function CreateSideMirrors(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	for _, side in ipairs({-1, 1}) do
		-- Ayna kolu
		local mirrorArm = Instance.new("Part")
		mirrorArm.Name = "MirrorArm_" .. (side == -1 and "L" or "R")
		mirrorArm.Size = Vector3.new(0.3, 0.3, 0.8)
		mirrorArm.Position = chassis.Position + Vector3.new(
			side * (chassisSize.X/2 + 0.4),
			chassisSize.Y/2 - 0.3,
			chassisSize.Z/4
		)
		mirrorArm.Color = config.ChassisColor
		mirrorArm.Material = Enum.Material.SmoothPlastic
		mirrorArm.CanCollide = false
		mirrorArm.Anchored = false
		mirrorArm.Parent = carModel
		WeldTo(chassis, mirrorArm)
		
		-- Ayna cam
		local mirrorGlass = Instance.new("Part")
		mirrorGlass.Name = "MirrorGlass_" .. (side == -1 and "L" or "R")
		mirrorGlass.Size = Vector3.new(0.1, 0.6, 0.8)
		mirrorGlass.Position = mirrorArm.Position + Vector3.new(side * 0.2, 0, 0)
		mirrorGlass.Color = Color3.fromRGB(150, 200, 255)
		mirrorGlass.Material = Enum.Material.Glass
		mirrorGlass.Reflectance = 0.8
		mirrorGlass.Transparency = 0.3
		mirrorGlass.CanCollide = false
		mirrorGlass.Anchored = false
		mirrorGlass.Parent = carModel
		WeldTo(mirrorArm, mirrorGlass)
	end
end

--[[
	Egzoz boruları oluşturur
]]
local function CreateExhaust(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	for _, side in ipairs({-0.3, 0.3}) do
		local exhaust = Instance.new("Part")
		exhaust.Name = "Exhaust_" .. (side < 0 and "L" or "R")
		exhaust.Size = Vector3.new(0.4, 0.4, 0.8)
		exhaust.Shape = Enum.PartType.Cylinder
		exhaust.Position = chassis.Position + Vector3.new(
			side * chassisSize.X/3,
			-chassisSize.Y/2 + 0.3,
			-chassisSize.Z/2 - 0.4
		)
		exhaust.Orientation = Vector3.new(90, 0, 0)
		exhaust.Color = Color3.fromRGB(80, 80, 80)
		exhaust.Material = Enum.Material.Metal
		exhaust.CanCollide = false
		exhaust.Anchored = false
		exhaust.Parent = carModel
		WeldTo(chassis, exhaust)
		
		-- Egzoz ışığı (opsiyonel efekt)
		local exhaustGlow = Instance.new("Part")
		exhaustGlow.Name = "ExhaustGlow_" .. (side < 0 and "L" or "R")
		exhaustGlow.Size = Vector3.new(0.3, 0.3, 0.1)
		exhaustGlow.Shape = Enum.PartType.Cylinder
		exhaustGlow.Position = exhaust.Position + Vector3.new(0, 0, -0.45)
		exhaustGlow.Orientation = Vector3.new(90, 0, 0)
		exhaustGlow.Color = Color3.fromRGB(255, 100, 0)
		exhaustGlow.Material = Enum.Material.Neon
		exhaustGlow.Transparency = 0.5
		exhaustGlow.CanCollide = false
		exhaustGlow.Anchored = false
		exhaustGlow.Parent = carModel
		WeldTo(exhaust, exhaustGlow)
	end
end

--[[
	Modern farlar oluşturur
]]
local function CreateHeadlights(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	for i, xOffset in ipairs({-chassisSize.X/3, chassisSize.X/3}) do
		-- Far gövdesi
		local headlightBody = Instance.new("Part")
		headlightBody.Name = "HeadlightBody" .. i
		headlightBody.Size = Vector3.new(1.2, 0.6, 0.4)
		headlightBody.Position = chassis.Position + Vector3.new(xOffset, 0.2, chassisSize.Z/2 + 0.2)
		headlightBody.Color = Color3.fromRGB(40, 40, 40)
		headlightBody.Material = Enum.Material.SmoothPlastic
		headlightBody.CanCollide = false
		headlightBody.Anchored = false
		headlightBody.Parent = carModel
		WeldTo(chassis, headlightBody)
		
		-- Far lambası
		local headlight = Instance.new("Part")
		headlight.Name = "Headlight" .. i
		headlight.Size = Vector3.new(1, 0.5, 0.3)
		headlight.Position = headlightBody.Position + Vector3.new(0, 0, 0.05)
		headlight.Color = Color3.fromRGB(255, 255, 220)
		headlight.Material = Enum.Material.Neon
		headlight.CanCollide = false
		headlight.Anchored = false
		headlight.Parent = carModel
		WeldTo(headlightBody, headlight)
		
		-- SpotLight
		local light = Instance.new("SpotLight")
		light.Brightness = 8
		light.Range = 80
		light.Angle = 100
		light.Face = Enum.NormalId.Front
		light.Color = Color3.fromRGB(255, 255, 220)
		light.Parent = headlight
		
		-- LED şeridi
		local ledStrip = Instance.new("Part")
		ledStrip.Name = "LEDStrip" .. i
		ledStrip.Size = Vector3.new(1, 0.1, 0.1)
		ledStrip.Position = headlightBody.Position + Vector3.new(0, -0.3, 0.1)
		ledStrip.Color = config.AccentColor or Color3.fromRGB(0, 150, 255)
		ledStrip.Material = Enum.Material.Neon
		ledStrip.CanCollide = false
		ledStrip.Anchored = false
		ledStrip.Parent = carModel
		WeldTo(headlightBody, ledStrip)
	end
end

--[[
	Modern arka lambalar oluşturur
]]
local function CreateTaillights(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	for i, xOffset in ipairs({-chassisSize.X/3, chassisSize.X/3}) do
		-- Arka lamba gövdesi
		local taillightBody = Instance.new("Part")
		taillightBody.Name = "TaillightBody" .. i
		taillightBody.Size = Vector3.new(1, 0.8, 0.4)
		taillightBody.Position = chassis.Position + Vector3.new(xOffset, 0.2, -chassisSize.Z/2 - 0.2)
		taillightBody.Color = Color3.fromRGB(40, 40, 40)
		taillightBody.Material = Enum.Material.SmoothPlastic
		taillightBody.CanCollide = false
		taillightBody.Anchored = false
		taillightBody.Parent = carModel
		WeldTo(chassis, taillightBody)
		
		-- Stop lambası
		local taillight = Instance.new("Part")
		taillight.Name = "Taillight" .. i
		taillight.Size = Vector3.new(0.9, 0.7, 0.3)
		taillight.Position = taillightBody.Position + Vector3.new(0, 0, -0.05)
		taillight.Color = Color3.fromRGB(255, 0, 0)
		taillight.Material = Enum.Material.Neon
		taillight.CanCollide = false
		taillight.Anchored = false
		taillight.Parent = carModel
		WeldTo(taillightBody, taillight)
		
		-- LED şerit (arka)
		local ledStrip = Instance.new("Part")
		ledStrip.Name = "TailLEDStrip" .. i
		ledStrip.Size = Vector3.new(0.8, 0.1, 0.1)
		ledStrip.Position = taillightBody.Position + Vector3.new(0, 0.4, 0)
		ledStrip.Color = Color3.fromRGB(255, 150, 0)
		ledStrip.Material = Enum.Material.Neon
		ledStrip.Transparency = 0.3
		ledStrip.CanCollide = false
		ledStrip.Anchored = false
		ledStrip.Parent = carModel
		WeldTo(taillightBody, ledStrip)
	end
end

--[[
	Alt şase ve splitter oluşturur
]]
local function CreateUnderbody(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	-- Ön splitter
	local frontSplitter = Instance.new("Part")
	frontSplitter.Name = "FrontSplitter"
	frontSplitter.Size = Vector3.new(chassisSize.X * 0.9, 0.2, 0.6)
	frontSplitter.Position = chassis.Position + Vector3.new(0, -chassisSize.Y/2 + 0.1, chassisSize.Z/2 + 0.3)
	frontSplitter.Color = Color3.fromRGB(20, 20, 20)
	frontSplitter.Material = Enum.Material.SmoothPlastic
	frontSplitter.CanCollide = false
	frontSplitter.Anchored = false
	frontSplitter.Parent = carModel
	WeldTo(chassis, frontSplitter)
	
	-- Yan etekler
	for _, side in ipairs({-1, 1}) do
		local sideskirt = Instance.new("Part")
		sideskirt.Name = "Sideskirt_" .. (side == -1 and "L" or "R")
		sideskirt.Size = Vector3.new(0.3, 0.4, chassisSize.Z * 0.8)
		sideskirt.Position = chassis.Position + Vector3.new(
			side * (chassisSize.X/2 + 0.15),
			-chassisSize.Y/2 + 0.2,
			0
		)
		sideskirt.Color = Color3.fromRGB(20, 20, 20)
		sideskirt.Material = Enum.Material.SmoothPlastic
		sideskirt.CanCollide = false
		sideskirt.Anchored = false
		sideskirt.Parent = carModel
		WeldTo(chassis, sideskirt)
		
		-- Neon alt aydınlatma
		local underglow = Instance.new("Part")
		underglow.Name = "Underglow_" .. (side == -1 and "L" or "R")
		underglow.Size = Vector3.new(0.1, 0.1, chassisSize.Z * 0.7)
		underglow.Position = sideskirt.Position + Vector3.new(0, -0.25, 0)
		underglow.Color = config.AccentColor or Color3.fromRGB(0, 150, 255)
		underglow.Material = Enum.Material.Neon
		underglow.Transparency = 0.3
		underglow.CanCollide = false
		underglow.Anchored = false
		underglow.Parent = carModel
		WeldTo(sideskirt, underglow)
		
		-- PointLight for underglow
		local glowLight = Instance.new("PointLight")
		glowLight.Brightness = 3
		glowLight.Range = 15
		glowLight.Color = config.AccentColor or Color3.fromRGB(0, 150, 255)
		glowLight.Parent = underglow
	end
end

--[[
	Modern spoiler oluşturur
]]
local function CreateSpoiler(chassis, config, carModel, style)
	style = style or "standard"
	local chassisSize = config.ChassisSize
	
	if style == "racing" then
		-- Büyük yarış spoileri
		-- Destekler
		for _, side in ipairs({-0.4, 0.4}) do
			local support = Instance.new("Part")
			support.Name = "SpoilerSupport_" .. (side < 0 and "L" or "R")
			support.Size = Vector3.new(0.3, 1.5, 0.2)
			support.Position = chassis.Position + Vector3.new(
				side * chassisSize.X/2,
				chassisSize.Y/2 + 0.75,
				-chassisSize.Z/2 + 0.5
			)
			support.Color = Color3.fromRGB(20, 20, 20)
			support.Material = Enum.Material.SmoothPlastic
			support.CanCollide = false
			support.Anchored = false
			support.Parent = carModel
			WeldTo(chassis, support)
		end
		
		-- Ana kanat
		local wing = Instance.new("Part")
		wing.Name = "SpoilerWing"
		wing.Size = Vector3.new(chassisSize.X * 1.1, 0.3, 2)
		wing.Position = chassis.Position + Vector3.new(0, chassisSize.Y/2 + 1.5, -chassisSize.Z/2 + 0.5)
		wing.Orientation = Vector3.new(-10, 0, 0)
		wing.Color = config.ChassisColor
		wing.Material = Enum.Material.SmoothPlastic
		wing.CanCollide = false
		wing.Anchored = false
		wing.Parent = carModel
		WeldTo(chassis, wing)
		
		-- Kanat kenar şeritleri
		local wingStrip = Instance.new("Part")
		wingStrip.Name = "SpoilerStrip"
		wingStrip.Size = Vector3.new(chassisSize.X * 1.1, 0.1, 0.1)
		wingStrip.Position = wing.Position + Vector3.new(0, 0.2, 0)
		wingStrip.Color = config.AccentColor or Color3.fromRGB(255, 50, 50)
		wingStrip.Material = Enum.Material.Neon
		wingStrip.CanCollide = false
		wingStrip.Anchored = false
		wingStrip.Parent = carModel
		WeldTo(wing, wingStrip)
		
	else
		-- Standart spoiler
		local spoiler = Instance.new("Part")
		spoiler.Name = "Spoiler"
		spoiler.Size = Vector3.new(chassisSize.X * 0.8, 0.4, 1)
		spoiler.Position = chassis.Position + Vector3.new(0, chassisSize.Y/2 + 0.2, -chassisSize.Z/2 - 0.3)
		spoiler.Color = config.ChassisColor
		spoiler.Material = Enum.Material.SmoothPlastic
		spoiler.CanCollide = false
		spoiler.Anchored = false
		spoiler.Parent = carModel
		WeldTo(chassis, spoiler)
	end
end

--[[
	Modern cam tasarımı oluşturur
]]
local function CreateWindows(chassis, config, carModel)
	local chassisSize = config.ChassisSize
	
	-- Ön cam (daha geniş ve eğimli)
	local windshield = Instance.new("Part")
	windshield.Name = "Windshield"
	windshield.Size = Vector3.new(chassisSize.X * 0.85, 2.2, 0.2)
	windshield.Position = chassis.Position + Vector3.new(0, chassisSize.Y/2 + 1.1, chassisSize.Z/3.5)
	windshield.Orientation = Vector3.new(-25, 0, 0)
	windshield.Color = Color3.fromRGB(100, 150, 200)
	windshield.Material = Enum.Material.Glass
	windshield.Transparency = 0.4
	windshield.Reflectance = 0.3
	windshield.CanCollide = false
	windshield.Anchored = false
	windshield.Parent = carModel
	WeldTo(chassis, windshield)
	
	-- Yan camlar
	for _, side in ipairs({-1, 1}) do
		local sideWindow = Instance.new("Part")
		sideWindow.Name = "SideWindow_" .. (side == -1 and "L" or "R")
		sideWindow.Size = Vector3.new(0.2, 1.5, chassisSize.Z * 0.4)
		sideWindow.Position = chassis.Position + Vector3.new(
			side * chassisSize.X/2,
			chassisSize.Y/2 + 0.75,
			chassisSize.Z/6
		)
		sideWindow.Color = Color3.fromRGB(100, 150, 200)
		sideWindow.Material = Enum.Material.Glass
		sideWindow.Transparency = 0.4
		sideWindow.Reflectance = 0.3
		sideWindow.CanCollide = false
		sideWindow.Anchored = false
		sideWindow.Parent = carModel
		WeldTo(chassis, sideWindow)
	end
	
	-- Arka cam
	local rearWindow = Instance.new("Part")
	rearWindow.Name = "RearWindow"
	rearWindow.Size = Vector3.new(chassisSize.X * 0.8, 1.5, 0.2)
	rearWindow.Position = chassis.Position + Vector3.new(0, chassisSize.Y/2 + 0.75, -chassisSize.Z/2.5)
	rearWindow.Orientation = Vector3.new(15, 0, 0)
	rearWindow.Color = Color3.fromRGB(100, 150, 200)
	rearWindow.Material = Enum.Material.Glass
	rearWindow.Transparency = 0.5
	rearWindow.Reflectance = 0.3
	rearWindow.CanCollide = false
	rearWindow.Anchored = false
	rearWindow.Parent = carModel
	WeldTo(chassis, rearWindow)
end

--[[
	ŞIK ARAÇ MODELİ OLUŞTURUR
]]
function StylishModelBuilder.CreateStylishCar(config)
	config = config or {}
	
	-- Varsayılan ayarlar
	local carName = config.Name or "StylishCar"
	config.ChassisSize = config.ChassisSize or Vector3.new(10, 2.5, 5)
	config.ChassisColor = config.ChassisColor or Color3.fromRGB(70, 130, 180)
	config.AccentColor = config.AccentColor or Color3.fromRGB(0, 150, 255)
	config.WheelRadius = config.WheelRadius or 1.5
	config.WheelWidth = config.WheelWidth or 1
	config.Wheelbase = config.Wheelbase or 8
	config.TrackWidth = config.TrackWidth or 6
	
	print("✨ Şık araç oluşturuluyor: " .. carName)
	
	-- Model container
	local carModel = Instance.new("Model")
	carModel.Name = carName
	carModel.Parent = workspace
	
	-- Chassis (ana gövde)
	local chassis = Instance.new("Part")
	chassis.Name = "Chassis"
	chassis.Size = config.ChassisSize
	chassis.Position = Vector3.new(0, 10, 0)
	chassis.Color = config.ChassisColor
	chassis.Material = Enum.Material.SmoothPlastic
	chassis.Anchored = false
	chassis.CanCollide = true
	chassis.CustomPhysicalProperties = PhysicalProperties.new(0.7, 0.3, 0.5, 1, 1)
	chassis.Parent = carModel
	carModel.PrimaryPart = chassis
	
	print("  ✅ Ana gövde")
	
	-- Tekerlekler (modern jantlarla)
	local wheelPositions = {
		{name = "WheelFL", x = -config.TrackWidth/2, z = config.Wheelbase/2},
		{name = "WheelFR", x = config.TrackWidth/2, z = config.Wheelbase/2},
		{name = "WheelRL", x = -config.TrackWidth/2, z = -config.Wheelbase/2},
		{name = "WheelRR", x = config.TrackWidth/2, z = -config.Wheelbase/2},
	}
	
	for _, pos in ipairs(wheelPositions) do
		local yOffset = -(config.ChassisSize.Y/2) - 0.5
		local position = chassis.Position + Vector3.new(pos.x, yOffset, pos.z)
		CreateWheel(config, pos.name, position, chassis, carModel)
	end
	
	print("  ✅ Tekerlekler ve jantlar")
	
	-- Detaylı öğeler
	CreateWindows(chassis, config, carModel)
	print("  ✅ Camlar")
	
	CreateGrill(chassis, config, carModel)
	print("  ✅ Ön ızgara")
	
	CreateHeadlights(chassis, config, carModel)
	print("  ✅ Farlar ve LED'ler")
	
	CreateTaillights(chassis, config, carModel)
	print("  ✅ Stop lambaları")
	
	CreateSideMirrors(chassis, config, carModel)
	print("  ✅ Yan aynalar")
	
	CreateExhaust(chassis, config, carModel)
	print("  ✅ Egzoz sistemi")
	
	CreateUnderbody(chassis, config, carModel)
	print("  ✅ Alt şase ve underglow")
	
	if config.Spoiler then
		CreateSpoiler(chassis, config, carModel, config.SpoilerStyle or "standard")
		print("  ✅ Spoiler")
	end
	
	print("✨ Şık araç tamamlandı: " .. carName)
	return carModel
end

--[[
	PERFORMANS ARABASI (Spor/Yarış)
]]
function StylishModelBuilder.CreatePerformanceCar()
	print("🏎️ Performans arabası oluşturuluyor...")
	
	local car = StylishModelBuilder.CreateStylishCar({
		Name = "PerformanceCar",
		ChassisSize = Vector3.new(8, 2.2, 4.5),
		ChassisColor = Color3.fromRGB(200, 20, 20),  -- Kırmızı
		AccentColor = Color3.fromRGB(255, 150, 0),   -- Turuncu
		WheelRadius = 1.4,
		WheelWidth = 1.3,
		Wheelbase = 7,
		TrackWidth = 7.5,
		Spoiler = true,
		SpoilerStyle = "racing"
	})
	
	return car
end

--[[
	LÜKSGelişmiş SEDAN
]]
function StylishModelBuilder.CreateLuxurySedan()
	print("💎 Lüks sedan oluşturuluyor...")
	
	local car = StylishModelBuilder.CreateStylishCar({
		Name = "LuxurySedan",
		ChassisSize = Vector3.new(10, 3, 6),
		ChassisColor = Color3.fromRGB(20, 20, 40),   -- Koyu lacivert
		AccentColor = Color3.fromRGB(200, 180, 100), -- Altın
		WheelRadius = 1.6,
		WheelWidth = 1.1,
		Wheelbase = 9,
		TrackWidth = 6.5,
		Spoiler = true,
		SpoilerStyle = "standard"
	})
	
	return car
end

--[[
	OFF-ROAD ARAÇ
]]
function StylishModelBuilder.CreateOffRoadVehicle()
	print("🚙 Off-road araç oluşturuluyor...")
	
	local car = StylishModelBuilder.CreateStylishCar({
		Name = "OffRoadVehicle",
		ChassisSize = Vector3.new(9, 4.5, 6),
		ChassisColor = Color3.fromRGB(80, 120, 60),  -- Askeri yeşil
		AccentColor = Color3.fromRGB(255, 200, 0),   -- Sarı
		WheelRadius = 2.2,
		WheelWidth = 1.6,
		Wheelbase = 9,
		TrackWidth = 8,
		Spoiler = false
	})
	
	return car
end

--[[
	SÜPER ARABA (Hypercar)
]]
function StylishModelBuilder.CreateHypercar()
	print("⚡ Hypercar oluşturuluyor...")
	
	local car = StylishModelBuilder.CreateStylishCar({
		Name = "Hypercar",
		ChassisSize = Vector3.new(7.5, 2, 4),
		ChassisColor = Color3.fromRGB(100, 0, 200),  -- Mor
		AccentColor = Color3.fromRGB(0, 255, 200),   -- Cyan
		WheelRadius = 1.3,
		WheelWidth = 1.5,
		Wheelbase = 6.5,
		TrackWidth = 8,
		Spoiler = true,
		SpoilerStyle = "racing"
	})
	
	return car
end

-- OTOMATİK OLUŞTURMA
wait(1)

print("✨ ================================")
print("✨ Stylish Model Builder")
print("✨ ================================")

local carType = "Hypercar"  -- "Performance", "Luxury", "OffRoad", "Hypercar"

local car
if carType == "Performance" then
	car = StylishModelBuilder.CreatePerformanceCar()
elseif carType == "Luxury" then
	car = StylishModelBuilder.CreateLuxurySedan()
elseif carType == "OffRoad" then
	car = StylishModelBuilder.CreateOffRoadVehicle()
elseif carType == "Hypercar" then
	car = StylishModelBuilder.CreateHypercar()
else
	car = StylishModelBuilder.CreateStylishCar()
end

print("🎉 ================================")
print("🎉 Şık araç hazır!")
print("🎉 Model: " .. car.Name)
print("🎉 ================================")

return StylishModelBuilder
