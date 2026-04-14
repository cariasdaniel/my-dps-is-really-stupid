extends Node
class_name AudioManager

@onready var songs = {
	ScenePaths.intro: "res://assets/bgm/8Bit Pack/Track01/Track01.mp3",
	ScenePaths.main: "res://assets/bgm/8Bit Pack/Track02/Track02.mp3",
	ScenePaths.gameOver: "res://assets/bgm/8Bit Pack/Track03/Track03.mp3",
	ScenePaths.gameWin: "res://assets/bgm/8Bit Pack/Track04/Track04.mp3",
}

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	SignalBus.on_master_volume_changed.connect(_change_master_volume)
	SignalBus.on_music_volume_changed.connect(_change_music_volume)
	SignalBus.on_sfx_volume_changed.connect(_change_sfx_volume)
	
	SceneChanger.scene_changed.connect(_pick_scene_music)
	
func _change_master_volume(value: float):
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
func _change_music_volume(value: float):
	var bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
func _change_sfx_volume(value: float):
	var bus_index = AudioServer.get_bus_index("SFX")
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
		
func _pick_scene_music(scene_path):
	var music = songs.get(scene_path)
	if !music: pass #KEEP PLAYING MUSIC FORM BEFORE, FROM SAME POINT
	else: 
		audio_player.stream = load(music)
		audio_player.play()
