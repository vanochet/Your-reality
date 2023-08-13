extends Area


var changes := false
var open := false
var pbody


func _on_body_entered(body):
	if body.name == "Player" and not open:
		changes = true
		body.get_node("Head/Camera/Pointer/Pointer2").set_visible(1)
		body.get_node("Head/Camera/Pointer/Pointer3").set_visible(1)
		pbody = body

func _on_body_exited(body):
	if body.name == "Player" and not open:
		changes = false
		body.get_node("Head/Camera/Pointer/Pointer2").set_visible(0)
		body.get_node("Head/Camera/Pointer/Pointer3").set_visible(0)

func _process(_delta):
	PhysicsServer.area_set_monitorable(self.get_rid(), true)
	if Input.is_action_just_pressed("ui_end"):
		print("E")
		if changes:
			get_parent().get_node("closed").visible = 0
			get_parent().get_node("opened").visible = 1
			get_parent().get_node("CollisionShape").disabled = true
			open = true
			pbody.get_node("Head/Camera/Pointer/Pointer2").set_visible(0)
			pbody.get_node("Head/Camera/Pointer/Pointer3").set_visible(0)
