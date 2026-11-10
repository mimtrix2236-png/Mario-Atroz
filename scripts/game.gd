extends Node2D

const WORLD_WIDTH := 4200.0
const FLOOR_Y := 455.0
const GRAVITY := 1450.0
const RUN_SPEED := 310.0
const JUMP_SPEED := -590.0

var player: CharacterBody2D
var camera: Camera2D
var hud: Label
var score := 0
var lives := 3
var game_over := false
var won := false
var enemies: Array[Node2D] = []
var pickups: Array[Area2D] = []
var platforms: Array[Rect2] = []
var touch_left := false
var touch_right := false
var touch_jump := false
var jump_was_down := false

func _ready() -> void:
	_build_level()
	_build_player()
	_build_ui()
	queue_redraw()

func _build_level() -> void:
	platforms = [
		Rect2(0, FLOOR_Y, 850, 200), Rect2(960, FLOOR_Y, 660, 200),
		Rect2(1710, FLOOR_Y, 730, 200), Rect2(2530, FLOOR_Y, 690, 200),
		Rect2(3300, FLOOR_Y, 900, 200),
		Rect2(430, 350, 170, 22), Rect2(1120, 345, 190, 22),
		Rect2(1430, 285, 150, 22), Rect2(1900, 350, 180, 22),
		Rect2(2250, 300, 160, 22), Rect2(2700, 350, 190, 22),
		Rect2(3000, 285, 170, 22), Rect2(3550, 350, 210, 22)
	]
	for r in platforms:
		var body := StaticBody2D.new()
		body.position = r.position + r.size / 2.0
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = r.size
		shape.shape = rect
		body.add_child(shape)
		add_child(body)

	for x in [620.0, 1240.0, 1990.0, 2810.0, 3650.0]:
		_spawn_enemy(x)
	for x in [250.0, 330.0, 470.0, 520.0, 1160.0, 1210.0, 1480.0, 1940.0, 2300.0, 2760.0, 3050.0, 3600.0]:
		_spawn_pickup(Vector2(x, 310 if x in [470.0, 520.0, 1480.0, 2300.0, 3050.0] else 405), false)
	for x in [800.0, 1570.0, 2400.0, 3170.0]:
		_spawn_pickup(Vector2(x, 400), true)

func _build_player() -> void:
	player = CharacterBody2D.new()
	player.position = Vector2(80, FLOOR_Y - 45)
	var collision := CollisionShape2D.new()
	var shape := RectangleShape2D.new()
	shape.size = Vector2(30, 46)
	collision.shape = shape
	player.add_child(collision)
	add_child(player)
	camera = Camera2D.new()
	camera.position_smoothing_enabled = true
	camera.position_smoothing_speed = 5.0
	camera.limit_left = 0
	camera.limit_right = int(WORLD_WIDTH)
	camera.limit_top = 0
	camera.limit_bottom = 540
	player.add_child(camera)
	camera.make_current()

func _build_ui() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	hud = Label.new()
	hud.position = Vector2(18, 14)
	hud.add_theme_font_size_override("font_size", 24)
	hud.add_theme_color_override("font_color", Color.WHITE)
	layer.add_child(hud)
	var hint := Label.new()
	hint.text = "ZOMBIE WORLD  •  A/D o ◀ ▶ para moverte  •  ESPACIO para saltar"
	hint.position = Vector2(18, 48)
	hint.add_theme_font_size_override("font_size", 14)
	hint.add_theme_color_override("font_color", Color(0.8, 0.9, 0.8))
	layer.add_child(hint)
	_add_touch_button(layer, "◀", Vector2(24, 405), "left")
	_add_touch_button(layer, "▶", Vector2(112, 405), "right")
	_add_touch_button(layer, "SALTAR", Vector2(790, 405), "jump")
	_update_hud()

