extends StaticBody2D

@onready var portal_sprite: AnimatedSprite2D = $AnimatedSprite2D

const ENEMY_SCENES = [
	preload("uid://nlpb0sqhemm8")
]

# TODO: REMOVE
var i = 1

func _ready() -> void:
	portal_sprite.play('default')

func _on_time_to_spawn_timeout() -> void:
	var enemy = _select_enemy_to_spawn().instantiate()
	
	#print("Enemy spawned")
	# TODO: REMOVE
	enemy.mob_name = 'Mob %s' % i
	i += 1

	enemy.add_to_group("enemies")
	get_tree().root.add_child(enemy)
	enemy.label.text = enemy.mob_name
	enemy.global_position = global_position

# TODO: spawn different enemies depending on game state
func _select_enemy_to_spawn() -> PackedScene:
	return ENEMY_SCENES.pick_random()
