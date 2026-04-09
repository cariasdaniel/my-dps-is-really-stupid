extends Resource
class_name SkillData

@export var id: String
@export var name: String
@export var description: String
@export var cost: float
@export var cooldown: float
@export var current_level: int = 0
@export var max_level: int
@export var distance: float
@export var area: float
@export var target: int
@export var tier: int
@export var icon: Texture2D
@export var vars: Array[int] = []
@export var dependencies: Dictionary[String, int] = {}
