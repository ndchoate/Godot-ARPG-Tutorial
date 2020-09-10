extends Area2D

const HitEffect = preload("res://Effects/HitEffect.tscn")

# Invincibility is for dealing with when we have an enemy/player that isn't going 
# in/out of the hurtbox, but should still be hurting. Or when an enemy/player is
# going in and out of the hurtbox very fast
var invincible = false setget set_invincible

onready var timer = $Timer

signal invincibility_started
signal invincibility_ended


func set_invincible(value):
    invincible = value
    if invincible:
        emit_signal("invincibility_started")
    else:
        emit_signal("invincibility_ended")


func start_invincibility(duration):
    self.invincible = true
    timer.start(duration)


func create_hit_effect():
    # show_hit can be unset on objects with Hurtboxes that we don't want the HitEffect
    # to be present (e.g. the grass)
    var effect = HitEffect.instance()
    var main = get_tree().current_scene
    main.add_child(effect)
    effect.global_position = global_position - Vector2(0, 8)  # Giving a bit of an offset


func _on_Timer_timeout():
    # Have to call with self. keyword because that's the only way you can call the
    # setter method from inside the class
    self.invincible = false

# When invincibility starts, it makes us unmonitorable. This means that the hurtbox
# is disabled (it will not be checking the Layer again)
func _on_Hurtbox_invincibility_started():
    # This will make it so that this attribute isn't changed until the end of the
    # game loop
    set_deferred("monitorable", false)


# When invincibility ends, it makes us monitorable. This means that the hurtbox
# is enabled again (it will be checking the Layer again)
func _on_Hurtbox_invincibility_ended():
    # This will make it so that this attribute isn't changed until the end of the
    # game loop
    set_deferred("monitorable", true)