func _add_touch_button(layer: CanvasLayer, caption: String, pos: Vector2, action: String) -> void:
	var b := Button.new()
	b.text = caption
	b.position = pos
	b.size = Vector2(78 if action != "jump" else 140, 76)
	b.add_theme_font_size_override("font_size", 22)
	b.modulate = Color(0.75, 1.0, 0.75, 0.82)
	layer.add_child(b)
	b.button_down.connect(func(): _set_touch(action, true))
	b.button_up.connect(func(): _set_touch(action, false))
	b.mouse_exited.connect(func(): _set_touch(action, false))

func _set_touch(action: String, pressed: bool) -> void:
	if action == "left": touch_left = pressed
	elif action == "right": touch_right = pressed
	elif action == "jump": touch_jump = pressed

func _spawn_enemy(x: float) -> void:
	var e := Node2D.new()
	e.set_meta("origin", x)
	e.set_meta("direction", -1.0 if int(x) % 2 == 0 else 1.0)
	e.set_meta("alive", true)
	e.position = Vector2(x, FLOOR_Y - 24)
	add_child(e)
	enemies.append(e)

func _spawn_pickup(pos: Vector2, vial: bool) -> void:
	var a := Area2D.new()
	a.position = pos
	a.set_meta("vial", vial)
	var c := CollisionShape2D.new()
	var s := CircleShape2D.new()
	s.radius = 17
	c.shape = s
	a.add_child(c)
	a.body_entered.connect(func(body): 
		if body == player and a in pickups:
			score += 5 if vial else 1
			pickups.erase(a)
			a.queue_free()
			_update_hud()
	)
	add_child(a)
	pickups.append(a)

func _physics_process(delta: float) -> void:
	if game_over or won:
		if Input.is_action_just_pressed("ui_accept"):
			get_tree().reload_current_scene()
		return
	var axis := Input.get_axis("ui_left", "ui_right")
	if touch_left: axis = -1.0
	if touch_right: axis = 1.0
	if Input.is_key_pressed(KEY_A): axis = -1.0
	if Input.is_key_pressed(KEY_D): axis = 1.0
	player.velocity.x = axis * RUN_SPEED
	player.velocity.y += GRAVITY * delta
	var jump_down := Input.is_action_pressed("ui_accept") or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP) or touch_jump
	if jump_down and not jump_was_down and player.is_on_floor():
		player.velocity.y = JUMP_SPEED
	jump_was_down = jump_down
	var previous_y := player.global_position.y
	player.move_and_slide()
	if player.position.y > 650:
		_lose_life()
	for e in enemies:
		if not is_instance_valid(e) or not e.get_meta("alive"): continue
		var direction: float = e.get_meta("direction")
		var origin: float = e.get_meta("origin")
		e.position.x += direction * 72.0 * delta
		if abs(e.position.x - origin) > 95:
			e.set_meta("direction", -direction)
		if player.global_position.distance_to(e.global_position) < 39:
			if player.velocity.y > 0 and previous_y < e.position.y - 14:
				e.set_meta("alive", false)
				e.queue_free()
				player.velocity.y = JUMP_SPEED * 0.55
				score += 10
				_update_hud()
			else:
				_lose_life()
				break
	if player.position.x > 4100:
		won = true
		_show_end("¡ESCAPASTE!  NIVEL COMPLETADO")
	queue_redraw()

func _lose_life() -> void:
	lives -= 1
	if lives <= 0:
		game_over = true
		_show_end("FIN DEL JUEGO")
	else:
		player.position = Vector2(max(80, player.position.x - 180), FLOOR_Y - 55)
		player.velocity = Vector2.ZERO
	_update_hud()

func _update_hud() -> void:
	if is_instance_valid(hud):
		hud.text = "🧟 BIO-MONEDAS: %03d     VIDAS: %d" % [score, lives]

func _show_end(message: String) -> void:
	var panel := Label.new()
	panel.text = message + "\nPulsa ENTER para volver a jugar"
	panel.position = Vector2(270, 190)
	panel.add_theme_font_size_override("font_size", 32)
	panel.add_theme_color_override("font_color", Color(1.0, 0.85, 0.45))
	panel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.z_index = 20
	var layer := get_node_or_null("EndLayer")
	if layer == null:
		layer = CanvasLayer.new()
		layer.name = "EndLayer"
		add_child(layer)
	layer.add_child(panel)

