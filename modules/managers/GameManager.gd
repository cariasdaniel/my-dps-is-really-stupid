extends Node

@onready var main: Node = $".."

@onready var portal: PackedScene = preload("res://modules/portal/portal.tscn")

var seconds_to_spawn = 60.0
var base_sec = 60.0
@onready var next_portal_timer: Timer = $next_portal


func _ready():
	SignalBus.portal_destroyed.connect(_on_portal_destroyed)
	
	next_portal_timer.start()


func spawn_portal() -> void:
	# select location
	var position_to_spawn = Vector2(randi_range(0, 900), randi_range(0, 900))
	
	# spawn portal
	var p = portal.instantiate()
	p.global_position = position_to_spawn
	add_child(p)
	
	# adjust time to next spawn
	seconds_to_spawn = randf_range(max(1.0, base_sec - 1.0), max(3.0, base_sec))
	next_portal_timer.wait_time = seconds_to_spawn
	print("Next portal in %s seconds..." % seconds_to_spawn)
	next_portal_timer.start()
	base_sec -= 1.0


func _on_timer_to_portal_timeout() -> void:
	spawn_portal()
	

func _on_portal_destroyed() -> void:
	var portals = get_children().filter(func(p): return p is StaticBody2D)
	var living_portals = portals.filter(func(p): return p.current_hp > 0)
	if living_portals.is_empty():
		SceneChanger.change_to(ScenePaths.gameWin)
	
