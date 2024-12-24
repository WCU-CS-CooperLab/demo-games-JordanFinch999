extends CanvasLayer
signal start_game
func update_score(value):
	$MarginContainer/Score.text = str(value)
func update_timer(value):
	$MarginContainer/Time.text = str(value)
func show_message(text):
	$Message.text = text
	$Message.show()
	

func _on_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$Message.hide()
	start_game.emit()
	$Controls/Information.show()
	
func show_game_over():
	show_message("Game Over")
	
func _process(delta):
	if Input.is_action_pressed("Continue"):
		$Controls/Information.hide()
