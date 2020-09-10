extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 50
export var FRICTION = 200
export var WANDER_TOLERANCE = 4

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
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer


func _ready():
    state = pick_random_state([IDLE, WANDER])


func _physics_process(delta):
    # Add some friction (compare to player script)
    knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
    
    knockback = move_and_slide(knockback)
    
    match state:
        IDLE:
            velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
            seek_player()
            
            if wanderController.get_time_left() == 0:
                update_wander()
        WANDER:
            seek_player()
            if wanderController.get_time_left() == 0:
                update_wander()
                
            accelerate_towards_point(wanderController.target_position, delta)
            
            if global_position.distance_to(wanderController.target_position) <= WANDER_TOLERANCE:
                update_wander()
            
        CHASE:
            var player = playerDetectionZone.player
            if player != null:
                accelerate_towards_point(player.global_position, delta)
            else:
                state = IDLE
            
            
    
    if softCollision.is_colliding():
        # The higher the value at the end is determines how likely they are to
        # overlap with each other at all
        velocity += softCollision.get_push_vector() * delta * 400
    
    velocity = move_and_slide(velocity)


func update_wander():
    state = pick_random_state([IDLE, WANDER])
    wanderController.start_wander_timer(rand_range(1, 3))


func accelerate_towards_point(point, delta):
    # This gives us the difference between our player and the bat,
    # and we normalize it for our calculations
    var direction = global_position.direction_to(point)
    
    # We then use the normalized direction vector with MAX_SPEED to 
    # figure out where to go
    velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

    # This will make it so that the bat properly faces us while chasing us
    sprite.flip_h = velocity.x < 0

func seek_player():
    if playerDetectionZone.can_see_player():
        state = CHASE


func pick_random_state(state_list):
    state_list.shuffle()
    return state_list.pop_front()


func _on_Hurtbox_area_entered(area):
    # area is the Hitbox scene (SwordHitbox, in this case)
    stats.health -= area.damage
    knockback = area.knockback_vector * 150
    hurtbox.create_hit_effect()
    hurtbox.start_invincibility(0.4)


func _on_Stats_no_health():
    queue_free()
    var enemyDeathEffect = EnemyDeathEffect.instance()
    get_parent().add_child(enemyDeathEffect)
    enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
    animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
    animationPlayer.play("Stop")
