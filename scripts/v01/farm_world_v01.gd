extends Node3D

const PLAYER_SCRIPT = preload("res://scripts/v01/player_controller.gd")
const ANIMAL_SCRIPT = preload("res://scripts/v01/animal_agent.gd")
const SAVE_SCRIPT = preload("res://scripts/v01/farm_save.gd")
const CROP_SCRIPT = preload("res://scripts/farm/crop_system.gd")

const CROP_EMPTY := 0
const CROP_PLANTED := 1
const CROP_GROWING := 2
const CROP_READY := 3

const HOUSE_SCENE = preload("res://Assets/Buildings/house.glb")
const BARN_SCENE = preload("res://Assets/Buildings/barn.glb")
const MILL_SCENE = preload("res://Assets/Buildings/mill.glb")
const OVEN_SCENE = preload("res://Assets/Buildings/oven.glb")
const CHEESE_SCENE = preload("res://Assets/Buildings/cheese_machine.glb")
const HIVE_SCENE = preload("res://Assets/Buildings/hive.glb")
const YUSUF_SCENE = preload("res://Assets/Characters/Yusuf.glb")
const ELIF_SCENE = preload("res://Assets/Characters/Elif.glb")
const COW_SCENE = preload("res://Assets/Animals/Cow.glb")
const SHEEP_SCENE = preload("res://Assets/Animals/Sheep.glb")
const GOAT_SCENE = preload("res://Assets/Animals/Goat.glb")
const HORSE_SCENE = preload("res://Assets/Animals/Horse.glb")
const CHICKEN_SCENE = preload("res://Assets/Animals/Chicken.glb")
const RABBIT_SCENE = preload("res://Assets/Animals/Rabbit.glb")
const DOG_SCENE = preload("res://Assets/Animals/Dog.glb")
const CAT_SCENE = preload("res://Assets/Animals/Cat.glb")
const TREE_SCENE = preload("res://Assets/Environment/tree.glb")
const ROCK_SCENE = preload("res://Assets/Environment/rock.glb")
const FENCE_SCENE = preload("res://Assets/Environment/fence.glb")
const RIVER_SCENE = preload("res://Assets/Environment/river.glb")
const WHEAT_SCENE = preload("res://Assets/Environment/crop_wheat.glb")
const PUMP_SCENE = preload("res://Assets/Infrastructure/water_pump.glb")
const TURBINE_SCENE = preload("res://Assets/Infrastructure/wind_turbine.glb")

var player: CharacterBody3D
var camera: Camera3D
var crop_system
var save_system: Node
var crop_visuals: Dictionary = {}
var interactables: Array[Node3D] = []
var current_target: Node3D
var virtual_move := Vector2.ZERO
var interact_requested := false
var auto_save_timer := 0.0
var toast_timer := 0.0

var status_label: Label
var objective_label: Label
var coins_label: Label
var prompt_label: Label
var toast_label: Label
var dpad_buttons: Dictionary = {}

func _ready() -> void:
    randomize()
    _setup_world()
    _setup_systems()
    _setup_ui()
    _load_saved_state()
    show_toast("🌾 Çiftliğe hoş geldin. WASD / ekran kontrolleri ile hareket et.")

func _setup_systems() -> void:
    crop_system = CROP_SCRIPT.new()
    add_child(crop_system)
    save_system = SAVE_SCRIPT.new()
    add_child(save_system)
    for index in range(1, 7):
        crop_system.create_field("field_%02d" % index)

func _setup_world() -> void:
    _create_environment()
    _create_ground()
    _create_paths()
    _create_buildings()
    _create_farm_plots()
    _create_animals()
    _create_environment_assets()
    _create_player()

