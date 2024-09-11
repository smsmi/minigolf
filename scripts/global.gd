extends Node2D

var charge = false
@export var charge_speed:float = 100.0
@export var power_scale:float  = 2.5
@export var sink_threshold:float = 50.0

var level2 = preload("res://scenes/levels/Level2.tscn")

var transition;

var power:float      = 0 # percent.
var power_dir:int    = 1 # which way to chagre the meter
var stroke_angle:int = 0
var direction:float  = 45.0
var input:bool       = true

signal stroke(power:float, direction:Vector2)

func _ready() -> void:
	get_window().size = Vector2i(640, 480)
	reset_ball()
	# connect signal to Level's goal
	$Level/Goal.connect('body_entered', _on_goal)
	
	transition = $Transition/AnimationPlayer

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("up"):
		load_level()
		
	if (input):
		# accept direction input
		if (Input.is_action_pressed("right")):
			direction -= 1
		elif (Input.is_action_pressed("left")):
			direction += 1
		
		if (Input.is_action_just_pressed("stroke")):
			if (charge):
				# hit the ball
				stroke.emit(power * power_scale, Vector2(cos(direction * PI/180), -sin(direction * PI/180)))
				charge = false
				power = 0
				power_dir = 1
				input = false
			else:
				# start powering up
				charge = true
	
	if (charge):
		power += charge_speed * delta * power_dir
		if (power >= 100 && power_dir == 1) or (power <= 0 && power_dir == -1):
			power = clamp(power, 0, 100)
			power_dir = -power_dir


func _on_ball_stopped():
	input = true

func _on_goal(body):
	# check if ball's velocity is low enough to sink it
	if (body.velocity.length() < sink_threshold):
		print("goal!")
		$Ball.velocity = Vector2.ZERO
		$GoalStream.play()
		# goal
		load_level()
	else:
		print("too fast...")	
	
	
func load_level():
	transition.play('Fade')
	await transition.animation_finished
	remove_child($Level)
	var l = level2.instantiate()
	add_child(l)
	reset_ball()
	# connect signal to Level's goal
	$Level/Goal.connect('body_entered', _on_goal)
	
	transition.play_backwards('Fade')
	# todo: reset scoring, strokes, etc.
	
func reset_ball():
	$Ball.velocity = Vector2.ZERO
	$Ball.position = $Level/StartPosition.position
