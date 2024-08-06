extends Control

@onready var music_slider = $VBoxContainer/HBoxContainer2/MusicSlider
@onready var sfx_slider = $VBoxContainer/HBoxContainer/SFXSlider

var sfx_bus_index : int
var music_bus_index : int

func _ready():
	sfx_slider.grab_focus()
	sfx_bus_index = AudioServer.get_bus_index("SFX")
	music_bus_index = AudioServer.get_bus_index("Music")

	sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(sfx_bus_index))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(music_bus_index))

func set_bus_volume(bus_idx : int, volume : float):
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(volume))

func _on_sfx_slider_value_changed(value):
	set_bus_volume(sfx_bus_index, value)

func _on_music_slider_value_changed(value):
	set_bus_volume(music_bus_index, value)
