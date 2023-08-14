extends KinematicBody

export var speed: float = 10.0
export var weapon: int = 0.0
export var gravity: float = -24.8
export var accel: float = 4.5
export var deaccel: float = 16.0
export var MAX_SLOPE_ANGLE: float = 89.0
export var mouse_sensitivity: float = 0.05
export var jump_strength: float = 9.0

onready var camera = $Head/Camera
onready var head = $Head

var dir
var vel: Vector3 = Vector3()
var chunk_cache = 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	var chunk_pos: Vector2 = (Vector2(transform.origin.x, transform.origin.z)/Vector2(64, 64)).round() + Vector2(8, 8)
	var chunk_id: int = int(chunk_pos.y * 16 + chunk_pos.x - 10)
	var chunk_sid := str(chunk_id)
	for _i in range((3 - chunk_sid.length())):
		chunk_sid = "0" + chunk_sid
	print("chunk pos: ", chunk_pos)
	print("chunk image: \"res://heightmaps/dark/image_part_"+chunk_sid+".png\"")
	if chunk_id != chunk_cache:
		get_parent().get_node("Heightmap").heightmap = load(str("res://heightmaps/dark/image_part_"+chunk_sid+".png"))
		get_parent().get_node("Heightmap").material.set_texture(0, load(str("res://textmaps/dark/image_part_"+chunk_sid+".png")))
		chunk_cache = chunk_id
		get_parent().get_node("Heightmap")._ready()
	
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
		if Input.is_action_just_pressed("ui_accept"):
			vel.y = jump_strength
	
	if Input.is_action_just_pressed("ui_alt"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
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
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_x(deg2rad((-event.relative.y) * mouse_sensitivity))
		self.rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rot = head.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		head.rotation_degrees = camera_rot
