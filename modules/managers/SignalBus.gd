extends Node

#Cursor Controller
signal hover_over

# Skills Hotbar
signal skill_selected(skill)

# Player management
signal gain_xp(value)
signal change_health(value)
signal change_mana(value)

# UI management
signal update_xp_info

# Audio
signal on_master_volume_changed
signal on_music_volume_changed
signal on_sfx_volume_changed

# EndGame
signal game_over
signal game_win
