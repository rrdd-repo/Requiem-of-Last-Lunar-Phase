class_name MainMinigame
extends Control

@export var minigame_scene_dict: Dictionary = {
	"1": preload("res://minigames/day1/minigame_day1.tscn"),
	"2": preload("res://minigames/day2/minigame_day2.tscn"),
	"4": preload("res://minigames/day4/minigame_day_4.tscn")
}

@export var vn_scene_dict: Dictionary = {
	"1": "res://vn/days/day1/vn_day1.tscn",
	"2": "res://vn/days/day2/vn_day2.tscn",
	"4": "res://vn/days/day4/vn_day4.tscn"
}

var _subviewport: SubViewport
var current_day: String
var day1_timer: Timer
var day2_timer: Timer

func _ready() -> void:
	current_day = str(Dialogic.VAR.day)
	_subviewport = %SubViewport
	
	if minigame_scene_dict.has(current_day):
		var scene_instance = minigame_scene_dict[current_day].instantiate()
		_subviewport.add_child(scene_instance)
		
		match current_day:
			"1":
				setup_day1_timer()
			"2":
				setup_day2_timer()

func _process(delta: float) -> void:
	match current_day:
		"2":
			if MinigameScoreManager._score >= 10:
				change_to_vn_scene()
		"4":
			if MinigameScoreManager._score >= 200:
				MinigameScoreManager._score = 200
				change_to_vn_scene()

func setup_day1_timer() -> void:
	day1_timer = Timer.new()
	day1_timer.set_wait_time(10.0)
	day1_timer.set_one_shot(true)
	day1_timer.connect("timeout", Callable(self, "_on_day1_timer_timeout"))
	add_child(day1_timer)
	day1_timer.start()

func setup_day2_timer() -> void:
	day2_timer = Timer.new()
	day2_timer.set_wait_time(30.0)
	day2_timer.set_one_shot(true)
	day2_timer.connect("timeout", Callable(self, "_on_day2_timer_timeout"))
	add_child(day2_timer)
	day2_timer.start()

func _on_day1_timer_timeout() -> void:
	if current_day == "1":
		change_to_vn_scene()

func _on_day2_timer_timeout() -> void:
	if current_day == "2":
		change_to_vn_scene()

func change_to_vn_scene() -> void:
	if vn_scene_dict.has(current_day):
		SceneManager.change_scene(vn_scene_dict[current_day])
