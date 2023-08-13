extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var timer := 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = 0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().get_node("Injan").trans == 2:
		get_parent().get_node("Injan").trans = 3
	
	if get_parent().get_node("Injan").trans == 3:
		timer += delta
		if timer > 2.0:
			get_parent().get_node("Injan").trans = 4
			
	if get_parent().get_node("Injan").trans == 4:
		visible = 1
		get_parent().get_node("Injan").trans = 5
