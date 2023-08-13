extends MeshInstance


func _process(_delta):
	look_at(get_parent().get_parent().get_node("Player").transform.origin, Vector3(0.0, 1.0, 0.0))
