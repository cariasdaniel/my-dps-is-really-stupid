extends Node

func _ready():
	SignalBus.on_master_volume_changed.connect(_change_master_volume)
	SignalBus.on_music_volume_changed.connect(_change_music_volume)
	SignalBus.on_sfx_volume_changed.connect(_change_sfx_volume)
	
func _change_master_volume(value: float):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
func _change_music_volume(value: float):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
func _change_sfx_volume(value: float):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
