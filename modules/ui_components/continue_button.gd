extends Button

@onready var label_text: RichTextLabel = $LabelText

func _ready():
	translate_text()

func show_text():
	var tween = create_tween()
	show()
	tween.tween_property(self, "modulate:a", 1.0, 2.0)

func translate_text():
	label_text.text = "[pulse]" + tr("CONTINUE") + " >[/pulse]"
