extends AudioStreamPlayer


func _ready():
    # Creating this scene will allow the sound to play, even if the player dies
    connect("finished", self, "queue_free")