func _create_environment() -> void:
    var world_env := WorldEnvironment.new()
    world_env.name = "WorldEnvironment"
    var environment := Environment.new()
    environment.background_mode = Environment.BG_SKY
    var sky := Sky.new()
    var sky_material := ProceduralSkyMaterial.new()
    sky_material.sky_top_color = Color("#58a6e6")
    sky_material.sky_horizon_color = Color("#cce6f8")
    sky_material.ground_bottom_color = Color("#6b7f57")
    sky_material.ground_horizon_color = Color("#b8cdb3")
    sky.sky_material = sky_material
    environment.sky = sky
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
    environment.ambient_light_energy = 0.85
    environment.tonemap_mode = Environment.TONE_MAPPER_FILMIC
    world_env.environment = environment
    add_child(world_env)

    var sun := DirectionalLight3D.new()
    sun.name = "Sun"
    sun.rotation_degrees = Vector3(-50.0, -35.0, 0.0)
    sun.light_energy = 1.15
    sun.shadow_enabled = true
    add_child(sun)

func _material(color: Color, roughness := 1.0, metallic := 0.0) -> StandardMaterial3D:
    var material := StandardMaterial3D.new()
    material.albedo_color = color
    material.roughness = roughness
    material.metallic = metallic
    return material

func _mesh_box(size: Vector3, color: Color, position: Vector3, name: String) -> MeshInstance3D:
    var mesh_instance := MeshInstance3D.new()
    mesh_instance.name = name
    var box := BoxMesh.new()
    box.size = size
    box.material = _material(color)
    mesh_instance.mesh = box
    mesh_instance.position = position
    add_child(mesh_instance)
    return mesh_instance

func _create_ground() -> void:
    _mesh_box(Vector3(56.0, 0.6, 56.0), Color("#78a85a"), Vector3(0.0, -0.3, 0.0), "GrassGround")
    var ground_body := StaticBody3D.new()
    ground_body.name = "GroundCollision"
    ground_body.position = Vector3(0.0, -0.3, 0.0)
    add_child(ground_body)
    _add_box_collision(ground_body, Vector3(56.0, 0.6, 56.0))
    _mesh_box(Vector3(28.0, 0.10, 20.0), Color("#9a6a45"), Vector3(-2.5, 0.01, 3.5), "FarmSoilArea")
    _mesh_box(Vector3(16.0, 0.08, 3.4), Color("#c8ad7c"), Vector3(0.0, 0.05, -6.0), "MainPath")
    _mesh_box(Vector3(3.4, 0.08, 22.0), Color("#c8ad7c"), Vector3(-11.0, 0.05, 5.0), "SidePath")

func _create_paths() -> void:
    var water := RIVER_SCENE.instantiate()
    water.position = Vector3(0.0, 0.02, 20.0)
    water.scale = Vector3(7.0, 1.0, 1.4)
    add_child(water)

    var bridge := _mesh_box(Vector3(6.0, 0.5, 2.8), Color("#8f633d"), Vector3(0.0, 0.28, 19.5), "Bridge")
    var bridge_collision := StaticBody3D.new()
    bridge_collision.position = bridge.position + Vector3(0.0, 0.2, 0.0)
    add_child(bridge_collision)
    _add_box_collision(bridge_collision, Vector3(6.0, 0.5, 2.8))

func _create_buildings() -> void:
    _add_building(HOUSE_SCENE, "Evim", Vector3(-9.0, 0.0, -3.5), Vector3(2.0, 2.0, 2.0), "🏡 Eve gir", Vector3(5.2, 3.2, 4.8))
    _add_building(BARN_SCENE, "Ahır", Vector3(8.0, 0.0, -4.0), Vector3(2.0, 2.0, 2.0), "🐄 Ahırı kontrol et", Vector3(5.2, 3.2, 4.8))
    _add_building(MILL_SCENE, "Değirmen", Vector3(8.5, 0.0, 5.0), Vector3(1.8, 1.8, 1.8), "⚙️ Değirmeni incele", Vector3(3.6, 3.2, 3.6))
    _add_building(OVEN_SCENE, "Fırın", Vector3(2.5, 0.0, 9.0), Vector3(1.5, 1.5, 1.5), "🔥 Fırını kullan", Vector3(2.6, 2.4, 2.6))
    _add_building(CHEESE_SCENE, "Peynir", Vector3(6.0, 0.0, 9.0), Vector3(1.5, 1.5, 1.5), "🧀 Peynir makinesini incele", Vector3(2.4, 2.0, 2.4))
    _add_building(HIVE_SCENE, "Arı Kovanı", Vector3(-9.0, 0.0, 9.5), Vector3(1.8, 1.8, 1.8), "🍯 Kovanı kontrol et", Vector3(2.5, 2.4, 2.5))
    _add_building(PUMP_SCENE, "Su Pompası", Vector3(-14.0, 0.0, 6.0), Vector3(1.7, 1.7, 1.7), "💧 Su pompasını kullan", Vector3(2.0, 3.0, 2.0))
    _add_building(TURBINE_SCENE, "Rüzgâr Türbini", Vector3(-14.0, 0.0, -2.0), Vector3(2.0, 2.0, 2.0), "🌬️ Türbini incele", Vector3(2.2, 6.0, 2.2))

