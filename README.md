# 🚗 Advanced Roblox Car Chassis System

Gelişmiş, modüler ve gerçekçi bir Roblox araba chassis sistemi. Bu sistem profesyonel araç simülasyonu için tasarlanmıştır.

## ✨ Özellikler

- **Gerçekçi Fizik Motoru**: İleri düzey araç fiziği ve dinamikleri
- **Modüler Yapı**: Kolayca özelleştirilebilir bileşenler
- **Süspansiyon Sistemi**: Gerçekçi yay ve sönümleme sistemi
- **Motor Simülasyonu**: Tork eğrisi, vites değiştirme ve güç aktarımı
- **Hassas Direksiyon**: Ackermann direksiyon geometrisi
- **Gelişmiş Fren Sistemi**: Normal ve el freni desteği
- **AWD/FWD/RWD Desteği**: Çeşitli çekiş sistemleri
- **Ayarlanabilir Parametreler**: Tüm önemli değişkenler özelleştirilebilir

## 📁 Proje Yapısı

```
/src
  ├── ChassisCore.lua        # Ana chassis sistemi
  ├── WheelSystem.lua        # Tekerlek yönetimi
  ├── SuspensionSystem.lua   # Süspansiyon fiziği
  ├── EngineSystem.lua       # Motor ve güç aktarımı
  ├── SteeringSystem.lua     # Direksiyon kontrolü
  ├── BrakeSystem.lua        # Fren sistemi
  └── Config.lua             # Ayarlar ve konfigürasyon

/examples
  └── ExampleCar.lua         # Örnek kullanım

Main                         # Ana giriş noktası
QuickSetup.lua              # ⚡ Otomatik kurulum (Önerilen!)
ModelBuilder.lua            # 🏗️ Otomatik model oluşturucu
```

## 🚀 Hızlı Başlangıç

### ⚡ Otomatik Kurulum (ÖNERİLEN)

**Kod ile otomatik model oluşturma:**

1. `src` klasörünü **ReplicatedStorage**'a koyun
2. `QuickSetup.lua` dosyasını **ServerScriptService**'e koyun
3. **F5** ile oyunu başlatın
4. Araç otomatik olarak oluşturulur ve çalışır! 🎉

Detaylı rehber → **`QUICK_START.md`**

### 🔧 Manuel Kurulum

1. Kendi araç modelinizi oluşturun (veya `ModelBuilder.lua` kullanın)
2. `Main` script'ini modele ekleyin
3. `src` klasörünü modele ekleyin
4. `Config.lua` dosyasından ayarları özelleştirin
5. Oyunu başlatın!

Detaylı rehber → **`SETUP_GUIDE.md`**

## 🎮 Kontroller

- **W/S**: İleri/Geri
- **A/D**: Sağa/Sola dönüş
- **Space**: El freni
- **Shift**: Vites değiştirme (manuel mod)

## ⚙️ Konfigürasyon

`Config.lua` dosyasından tüm parametreleri ayarlayabilirsiniz:

- Motor gücü ve tork eğrisi
- Süspansiyon sertliği ve sönümlemesi
- Tekerlek boyutları ve sürtünme
- Direksiyon hassasiyeti
- Fren gücü
- Ve daha fazlası...

## 📖 Dokümantasyon

- **`QUICK_START.md`** - ⚡ Otomatik model oluşturma rehberi (2 dakika)
- **`SETUP_GUIDE.md`** - 📖 Detaylı manuel kurulum rehberi
- **`FEATURES.md`** - 🎯 Tüm özellikler ve teknik detaylar
- **`CHANGELOG.md`** - 📝 Versiyon geçmişi ve güncellemeler
- **Her modül** - Kod içinde detaylı açıklamalar

## 🔧 Geliştirme

Bu sistem sürekli geliştirilmektedir. Katkılarınızı bekliyoruz!

## 📝 Lisans

MIT License - İstediğiniz gibi kullanabilir ve değiştirebilirsiniz.

---

**Not**: Bu sistem Roblox'un yeni constraint sistemini kullanır. Eski body movers yerine VectorForce, Torque ve diğer modern constraint'leri tercih eder.