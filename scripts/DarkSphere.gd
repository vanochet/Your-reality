extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var camera: NodePath


# Called when the node enters the scene tree for the first time.
func _ready():
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
  var sphere_shift: Vector2 = get_viewport().size / 2 - (get_node(camera) as Camera).unproject_position(global_transform.origin)
  sphere_shift *= 2
  var dir := Vector3(sphere_shift.x / get_viewport().size.x, -0.8 * sphere_shift.y / get_viewport().size.y, 1.0)
  $MeshInstance.mesh.surface_get_material(0).set_shader_param("dir", dir)
