extends PointLight2D

const NAME_TURN_OFF = "turn_off"
const NAME_TURN_ON = "turn_on"

@export var speed_scale_turn_off : float = 1.0
@export var speed_scale_turn_on : float = 1.0
@export var low_ene : float = 1.0
@export var low_sca : float = 1.0
@export var norm_ene : float = 1.0
@export var norm_sca : float = 1.0
@export var is_on : bool = true

@export var animation_player : AnimationPlayer

func _ready():
	fix_animation(NAME_TURN_OFF)
	fix_animation(NAME_TURN_ON)
	set_animation_keys(NAME_TURN_OFF, norm_ene, low_ene, norm_sca, low_sca)
	set_animation_keys(NAME_TURN_ON, low_ene, norm_ene, low_sca, norm_sca)
	if is_on:
		turn_on()
	else:
		energy = low_ene
		texture_scale = low_sca
		
func set_animation_keys(_name : String, a_ene : float, b_ene : float, a_sca : float, b_sca : float):
	var animation = animation_player.get_animation(_name)
	var track_texture_scale = animation.find_track(".:texture_scale", Animation.TrackType.TYPE_VALUE)
	var track_energy = animation.find_track(".:energy", Animation.TrackType.TYPE_VALUE)
	animation.track_set_key_value(track_energy, 0, a_ene)
	animation.track_set_key_value(track_energy, 1, b_ene)
	animation.track_set_key_value(track_texture_scale, 0, a_sca)
	animation.track_set_key_value(track_texture_scale, 1, b_sca)
	
func switch():
	var start_position = animation_player.current_animation_length - animation_player.current_animation_position
	turn_off() if is_on else turn_on()
	animation_player.seek(start_position, true)
		
func turn_off():
	is_on = false
	animation_player.play(NAME_TURN_OFF, 0.4, speed_scale_turn_off)

func turn_on():
	is_on = true
	animation_player.play(NAME_TURN_ON, 0.4, speed_scale_turn_on)

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
