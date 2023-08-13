extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var trans := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if trans == 0:
		rotation_degrees.z -= 8*delta
		scale.x += delta/8
		scale.y += delta/8
		
		if -190.0 < rotation_degrees.z && rotation_degrees.z < -180.0 && round(scale.y) == 4.0:
			trans = 1
	
	if trans == 1:
		scale.x -= delta
		scale.y -= delta
		
		if scale.x <= 1.1:
			trans = 2
			rotation_degrees = Vector3(0.0, 0.0, 180.0)
			scale = Vector3(1.0, 1.0, 1.0)
