# V0.13 — Hayvan Et Üretimi + Balık/Deniz Ürünleri + İleri İşleme

Bu sürümde hayvanlar yalnızca süt/yumurta/yün üretmez. Yetişkinlik, bakım, kalite ve damızlık/etlik ayrımı üzerinden et zincirine bağlanır.

## Ana zincir
Hayvan -> bakım/büyüme -> canlı ürünler veya etlik değerlendirme -> et işleme -> tütsüleme/tuzlama/kurutma/konserve -> yemek -> market.

## Yeni sistemler
- İnek, koyun, keçi, domuz, tavuk, hindi, ördek, kaz, tavşan, deve kuşu için et ürünleri.
- 13+ balık türü, 5 tatlı su türü, 8 deniz ürünü ve nadir balıklar.
- Tütsüleme, tuzlama, kurutma, konserve, fermantasyon, olgunlaştırma.
- Et işleme tesisi, tütsüleme evi, konserve makinesi, kurutma makinesi, tuzlama istasyonu, fermantasyon tankı, olgunlaştırma mahzeni.
- Normal/Süper makine mantığı korunur.
- 5 kalite seviyesi ve kaliteyi etkileyen veri kaynakları.
- Hayvan ırkları ve özel ürünler.
- Otomasyon merkezi 8. seviyeye genişletildi.

## Tasarım ilkesi
Veriler JSON tabanlıdır. Yeni hayvan, balık, ürün, makine veya tarif eklemek için oyun kodunun içine tek tek if/else yazılmamalıdır.
