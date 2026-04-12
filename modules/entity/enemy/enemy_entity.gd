extends Entity
class_name Enemy

#TODO encapsulate HP Bar elsewhere?
@onready var hp_bar: ProgressBar = $HpBar
@onready var label: Label = $Label
var mob_name = ""


func _ready() -> void:
	current_hp = max_hp
	current_mana = max_mana
	
	hp_bar.max_value = max_hp
	
	move_speed = 50.0
	
	SignalBus.change_health.connect(_on_health_changed)

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
	
	
func _on_health_changed(target: Entity, value) -> void:
	if self != target: return
	current_hp = clamp(current_hp + value, 0, max_hp)
	print("Damaged " + mob_name)
	if current_hp <= 0:
		print(mob_name + " died.")
		SignalBus.gain_xp.emit(40)
		queue_free()
	
	#TODO encapsulate HP Bar elsewhere?
	hp_bar.value = current_hp
