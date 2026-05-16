extends Resource
class_name SkillData

enum shapes { CIRCLE, LINE }
enum resource_cost { MANA, STRESS }

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var area_vfx: SpriteFrames
@export var self_vfx: SpriteFrames
@export var ally_target_vfx: SpriteFrames
@export var enemy_target_vfx: SpriteFrames

@export var cost: float
@export var cost_type: resource_cost

@export var cooldown: float

@export var current_level: int = 0
@export var max_level: int
@export var tier: int
@export var dependencies: Dictionary[String, int] = {}

@export var shape: shapes # shape around the source
@export var area: float = 0.5 # area around the source if circle shape
@export var size: Vector2 = Vector2.ZERO # width, height if line shape

@export var n_apply_effects: int = 1 # how many times effect is applied
@export var apply_interval: float = 1 # interval in seconds between effect application

@export var duration: float = 0 # how long skill stays "up"
@export var distance: float = 0 # how far from source may be casted

@export var minimum_targets: int = 0
@export var ignore_self: bool

@export var self_effects: Array[Script]
@export var ally_effects: Array[Script]
@export var enemy_effects: Array[Script]

@export var vars: Dictionary[String,int] = {}
