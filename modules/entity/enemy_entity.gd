extends CharacterBody2D

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

@export var skills: Array[SkillData] = []

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	move_and_slide()
	
	if velocity.length() > 0:
		sprite.play('walk')
	else:
		sprite.play('idle')
	
	if velocity.x > 0: 
		sprite.flip_h = false
	else:
		sprite.flip_h = true
		
