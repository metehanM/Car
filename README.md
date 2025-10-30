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
```

## 🚀 Hızlı Başlangıç

1. Tüm dosyaları Roblox Studio'ya aktarın
2. Araç modelinize `Main` script'ini ekleyin
3. `Config.lua` dosyasından ayarları özelleştirin
4. Oyunu başlatın ve sürüşün keyfini çıkarın!

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

Her modül kendi içinde detaylı açıklamalar içerir. Modüler yapı sayesinde sadece ihtiyacınız olan özellikleri kullanabilirsiniz.

## 🔧 Geliştirme

Bu sistem sürekli geliştirilmektedir. Katkılarınızı bekliyoruz!

## 📝 Lisans

MIT License - İstediğiniz gibi kullanabilir ve değiştirebilirsiniz.

---

**Not**: Bu sistem Roblox'un yeni constraint sistemini kullanır. Eski body movers yerine VectorForce, Torque ve diğer modern constraint'leri tercih eder.