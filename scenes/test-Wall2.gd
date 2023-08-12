extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MeshInstance.free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	transform.origin.x = get_parent().get_node("Player").transform.origin.x
	transform.origin.z = get_parent().get_node("Player").transform.origin.z
