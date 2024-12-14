extends CanvasLayer
signal new
func show_message(text):
	$Information.text = text
	$Information.show()
	
func _process(delta):
	if Input.is_action_pressed("Continue"):
		$Information.hide()
		new.emit()
