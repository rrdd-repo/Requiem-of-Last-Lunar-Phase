class_name MinigameDay4
extends Node2D

func _ready() -> void:
	MinigameScoreManager._score_label = $CanvasLayer/ScoreLabel
	await get_tree().create_timer(8).timeout
	%TutorialLabel.hide()

func _process(delta: float) -> void:
	if MinigameScoreManager._score >= 150:
		%TutorialLabel.text = str(200 - MinigameScoreManager._score)+ " more to go!"
		%TutorialLabel.show()
		
	if Input.is_action_just_pressed("restart"):
		MinigameScoreManager._score = 0
		get_tree().reload_current_scene()
	
