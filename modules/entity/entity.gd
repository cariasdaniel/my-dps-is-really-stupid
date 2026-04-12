extends CharacterBody2D
class_name Entity

@export var max_hp: int = 100
var current_hp:= 0
@export var hp_recovery: float = 1.0

@export var max_mana: int = 50
var current_mana:= 0
@export var mana_recovery: float = 0.5

@export var attack: int = 10
@export var magic_power: int = 10

@export var defense: int = 50
@export var magic_defense: int = 30

@export var move_speed:= 100.0

@export var skills: Array[SkillData] = []

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _init() -> void:
	input_pickable = true
	
	mouse_entered.connect(_on_mouse_entered_target)
	mouse_exited.connect(_on_mouse_exited_untarget)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_hp = max_hp
	current_mana = max_mana

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_mouse_entered_target():
	var player = get_tree().get_first_node_in_group("Player")
	assert(player, 'Player não instanciado')
	player.add_target(self)

func _on_mouse_exited_untarget():
	var player = get_tree().get_first_node_in_group("Player")
	assert(player, 'Player não instanciado')
	player.remove_target(self)
