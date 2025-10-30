# 📖 Kurulum Rehberi - Advanced Car Chassis System

Bu rehber, sistemi Roblox Studio'da nasıl kuracağınızı ve kullanacağınızı adım adım açıklar.

## 📋 Gereksinimler

- **Roblox Studio** (En güncel sürüm önerilir)
- Temel Lua bilgisi (opsiyonel, fakat faydalı)
- Basit bir araç modeli

---

## 🚀 Hızlı Kurulum (5 Dakika)

### Adım 1: Dosyaları İçe Aktarma

1. Roblox Studio'yu açın
2. Yeni bir oyun oluşturun veya mevcut oyununuzu açın
3. Bu GitHub reposunu bilgisayarınıza indirin
4. Roblox Studio'da **View** → **Explorer** menüsünden projenizi görüntüleyin

### Adım 2: Araç Modeli Oluşturma

#### Basit Araç Modeli İçin:

1. **Workspace**'de yeni bir **Model** oluşturun ve adını `MyCar` yapın
2. Model içinde ana gövde için bir **Part** oluşturun:
   - Adı: `Chassis`
   - Boyut: `10, 3, 5` (veya istediğiniz boyut)
   - Bu part araç gövdeniz olacak
3. Model'in **PrimaryPart**'ını `Chassis` olarak ayarlayın
4. 4 tekerlek için **Part** oluşturun:
   - Adları: `WheelFL`, `WheelFR`, `WheelRL`, `WheelRR` (veya "Wheel" kelimesini içeren herhangi bir isim)
   - Şekil: Cylinder veya Ball
   - Boyut: `3, 3, 3` (yaklaşık)
   - Tekerlekleri araç gövdesinin etrafına yerleştirin (ön-sol, ön-sağ, arka-sol, arka-sağ)

**Önemli:** Tekerleklerin Part isimlerinde "Wheel" kelimesi geçmeli!

### Adım 3: Script Ekleme

1. GitHub'dan indirdiğiniz dosyaları Roblox Studio'ya aktarın:
   
   **Yöntem A - Manuel:**
   - `src` klasörünü `ReplicatedStorage` içine kopyalayın
   - `Main` script'ini araç modelinizin içine ekleyin
   
   **Yöntem B - Roblox Studio Plugin ile:**
   - Tüm dosyaları seçin ve sürükle-bırak yapın

2. Dosya yapısı şu şekilde olmalı:
   ```
   Workspace
   └── MyCar (Model)
       ├── Chassis (Part) - PrimaryPart
       ├── WheelFL (Part)
       ├── WheelFR (Part)
       ├── WheelRL (Part)
       ├── WheelRR (Part)
       ├── Main (Script)
       └── src (Folder)
           ├── ChassisCore (ModuleScript)
           ├── WheelSystem (ModuleScript)
           ├── SuspensionSystem (ModuleScript)
           ├── EngineSystem (ModuleScript)
           ├── SteeringSystem (ModuleScript)
           ├── BrakeSystem (ModuleScript)
           └── Config (ModuleScript)
   ```

### Adım 4: Test Etme

1. Oyunu başlatın (F5 veya Play butonu)
2. Konsolu açın (View → Output)
3. Şu mesajları görmelisiniz:
   ```
   🚗 Advanced Car Chassis System
   🚗 Araç yükleniyor: MyCar
   🛞 4 tekerlek başarıyla yüklendi
   ⚙️ Süspansiyon sistemi yüklendi
   🔧 Motor sistemi yüklendi
   ✅ Chassis sistemi başarıyla başlatıldı!
   ```

4. **Kontroller:**
   - `W` - İleri gitmek
   - `S` - Geri gitmek / Frenleme
   - `A` - Sola dönmek
   - `D` - Sağa dönmek
   - `Space` - El freni

---

## ⚙️ Gelişmiş Kurulum

### Özelleştirme Yapma

`src/Config.lua` dosyasını açın ve araç parametrelerini değiştirin:

```lua
-- Örnek: Daha güçlü motor
Config.Engine.MaxPower = 600  -- Varsayılan: 400
Config.Engine.MaxTorque = 700  -- Varsayılan: 500

-- Örnek: Daha sert süspansiyon
Config.Suspension.SpringStiffness = 35000  -- Varsayılan: 25000

-- Örnek: Daha hassas direksiyon
Config.Steering.Sensitivity = 1.5  -- Varsayılan: 1.0
```

### Farklı Araç Tipleri

`examples/ExampleCar.lua` dosyasında farklı araç konfigürasyonları bulabilirsiniz:

- **Performans Arabası**: 800 HP, RWD, sert süspansiyon
- **Off-Road Araç**: Yüksek kalkınklık, AWD, yumuşak süspansiyon
- **Özel Konfigürasyon**: Tamamen özelleştirilebilir

### Kendi Modelinizi Kullanma

Eğer zaten bir araç modeliniz varsa:

1. Modelin ana gövdesini `Chassis` olarak adlandırın (veya PrimaryPart olarak ayarlayın)
2. Tekerleklerin isimlerinde "Wheel" kelimesi geçtiğinden emin olun
3. `Main` script'ini modele ekleyin
4. `src` klasörünü modele veya `ReplicatedStorage`'a ekleyin

---

## 🔧 Sorun Giderme

### "Araç modeli bir BasePart içermelidir!" hatası

