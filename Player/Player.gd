extends KinematicBody2D

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var ROLL_SPEED = 125
export var FRICTION = 500

# Create the state machine
enum {
	MOVE,
	ROLL,
	ATTACK
}

var state = MOVE
var velocity = Vector2.ZERO

# Don't want it to start at ZERO because you don't want to be able to roll in
# place. We start out facing down, so init with that
var roll_vector = Vector2.DOWN

# Grab the global singleton, PlayerStats
var stats = PlayerStats

onready var hurtbox = $Hurtbox

# onready variables are instantiated when the node and all of its children are
# loaded in to the scene
# The $ is used to reference different nodes in the scene
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree

# This is setting animationState to be equal to Parameters -> Playback property,
# which is AnimationNodeState. That is essentially what you have set up in the
# bottom pane when you click on "AnimationTree" node
onready var animationState = animationTree.get("parameters/playback")

onready var swordHitbox = $HitboxPivot/SwordHitbox

func _ready():
	# Apply the play stats
	stats.connect("no_health", self, "queue_free")
	
	# Animation tree won't be active until the game actually starts
	animationTree.active = true
	
	# Add knockback from the sword
	swordHitbox.knockback_vector = roll_vector


func _physics_process(delta):
	# This is basically a switch-case statement, except that with match statements,
	# you can have variables as the cases as well
	match state:
		MOVE:
			move_state(delta)
			
		ROLL:
			roll_state(delta)
			
		ATTACK:
			attack_state(delta)


func move_state(delta):
	# IMPORTANT! Basically, delta is used to take your physics measurements from
	#	being based on frames (pixels / frame) to (distance / sec). delta will be
	#	a fraction (something like 1/60)
	var input_vector = Vector2.ZERO
	
	# Think of the math here as you're moving a joystick and it's creating a vector
	# on a grid
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# normalized() will not change the instance, it will just return a normalized
	# version of that instance
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		# Again, want to avoid rolling in place
		roll_vector = input_vector
		
		# This will make it so that our knockback vector is going to be the same 
		# as the direction we're moving in
		swordHitbox.knockback_vector = input_vector
		
		# Set your blend position ere. To find the property name to pass in here, go to
		# AnimationTree -> Right Pane -> Parameters -> Hover over "Blend Position"
		# for one of your blends
		animationTree.set("parameters/Idle/blend_position", input_vector)
		animationTree.set("parameters/Run/blend_position", input_vector)
		
		# Setting the blend position in here makes it so that our character will
		# be stuck in a position once they dedicate to an attack
		animationTree.set("parameters/Attack/blend_position", input_vector)
		animationTree.set("parameters/Roll/blend_position", input_vector)
		
		# Set our animation at this point in time to be "Run" (this is what we 
		# defined in the AnimationTree as a BlendSpace2D)
		animationState.travel("Run")
		
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else:
		animationState.travel("Idle")
		# This adds friction for when we stop moving
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)

	# Setting this equal to velocity will allow us to remember the velocity we had
	# before the collision and properly handle that
	move()
	
	if Input.is_action_just_pressed("roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK


func attack_state(delta):
	# setting the velocity to zero will make it so we don't slide after we attack
	velocity = Vector2.ZERO
	animationState.travel("Attack")


func attack_animation_finished():
	state = MOVE


func roll_state(delta):
	velocity = roll_vector * ROLL_SPEED
	animationState.travel("Roll")
	move()


func roll_animation_finished():
	# to reduce the sliding, you can lower the velocity once the animation finishes
	velocity = velocity * .75
	state = MOVE


func move():
	velocity = move_and_slide(velocity)


func _on_Hurtbox_area_entered(area):
	stats.health -= 1
	hurtbox.start_invincibility(0.5)
	hurtbox.create_hit_effect()
