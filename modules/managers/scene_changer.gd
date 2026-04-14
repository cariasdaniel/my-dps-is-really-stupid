extends CanvasLayer

@onready var audio_manager: Node = $AudioManager

@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal scene_changed

func change_to(new_scene_path: String):
	color_rect.visible = true
	animation_player.play("fade_to_black")
	await animation_player.animation_finished
	
	get_tree().change_scene_to_file(new_scene_path)
	scene_changed.emit(new_scene_path)
	
	animation_player.play("fade_to_scene")
	await animation_player.animation_finished
	color_rect.visible = false
	
	
