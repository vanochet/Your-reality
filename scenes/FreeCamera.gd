extends Spatial

export var speed: float = 10.0
export var weapon: int = 0.0
export var MAX_SLOPE_ANGLE: float = 89.0
export var mouse_sensitivity: float = 0.05

var dir


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	
	dir = Vector3()
	var cam_xform = get_global_transform()
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
	
	if Input.is_action_pressed("ui_accept"):
		dir.y = speed
	if Input.is_action_pressed("ui_focus_prev"):
		dir.y = -speed
	
	if Input.is_action_just_pressed("ui_alt"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#	if !get_parent().get_node("Player").enabled:
	#		$Head/Camera.current = false
	#		get_parent().get_node("Player/Head/Camera").current = true
	#		get_parent().get_node("Player").enabled = true
	#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#	else:
	#		$Head/Camera.current = true
	#		get_parent().get_node("Player/Head/Camera").current = false
	#		get_parent().get_node("Player").enabled = false
	#		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	dir = dir.normalized()
	
	var hvel = dir * delta
	
	var target = dir
	target *= speed
	
	hvel = hvel.linear_interpolate(target, delta)
	
	if !get_parent().get_node("Player").enabled:
		transform.origin += hvel


func _input(event):
	if event is InputEventMouseMotion && Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		$Head.rotate_x(deg2rad(event.relative.y * mouse_sensitivity * -1))
		rotate_y(deg2rad(event.relative.x * mouse_sensitivity * -1))
		
		var camera_rot = $Head.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		$Head.rotation_degrees = camera_rot
