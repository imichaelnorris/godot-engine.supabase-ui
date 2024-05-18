@tool
extends VBoxContainer
class_name SCheckBox
const Mode = preload ("res://addons/supabase-ui/theme/theme.gd").Mode

signal pressed()
signal released()
signal toggled(toggle)
signal hover()

@export var mode: Mode = Mode.LIGHT_MODE: set = set_mode

var colors: Dictionary = {
    "text": [Color("#1F1F1F"), Color.WHITE],
    "description": [Color("#666666"), Color("#BBBBBB")],
    "border": [Color.FLORAL_WHITE, Color.FLORAL_WHITE],
    "border_hover": [Color.WHITE, Color.WHITE]
   }

var font_size: int = 15: set = set_font_size

var text: String = "": set = set_text
var description: String = "Description": set = set_description
var show_description: bool = false: set = set_show_description
var is_pressed: bool = false: set = set_pressed
var pressing: bool = false

var property_list: Array = [
    {
        "class_name": "SChekBox",
        "hint": PROPERTY_HINT_NONE,
        "usage": PROPERTY_USAGE_CATEGORY,
        "name": "SCheckBox",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_GROUP,
        "name": "Contents",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "text",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "pressed",
        "type": TYPE_BOOL
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "show_description",
        "type": TYPE_BOOL
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "description",
        "type": TYPE_STRING
    },
    {
        "usage": PROPERTY_USAGE_DEFAULT|PROPERTY_USAGE_SCRIPT_VARIABLE,
        "name": "font_size",
        "type": TYPE_INT
    }
]

func _get_property_list():
    return property_list

func _load_defaults():
    pass

func _connect_signals():
    $CheckboxContainer/CheckBox.connect("mouse_entered", _on_focus_entered)
    $CheckboxContainer/CheckBox.connect("mouse_exited", _on_focus_exited)

func _ready():
    _connect_signals()
    _load_defaults()
    set_mode(mode)
    set_text(text)
    set_pressed(is_pressed)
    add_to_group("supabase_components")

func set_text(_text: String) -> void:
    text = _text
    if has_node("CheckboxContainer/Text"):
        get_node("CheckboxContainer/Text").set_text(_text)

func set_pressed(_pressed: bool) -> void:
    
    is_pressed = _pressed
    if has_node("CheckboxContainer/CheckBox"):
        get_node("CheckboxContainer/CheckBox").pressed = pressed

func get_text() -> String:
    return $CheckboxContainer/Text.get_text()

func set_description(_text: String) -> void:
    description = _text
    if has_node("Description"):
        get_node("Description").set_text(_text)

func set_text_color(_color: Color) -> void:
    if has_node("CheckboxContainer/Text"):
        get_node("CheckboxContainer/Text").modulate = _color

func set_name_color(_color: Color) -> void:
    $CheckboxContainer/Text.modulate = _color

func set_description_color(_color: Color) -> void:
    if has_node("Description"):
        get_node("Description").modulate = _color

func get_description_color() -> Color:
    if has_node("Description"):
        return get_node("Description").modulate
    else:
        return colors.description[mode]

func set_mode(_mode: int) -> void:
    mode = _mode
    set_text_color(colors.text[mode])
    set_description_color(colors.description[mode])
    set_border(colors.border[mode])

func set_border(_color: Color) -> void:
    $CheckboxContainer/CheckBox.modulate = _color

func get_border() -> Color:
    return $CheckboxContainer/CheckBox.modulate

func set_font_size(_size: int) -> void:
    font_size = _size
    get("theme").get("default_font").set("size", _size)

func set_show_description(_value: bool):
    show_description = _value
    if has_node("Description"): get_node("Description").visible = _value

func _on_focus_entered():
    var tween = get_tree().create_tween()
    tween.tween_method(set_border, get_border(), colors.border_hover[mode], 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
    tween.start()

func _on_focus_exited():
    if $CheckboxContainer/CheckBox.pressed: return
    var tween = get_tree().create_tween()
    tween.tween_method(set_border, get_border(), colors.border[mode], 0.2).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
    tween.start()

func set_toggled(toggled: bool) -> void:
    $CheckboxContainer/CheckBox.pressed = toggled

func _on_CheckBox_toggled(button_pressed):
    emit_signal("toggled", button_pressed)
