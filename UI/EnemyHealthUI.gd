extends Control


var hearts = 3 setget set_hearts
var max_hearts = 3 setget set_max_hearts

var TEXTURE_WIDTH = 15

onready var heartUIFull = $EnemyHeartUIFull
onready var heartUIEmpty = $EnemyHeartUIEmpty


func adjust_health_ui_size():
    var size = Vector2(TEXTURE_WIDTH * max_hearts, TEXTURE_WIDTH)
    set_size(size)


func set_hearts(value):
    # Clamp it so that value is never < 0 or > max_hearts
    hearts = clamp(value, 0, max_hearts)
    if heartUIFull:
        # The heart full texture is 15 pixels wide, so the number of hearts that
        # we will display is hearts * 15
        heartUIFull.rect_size.x = hearts * TEXTURE_WIDTH


func set_max_hearts(value):
    max_hearts = max(value, 1)
    self.hearts = min(hearts, max_hearts)  # hearts can never be larger than max_hearts
    adjust_health_ui_size()
    if heartUIEmpty:
        heartUIEmpty.rect_size.x = max_hearts * TEXTURE_WIDTH


#func _ready():
#    self.max_hearts = PlayerStats.max_health
#    self.hearts = PlayerStats.health
#
#    # Pass the argument sent with the signal into set_hearts
#    PlayerStats.connect("health_changed", self, "set_hearts")
#    PlayerStats.connect("max_health_changed", self, "set_max_hearts")
