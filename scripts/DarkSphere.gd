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
  var dir: Vector3 = (get_node(camera).global_transform.origin - $MeshInstance.global_transform.origin).normalized()
  $MeshInstance.mesh.surface_get_material(0).set_shader_param("dir", dir)
