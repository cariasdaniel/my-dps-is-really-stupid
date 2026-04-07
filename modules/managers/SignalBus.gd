extends Node

# Skills Hotbar
signal skill_selected(skill)

# Player management
signal gain_xp(value)
signal gain_level(new_level)

# UI management
signal update_xp_info

# Audio
signal on_master_volume_changed
signal on_music_volume_changed
signal on_sfx_volume_changed
