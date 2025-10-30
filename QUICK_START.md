# ⚡ Hızlı Başlangıç - Otomatik Model Oluşturma

Bu rehber, araç modelini **kod ile otomatik olarak** nasıl oluşturacağınızı gösterir. Hiç manuel işlem yapmadan tam çalışır bir araç sistemi kurabilirsiniz!

---

## 🎯 3 Farklı Yöntem

### Yöntem 1: QuickSetup (EN KOLAY) ⭐ ÖNERİLEN
**Tek script ile her şey hazır!**

### Yöntem 2: ModelBuilder (Sadece Model)
**Sadece araç modelini oluşturur, chassis'i manuel eklemeniz gerekir**

### Yöntem 3: Manuel Kurulum
**Her şeyi kendiniz yaparsınız (SETUP_GUIDE.md'ye bakın)**

---

## 🚀 Yöntem 1: QuickSetup (3 Adım)

### Adım 1: Dosyaları Yerleştirin

Roblox Studio'da:

1. **Explorer** panelini açın
2. **ReplicatedStorage**'a sağ tıklayın → **Insert Object** → **Folder**
3. Folder'ın adını `src` yapın
4. GitHub'dan indirdiğiniz `src` klasöründeki tüm dosyaları bu folder'a kopyalayın:
   - Config.lua
   - ChassisCore.lua
   - WheelSystem.lua
   - SuspensionSystem.lua
   - EngineSystem.lua
   - SteeringSystem.lua
   - BrakeSystem.lua

### Adım 2: QuickSetup Script'ini Ekleyin

1. **ServerScriptService**'e sağ tıklayın → **Insert Object** → **Script**
2. Script'in adını `QuickSetup` yapın
3. Script'i açın ve içeriğini silin
4. GitHub'dan `QuickSetup.lua` dosyasının içeriğini kopyalayıp yapıştırın

### Adım 3: Oyunu Başlatın!

1. **F5** tuşuna basın veya üstteki **Play** butonuna tıklayın
2. Console'u açın (**View** → **Output**)
3. Şu mesajları göreceksiniz:
   ```
   🚗 Tam Sistem Kurulumu Başlıyor...
   🏗️ Araç modeli oluşturuluyor...
   ✅ Chassis sistemi hazır!
   ✅ Kurulum Tamamlandı!
   ```
4. **Workspace**'de araç oluşturulacak ve otomatik olarak çalışmaya başlayacak!

### Araç Tipini Değiştirme

QuickSetup.lua dosyasında (yaklaşık 249. satır):

```lua
local setupMode = "Single"  -- "Single" veya "Multiple"
local carType = "Basic"     -- Burası değiştirin!
```

**Mevcut Araç Tipleri:**
- `"Basic"` - Normal araç (mavi)
- `"Performance"` - Spor araba (kırmızı, 800 HP)
- `"OffRoad"` - Arazi aracı (yeşil, büyük tekerlekler)
- `"Racing"` - Yarış arabası (sarı, spoilerli)

### Birden Fazla Araç Oluşturma

```lua
local setupMode = "Multiple"  -- Bunu yapın
```

Bu mod 4 farklı araç tipini yan yana oluşturur (test/demo için harika!)

---

## 🏗️ Yöntem 2: ModelBuilder (Sadece Model)

Sadece araç modelini oluşturmak istiyorsanız (chassis sistemini sonra manuel ekleyecekseniz):

### Kurulum

1. `ModelBuilder.lua` dosyasını **ServerScriptService**'e ekleyin
2. Dosyayı açın ve en alttaki ayarları düzenleyin:

```lua
local carType = "Performance"  -- İstediğiniz tipi seçin
```

3. Oyunu çalıştırın (F5)

### Mevcut Fonksiyonlar

```lua
-- Temel araç
ModelBuilder.CreateBasicCar()

-- Performans arabası
ModelBuilder.CreatePerformanceCar()

-- Off-road araç
ModelBuilder.CreateOffRoadVehicle()

-- Yarış arabası
ModelBuilder.CreateRacingCar()

-- Kamyon
ModelBuilder.CreateTruck()

-- Özel araç (tam özelleştirilebilir)
ModelBuilder.CreateCustomCar({
    Name = "MyCustomCar",
    ChassisSize = Vector3.new(12, 4, 6),
    ChassisColor = Color3.fromRGB(255, 0, 255),
    WheelRadius = 2,
    -- ... daha fazla ayar
})
```

### Chassis Sistemini Ekleme

Model oluşturulduktan sonra:

1. `src` klasörünü modele kopyalayın
2. `Main` script'ini modele ekleyin
3. Oyunu yeniden başlatın

---

## 🎨 Özelleştirme Örnekleri

### Örnek 1: Kendi Renklerinizle Araç

QuickSetup.lua dosyasındaki `configs` tablosunu düzenleyin:

```lua
Basic = {
    Name = "MyCoolCar",
    ChassisSize = Vector3.new(10, 3, 5),
    ChassisColor = Color3.fromRGB(255, 0, 255),  -- Pembe!
    WheelRadius = 2,  -- Büyük tekerlekler
    WheelWidth = 1.5,
    Wheelbase = 8,
    TrackWidth = 6,
},
```

### Örnek 2: Dev Kamyon

```lua
local config = {
    Name = "MonsterTruck",
    ChassisSize = Vector3.new(15, 6, 8),
    ChassisColor = Color3.fromRGB(0, 255, 0),
    WheelRadius = 3,  -- Çok büyük tekerlekler!
    WheelWidth = 2,
    Wheelbase = 12,
    TrackWidth = 10,
}
QuickSetup.BuildCarModel(config, Vector3.new(0, 20, 0))
```

### Örnek 3: Mini Araç

```lua
local config = {
    Name = "MiniCar",
    ChassisSize = Vector3.new(5, 2, 3),
    ChassisColor = Color3.fromRGB(255, 200, 0),
    WheelRadius = 0.8,  -- Küçük tekerlekler
    WheelWidth = 0.6,
    Wheelbase = 4,
    TrackWidth = 3,
}
QuickSetup.BuildCarModel(config, Vector3.new(0, 10, 0))
```

---

## 🔧 İleri Seviye: Script İçinden Kullanım

Kendi scriptlerinizden araç oluşturmak için:

```lua
-- QuickSetup modülünü require edin
local QuickSetup = require(game.ServerScriptService.QuickSetup)

-- Araç oluşturun
local myCar = QuickSetup.CreateCompleteCarSystem("Performance", Vector3.new(0, 10, 0))

-- İşlemler yapın
print("Araç oluşturuldu: " .. myCar.Name)

-- Veya birden fazla araç
for i = 1, 5 do
    local pos = Vector3.new(i * 15, 10, 0)
    QuickSetup.CreateCompleteCarSystem("Basic", pos)
    wait(0.5)
end
```

---

## 📊 Model Spesifikasyonları

### Basic Car
```
Boyut: 10 x 3 x 5 studs
Renk: Açık Mavi
Tekerlek: 1.5 yarıçap
Dingil: 8 studs
Track: 6 studs
```

### Performance Car
```
Boyut: 8 x 2.5 x 4.5 studs
Renk: Kırmızı
Tekerlek: 1.3 yarıçap (geniş)
Dingil: 7 studs
Track: 7 studs
Ekstra: Spoiler
```

### Off-Road Vehicle
```
Boyut: 9 x 4 x 6 studs
Renk: Yeşil-Kahverengi
Tekerlek: 2.0 yarıçap (büyük!)
Dingil: 9 studs
Track: 8 studs
Ekstra: Tavan taşıyıcı
```

### Racing Car
```
Boyut: 7 x 2 x 4 studs
Renk: Sarı
Tekerlek: 1.2 yarıçap (çok geniş)
Dingil: 6.5 studs
Track: 7.5 studs
Ekstra: Büyük arka spoiler
```

---

## 🐛 Sorun Giderme

### "src klasörü bulunamadı" hatası

**Çözüm:**
1. `src` klasörünün **ReplicatedStorage**'da olduğundan emin olun
2. Tüm 7 modül dosyasının içinde olduğunu kontrol edin

### Araç oluşturuldu ama hareket etmiyor

**Çözüm:**
1. Console'da hata var mı kontrol edin
2. `Main` script'inin araç modelinin içinde olduğundan emin olun
3. Oyunu durdurup yeniden başlatın

### Tekerlekler yanlış pozisyonda

**Çözüm:**
`Wheelbase` ve `TrackWidth` değerlerini ayarlayın:

```lua
Wheelbase = 8,   -- Ön-arka mesafe (artırın/azaltın)
TrackWidth = 6,  -- Sol-sağ mesafe (artırın/azaltın)
```

### Araç havada asılı kaldı

**Normal!** Araç kasıtlı olarak yüksekte oluşturulur ve yere düşer. Bu, zemin çarpışmasını önler.

---

## 💡 İpuçları

### İpucu 1: Test Ortamı
Birden fazla araç oluşturup test etmek için:
```lua
local setupMode = "Multiple"
```

### İpucu 2: Pozisyonları Ayarlama
Araçları farklı yerlerde oluşturmak için:
```lua
QuickSetup.CreateCompleteCarSystem("Performance", Vector3.new(50, 10, 50))
```

### İpucu 3: Spawnpad Oluşturma
Oyuncular için spawn noktası:
```lua
local spawn = Instance.new("SpawnLocation")
spawn.Position = Vector3.new(0, 1, 20)
spawn.Parent = workspace
```

### İpucu 4: Araç Galerisi
Tüm araç tiplerini göstermek için:
```lua
local types = {"Basic", "Performance", "OffRoad", "Racing"}
for i, carType in ipairs(types) do
    local x = (i - 1) * 20
    QuickSetup.CreateCompleteCarSystem(carType, Vector3.new(x, 10, 0))
end
```

---

## 🎬 Video Rehber

1. **Dosyaları hazırlayın** (src klasörü + QuickSetup.lua)
2. **F5** ile oyunu başlatın
3. **Output** penceresinden ilerlemeyi izleyin
4. **Workspace**'de araç belirecek
5. **W/A/S/D** ile test edin!

**Toplam Süre:** ~2 dakika ⚡

---

## 📞 Destek

Sorun yaşıyorsanız:

1. **Output** penceresindeki hata mesajlarını kontrol edin
2. `SETUP_GUIDE.md` dosyasına bakın
3. GitHub Issues'da sorun bildirin

---

## 🎉 Başarıyla Kurulduktan Sonra

Araç çalışıyorsa:

✅ **Config.lua** dosyasından ayarları değiştirin
✅ **ExampleCar.lua** dosyasındaki örneklere bakın
✅ Kendi araç tipinizi oluşturun
✅ Multiplayer testleri yapın

---

**Tebrikler! Artık kod ile araç oluşturabiliyorsunuz! 🚗💨**
