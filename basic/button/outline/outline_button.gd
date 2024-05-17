@tool
extends DefaultButton
class_name OutlineButton

func _load_defaults():
    property_list[0]["class_name"] = "OutlineButton"
    property_list[0]["name"] = "OutlineButton"
    
    colors.button = [Color.TRANSPARENT, Color.TRANSPARENT]
    colors.button_hover[1] = Color.WHITE
    colors.text_hover = [Color("#414141"), colors.text[0]]
    colors.border = [Color("#a5a5a5"), Color("#cccccc")]
    colors.border_hover = [Color.BLACK, colors.border[0]]
    colors.shadow_size = [0, 0]
    
    text = "Outline Button"
