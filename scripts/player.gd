extends CharacterBody2D

@export var speed:float = 100.0
@export var jump_speed:float = -300.0

var gravity:float = 0 #ProjectSettings.get_setting("physics/2d/default_gravity")

const PUSH_FORCE = 100
const BLOCK_MAX_VELOCITY = 180

func _ready() -> void:
	print(global_position)
	
func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
	
	var dir = Input.get_axis("left", "right")
	velocity.x = dir * speed
	
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var col_block = col.get_collider()
		if (col_block.is_in_group("Blocks") and abs(col_block.get_linear_velocity().x) < BLOCK_MAX_VELOCITY):
			col_block.apply_central_impulse(col.get_normal() * -PUSH_FORCE)
	move_and_slide()
