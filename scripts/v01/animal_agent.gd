extends Node3D

class_name V01AnimalAgent

@export var species := "cow"
@export var wander_radius := 3.0
@export var wander_speed := 0.8
@export var interaction_label := "Hayvanı sev"

var home_position := Vector3.ZERO
var target_position := Vector3.ZERO
var fed := false
var happiness := 100
var idle_time := 0.0

func _ready() -> void:
    home_position = global_position
    target_position = global_position
    add_to_group("interactable")
    set_meta("interaction_label", interaction_label)
    call_deferred("_pick_target")

func interact(world: Node) -> void:
    fed = true
    happiness = mini(happiness + 10, 100)
    if world.has_method("show_toast"):
        world.show_toast("🐾 %s beslendi. Mutluluk: %d" % [species.capitalize(), happiness])
    _pick_target()

func _pick_target() -> void:
    var angle := randf() * TAU
    var radius := randf_range(0.8, wander_radius)
    target_position = home_position + Vector3(cos(angle) * radius, 0.0, sin(angle) * radius)

func _process(delta: float) -> void:
    idle_time += delta
    if global_position.distance_to(target_position) < 0.35 or idle_time > 5.0:
        idle_time = 0.0
        _pick_target()
        return
    var direction := target_position - global_position
    direction.y = 0.0
    if direction.length_squared() > 0.01:
        direction = direction.normalized()
        global_position += direction * wander_speed * delta
        rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), minf(delta * 4.0, 1.0))