func _add_building(scene: PackedScene, label: String, position: Vector3, scale: Vector3, interaction_label: String, collision_size: Vector3) -> void:
    var node := scene.instantiate()
    node.name = label
    node.position = position
    node.scale = scale
    node.add_to_group("interactable")
    node.set_meta("interaction_label", interaction_label)
    node.set_meta("interaction_kind", "building")
    add_child(node)
    interactables.append(node)

    var body := StaticBody3D.new()
    body.name = label + "Collision"
    body.position = position + Vector3(0.0, collision_size.y * 0.5, 0.0)
    add_child(body)
    _add_box_collision(body, collision_size)

func _create_farm_plots() -> void:
    var positions := [
        Vector3(-8.0, 0.12, 4.0), Vector3(-4.5, 0.12, 4.0), Vector3(-1.0, 0.12, 4.0),
        Vector3(-8.0, 0.12, 8.0), Vector3(-4.5, 0.12, 8.0), Vector3(-1.0, 0.12, 8.0)
    ]
    for i in positions.size():
        _create_plot(i + 1, positions[i])

func _create_plot(index: int, position: Vector3) -> void:
    var plot := Node3D.new()
    plot.name = "Field_%02d" % index
    plot.position = position
    plot.add_to_group("interactable")
    plot.set_meta("interaction_label", "🌱 Tarlayı hazırla")
    plot.set_meta("interaction_kind", "crop")
    plot.set_meta("field_id", "field_%02d" % index)
    add_child(plot)
    interactables.append(plot)

    var soil := MeshInstance3D.new()
    var plane := BoxMesh.new()
    plane.size = Vector3(2.8, 0.12, 2.5)
    plane.material = _material(Color("#6f452e"))
    soil.mesh = plane
    soil.position.y = -0.12
    plot.add_child(soil)

    var wheat := WHEAT_SCENE.instantiate()
    wheat.name = "Wheat"
    wheat.position = Vector3.ZERO
    wheat.scale = Vector3.ZERO
    plot.add_child(wheat)
    crop_visuals["field_%02d" % index] = wheat

func _create_animals() -> void:
    var companion := ELIF_SCENE.instantiate()
    companion.name = "ElifCompanion"
    companion.position = Vector3(-6.5, 0.0, -2.0)
    companion.scale = Vector3.ONE * 1.15
    companion.add_to_group("interactable")
    companion.set_meta("interaction_label", "👩 Elif ile konuş")
    add_child(companion)
    interactables.append(companion)

    _add_animal(COW_SCENE, "inek", "İneği besle", Vector3(7.0, 0.2, 0.5), 1.0)
    _add_animal(SHEEP_SCENE, "koyun", "Koyunu besle", Vector3(10.0, 0.2, 2.5), 0.95)
    _add_animal(GOAT_SCENE, "keçi", "Keçiyi besle", Vector3(10.5, 0.2, 0.0), 0.95)
    _add_animal(HORSE_SCENE, "at", "Atı besle", Vector3(5.5, 0.2, 4.0), 1.0)
    _add_animal(CHICKEN_SCENE, "tavuk", "Tavuğu besle", Vector3(9.0, 0.15, 5.5), 0.85)
    _add_animal(RABBIT_SCENE, "tavşan", "Tavşanı sev", Vector3(-2.0, 0.15, 11.0), 0.75)
    _add_animal(DOG_SCENE, "köpek", "Köpeği sev", Vector3(-7.0, 0.15, -1.0), 0.9)
    _add_animal(CAT_SCENE, "kedi", "Kediyi sev", Vector3(-5.0, 0.15, -0.5), 0.75)

