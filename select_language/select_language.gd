extends Control

@onready var continue_button: Button = $ContinueButton


func _on_select_english_pressed() -> void:
	TranslationServer.set_locale('en_us')
	continue_button.translate_text()


func _on_select_portuguese_pressed() -> void:
	TranslationServer.set_locale('pt_br')
	continue_button.translate_text()


func _on_continue_button_pressed() -> void:
	SceneChanger.change_to(ScenePaths.intro)
