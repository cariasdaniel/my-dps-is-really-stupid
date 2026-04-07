extends Node
class_name StateMachine

var prev_state: State
var curr_state: State

@onready var parent:= get_parent()

func _state_logic(delta): pass

func _get_transition(delta) -> State: return
