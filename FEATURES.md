# 🎯 Özellikler - Advanced Car Chassis System

Bu dokümanda sistemin tüm özellikleri ve teknik detayları açıklanmaktadır.

---

## 🚗 Ana Özellikler

### 1. Modüler Mimari

Sistem tamamen modüler tasarlanmıştır. Her bileşen bağımsız çalışabilir:

- **ChassisCore**: Ana koordinasyon merkezi
- **WheelSystem**: Tekerlek fiziği ve yönetimi
- **SuspensionSystem**: Süspansiyon simülasyonu
- **EngineSystem**: Motor ve güç aktarımı
- **SteeringSystem**: Direksiyon kontrolü
- **BrakeSystem**: Fren sistemi
- **Config**: Merkezi konfigürasyon

**Avantajlar:**
- Kolay özelleştirme
- Sadece ihtiyaç duyulan modüller kullanılabilir
- Bakım ve güncelleme kolaylığı
- Kod tekrarının önlenmesi

---

## ⚙️ Motor Sistemi (EngineSystem)

### Gerçekçi Motor Simülasyonu

```lua
- RPM takibi (Idle'dan Redline'a)
- Tork eğrisi simülasyonu
- Güç hesaplaması (HP/kW)
- Motor tipi desteği:
  * Naturally Aspirated (Atmosferik)
  * Turbocharged (Turbo)
  * Supercharged (Kompresör)
  * Electric (Elektrikli)
```

### Vites Sistemi

```lua
- Otomatik vites değiştirme
- Manuel vites kontrolü
- Özelleştirilebilir vites oranları (1-7 vites)
- Geri vites desteği
- Vites değiştirme cooldown'u
- RPM bazlı otomatik vites değişimi
```

### Güç Aktarımı

```lua
- AWD (4 tekerlekten çekiş)
- FWD (Önden çekiş)
- RWD (Arkadan itiş)
- Özelleştirilebilir güç dağılımı (AWD için)
- Diferansiyel oranı ayarı
```

### Tork Eğrisi

Gerçekçi tork eğrisi simülasyonu ile:
- Düşük RPM'de düşük güç
- Orta RPM'de maksimum tork
- Yüksek RPM'de düşen tork
- Tamamen özelleştirilebilir eğri noktaları

---

## 🛞 Tekerlek Sistemi (WheelSystem)

### Fizik Özellikleri

```lua
- Tekerlek yarıçapı ve genişliği
- Tekerlek kütlesi
- Sürtünme katsayıları:
  * İleri/geri sürtünme
  * Yanal (dönüş) sürtünme
- Kayma hesaplaması (slip ratio)
- Zemin tespiti (raycast)
```

### Yol Tutuş (Grip)

```lua
- Grip multiplier (kavrama katsayısı)
- Kayma toleransı ayarı
- Farklı yüzey materyallerine tepki
- Yanal kuvvet hesaplaması
- Kayma oranı takibi
```

### Zemin Tespiti

```lua
- Raycast tabanlı zemin kontrolü
- Zemin normali hesaplama
- Zemin materyali tespiti
- Her tekerlek için bağımsız kontrol
- Havada/yerde durumu takibi
```

---

## 🔧 Süspansiyon Sistemi (SuspensionSystem)

### Yay Fiziği (Spring Physics)

```lua
- Hooke Yasası tabanlı hesaplama
- Özelleştirilebilir yay sertliği
- Sönümleme (damping) sistemi
- Sıkışma takibi
- Dinamik yay uzunluğu
```

### Süspansiyon Özellikleri

```lua
- Bağımsız süspansiyon (her tekerlek)
- Ön/arka süspansiyon oranı ayarı
- Maksimum sıkışma limiti
- Süspansiyon uzunluğu ayarı
- Dinamik yükseklik değişimi
```

### Anti-Roll Bar

```lua
- Yanal stabilite kontrolü
- Sol/sağ tekerlek dengeleme
- Ön ve arka aksam için ayrı hesaplama
- Ayarlanabilir anti-roll kuvveti
- Viraj dengeleme
```

### Gerçek Zamanlı İzleme

