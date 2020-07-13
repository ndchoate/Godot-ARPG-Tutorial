extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200

enum {
	IDLE,
	WANDER,
	CHASE
}

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

var state = IDLE

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision

func _ready():
	print(stats.max_health)
	print(stats.health)

func _physics_process(delta):
	# Add some friction (compare to player script)
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
			
		WANDER:
			pass
			
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				# This gives us the difference between our player and the bat,
				# and we normalize it for our calculations
				var direction = (player.global_position - global_position).normalized()
				
				# We then use the normalized direction vector with MAX_SPEED to 
				# figure out where to go
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			else:
				state = IDLE
			
			# This will make it so that the bat properly faces us while chasing us
			sprite.flip_h = velocity.x < 0
	
	if softCollision.is_colliding():
		# The higher the value at the end is determines how likely they are to
		# overlap with each other at all
		velocity += softCollision.get_push_vector() * delta * 400
	
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	# area is the Hitbox scene (SwordHitbox, in this case)
	stats.health -= area.damage
	knockback = area.knockback_vector * 150
	hurtbox.create_hit_effect()


func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
