extends Spatial


func _ready():
	$Loading.visible = false
	if OS.get_name() != "HTML5":
		OS.window_fullscreen = true


func load_level():
	var __ = get_tree().change_scene_to(load("res://scenes/DarkWorld.tscn"))


func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Loading.visible = true
		Thread.new().start(self, "load_level")
	
	if OS.get_name() != "HTML5" && Input.is_action_just_pressed("ui_cancel"):
		get_tree().free()
