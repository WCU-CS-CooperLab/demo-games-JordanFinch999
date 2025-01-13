extends ColorRect

signal answered(is_answer_correct)


@export_file var questions_database = "res://05.online-quiz/QuizQuestions.json"

@onready var answer_container = $Answers
@onready var question_label = $QuestionLabel

var questions = {}
var available_questions = []
var correct_answer = 0

func _ready():
	var questions_as_text = FileAccess.open(questions_database, FileAccess.READ).get_as_text()
	questions = JSON.parse_string(questions_as_text)
	for question in questions:
		available_questions.append(question)
	connect_answer_buttons()
	lock_answers()


func lock_answers():
	pass


func unlock_answers():
	pass


@rpc
func update_winner(winner_name):
	pass


@rpc
func player_missed(loser_name):
	pass


@rpc
func update_question(new_question_index):
	pass


func connect_answer_buttons():
	for button in answer_container.get_children():
		button.pressed.connect(_on_answer_button_pressed.bind(button.get_index()))


func evaluate_answer(answer_index):
	pass


func _on_answer_button_pressed(button_index):
	evaluate_answer(button_index)
