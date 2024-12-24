extends CanvasLayer
signal new
var can_start_game = true
func show_message(text):
	$Information.text = text
	$Information.show()
	
func _process(delta):
	if Input.is_action_pressed("Continue"):
		$Information.hide()
		if can_start_game:
			new.emit()
			can_start_game = false
		else:
			pass
