extends Node

var pump_fixed := true
var creek_available := true
var wind_turbines := 0
var electricity := 0.0

func add_wind_turbine():
    wind_turbines += 1

func tick_energy(seconds: float):
    electricity += wind_turbines * seconds * 0.1

func can_irrigate() -> bool:
    return creek_available and pump_fixed