**Çözüm:** Model'in PrimaryPart'ını ayarlayın veya `Chassis` adında bir Part ekleyin.

### "Araç modelinde tekerlek bulunamadı!" hatası

**Çözüm:** Tekerlek Part'larının isimlerinde "Wheel" kelimesi geçtiğinden emin olun (büyük/küçük harf önemsiz).

### "src klasörü bulunamadı!" hatası

**Çözüm:** `src` klasörünün araç modelinin içinde veya `ReplicatedStorage`'da olduğundan emin olun. `Main` script içindeki path'i düzeltin:

```lua
-- Eğer src ReplicatedStorage'daysa:
local srcFolder = game.ReplicatedStorage:FindFirstChild("src")
```

### Araç hareket etmiyor

**Kontroller:**
1. Tekerleklerin anchored olmadığından emin olun
2. Chassis Part'ın anchored olmadığından emin olun
3. Tekerleklerin zemine değdiğinden emin olun
4. Console'da hata mesajı var mı kontrol edin

### Araç havada duruyor / düşüyor

**Çözüm:** Süspansiyon uzunluğunu ayarlayın:

```lua
Config.Suspension.SpringLength = 2  -- Daha uzun/kısa yapın
```

---

## 🎮 Oyun İçi Kontroller

### Klavye Kontrolleri (Varsayılan)

| Tuş | Fonksiyon |
|-----|-----------|
| W | Gaz (İleri) |
| S | Fren / Geri |
| A | Sola Dön |
| D | Sağa Dön |
| Space | El Freni |
| Left Shift | Vites Yükselt (Manuel mod) |
| Left Ctrl | Vites Düşür (Manuel mod) |

### Kontrolleri Değiştirme

`Config.lua` dosyasında:

```lua
Config.Controls = {
	Throttle = Enum.KeyCode.W,      -- Farklı tuş atayın
	Brake = Enum.KeyCode.S,
	SteerLeft = Enum.KeyCode.A,
	SteerRight = Enum.KeyCode.D,
	Handbrake = Enum.KeyCode.Space,
	-- ...
}
```

---

## 📊 HUD ve UI

Sistem otomatik olarak ekranın sağ alt köşesinde bir HUD oluşturur:

- **Hız göstergesi** (km/h)
- **RPM göstergesi**
- **Vites göstergesi**
- **Throttle bar**

HUD'u özelleştirmek için `Main` dosyasındaki `createSpeedometer()` fonksiyonunu düzenleyin.

---

## 🚀 Performans İpuçları

### Düşük FPS İçin

```lua
Config.Performance = {
	UpdateRate = 30,  -- 60'tan düşürün
	HighPrecisionPhysics = false,
	WheelRaycastCount = 1,  -- 2'den düşürün
}
```

### Yüksek Kalite İçin

```lua
Config.Performance = {
	UpdateRate = 60,
	HighPrecisionPhysics = true,
	WheelRaycastCount = 3,
}
```

---

## 🎨 Görsel İyileştirmeler

### Tekerlek Efektleri

- Tekerleklere **Trail** veya **ParticleEmitter** ekleyin (kayma efekti için)
- Motor sesini **Sound** objeleri ile ekleyin

### Işıklandırma

- Farlar için **SpotLight** ekleyin
- Stop lambaları için **PointLight** ekleyin
- Vites göstergesi için renkli **SurfaceLight** kullanın

---

## 📚 İleri Seviye Kullanım

### Dinamik Ayarlar (Oyun içinde değiştirme)

```lua
-- Script örneği
local chassis = carModel.ChassisInstance  -- Chassis referansını alın

-- Süspansiyon yüksekliğini değiştir
chassis.Systems.Suspension:AdjustHeight(0.5)

-- Direksiyon hassasiyetini değiştir
chassis.Systems.Steering:SetSensitivity(1.5)

-- Fren gücünü değiştir
chassis.Systems.Brakes:SetBrakeForce(20000)
```

### Çoklu Araç Yönetimi

```lua
local cars = {}

for _, carModel in ipairs(workspace.Cars:GetChildren()) do
	local chassis = ChassisCore.new(carModel, Config)
	chassis:Initialize()
	chassis:Start()
	table.insert(cars, chassis)
end
```

---

## 🐛 Debug Modu

Debug özelliklerini açmak için:

```lua
Config.Debug = {
	Enabled = true,
	ShowWheelForces = true,
	ShowSuspension = true,
	ShowCenterOfMass = true,
	PrintRPM = true,
	PrintSpeed = true,
	PrintGear = true,
}
```

---

## 💡 İpuçları

1. **Araç Dengesi**: `Config.Chassis.CenterOfMassOffset` ile kütle merkezini ayarlayın
2. **Drift Arabası**: `DriveType = "RWD"` ve düşük `Friction.Lateral` değeri kullanın
3. **Yarış Arabası**: Yüksek downforce ve sert süspansiyon kullanın
4. **Off-Road**: Yumuşak süspansiyon, büyük tekerlekler ve yüksek tork kullanın

---

## 🆘 Destek

Sorun yaşıyorsanız:

1. GitHub Issues sayfasını kontrol edin
2. Yeni bir issue açın
3. Kod örneklerinizi ve hata mesajlarını paylaşın

---

## 📝 Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için `LICENSE` dosyasına bakın.

---

**İyi sürüşler! 🏎️💨**
