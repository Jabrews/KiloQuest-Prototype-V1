extends State


@export var speed = 50
@export var nav_agent : NavigationAgent2D

var target_node = null
var home_position = Vector2.ZERO

func _ready():
	home_position = character.global_position
	
	nav_agent.path_desired_distance = 4 ## these prohibit the exact "best path" but make the enemy target near the players spot
	nav_agent.target_desired_distance = 4
	
	
func state_process(delta):
	if nav_agent.is_navigation_finished():
		return ##bool
		
	## could control animations with axis## ##think anim player!!#
	var axis = character.to_local(nav_agent.get_next_path_position()).normalized() ##what direction is enemy going toward 
	var intended_velocity = axis * speed ##where we want to go 
	nav_agent.set_velocity(intended_velocity) ##check if safe
	
func recalc_path():
	##check for target
	##calc path
	##if no target go back home
	if target_node:
		nav_agent.target_position = target_node.global_position
	else:
		nav_agent.target_position = home_position

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	character.velocity = safe_velocity
	character.move_and_slide()


func _on_aggro_start_body_entered(body):
	target_node = body


func _on_aggro_range_body_exited(body):
	if body == target_node:
		target_node = null


func _on_recalculate_timeout():
	recalc_path()