```lua
- Sıkışma miktarı takibi
- Sıkışma hızı hesaplama
- Ortalama sıkışma
- Pitch (ön/arka) sıkışma farkı
- Roll (sol/sağ) sıkışma farkı
```

---

## 🎯 Direksiyon Sistemi (SteeringSystem)

### Ackermann Geometrisi

```lua
- Gerçekçi dönüş geometrisi
- İç tekerlek daha fazla döner
- Dış tekerlek daha az döner
- Ayarlanabilir Ackermann faktörü
- Dingil ve track genişliği hesabı
```

### Direksiyon Özellikleri

```lua
- Maksimum direksiyon açısı ayarı
- Hassasiyet ayarı
- Dönüş hızı kontrolü
- Merkeze otomatik dönüş
- Yumuşak geçiş (smooth steering)
```

### Hız Bazlı Direksiyon

```lua
- Yüksek hızda azalan direksiyon
- Düşük hızda tam kontrol
- Ayarlanabilir azaltma faktörü
- Gerçekçi araç davranışı
```

### Servo Motorlar

```lua
- HingeConstraint tabanlı
- Servo modu ile hassas kontrol
- Tork limitleyici
- Açı sınırlayıcı
```

---

## 🛑 Fren Sistemi (BrakeSystem)

### Fren Türleri

```lua
- Normal fren (pedal)
- El freni (handbrake)
- Acil fren fonksiyonu
- Geri giderken fren
```

### Fren Dağılımı

```lua
- Ön/arka fren oranı (bias)
- El freni sadece arka veya tüm tekerlekler
- Ayarlanabilir fren kuvveti
- Farklı tekerleklere farklı kuvvet
```

### ABS (Anti-lock Braking System)

```lua
- Tekerlek kilitlenmesini önler
- Kayma tespiti
- Pulse sistemi (fren basma-bırakma)
- Ayarlanabilir pulse hızı
- Görsel ve ses feedback (opsiyonel)
```

### Dinamik Fren

```lua
- Hız bazlı fren kuvveti
- Zemin durumuna göre ayarlama
- Tekerlek kayması kontrolü
- Güvenli frenleme mesafesi
```

---

## 🌬️ Aerodinamik Sistemi

### Hava Direnci (Drag)

```lua
- Hız karesiyle artan direnç
- Ayarlanabilir drag katsayısı
- Gerçekçi hız limiti
- Yakıt ekonomisi simulasyonu (opsiyonel)
```

### Downforce (Basınç Kuvveti)

```lua
- Yüksek hızda yere basma kuvveti
- Ön/arka downforce dağılımı
- Ayarlanabilir downforce çarpanı
- Yol tutuşu artırma
- Yarış arabası simülasyonu
```

---

## 🎮 Kontrol Sistemi

### Input Yönetimi

```lua
- Klavye desteği
- Gamepad desteği (opsiyonel)
- Özelleştirilebilir tuş atamaları
- Input smoothing
- Deadzone ayarları
```

### Kontrol Modları

```lua
- Tam kontrol modu
- Yardımcı kontrol (assists)
- Manuel/otomatik vites seçimi
- Cruise control (opsiyonel)
```

---

## 📊 UI ve HUD Sistemi

### Ekran Göstergeleri

```lua
- Hız göstergesi (KM/H, MPH)
- RPM göstergesi
- Vites göstergesi
- Throttle bar
- Fren göstergesi
- El freni uyarısı
```

### Renk Kodlaması

```lua
- RPM uyarı sistemi:
  * Mavi: Normal (< %70)
  * Sarı: Dikkat (%70-90)
  * Kırmızı: Redline (> %90)
- Vites durumu:
  * Yeşil: İleri vitesler
  * Kırmızı: Geri vites
```

### Özelleştirilebilir HUD

```lua
- Pozisyon ayarı
- Boyut ayarı
- Renk şeması
- Gösterim modları
- Gizleme/gösterme seçenekleri
```

---

## 🔍 Debug Sistemi

### Görsel Debug

```lua
- Tekerlek kuvvetleri gösterimi
- Süspansiyon durumu
- Kütle merkezi gösterimi
- Zemin raycast çizgileri
- Vektör yönleri
```

