extends Area


var changes := false
var open := false


func _on_body_entered(body):
	if body.name == "Player":
		changes = true
		body.get_node("Head/Camera/Pointer2").set_visible(1)
		body.get_node("Head/Camera/Pointer3").set_visible(1)

func _on_body_exited(body):
	if body.name == "Player":
		changes = false
		body.get_node("Head/Camera/Pointer2").set_visible(0)
		body.get_node("Head/Camera/Pointer3").set_visible(0)

func _process(_delta):
	PhysicsServer.area_set_monitorable(self.get_rid(), true)
	if Input.is_action_just_pressed("ui_end"):
		print("E")
		if changes:
			if not open:
				get_parent().rotation_degrees.y = 0.0
			else:
				get_parent().rotation_degrees.y = -148.0
			open = not open
