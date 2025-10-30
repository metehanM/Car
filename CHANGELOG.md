# 📝 Changelog

Bu dosya projedeki tüm önemli değişiklikleri içerir.

Versiyon formatı: [Semantic Versioning](https://semver.org/) (MAJOR.MINOR.PATCH)

---

## [1.0.0] - 2025-10-30

### 🎉 İlk Sürüm

İlk stabil sürüm yayınlandı!

#### ✨ Yeni Özellikler

**Ana Sistemler:**
- ✅ ChassisCore - Ana araç sistemi koordinasyonu
- ✅ WheelSystem - Tekerlek fiziği ve yönetimi
- ✅ SuspensionSystem - Gerçekçi süspansiyon simülasyonu
- ✅ EngineSystem - Motor ve güç aktarımı
- ✅ SteeringSystem - Ackermann direksiyon geometrisi
- ✅ BrakeSystem - ABS destekli fren sistemi

**Motor Özellikleri:**
- Gerçekçi RPM simülasyonu
- Tork eğrisi desteği
- 4 farklı motor tipi (Naturally Aspirated, Turbocharged, Supercharged, Electric)
- Otomatik ve manuel vites sistemi (1-7 vites)
- 3 çekiş sistemi (AWD, FWD, RWD)
- Özelleştirilebilir güç dağılımı

**Süspansiyon Özellikleri:**
- Hooke Yasası tabanlı yay fiziği
- Bağımsız süspansiyon (her tekerlek için)
- Anti-roll bar sistemi
- Dinamik sıkışma takibi
- Ön/arka süspansiyon oranı ayarı

**Tekerlek Özellikleri:**
- Gerçekçi sürtünme hesaplaması
- Kayma (slip) hesaplaması
- Zemin tespiti (raycast)
- Yanal kuvvet simülasyonu
- Özelleştirilebilir grip

**Direksiyon Özellikleri:**
- Ackermann direksiyon geometrisi
- Hız bazlı hassasiyet
- Merkeze otomatik dönüş
- Servo motor tabanlı kontrol

**Fren Özellikleri:**
- Normal ve el freni
- ABS (Anti-lock Braking System)
- Ön/arka fren dağılımı
- Pulse tabanlı ABS sistemi

**Aerodinamik:**
- Hava direnci (drag)
- Downforce (basınç kuvveti)
- Hız bazlı kuvvetler

**UI ve HUD:**
- Hız göstergesi (KM/H)
- RPM göstergesi
- Vites göstergesi
- Throttle bar
- Dinamik renk kodlaması

**Kontrol Sistemi:**
- Klavye desteği
- Özelleştirilebilir tuş atamaları
- Smooth input handling

**Konfigürasyon:**
- Merkezi Config.lua dosyası
- 100+ ayarlanabilir parametre
- Preset konfigürasyonlar
- Dinamik ayar değiştirme

**Debug Sistemi:**
- Görsel debug (çizgiler, vektörler)
- Konsol loglaması
- Performans takibi

**Dokümantasyon:**
- ✅ README.md - Genel bilgi ve özellikler
- ✅ SETUP_GUIDE.md - Detaylı kurulum rehberi
- ✅ FEATURES.md - Özellik listesi
- ✅ ExampleCar.lua - Örnek kullanımlar
- ✅ LICENSE - MIT lisansı
- ✅ Her modülde detaylı açıklamalar

#### 📦 Örnek Konfigürasyonlar

- Temel Araç (Basic Car)
- Performans Arabası (800 HP, RWD)
- Off-Road Araç (AWD, yüksek kalkınklık)
- Özelleştirilebilir konfigürasyonlar

#### 🔧 Teknik İyileştirmeler

- Optimize edilmiş fizik hesaplamaları
- Network ownership yönetimi
- Efficient update loop
- Modüler mimari

---

## [0.9.0] - Beta Sürüm (Unreleased)

### Beta Test Aşaması

- Temel sistemlerin test edilmesi
- Bug fix'ler
- Performans optimizasyonları

---

## 🔮 Gelecek Sürümler

### [1.1.0] - Planlanan Özellikler

**Ses Sistemi:**
- Motor sesi (RPM bazlı)
- Tekerlek gıcırtısı
- Fren sesi
- Vites değiştirme sesi
- Çarpışma sesleri

**Görsel Efektler:**
- Egzoz dumanı
- Tekerlek kayma izi
- Drift dumanı
- Fren ısınması efekti

**Gamepad Desteği:**
- Xbox controller
- PlayStation controller
- Analog stick desteği
- Vibration feedback

**Yeni Konfigürasyonlar:**
- Drift arabası
- Formula arabası
- Kamyon/Ağır araç
- Elektrikli araç (gelişmiş)

### [1.2.0] - İleri Seviye Özellikler

**Nitro/Boost Sistemi:**
- Nitro tankı
- Boost animasyonları
- Hız artışı efektleri

**Lastik Sistemi:**
- Lastik sıcaklığı
- Lastik aşınması
- Grip değişimi
- Lastik türleri (soft/medium/hard)

**Motor Gelişmiş Özellikler:**
- Turbo lag simülasyonu
- Motor ısınması
- Yakıt sistemi
- Motor hasarı

### [2.0.0] - Major Update

**Hasar Sistemi:**
- Motor hasarı
- Tekerlek hasarı
- Süspansiyon hasarı
- Görsel deformasyon
- Tamir mekanikleri

**AI Sürücü:**
- Yapay zeka kontrollü araçlar
- Yol takibi
- Trafik simülasyonu
- Yarış AI'ı

**Multiplayer Özellikleri:**
- Network optimizasyonu
- Senkronizasyon iyileştirmeleri
- Lag kompansasyonu

**Yarış Modu:**
- Lap zamanlayıcı
- Checkpoint sistemi
- Liderlik tablosu
- Yarış kategorileri

**Hava Koşulları:**
- Yağmur etkisi (düşük grip)
- Kar etkisi
- Rüzgar etkisi
- Gece/gündüz döngüsü

---

## 📊 İstatistikler

### v1.0.0 Kod İstatistikleri

```
Toplam Satır: ~3000+ satır Lua kodu
Modül Sayısı: 7 ana modül
Konfigürasyon Parametresi: 100+
Örnek Kullanım: 6 farklı senaryo
Dokümantasyon: 1000+ satır
```

### Performans

```
Ortalama FPS: 60
Güncelleme Sıklığı: 60 Hz
Raycast Sayısı: 4-12 (ayarlanabilir)
Network Data: Optimize edilmiş
```

---

## 🐛 Bilinen Sorunlar

### v1.0.0

Şu an için bilinen kritik sorun bulunmamaktadır.

**Minör Sorunlar:**
- Çok yüksek hızlarda (200+ km/h) hafif fizik instability'si
- Çok dik yokuşlarda tekerlek grip kaybı
- Bazı özel yüzeylerde raycast problemleri

Bu sorunlar gelecek versiyonlarda düzeltilecektir.

---

## 🙏 Katkıda Bulunanlar

- **Ana Geliştirici**: [Your Name]
- **Test Ekibi**: Community Contributors
- **Dokümantasyon**: [Your Name]

---

## 📝 Notlar

- Her sürüm geriye dönük uyumlu olacak şekilde tasarlanmıştır
- Breaking changes sadece major versiyonlarda (x.0.0) yapılacaktır
- Tüm bug fix'ler patch versiyonlarında (x.x.X) yayınlanacaktır

---

**Son Güncelleme**: 2025-10-30

**Sonraki Planlanan Güncelleme**: 1.1.0 (TBA)
