extends StaticBody2D

const BUTTON_DOWN_NAME = "button_down"
const BUTTON_UP_NAME = "button_up"

@export_file("*.tscn") var next_level_path
#@export var is_last_level : bool = false
@export var lights : Array[PointLight2D] = []

@onready var animation_player = $AnimationPlayer

var can_go_to_scene := false

func _ready():
	set_process(false)

func _process(delta):
	var can_goto_scene := true
	for light in lights:
		if light.animation_player.is_playing():
			can_goto_scene = false
	if can_goto_scene:
		Global.goto_scene(next_level_path)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == BUTTON_DOWN_NAME:
		animation_player.active = false
		for light in lights:
			if light.is_on:
				light.switch()
		set_process(true)
		#if is_last_level:
		#	Global.last_level_finished = true


func _on_area_2d_body_entered(body):
	if body.is_in_group(Global.player_group):
		animation_player.play(BUTTON_DOWN_NAME)


func _on_area_2d_body_exited(body):
	if body.is_in_group(Global.player_group):
		animation_player.play(BUTTON_UP_NAME)
