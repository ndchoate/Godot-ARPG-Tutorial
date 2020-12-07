# Grabbed this code from a short video on a little arrow game someone made
# with Godot:
#   https://www.youtube.com/watch?v=3gHdnF1FZ1w
extends Area2D

# Tweak this as you wish
export var mass = 0.25

var launched = false
var velocity = Vector2(0, 0)


func _ready():
    pass
    

func _process(delta):
    if launched:
        velocity += gravity_vec * gravity * mass
        position += velocity * delta
        rotation = velocity.angle()
        

func launch(initial_velocity : Vector2):
    launched = true
    velocity = initial_velocity
