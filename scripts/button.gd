extends StaticBody2D

## switch for pingpong, light, loop
## reverse for none loop, loop
## push is a switch. if you jump off it switches back
## reverse push is a reverse. if you jump off it switches back to og state
## one_times are the same, but can be performed only 1 time
enum ButtonType { SWITCH, REVERSE, REVERSE_PUSH, PUSH, ONE_TIME_SWITCH, ONE_TIME_REVERSE }

const BUTTON_DOWN_NAME := "button_down"
const BUTTON_UP_NAME := "button_up"

@export var moving_nodes : Array[Path2D] = []
@export var lightsources : Array[Node] = []
@export var button_type : ButtonType

@onready var animation_player = $AnimationPlayer

var pushed_down : bool = false

func _on_area_2d_body_entered(body):
	if body.is_in_group(Global.player_group):
		animation_player.play(BUTTON_DOWN_NAME)

func _on_area_2d_body_exited(body):
	if body.is_in_group(Global.player_group):
		animation_player.play(BUTTON_UP_NAME)

func _on_animation_player_animation_finished(anim_name):
	match button_type:
		ButtonType.SWITCH:
			switch(anim_name)
		ButtonType.REVERSE:
			reverse(anim_name)
		ButtonType.REVERSE_PUSH:
			reverse_push(anim_name)
		ButtonType.PUSH:
			push(anim_name)
		ButtonType.ONE_TIME_SWITCH:
			one_time_switch(anim_name)
		ButtonType.ONE_TIME_REVERSE:
			one_time_reverse(anim_name)
			
func one_time_switch(anim_name : String):
	if anim_name == BUTTON_DOWN_NAME:
		animation_player.pause()
		animation_player.active = false
		switch(anim_name)
		
func one_time_reverse(anim_name : String):
	if anim_name == BUTTON_DOWN_NAME:
		animation_player.pause()
		animation_player.active = false
		reverse(anim_name)

func switch(anim_name : String):
	if anim_name == BUTTON_DOWN_NAME:
		switch_nodes()
	
func reverse(anim_name : String):
	if anim_name == BUTTON_DOWN_NAME:
		for node in moving_nodes:
			node.reverse()
			
func reverse_push(anim_name : String):
	if anim_name == BUTTON_DOWN_NAME:
		pushed_down = true
		reverse_nodes()
	elif anim_name == BUTTON_UP_NAME and pushed_down == true:
		pushed_down = false
		reverse_nodes()

func push(anim_name : String):
	if anim_name == BUTTON_DOWN_NAME:
		pushed_down = true
		switch_nodes()
	elif anim_name == BUTTON_UP_NAME and pushed_down == true:
		pushed_down = false
		switch_nodes()
			
func reverse_nodes():
	for node in moving_nodes:
		node.reverse()
		
func switch_nodes():
	for node in moving_nodes:
		node.switch()
	for node in lightsources:
		node.switch()
