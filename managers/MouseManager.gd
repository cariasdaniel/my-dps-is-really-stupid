extends Node

var cursors: Dictionary[String, CompressedTexture2D]={
	'default': preload("res://assets/cursors/Used/target_a.png"),
	'ally_target': preload("res://assets/cursors/Used/target_ally.png"),
	'enemy_target': preload("res://assets/cursors/Used/target_enemy.png"),
	#'aim': preload(),
	#'area': preload()
}

func _ready() -> void:
	Input.set_custom_mouse_cursor(cursors['default'], Input.CURSOR_ARROW, cursors['default'].get_size()/2)
	
	SignalBus.hover_over.connect(_on_hover_over_change_shape)

func _on_hover_over_change_shape(obj: Node):
	if obj:
		if obj.is_in_group('players'):
			Input.set_custom_mouse_cursor(cursors['ally_target'], Input.CURSOR_ARROW, cursors['ally_target'].get_size()/2)
		if obj.is_in_group('enemies'):
			Input.set_custom_mouse_cursor(cursors['enemy_target'], Input.CURSOR_ARROW, cursors['enemy_target'].get_size()/2)
	else:
		Input.set_custom_mouse_cursor(cursors['default'], Input.CURSOR_ARROW, cursors['default'].get_size()/2)
