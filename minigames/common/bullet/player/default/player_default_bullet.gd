class_name PlayerDefaultBullet
extends Bullet

@onready var _sprite_group = %SpriteGroup

func _ready() -> void:
	super._ready()
	
	var tween = get_tree().create_tween()
	
	tween.tween_property(
		_sprite_group,
		"scale",
		Vector2.ZERO,
		_bullet_data._lifespan / 4
	).set_delay(
		3 * _bullet_data._lifespan / 4
	)