func _add_animal(scene: PackedScene, species: String, label: String, position: Vector3, scale_factor: float) -> void:
    var animal := scene.instantiate()
    animal.position = position
    animal.scale = Vector3.ONE * scale_factor
    animal.set_script(ANIMAL_SCRIPT)
    animal.species = species
    animal.interaction_label = label
    add_child(animal)
    interactables.append(animal)

func _create_environment_assets() -> void:
    var tree_positions := [
        Vector3(-21, 0.0, -17), Vector3(-16, 0.0, -19), Vector3(-11, 0.0, -18), Vector3(12, 0.0, -18),
        Vector3(18, 0.0, -15), Vector3(21, 0.0, -9), Vector3(21, 0.0, 9), Vector3(18, 0.0, 14),
        Vector3(-20, 0.0, 14), Vector3(-22, 0.0, 8), Vector3(-20, 0.0, 0), Vector3(14, 0.0, 17)
    ]
    for i in tree_positions.size():
        var tree := TREE_SCENE.instantiate()
        tree.position = tree_positions[i]
        var scale_value := 1.4 + float(i % 3) * 0.18
        tree.scale = Vector3.ONE * scale_value
        add_child(tree)

    var rocks := [Vector3(-17, 0.0, 6), Vector3(17, 0.0, 6), Vector3(13, 0.0, -11), Vector3(-13, 0.0, -12)]
    for p in rocks:
        var rock := ROCK_SCENE.instantiate()
        rock.position = p
        rock.scale = Vector3.ONE * 1.4
        add_child(rock)

    _add_fence_segment(Vector3(-13.0, 0.0, -15.0), Vector3(7.0, 1.0, 1.0))
    _add_fence_segment(Vector3(13.0, 0.0, -15.0), Vector3(7.0, 1.0, 1.0))
    _add_fence_segment(Vector3(-14.5, 0.0, 15.0), Vector3(4.5, 1.0, 1.0))
    _add_fence_segment(Vector3(14.5, 0.0, 15.0), Vector3(4.5, 1.0, 1.0))

func _add_fence_segment(position: Vector3, scale_value: Vector3) -> void:
    var fence := FENCE_SCENE.instantiate()
    fence.position = position
    fence.scale = scale_value
    add_child(fence)

func _create_player() -> void:
    player = PLAYER_SCRIPT.new()
    player.name = "YusufPlayer"
    player.position = Vector3(-3.0, 0.6, -5.0)
    player.move_speed = 4.2
    add_child(player)

    var collision := CollisionShape3D.new()
    var capsule := CapsuleShape3D.new()
    capsule.radius = 0.35
    capsule.height = 1.6
    collision.shape = capsule
    collision.position.y = 0.8
    player.add_child(collision)

    var model := YUSUF_SCENE.instantiate()
    model.name = "YusufModel"
    model.scale = Vector3.ONE * 1.2
    player.add_child(model)

    camera = Camera3D.new()
    camera.name = "Camera3D"
    camera.fov = 58.0
    player.add_child(camera)

func _add_box_collision(parent: Node3D, size: Vector3) -> void:
    var shape := CollisionShape3D.new()
    var box := BoxShape3D.new()
    box.size = size
    shape.shape = box
    parent.add_child(shape)