func _draw() -> void:
	draw_rect(Rect2(-100, 0, WORLD_WIDTH + 300, 540), Color(0.10, 0.14, 0.17))
	# Distant ruined skyline
	for i in range(35):
		var x := float(i * 135)
		var h := 90.0 + float((i * 47) % 150)
		draw_rect(Rect2(x, FLOOR_Y - h - 35, 92, h), Color(0.16, 0.21, 0.22))
		for wy in range(2, int(h / 28)):
			draw_rect(Rect2(x + 14, FLOOR_Y - h - 22 + wy * 28, 12, 10), Color(0.55, 0.43, 0.22, 0.55))
	# Ground and platforms
	for r in platforms:
		draw_rect(r, Color(0.28, 0.31, 0.25))
		draw_rect(Rect2(r.position.x, r.position.y, r.size.x, 9), Color(0.40, 0.55, 0.29))
		for j in range(int(r.size.x / 45)):
			draw_line(Vector2(r.position.x + j * 45, r.position.y + 13), Vector2(r.position.x + j * 45 + 20, r.position.y + 13), Color(0.20, 0.23, 0.19), 2)
	# Evacuation gate
	draw_rect(Rect2(4070, 325, 58, 130), Color(0.85, 0.35, 0.12))
	draw_rect(Rect2(4080, 335, 38, 120), Color(1.0, 0.72, 0.28))
	draw_circle(Vector2(4100, 310), 15, Color(1.0, 0.75, 0.25))
	# Zombie player
	if is_instance_valid(player):
		var p := player.position
		draw_rect(Rect2(p.x - 15, p.y - 9, 30, 30), Color(0.30, 0.72, 0.38))
		draw_rect(Rect2(p.x - 12, p.y - 25, 24, 20), Color(0.42, 0.82, 0.46))
		draw_rect(Rect2(p.x - 10, p.y - 20, 6, 5), Color.WHITE)
		draw_rect(Rect2(p.x + 3, p.y - 20, 6, 5), Color.WHITE)
		draw_rect(Rect2(p.x - 9, p.y - 19, 3, 4), Color.BLACK)
		draw_rect(Rect2(p.x + 4, p.y - 19, 3, 4), Color.BLACK)
		draw_rect(Rect2(p.x - 8, p.y - 8, 16, 4), Color(0.18, 0.08, 0.07))
		draw_rect(Rect2(p.x - 13, p.y + 20, 10, 9), Color(0.18, 0.20, 0.24))
		draw_rect(Rect2(p.x + 3, p.y + 20, 10, 9), Color(0.18, 0.20, 0.24))
	# Enemies
	for e in enemies:
		if is_instance_valid(e) and e.get_meta("alive"):
			var p := e.position
			draw_rect(Rect2(p.x - 14, p.y - 8, 28, 29), Color(0.55, 0.48, 0.25))
			draw_rect(Rect2(p.x - 12, p.y - 24, 24, 20), Color(0.63, 0.58, 0.34))
			draw_circle(Vector2(p.x - 5, p.y - 16), 3, Color(0.9, 0.15, 0.12))
			draw_circle(Vector2(p.x + 5, p.y - 16), 3, Color(0.9, 0.15, 0.12))
	# Pickups
	for a in pickups:
		if is_instance_valid(a):
			if a.get_meta("vial"):
				draw_rect(Rect2(a.position.x - 8, a.position.y - 12, 16, 24), Color(0.25, 0.95, 0.55))
				draw_rect(Rect2(a.position.x - 5, a.position.y - 17, 10, 6), Color(0.8, 0.9, 0.8))
			else:
				draw_circle(a.position, 10, Color(1.0, 0.78, 0.18))
				draw_circle(a.position, 5, Color(1.0, 0.94, 0.55))
