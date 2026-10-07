extends CharacterBody3D

class_name V01PlayerController

@export var move_speed := 4.2
@export var acceleration := 18.0
@export var camera_height := 6.8
@export var camera_distance := 8.5

var external_move := Vector2.ZERO
var can_move := true

@onready var camera: Camera3D = $Camera3D

func _ready() -> void:
    add_to_group("player")
    camera.current = true

func set_virtual_move(value: Vector2) -> void:
    external_move = value

func _physics_process(delta: float) -> void:
    if not can_move:
        velocity.x = move_toward(velocity.x, 0.0, acceleration * delta)
        velocity.z = move_toward(velocity.z, 0.0, acceleration * delta)
        move_and_slide()
        _update_camera()
        return

    var keyboard := Vector2.ZERO
    if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
        keyboard.x -= 1.0
    if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
        keyboard.x += 1.0
    if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
        keyboard.y -= 1.0
    if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
        keyboard.y += 1.0

    var input_vec := keyboard
    if external_move.length_squared() > input_vec.length_squared():
        input_vec = external_move
    input_vec = input_vec.limit_length(1.0)

    var desired := Vector3(input_vec.x, 0.0, input_vec.y) * move_speed
    velocity.x = move_toward(velocity.x, desired.x, acceleration * delta)
    velocity.z = move_toward(velocity.z, desired.z, acceleration * delta)

    if not is_on_floor():
        velocity.y -= 18.0 * delta
    else:
        velocity.y = 0.0

    if desired.length_squared() > 0.05:
        var target_angle := atan2(desired.x, desired.z)
        rotation.y = lerp_angle(rotation.y, target_angle, minf(delta * 10.0, 1.0))

    move_and_slide()
    _clamp_to_farm()
    _update_camera()

func _clamp_to_farm() -> void:
    global_position.x = clampf(global_position.x, -26.0, 26.0)
    global_position.z = clampf(global_position.z, -26.0, 26.0)

func _update_camera() -> void:
    var offset := Vector3(0.0, camera_height, camera_distance)
    camera.global_position = global_position + offset
    camera.look_at(global_position + Vector3(0.0, 1.1, 0.0), Vector3.UP)

func force_set_position(value: Vector3) -> void:
    global_position = value
    velocity = Vector3.ZERO
    _update_camera()
