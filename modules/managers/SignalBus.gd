extends Node

# Cursor Controller
signal hover_over

# Effect Manager
signal apply_effect
signal apply_effect_on_range

# Progression
signal level_up

# Skills Hotbar
signal skill_selected(skill)

# Player management
signal gain_xp(value)
signal change_health(entity, value)
signal change_mana(entity, value)
signal deal_damage(entity, value)
signal died

# DPS behavior management
signal force_transitioned(new_state, options)
signal interrupt

# Portal management
signal portal_destroyed

# UI management
signal update_xp_info
signal update_resource_bars

# Audio
signal on_master_volume_changed
signal on_music_volume_changed
signal on_sfx_volume_changed

# EndGame
signal game_over
signal game_win
