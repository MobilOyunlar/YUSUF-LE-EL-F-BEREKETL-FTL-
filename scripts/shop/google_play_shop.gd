extends Node

# Google Play Billing integration placeholder.
# Product IDs are stable; prices are NOT hard-coded in the game.
# Google Play presents localized prices for the user's market.

var product_ids := [
    "diamond_500",
    "diamond_1500",
    "diamond_2500",
    "diamond_4000",
    "diamond_8000",
    "diamond_16000",
    "diamond_20000",
    "diamond_30000",
    "diamond_50000"
]

func purchase(product_id: String):
    # Native Google Play Billing integration will be connected here.
    print("Purchase requested: ", product_id)
