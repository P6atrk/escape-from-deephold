extends AnimatableBody2D

@export var platform_scale := Vector2(1.0, 1.0)

@onready var collision_shape = $CollisionShape
@onready var light_occluder = $LightOccluder

func _ready():
	set_platform_scale(platform_scale)
	
func set_platform_scale(_scale : Vector2):
	collision_shape.scale = _scale
	light_occluder.scale = _scale
	
