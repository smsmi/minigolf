extends Line2D

var ray = preload("res://scenes/PreviewRay.tscn")

var GC;
var bounces = 3
var rays:Array[RayCast2D]

@onready var ball = get_node("../Ball")


func _ready() -> void:
	GC = get_parent()
	for i in bounces:
		var _r = ray.instantiate()
		rays.append(_r)
		add_child(_r)

func _process(delta: float) -> void:
	clear_points()
	
	# start from ball coords
	add_point(ball.position)
	var start_pos = ball.position
	var new_target = Vector2(cos(GC.direction * PI / 180) * 1000, -sin(GC.direction*PI/180) * 1000)
	# iterate...
	for i in bounces:
		# set target to prev loop's target, assuming collision
		rays[i].global_position = start_pos
		rays[i].set_target_position(new_target)
		if (rays[i].is_colliding()):
			add_point(rays[i].get_collision_point())
			start_pos = rays[i].get_collision_point()
			new_target = new_target.bounce(rays[i].get_collision_normal()) 
		else:
			break;

#func _on_ball_stopped() -> void:

func _on_game_controller_stroke(power: float, direction: Vector2) -> void:
	print("hiding")
	visible = false # Replace with function body.


func _on_ball__ball_stopped() -> void:
	visible = true;
