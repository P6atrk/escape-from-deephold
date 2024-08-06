extends CharacterBody2D

@export var move_speed : float
@export var move_acceleration : float

@export var jump_height : float
@export var jump_double_height : float
@export var jump_variable_height : float
@export var jump_time_to_peak : float
@export var jump_double_time_to_peak : float
@export var jump_time_to_descent : float

@export var jump_buffer_time : float
@export var jump_coyote_time : float

@export var background_enabled : bool = true

@export var jump_sounds : Array[AudioStreamWAV]
@export var on_floor_sounds : Array[AudioStreamWAV]

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_double_velocity : float = ((2.0 * jump_double_height) / jump_double_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var jump_variable_gravity : float = (jump_velocity * jump_velocity) / (2 * jump_variable_height)
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1.0

@onready var jump_buffer_timer = $JumpBufferTimer
@onready var jump_coyote_timer = $JumpCoyoteTimer
@onready var background = $Background
@onready var jump_audio_player = $JumpAudioPlayer
@onready var on_floor_audio_player = $OnFloorAudioPlayer

var jump_available : bool = true
var jump_buffer : bool = false
var jumped_double : bool = false

func _ready():
	if not background_enabled:
		background.visible = false
	jump_buffer_timer.wait_time = jump_buffer_time
	jump_coyote_timer.wait_time = jump_coyote_time

func _physics_process(delta):
	horizontal_movement()
	vertical_movement(delta)
	move_and_slide()
	
func horizontal_movement():
	var horizontal_dir = (Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"))
	velocity.x = lerpf(velocity.x, move_speed * horizontal_dir, move_acceleration)
	
func get_gravity(is_falling : bool, is_jump_cancelled : bool) -> float:
	if is_jump_cancelled:
		return jump_variable_gravity
	elif is_falling:
		return fall_gravity
	else:
		return jump_gravity	
	
func vertical_movement(delta : float):
	var is_falling : bool = velocity.y > 0.0 and not is_on_floor()
	var is_jumping : bool = (Input.is_action_just_pressed("jump") or jump_buffer) and jump_available
	var is_double_jumping : bool = Input.is_action_just_pressed("jump") and not is_on_floor() and not jumped_double
	var is_jump_cancelled : bool = not Input.is_action_pressed("jump") and velocity.y < 0.0 and not is_on_floor() 
	var is_idling : bool = is_on_floor() and is_zero_approx(velocity.x)
	var is_running : bool = is_on_floor() and not is_zero_approx(velocity.x)
	
	if is_falling and jump_available and jump_coyote_timer.is_stopped():
		jump_coyote_timer.start()
	
	if Input.is_action_just_pressed("jump"):
		jump_buffer = true
		jump_buffer_timer.start()
	
	velocity.y += get_gravity(is_falling, is_jump_cancelled) * delta
	
	if is_jumping:
		play_jump_sound()
		velocity.y = jump_velocity
		jump_buffer = false
		jump_available = false
	elif is_double_jumping:
		play_jump_sound()
		jumped_double = true
		velocity.y = jump_double_velocity
	elif is_idling or is_running:
		if jumped_double or not jump_available:
			play_on_floor_sound()
		jumped_double = false
		jump_available = true
	
func _on_jump_buffer_timer_timeout():
	jump_buffer = false

func _on_jump_coyote_timer_timeout():
	jump_available = false
	
func play_on_floor_sound():
	on_floor_audio_player.stream = on_floor_sounds.pick_random()
	on_floor_audio_player.pitch_scale = randf_range(0.5, 1.2)
	on_floor_audio_player.play()

func play_jump_sound():
	jump_audio_player.stream = jump_sounds.pick_random()
	jump_audio_player.pitch_scale = randf_range(0.5, 1.2)
	jump_audio_player.play()