func _setup_ui() -> void:
    var layer := CanvasLayer.new()
    layer.name = "HUD"
    add_child(layer)

    var top := ColorRect.new()
    top.color = Color(0.06, 0.12, 0.08, 0.82)
    top.position = Vector2(18, 18)
    top.size = Vector2(580, 116)
    layer.add_child(top)

    var title := Label.new()
    title.text = "YUSUF İLE ELİF  •  BEREKETLİ ÇİFTLİK"
    title.position = Vector2(18, 12)
    title.add_theme_font_size_override("font_size", 23)
    top.add_child(title)

    coins_label = Label.new()
    coins_label.position = Vector2(18, 47)
    coins_label.add_theme_font_size_override("font_size", 18)
    top.add_child(coins_label)

    status_label = Label.new()
    status_label.position = Vector2(18, 77)
    status_label.add_theme_font_size_override("font_size", 15)
    top.add_child(status_label)

    objective_label = Label.new()
    objective_label.text = "🎯 İlk hedef: bir tarlaya yaklaş ve ETKİLEŞ."
    objective_label.position = Vector2(24, 150)
    objective_label.add_theme_font_size_override("font_size", 17)
    layer.add_child(objective_label)

    prompt_label = Label.new()
    prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    prompt_label.position = Vector2(330, 640)
    prompt_label.size = Vector2(620, 42)
    prompt_label.add_theme_font_size_override("font_size", 20)
    layer.add_child(prompt_label)

    toast_label = Label.new()
    toast_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
    toast_label.position = Vector2(280, 560)
    toast_label.size = Vector2(720, 54)
    toast_label.add_theme_font_size_override("font_size", 20)
    toast_label.add_theme_color_override("font_color", Color("#fff3cf"))
    layer.add_child(toast_label)

    _create_mobile_controls(layer)
    _refresh_hud()

func _create_mobile_controls(layer: CanvasLayer) -> void:
    var positions := {
        "up": Vector2(88, 520),
        "left": Vector2(20, 578),
        "right": Vector2(156, 578),
        "down": Vector2(88, 636)
    }
    for direction in positions:
        var button := Button.new()
        button.text = {"up": "▲", "left": "◀", "right": "▶", "down": "▼"}[direction]
        button.position = positions[direction]
        button.size = Vector2(64, 56)
        button.modulate = Color(1, 1, 1, 0.78)
        button.add_theme_font_size_override("font_size", 26)
        button.button_down.connect(func(): _set_dpad(direction, true))
        button.button_up.connect(func(): _set_dpad(direction, false))
        layer.add_child(button)
        dpad_buttons[direction] = button

    var interact := Button.new()
    interact.text = "ETKİLEŞ\nE"
    interact.position = Vector2(1060, 540)
    interact.size = Vector2(170, 120)
    interact.modulate = Color(0.95, 0.85, 0.52, 0.90)
    interact.add_theme_font_size_override("font_size", 24)
    interact.pressed.connect(func(): interact_requested = true)
    layer.add_child(interact)

func _set_dpad(direction: String, pressed: bool) -> void:
    var x := 0.0
    var y := 0.0
    match direction:
        "left": x = -1.0
        "right": x = 1.0
        "up": y = -1.0
        "down": y = 1.0
    var contribution := Vector2(x, y) if pressed else Vector2(-x, -y)
    virtual_move += contribution
    virtual_move = virtual_move.limit_length(1.0)
    if is_instance_valid(player):
        player.set_virtual_move(virtual_move)

func _process(delta: float) -> void:
    if not is_instance_valid(player):
        return
    auto_save_timer += delta
    toast_timer = maxf(toast_timer - delta, 0.0)
    if auto_save_timer >= 15.0:
        auto_save_timer = 0.0
        _save_game()
    _grow_crops(delta)
    _update_interaction_target()
    if interact_requested or Input.is_key_pressed(KEY_E) or Input.is_key_pressed(KEY_SPACE):
        interact_requested = false
        _interact_current()
    _refresh_hud()

func _grow_crops(delta: float) -> void:
    for i in range(1, 7):
        var field_id := "field_%02d" % i
        var before := int(crop_system.fields[field_id]["state"])
        if before != CROP_EMPTY:
            crop_system.grow(field_id, delta / 28.0)
        var after := int(crop_system.fields[field_id]["state"])
        var wheat: Node3D = crop_visuals[field_id]
        if after == CROP_EMPTY:
            wheat.scale = Vector3.ZERO
        elif after == CROP_READY:
            wheat.scale = Vector3.ONE * 0.85
        else:
            var growth: float = float(crop_system.fields[field_id]["growth"])
            wheat.scale = Vector3.ONE * maxf(0.22, 0.35 + growth * 0.35)

