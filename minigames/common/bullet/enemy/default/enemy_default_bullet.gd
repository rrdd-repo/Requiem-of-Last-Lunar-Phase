class_name EnemyDefaultBullet
extends Bullet

func _ready() -> void:
	_direction = Vector2.LEFT.rotated(global_rotation)



func _on_enemy_hitbox_area_entered(area: Area2D) -> void:
	queue_free()
