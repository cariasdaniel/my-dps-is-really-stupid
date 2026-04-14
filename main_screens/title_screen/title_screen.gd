extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var bg_l: AnimatedSprite2D = $AnimatedSprite2D
@onready var bg_r: AnimatedSprite2D = $AnimatedSprite2D2


func _ready():
	animation_player.play("floating_title")
	bg_l.play('default')
	bg_r.play('default')

func _on_play_pressed() -> void:
	SceneChanger.change_to(ScenePaths.main)


func _on_settings_pressed() -> void:
	var settings = load(ScenePaths.settings).instantiate()
	add_child(settings)
	get_tree().paused = true


func _on_quit_pressed() -> void:
	get_tree().quit()
