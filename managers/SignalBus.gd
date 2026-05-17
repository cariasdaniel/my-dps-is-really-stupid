extends Node

# Cursor Controller
signal hover_over

# Effect Manager
signal apply_effect
signal apply_effect_on_range

# Progression
signal level_up

# Skills Hotbar
#signal skill_selected(skill)
signal skill_slot_pressed(slot_index)
signal slot_has_skill
#signal add_effect(effect) # apply skill effects in entity
signal activate_skill(skill, cooldown)
signal learn_skill(skill)
signal update_skills_ui(known_skills)

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
signal update_health_bar(entity, value)
signal update_mana_bar(entity, value)

# Audio
signal on_master_volume_changed
signal on_music_volume_changed
signal on_sfx_volume_changed

# EndGame
signal game_over
signal game_win
