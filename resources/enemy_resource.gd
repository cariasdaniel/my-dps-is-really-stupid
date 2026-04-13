extends Resource
class_name EnemyResource

@export var id: String

@export var max_hp: int = 100
@export var hp_recovery: float = 1.0

@export var max_mana: int = 50
@export var mana_recovery: float = 0.5

@export var attack: int = 10
@export var magic_power: int = 10

@export var defense: int = 50
@export var magic_defense: int = 30

@export var move_speed:= 50.0

@export var skills: Array[SkillData] = []

@export var xp_reward:= 1.0
