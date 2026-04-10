extends CanvasLayer

@onready var tab_bar: TabBar = $MarginContainer/VBoxContainer/HBoxContainer/TabBar
@onready var v_box_container: VBoxContainer = $MarginContainer/VBoxContainer
@onready var panels = v_box_container.get_children()

enum tabs {GENERAL, AUDIO, GAMEPLAY, SHORTCUTS}

func _on_tab_bar_tab_changed(tab: int) -> void:
	var selected_tab = tab_bar.get_tab_title(tab)
	var panel_to_show = selected_tab + "Panel"
	for child in panels:
		if !(child is Panel):
			continue
		if child.name != panel_to_show:
			child.visible = false
		else:
			child.visible = true


func _on_close_button_pressed() -> void:
	get_tree().paused = false
	queue_free()


func _on_master_slider_value_changed(value: float) -> void:
	AudioManager._change_master_volume(value)

func _on_music_slider_value_changed(value: float) -> void:
	AudioManager._change_music_volume(value)

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioManager._change_sfx_volume(value)
