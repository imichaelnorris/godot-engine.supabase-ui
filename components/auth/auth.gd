@tool
class_name SupabaseAuthPanel
extends PanelContainer

signal signed_in(user)
signal signed_up(user)
signal magic_link_send()
signal instructions_send()
signal error(error)

@onready var sign_in_box: VBoxContainer = $Container/SignIn
@onready var sign_up_box: VBoxContainer = $Container/SignUp
@onready var forgot_password_box: VBoxContainer = $Container/ForgotPassword
@onready var with_magic_link_box: VBoxContainer = $Container/WithMagicLink

@onready var sign_in_error_lbl: SErrorLabel = sign_in_box.get_node("ErrorLbl")
@onready var sign_up_error_lbl: SErrorLabel = sign_up_box.get_node("ErrorLbl")
@onready var forgot_password_error_lbl: SErrorLabel = forgot_password_box.get_node("ErrorLbl")
@onready var magic_link_error_lbl: SErrorLabel = with_magic_link_box.get_node("ErrorLbl")

@export var app_name: String = "":
	set = set_app_name

var remember_me: bool = false

func _load_boxes():
	
	sign_in_box.show()
	sign_up_box.hide()
	forgot_password_box.hide()
	with_magic_link_box.hide()

func load_user() -> void:
	if Engine.is_editor_hint(): return
	var file: FileAccess = FileAccess.open_encrypted_with_pass("user://user.data", FileAccess.READ, OS.get_unique_id())
	if file == null:
		remember_me = false
	else:
		var content: Dictionary = JSON.parse_string(file.get_as_text())
		remember_me = content.get("remember_me", false)
		$Container/SignIn/HBoxContainer/Checkbox.set_toggled(remember_me)
		$Container/SignIn/EmailAddress.set_text(content.get("email", ""))
		$Container/SignIn/Password.set_text(content.get("pwd", ""))
		file.close()

func save_user() -> void:
	if not remember_me: return
	var file: FileAccess = FileAccess.open_encrypted_with_pass("user://user.data", FileAccess.WRITE, OS.get_unique_id())
	if file == null:
		remember_me = false
	else:
		var content: Dictionary = {
			remember_me = remember_me,
			email = $Container/SignIn/EmailAddress.get_text(),
			pwd = $Container/SignIn/Password.get_text()
		   }
		file.store_string(JSON.stringify((content)))
		file.close()

func _ready():
	add_to_group("supabase_components")
	_load_boxes()
	load_user()
	await Supabase.ready
	Supabase.auth.connect("error", _on_auth_error)

func _on_auth_error(error):
	printerr(error)

func set_app_name(_name: String) -> void:
	app_name = _name
	$Container/Label.set_text(app_name)

# =========== SIGN IN ==================
func _on_SignInBtn_pressed():
	sign_in_error_lbl.hide()
	_force_resize()
	var user_mail: String = $Container/SignIn/EmailAddress/Container/InputContainer/Box/Text.get_text()
	var user_pwd: String = $Container/SignIn/Password/Container/InputContainer/Box/Text.get_text()
	if user_mail == "" or user_pwd == "":
		show_sign_in_error("You must provide either an email/password combination or a third-party provider.")
		return
	var sign_in: AuthTask = await Supabase.auth.sign_in(user_mail, user_pwd).completed
	if sign_in.error:
		show_sign_in_error(str(sign_in.error))
		return
	save_user()
	signed_in.emit(sign_in.user)

func show_sign_in_error(message: String):
	sign_in_error_lbl.set_text(message)
	sign_in_error_lbl.show()
	emit_signal("error", message)

# =========== SIGN UP ==================
func _on_SignUpBtn_pressed():
	sign_up_error_lbl.hide()
	_force_resize()
	var user_mail: String = $Container/SignUp/EmailAddress/Container/InputContainer/Box/Text.text
	var user_pwd: String = $Container/SignUp/Password/Container/InputContainer/Box/Text.text
	if user_mail == "" or user_pwd == "":
		show_sign_up_error("You must provide either an email/password combination or a third-party provider.")
		return
	var sign_up: AuthTask = await Supabase.auth.sign_up(user_mail, user_pwd).completed
	if sign_up.error:
		show_sign_up_error(str(sign_up.error))
		return
	save_user()
	emit_signal("signed_up", sign_up.user)

func show_sign_up_error(message: String):
	sign_up_error_lbl.set_text(message)
	sign_up_error_lbl.show()
	emit_signal("error", message)

# =========== FORGOT PASSWORD ==================
func _on_SendInstructionsBtn_pressed():
	forgot_password_error_lbl.hide()
	_force_resize()
	var user_mail: String = $Container/ForgotPassword/EmailAddress.get_text()
	if user_mail == "":
		show_forgot_password_error("You must provide a mail to send the link to.")
		return
	var forgot_pwd: AuthTask = await Supabase.auth.reset_password_for_email(user_mail).completed
	if forgot_pwd.error:
		show_forgot_password_error(str(forgot_pwd.error))
		return
	emit_signal("instructions_send")

func show_forgot_password_error(message: String):
	forgot_password_error_lbl.set_text(message)
	forgot_password_error_lbl.show()
	emit_signal("error", message)

# =========== MAGIC LINK ==================
func _on_SendLinkBtn_pressed():
	magic_link_error_lbl.hide()
	_force_resize()
	var user_mail: String = $Container/WithMagicLink/EmailAddress.get_text()
	if user_mail == "":
		show_magic_link_error("You must provide a mail to send the link to.")
		return
	var magic_link: AuthTask = await Supabase.auth.send_magic_link(user_mail).completed
	if magic_link.error:
		show_magic_link_error(str(magic_link.error))
		return
	emit_signal("magic_link_send")

func show_magic_link_error(message: String):
	magic_link_error_lbl.set_text(message)
	magic_link_error_lbl.show()
	emit_signal("error", message)

# ================================================

func _on_ForgotPassword_pressed():
	sign_in_box.hide()
	forgot_password_box.show()
	_force_resize()

func _on_MagicLink_pressed():
	sign_in_box.hide()
	with_magic_link_box.show()
	_force_resize()

func _on_SignUp_pressed():
	sign_in_box.hide()
	sign_up_box.show()
	_force_resize()

func _on_SignIn_pressed():
	sign_in_box.show()
	sign_up_box.hide()
	_force_resize()

func _on_BackToSignIn_pressed():
	sign_in_box.show()
	forgot_password_box.hide()
	_force_resize()

func _on_SignWithPassword_pressed():
	sign_in_box.show()
	with_magic_link_box.hide()
	_force_resize()

func _force_resize():
	hide()
	show()

func _on_Checkbox_toggled(toggle):
	remember_me = toggle
