extends AnimatedSprite

func _ready():
    # Want to make sure that we start on the first frame before we animate
    connect("animation_finished", self, "_on_animation_finished")
    frame = 0
    play("Animate")

# Sometimes this can be useful for debugging
#func _process(delta):
#	if Input.is_action_just_pressed("attack"):
#		animatedSprite.frame = 0
#		animatedSprite.play("Animate")


func _on_animation_finished():
    # When the animation finishes, this grass effect will destroy itself
    queue_free()
