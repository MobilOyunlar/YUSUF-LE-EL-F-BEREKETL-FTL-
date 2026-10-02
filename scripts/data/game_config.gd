extends Node

# YUSUF İLE ELİF: BEREKETLİ ÇİFTLİĞİ
# Merkezi oyun yapılandırması.
# Fiyatlar ve oyun ekonomisi veri odaklı tutulur.

const GAME_NAME := "Yusuf ile Elif: Bereketli Çiftliği"
const STUDIO_NAME := "LUMORIX Gamer Studio"
const GAME_VERSION := "1.0.0"

const DIAMOND_PACKAGES := [
	{"id": "diamonds_500", "diamonds": 500, "price_try": 250.0},
	{"id": "diamonds_1500", "diamonds": 1500, "price_try": 1200.0},
	{"id": "diamonds_2000", "diamonds": 2000, "price_try": 1600.0},
	{"id": "diamonds_4000", "diamonds": 4000, "price_try": 3100.0},
	{"id": "diamonds_8000", "diamonds": 8000, "price_try": 4000.0},
	{"id": "diamonds_16000", "diamonds": 16000, "price_try": 7100.0},
	{"id": "diamonds_30000", "diamonds": 30000, "price_try": 12500.0},
	{"id": "diamonds_50000", "diamonds": 50000, "price_try": 19999.0},
	{"id": "diamonds_70000", "diamonds": 70000, "price_try": 27999.0}
]

const COIN_PACKAGES := [
	{"id": "coins_1500", "coins": 1500, "price_try": 400.0},
	{"id": "coins_2500", "coins": 2500, "price_try": 700.0},
	{"id": "coins_4000", "coins": 4000, "price_try": 1500.0},
	{"id": "coins_8000", "coins": 8000, "price_try": 3100.0},
	{"id": "coins_16000", "coins": 16000, "price_try": 6000.0},
	{"id": "coins_30000", "coins": 30000, "price_try": 10000.0},
	{"id": "coins_50000", "coins": 50000, "price_try": 17000.0}
]

# İlk sürüm arazi sınırı.
# Sistem ileride 60x60'ın üzerine çıkabilecek şekilde tasarlanır.
const FARM_START_SIZE := 12
const FARM_MAX_SIZE_V1 := 60

# Arazi genişleme örnek kademeleri.
const FARM_EXPANSIONS := [
	{"size": 12, "diamonds": 0},
	{"size": 14, "diamonds": 500},
	{"size": 16, "diamonds": 750},
	{"size": 18, "diamonds": 1050},
	{"size": 20, "diamonds": 1400},
	{"size": 22, "diamonds": 1800},
	{"size": 24, "diamonds": 2300},
	{"size": 28, "diamonds": 3000},
	{"size": 32, "diamonds": 4000},
	{"size": 36, "diamonds": 5200},
	{"size": 40, "diamonds": 6800},
	{"size": 44, "diamonds": 8500},
	{"size": 48, "diamonds": 10500},
	{"size": 54, "diamonds": 13500},
	{"size": 60, "diamonds": 17000}
]

# Kampanya sistemi için temel dönem.
const LAND_EXPANSION_RESOURCE_COSTS := [
	{"size": 14, "wood": 80, "stone": 60, "iron": 20},
	{"size": 16, "wood": 120, "stone": 90, "iron": 30},
	{"size": 18, "wood": 170, "stone": 130, "iron": 45},
	{"size": 20, "wood": 230, "stone": 180, "iron": 60},
	{"size": 22, "wood": 300, "stone": 240, "iron": 80},
	{"size": 24, "wood": 380, "stone": 310, "iron": 105},
	{"size": 28, "wood": 500, "stone": 420, "iron": 140},
	{"size": 32, "wood": 650, "stone": 550, "iron": 185},
	{"size": 36, "wood": 820, "stone": 700, "iron": 240},
	{"size": 40, "wood": 1020, "stone": 880, "iron": 300},
	{"size": 44, "wood": 1250, "stone": 1080, "iron": 370},
	{"size": 48, "wood": 1500, "stone": 1300, "iron": 450},
	{"size": 54, "wood": 1850, "stone": 1600, "iron": 550},
	{"size": 60, "wood": 2250, "stone": 1950, "iron": 680}
]

const PROMOTION_PERIOD_DAYS := 15
