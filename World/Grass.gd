extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
    # Best practices is capitalized camel case for the Scene itself and
    # lower-case camel case for the instance
    var grassEffect = GrassEffect.instance()
    
    # Gets the current main scene from our scene tree
    # var world = get_tree().current_scene
    
    # Add the grass effect and a child node programmatically
    get_parent().add_child(grassEffect)
    
    # global_position here is the global_position of the Grass, since we're
    # in the Grass node's script
    grassEffect.global_position = global_position


func _on_Hurtbox_area_entered(area):
    create_grass_effect()
    queue_free()
