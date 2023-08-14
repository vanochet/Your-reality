extends Spatial


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var __ = get_tree().change_scene_to(load("res://scenes/DarkWorld.tscn"))
	
	if OS.get_name() != "HTML5" && Input.is_action_just_pressed("ui_cancel"):
		get_tree().free()
