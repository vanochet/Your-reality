extends KinematicBody

export var speed: float = 10.0
export var weapon: int = 0.0
export var gravity: float = -24.8
export var accel: float = 4.5
export var deaccel: float = 16.0
export var MAX_SLOPE_ANGLE: float = 89.0
export var mouse_sensitivity: float = 0.05
export var jump_strength: float = 9.0
export var enabled: bool = true

onready var camera = $Head/Camera
onready var head = $Head

var dir
var vel: Vector3 = Vector3()
var chunk_cache: int = -1

onready var chunk_0_0 = get_parent().get_node("Terrain/hm_0_0")
onready var chunk_1_0 = get_parent().get_node("Terrain/hm_1_0")
onready var chunk_0_1 = get_parent().get_node("Terrain/hm_0_1")
onready var chunk_m1_0 = get_parent().get_node("Terrain/hm_m1_0")
onready var chunk_0_m1 = get_parent().get_node("Terrain/hm_0_m1")


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func load_chunk(pos: Vector3, shift: Vector2):
	var pos2d: Vector2
	var id: int
	var mapname: String
	var global_pos: Vector3
	var node_name: String
	var chunk: Spatial
	
	# calculate coordinates
	pos2d = (Vector2(pos.x, pos.y) / Vector2(64, 64) + Vector2(7, 7) + shift).round()
	id = int(pos2d.y) * 16 + int(pos2d.x) - 10
	
	# generate filename for hm and tm
	mapname = str(id)
	for _i in range(3 - mapname.length()):
		mapname = "0" + mapname # so we need to align number by 3 via zeros
	
	# generate node name
	node_name = "Terrain/hm_" + ("m" if shift.x < 0 else "") + str(abs(shift.x)) + "_" + \
		("m" if shift.y < 0 else "") + str(abs(shift.y))
	
	# get node
	chunk = get_parent().get_node(node_name)
	
	# calculate chunk new position    align by ones    align by center
	pos2d = (pos2d - Vector2(7, 7)) * Vector2(64, 64) + Vector2(-32, 32)
	global_pos = Vector3(pos2d.x, chunk.global_translation.y, pos2d.y)
	
	# I need to set the position before heightmap and texture becouse player cal fall out of scene
	chunk.global_translation = global_pos
	
	# loading textures
	chunk.heightmap = load(str("res://heightmaps/dark/image_part_"+mapname+".png"))
	chunk.material.set_texture(0, load(str("res://textmaps/dark/image_part_"+mapname+".png")))
	
	# and applying them
	# unused because of crushing, uuse at your own risk
	# var _a = Thread.new().start(chunk, "update")
	chunk.update()


func _process(delta):
	load_chunk(transform.origin, Vector2(0, 0))
	load_chunk(transform.origin, Vector2(1, 0))
	load_chunk(transform.origin, Vector2(0, 1))
	load_chunk(transform.origin, Vector2(-1, 0))
	load_chunk(transform.origin, Vector2(0, -1))
	
	if enabled:
		dir = Vector3()
		var cam_xform = camera.get_global_transform()
		var input_movement_vector = Vector2()
		if Input.is_action_pressed("ui_up"):
			input_movement_vector.y += 1
		if Input.is_action_pressed("ui_down"):
			input_movement_vector.y -= 1
		if Input.is_action_pressed("ui_left"):
			input_movement_vector.x -= 1
		if Input.is_action_pressed("ui_right"):
			input_movement_vector.x += 1
	
		if Input.is_action_just_pressed("ui_focus_next"):
			OS.window_fullscreen = !OS.window_fullscreen
	
		input_movement_vector = input_movement_vector.normalized()
	
		dir += -cam_xform.basis.z * input_movement_vector.y
		dir += cam_xform.basis.x * input_movement_vector.x
	
		if is_on_floor():
			if Input.is_action_pressed("ui_accept"):
				vel.y = jump_strength
	
		dir.y = 0
		dir = dir.normalized()
	
		vel.y += delta * gravity
	
		var hvel = vel
		hvel.y = 0
	
		var target = dir
		target *= speed
	
		var do_accel
		if dir.dot(hvel) > 0:
			do_accel = accel
		else:
			do_accel = deaccel
	
		hvel = hvel.linear_interpolate(target, do_accel * delta)
		vel.x = hvel.x
		vel.z = hvel.z
		vel = move_and_slide(vel, Vector3(0, 1, 0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))


func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED && enabled:
		head.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
		rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rot = head.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		head.rotation_degrees = camera_rot
