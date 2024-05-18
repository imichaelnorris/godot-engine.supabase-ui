@tool
extends DefaultButton
class_name TextButton

func _load_defaults():
	property_list[0]["class_name"] = "TextButton"
	property_list[0]["name"] = "TextButton"

	colors.text = [Color("#666666"), Color.WHITE]
	colors.button = [Color.TRANSPARENT, Color.TRANSPARENT]
	colors.button_hover = [Color("#1cb1b1b1"), Color("#1cb1b1b1")]
	colors.border = [Color.TRANSPARENT, Color.TRANSPARENT]
	colors.shadow_size = [0, 0]
	
	text = "Text Button"
