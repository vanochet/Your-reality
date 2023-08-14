extends MeshInstance


func _ready():
	if OS.get_name() == "HTML5":
		visible = 1
	else:
		visible = 0
