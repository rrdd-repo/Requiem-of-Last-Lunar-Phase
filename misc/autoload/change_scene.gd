extends Node

var current_scene: Node = null

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func change_scene(path: String) -> void:
	# Call deferred to ensure this happens after the current frame
	call_deferred("_deferred_change_scene", path)

func _deferred_change_scene(path: String) -> void:
	# Clean up the current scene
	current_scene.free()

	# Load the new scene
	var new_scene = load(path)

	# Instance the new scene
	current_scene = new_scene.instantiate()

	# Add it to the active scene, as child of root
	get_tree().root.add_child(current_scene)

	# Optionally, set the current scene as the active one
	get_tree().current_scene = current_scene
