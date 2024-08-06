class_name Path
extends Path2D

const MOVE_NAME = "move"
const MOVE_BACKWARD_NAME = "move_backward"
const BLEND : float = 0.4

@export var speed : float = 1.0
## animation looping
@export var loop_mode : Animation.LoopMode = Animation.LOOP_NONE
## path2d loop
@export var loop := false
@export var loop_speed : float = 0.0

@export var node : Node2D

@onready var animation_player = $AnimationPlayer
@onready var path_follow = $PathFollow
@onready var remote_transform = $PathFollow/RemoteTransform

var is_on : bool = true
var is_reversed : bool = false

func _ready():
	fix_animation(MOVE_NAME)
	remote_transform.remote_path = remote_transform.get_path_to(node)
	animation_player.get_animation(MOVE_NAME).set_loop_mode(loop_mode)
	if not loop and loop_mode == Animation.LOOP_PINGPONG:
		animation_player.play(MOVE_NAME, BLEND, speed)
		
func _physics_process(delta):
	if loop and is_on:
		path_follow.progress += loop_speed * delta

# Can be used by LOOP_NONE and loop
func reverse():
	if not loop and loop_mode == Animation.LOOP_NONE:
		var start_pos = animation_player.current_animation_position
		if is_reversed:
			is_reversed = false
			animation_player.play(MOVE_NAME, -1, -speed, true)
		else:
			is_reversed = true
			animation_player.play(MOVE_NAME, -1, speed, false)
		animation_player.seek(start_pos, true)
	else:
		loop_speed *= -1

# Can be used by PINGPONG and loop
func switch():
	turn_off() if is_on else turn_on()

func turn_off():
	is_on = false
	if not loop and animation_player.is_playing():
		animation_player.pause()

func turn_on():
	is_on = true
	if not loop and loop_mode == Animation.LOOP_PINGPONG:
		animation_player.play()
		
# https://github.com/godotengine/godot/issues/82421
func fix_animation(animation_name : String):
	var animation_library: AnimationLibrary = animation_player.get_animation_library(&"")
	animation_library = animation_library.duplicate()
	animation_player.remove_animation_library(&"")
	animation_player.add_animation_library(&"", animation_library)
	var animation = animation_player.get_animation(animation_name)
	animation = animation.duplicate()
	animation_library.remove_animation(animation_name)
	animation_library.add_animation(animation_name, animation)
