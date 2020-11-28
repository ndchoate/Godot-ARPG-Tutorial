extends Control


var hearts = 3 setget set_hearts
var max_hearts = 3 setget set_max_hearts

var TEXTURE_WIDTH = 32

onready var heartUIFull = $EnemyHeartUIFull
onready var heartUIEmpty = $EnemyHeartUIEmpty


func adjust_health_ui_size():
    var percent_health = float(hearts) / float(max_hearts)
    var size = Vector2(TEXTURE_WIDTH * percent_health, TEXTURE_WIDTH)
    set_size(size)


func set_hearts(value):
    # Clamp it so that value is never < 0 or > max_hearts
    hearts = clamp(value, 0, max_hearts)
    if heartUIFull:
        var percent_health = float(hearts) / float(max_hearts)
        heartUIFull.rect_size.x = percent_health * TEXTURE_WIDTH


func set_max_hearts(value):
    max_hearts = max(value, 1)
    self.hearts = min(hearts, max_hearts)  # hearts can never be larger than max_hearts
    adjust_health_ui_size()
    if heartUIEmpty:
        var percent_health = float(hearts) / float(max_hearts)
        heartUIEmpty.rect_size.x = percent_health * TEXTURE_WIDTH
