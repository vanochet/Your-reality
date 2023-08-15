extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var shift := Vector3(0, 100, 0)  # 21.354, 23.689, -36.827)


# Called when the node enters the scene tree for the first time.
func _ready():
	set_visible(1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	transform.origin = get_parent().get_parent().get_node("Player").transform.origin + shift
