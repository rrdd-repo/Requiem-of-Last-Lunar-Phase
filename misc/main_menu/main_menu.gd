class_name MainMenu
extends Control


func _on_play_pressed() -> void:
	SceneManager.change_scene("res://vn/days/day1/vn_day1.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_credits_pressed() -> void:
	SceneManager.change_scene("res://misc/main_menu/credits_scene.tscn")
