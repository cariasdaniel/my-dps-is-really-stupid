extends Node
class_name PlayerData

@export var max_hp: int = 100
@export var curr_hp: int = max_hp
@export var max_mana: int = 50
@export var curr_mana: int = max_mana
@export var hp_recovery: float = 1.0
@export var mana_recovery: float = 0.5
@export var attack: int = 10
@export var magic_power: int = 10
@export var defense: int = 50
@export var magic_defense: int = 30
@export var skills: Array[SkillData] = []
