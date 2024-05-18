@tool
class_name SPopup
extends PopupPanel
const Mode = preload ("res://addons/supabase-ui/theme/theme.gd").Mode

signal pressed()

const colors: Dictionary = {
	"panel": [Color.WHITE, Color("#2a2a2a")]
   }

func _ready():
	add_to_group("supabase_components")

func set_mode(_mode: int):
	super.set_mode(_mode)
	add_theme_color_override("bg_color", colors.panel[mode])

func _force_resize():
	hide()
	show()

func _on_Panel_gui_input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 1 and event.is_pressed():
			emit_signal("pressed")