func _update_interaction_target() -> void:
    current_target = null
    var best_distance := 3.0
    for candidate in interactables:
        if not is_instance_valid(candidate):
            continue
        var distance := player.global_position.distance_to(candidate.global_position)
        if distance < best_distance:
            best_distance = distance
            current_target = candidate
    if current_target != null:
        prompt_label.text = "[%s]" % str(current_target.get_meta("interaction_label", "ETKİLEŞ"))
    else:
        prompt_label.text = "WASD / ekran tuşları  •  E / ETKİLEŞ"

func _interact_current() -> void:
    if current_target == null:
        show_toast("Bir nesneye, hayvana veya tarlaya biraz daha yaklaş.")
        return
    var kind := str(current_target.get_meta("interaction_kind", ""))
    if kind == "crop":
        _interact_crop(current_target)
        return
    if current_target.has_method("interact"):
        current_target.interact(self)
        _save_game()
        return
    var label := str(current_target.get_meta("interaction_label", "Etkileşim"))
    show_toast(label + " • temel etkileşim hazır.")
    _save_game()

func _interact_crop(plot: Node3D) -> void:
    var field_id := str(plot.get_meta("field_id"))
    var state := int(crop_system.fields[field_id]["state"])
    match state:
        CROP_EMPTY:
            if crop_system.plant(field_id, "wheat"):
                plot.set_meta("interaction_label", "💧 Tarlayı sula")
                objective_label.text = "🎯 Buğday ekildi. Sulayıp büyümesini bekle."
                show_toast("🌱 Buğday ekildi.")
        CROP_PLANTED, CROP_GROWING:
            crop_system.grow(field_id, 0.12)
            plot.set_meta("interaction_label", "💧 Tarlayı sula")
            show_toast("💧 Sulandı. Büyüme hızlandı.")
        CROP_READY:
            var crop_id: String = str(crop_system.harvest(field_id))
            if crop_id != "":
                plot.set_meta("interaction_label", "🌱 Tarlayı hazırla")
                Economy.add_coins(25)
                show_toast("🌾 Buğday hasat edildi! +25 para")
                objective_label.text = "🎯 Harika! Şimdi hayvanlardan birine yaklaş."
    _save_game()

func _refresh_hud() -> void:
    if not is_instance_valid(coins_label):
        return
    coins_label.text = "💰 %d   💎 50" % int(Economy.coins)
    status_label.text = "📍 %s" % ("Çiftlikte dolaşıyorsun" if current_target == null else str(current_target.name))
    if toast_timer <= 0.0:
        toast_label.text = ""

func show_toast(message: String) -> void:
    toast_label.text = message
    toast_timer = 3.2

func _save_game() -> void:
    var language := "tr"
    var ok: bool = save_system.save_game(player, crop_system.fields, int(Economy.coins), language)
    if not ok:
        show_toast("⚠️ Kayıt yapılamadı.")

func _load_saved_state() -> void:
    var state: Dictionary = save_system.load_game()
    if state.is_empty():
        Economy.coins = 1000
        return
    var p = state.get("player", {})
    if p is Dictionary:
        player.force_set_position(Vector3(float(p.get("x", -3.0)), float(p.get("y", 0.6)), float(p.get("z", -5.0))))
    Economy.coins = int(state.get("coins", 1000))
    var saved_crops = state.get("crops", {})
    if saved_crops is Dictionary:
        for field_id in saved_crops.keys():
            if crop_system.fields.has(field_id) and saved_crops[field_id] is Dictionary:
                crop_system.fields[field_id] = saved_crops[field_id].duplicate(true)
    _refresh_crop_labels()

func _refresh_crop_labels() -> void:
    for i in range(1, 7):
        var field_id := "field_%02d" % i
        var plot := get_node_or_null("Field_%02d" % i)
        if plot == null:
            continue
        var state := int(crop_system.fields[field_id]["state"])
        if state == CROP_READY:
            plot.set_meta("interaction_label", "🌾 Buğdayı hasat et")
        elif state == CROP_EMPTY:
            plot.set_meta("interaction_label", "🌱 Ekim yap")
        else:
            plot.set_meta("interaction_label", "💧 Tarlayı sula")
