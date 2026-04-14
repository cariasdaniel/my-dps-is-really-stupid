extends Node

# Cursor Controller
signal hover_over

# Effect Manager
signal apply_effect
signal apply_effect_on_range

# Skills Hotbar
signal skill_selected(skill)

# Player management
signal gain_xp(value)
signal change_health(value)
signal change_mana(value)

# DPS behavior management
signal force_transitioned(new_state, options)
signal interrupt

# UI management
signal update_xp_info

# Audio
signal on_master_volume_changed
signal on_music_volume_changed
signal on_sfx_volume_changed

# EndGame
signal game_over
signal game_win
