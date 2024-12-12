extends Node

var _score: int = 0
var _score_label: Label

func add_score(amount: int) -> void:
	_score += amount
	update_score_label()

func update_score_label() -> void:
	_score_label.text = "Score: " + str(_score)
