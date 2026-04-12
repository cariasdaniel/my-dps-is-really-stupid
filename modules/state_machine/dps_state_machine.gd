extends Node
class_name DpsStateMachine

@export var initial_state: State

var states:= {}
var curr_state: State

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transitioned.connect(on_state_transition)
			
	if initial_state:
		initial_state.enter()
		curr_state = initial_state
		#print(curr_state)


func _process(delta):
	if curr_state:
		curr_state.update(delta)
	
func _physics_process(delta):
	if curr_state:
		curr_state.physics_update(delta)

func on_state_transition(state, new_state_name):
	if state != curr_state: return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state: return
	
	if curr_state: curr_state.exit()
	
	new_state.enter()
	curr_state = new_state
