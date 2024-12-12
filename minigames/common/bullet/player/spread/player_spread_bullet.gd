class_name PlayerSpreadBullet
extends Bullet

# Would be cool to have piercing bullets in a later project

func _on_player_hitbox_area_entered(area: Area2D) -> void:
	queue_free()