### Konsol Debug

```lua
- RPM loglaması
- Hız loglaması
- Vites durumu
- Tekerlek durumları
- Sistem performansı
```

---

## ⚡ Performans Özellikleri

### Optimize Edilmiş Hesaplamalar

```lua
- Verimli fizik döngüsü
- Gereksiz hesaplamaların önlenmesi
- Akıllı güncelleme sistemi
- Sadece gerekli modüller aktif
```

### Ayarlanabilir Kalite

```lua
- Düşük/Orta/Yüksek preset'ler
- Güncelleme hızı ayarı (30/60 FPS)
- Hassasiyet seviyesi
- Raycast sayısı ayarı
```

### Network Optimizasyonu

```lua
- Server-client senkronizasyonu
- Network ownership yönetimi
- Bandwidth tasarrufu
- Multiplayer uyumlu
```

---

## 🛠️ Özelleştirme Özellikleri

### Konfigürasyon Sistemi

```lua
- Merkezi Config.lua dosyası
- Her parametre özelleştirilebilir
- Preset'ler:
  * Basic Car
  * Performance Car
  * Off-Road Vehicle
  * Racing Car
  * Drift Car
```

### Dinamik Ayarlar

```lua
- Oyun içi parametre değiştirme
- Gerçek zamanlı güncelleme
- Tuning sistemi
- Upgrade sistemi (opsiyonel)
```

---

## 🎨 Gelişmiş Özellikler

### Ses Sistemi (Opsiyonel)

```lua
- Motor sesi (RPM bazlı pitch)
- Tekerlek gıcırtısı
- Fren sesi
- Vites değiştirme sesi
- Ayarlanabilir ses seviyeleri
```

### Partikel Efektleri (Opsiyonel)

```lua
- Egzoz dumanı
- Tekerlek kayma izi
- Fren ısınması
- Drift dumanı
```

### Damage System (Gelecek Özellik)

```lua
- Motor hasarı
- Tekerlek hasarı
- Süspansiyon hasarı
- Görsel deformasyon
```

---

## 📈 Sistem Gereksinimleri

### Minimum

```lua
- Roblox Studio (2020+)
- 4 tekerlek
- 1 chassis part
- Temel fizik ayarları
```

### Önerilen

```lua
- Roblox Studio (En güncel)
- Detaylı araç modeli
- Özelleştirilmiş ayarlar
- Ses ve görsel efektler
```

---

## 🔄 Güncelleme ve Bakım

### Kolay Güncelleme

```lua
- Modüler yapı sayesinde
- Sadece değişen dosyaları güncelleme
- Geriye dönük uyumluluk
- Migration guide'lar
```

### Version Control

```lua
- Git uyumlu
- Semantic versioning
- Changelog
- Release notes
```

---

## 🚀 Gelecek Özellikler (Roadmap)

### v2.0 Planları

```lua
- Nitro boost sistemi
- Turbo lag simülasyonu
- Lastik sıcaklığı ve aşınması
- Yakıt sistemi
- Hasar ve tamir sistemi
- Çoklu araç sınıfları
- AI sürücü desteği
- Yarış modu özellikleri
```

---

## 📖 Dokümantasyon

Her modül kendi içinde detaylı açıklamalar içerir:

- Fonksiyon açıklamaları
- Parametre açıklamaları
- Kullanım örnekleri
- Teknik notlar

---

## 💡 Kullanım Senaryoları

### 1. Yarış Oyunu
- Yüksek performanslı araçlar
- Hassas kontrol
- Gerçekçi fizik

### 2. Açık Dünya Oyunu
- Çeşitli araç tipleri
- Off-road yetenekleri
- Dinamik hava koşulları

### 3. Sürüş Simülatörü
- Gerçekçi araç davranışı
- Detaylı ayarlar
- Profesyonel kontroller

### 4. Arcade Yarış
- Basitleştirilmiş fizik
- Eğlenceli kontroller
- Hızlı oynanış

---

**Bu özellik listesi sürekli güncellenmektedir. Yeni özellikler eklenirken bu dokümantasyon güncellenecektir.**
