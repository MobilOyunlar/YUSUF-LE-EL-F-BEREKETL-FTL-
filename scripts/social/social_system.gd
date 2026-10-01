extends Node

# Future V2 social foundation:
# neighbors, farm visits, help actions, product requests and secure chat.

var neighbors := []

func add_neighbor(player_id: String):
    if not neighbors.has(player_id):
        neighbors.append(player_id)
