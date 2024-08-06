extends Button

@export_file("*.tscn") var path : String
@export var is_exit := false
@export var is_visible := true
@export var lights : Array[PointLight2D] = []
@export var grab_focus_first := false

func _ready():
	if not is_visible and not Global.last_level_finished:
		visible = false
	if grab_focus_first:
		grab_focus()
	set_process(false)

func _process(delta):
	var can_goto_scene := true
	for light in lights:
		if light.animation_player.is_playing():
			can_goto_scene = false
	if can_goto_scene:
		Global.goto_scene(path)

func _on_pressed():
	if is_exit:
		get_tree().quit()
	else:
		for light in lights:
			if light.is_on:
				light.switch()
		set_process(true)
