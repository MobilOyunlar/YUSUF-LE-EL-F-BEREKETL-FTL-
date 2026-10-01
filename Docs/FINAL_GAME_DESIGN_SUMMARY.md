# YUSUF İLE ELİF: BEREKETLİ ÇİFTLİĞİ
## FINAL PROJECT CANDIDATE v1.0

Bu paket, V0.1–V0.45 boyunca oluşturulan sistemlerin üzerine son kullanıcı akışını ekleyen toplu proje paketidir.

## Temel oyuncu akışı
Hikâye → Öğretici görev → XP → Level → Yeni içerik → Üretim → Satış → Çiftliği büyütme → Yeni hikâye.

## Açılış
Yusuf ve Elif şehir hayatından sıkılır ve dedelerinden kalan eski çiftliğe geri döner. Oyuncu ilk dakikalarda küçük ve anlaşılır görevlerle sistemi öğrenir.

## Kademeli açılış
İçerikler normalde oyuncu seviyesi + hikâye/görev ilerlemesiyle açılır:
- Level 4: Tavuk
- Level 5: İnek
- Level 6: Değirmen
- Level 8: Koyun
- Level 10: Fırın
- Level 15: Peynir makinesi
- Level 18: Arı kovanı
- Level 20: Traktör
- Level 25: Balıkçılık
- Level 30: Maden
- Level 35: Orman bölgesi
- Level 40: Kasaba
- Level 50: Ada

Değerler veri dosyasından değiştirilebilir ve nihai ekonomi testlerinde dengelenmelidir.

## Elmasla erken açma
Oyuncu normal level şartını beklemek istemezse mağazadaki kilitli içeriği elmasla erken açabilir. Elmasla açma, temel kontrol öğreticilerini atlamaz; sadece içerik erişim şartını erkenden karşılar.

## Korunan ana sistemler
Arazi 12×12'den başlayıp ileride 60×60 ve üstüne çıkabilecek şekilde genişler; ekin/bozulma, hayvanlar ve cinsler, üretim zincirleri, normal/Süper makineler, depo/market/sipariş, traktör/otomasyon, balıkçılık, maden, orman, köy-kasaba-bölge, ulaşım, keşif, mevsim/hava, Yusuf-Elif evleri ve kıyafetleri, dekorasyon, sosyal sistem, bulut kayıt, Google Play Billing, performans/güvenlik altyapısı korunur.

## Sonraki gerçek dünya adımları
Bu ZIP'i “mağazaya yüklenmeye hazır ve gerçek cihazda tamamen doğrulanmış oyun” olarak değerlendirmemek gerekir. Final aşamasında gerçek Android/iOS cihazlarında build, performans, kayıt, ağ, satın alma ve uzun süreli oynama testleri yapılmalıdır. Google Play/App Store yapılandırmaları, imzalama anahtarları ve üretim backend bilgileri ayrıca bağlanmalıdır.
