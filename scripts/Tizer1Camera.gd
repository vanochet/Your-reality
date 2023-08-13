extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Injan.trans == 5:
		rotation_degrees.x += 16*delta
		if rotation_degrees.x >= 104:
			$Injan.trans = 6
