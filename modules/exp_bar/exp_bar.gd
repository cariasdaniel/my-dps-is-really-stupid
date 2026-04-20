extends TextureProgressBar

@onready var level_label: Label = $LevelLabel
@onready var xp_label: Label = $XpLabel
@export var player_level: int = 1

func _ready():
	SignalBus.update_xp_info.connect(_update_progress)
	_update_progress()

func _update_progress() -> void:
	print('updating xp bar UI')
	max_value = ExpManager.get_xp_to_next_level()
	value = ExpManager.xp
	level_label.text = tr("LEVEL") + " " + str(ExpManager.level)
	xp_label.text = "%3.2f%%" % ((value / max_value) * 100)




# TODO: REMOVE AFTER PROPER XP GAIN IS IMPLEMENTED
func _on_button_pressed() -> void:
	SignalBus.gain_xp.emit(30)
	print("gain xp emitted")
