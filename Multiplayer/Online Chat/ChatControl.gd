extends Control


@onready var label = $ScrollContainer/Label
@onready var line_edit = $LineEdit
@onready var container = $ScrollContainer

var avatar_name = "John"


func _ready():
	line_edit.grab_focus()


func add_message(_avatar_name, message):
	pass


@rpc
func set_avatar_name(new_avatar_name):
	avatar_name = new_avatar_name
