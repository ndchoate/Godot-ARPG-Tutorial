extends Node2D

# Why can't you just do $SaveAndLoadUtils here? It's null if you try that
onready var SaveAndLoadUtils = $"/root/SaveAndLoadUtils"


func _ready():
    # TODO: call load function
    pass


func _input(event):
    if event.is_action_pressed("save_game"):
        SaveAndLoadUtils.save_game()
    if event.is_action_pressed("load_game"):
        SaveAndLoadUtils.load_game()
