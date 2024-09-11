extends CharacterBody2D

@export var deadzone = 0.2 # Velocity at or under which the ball should be considered "stopped"

signal _ball_stopped

#@onready var ray = $PreviewRay

func _ready() -> void:
	#print(global_position)
	get_parent().connect('stroke', _on_stroke)

func _process(delta: float) -> void:
	velocity = lerp(velocity, Vector2.ZERO, 0.01)
	if (velocity.length() <= deadzone):
		velocity = Vector2.ZERO
		_ball_stopped.emit()
	
	var collision_info = move_and_collide(velocity * delta)
	if (collision_info):
		$BounceSound.play()
		velocity = velocity.bounce(collision_info.get_normal())
	
	#var dir = velocity.angle()
	#ray.set_target_position(velocity * 100)

func _on_stroke(power:float, direction:Vector2) -> void: 
	velocity = direction.normalized() * power
	print("stroke")
	

func approach(a:float, b:float, c:float):
	# returns a shifted toward b by c
	return a + (sign(b - a) * c)
