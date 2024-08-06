extends AudioStreamPlayer

@onready var animation_player = $AnimationPlayer
var music_bus_index : int
var max_music_volume : float = 0.4
var music_volume : float = 0.0
var step : float = 0.05

func _process(delta):
	music_volume += step * delta
	if music_volume <= max_music_volume:
		AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(music_volume))
	else:
		set_process(false)

func _ready():
	music_bus_index = AudioServer.get_bus_index("Music")

