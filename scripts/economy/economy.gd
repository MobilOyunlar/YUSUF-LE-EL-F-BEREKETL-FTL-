extends Node

var coins := 1000
var diamonds := 50

func add_coins(amount: int):
    coins += amount

func spend_coins(amount: int) -> bool:
    if coins < amount:
        return false
    coins -= amount
    return true

func add_diamonds(amount: int):
    diamonds += amount

func spend_diamonds(amount: int) -> bool:
    if diamonds < amount:
        return false
    diamonds -= amount
    return true
