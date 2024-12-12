class_name MinigameDay2
extends Node2D

func _ready() -> void:
	MinigameScoreManager._score_label = $CanvasLayer/ScoreLabel
	await get_tree().create_timer(8).timeout
	%TutorialLabel.queue_free()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		MinigameScoreManager._score = 0
		get_tree().reload_current_scene()  # Reloads the current scene
