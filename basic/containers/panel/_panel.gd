@tool
class_name SPanel
extends PanelContainer
const Mode = preload ("res://addons/supabase-ui/theme/theme.gd").Mode

signal pressed()

const colors: Dictionary = {
    "panel": [Color.WHITE, Color("#2a2a2a")]
   }

@export var mode: Mode = Mode.LIGHT_MODE: set = set_mode

func _ready():
    add_to_group("supabase_components")

func set_mode(_mode: int):
    mode = _mode
    get("custom_styles/panel").set("bg_color", colors.panel[mode])

func _force_resize():
    hide()
    show()

func _on_Panel_gui_input(event):
    if event is InputEventMouseButton:
        if event.get_button_index() == 1 and event.is_pressed():
            emit_signal("pressed")
