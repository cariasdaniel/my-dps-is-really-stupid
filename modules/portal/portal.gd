extends StaticBody2D

@onready var portal_sprite: AnimatedSprite2D = $AnimatedSprite2D

const ENEMY_SCENES = [
	preload("uid://nlpb0sqhemm8")
]

func _ready() -> void:
	portal_sprite.play('default')

func _on_time_to_spawn_timeout() -> void:
	print("Enemy spawned")
	var enemy = _select_enemy_to_spawn().instantiate()
	enemy.add_to_group("enemies")
	get_tree().root.add_child(enemy)
	enemy.global_position = global_position

# TODO: spawn different enemies depending on game state
func _select_enemy_to_spawn() -> PackedScene:
	return ENEMY_SCENES.pick_random()
