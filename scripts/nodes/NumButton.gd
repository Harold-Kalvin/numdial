extends Node2D

var num_str = ""


func _ready():
    set_num()
    set_num_position()


func init(num):
    num_str = str(num)


func set_num():
    $Num.text = num_str


func set_num_position():
    var size = $Num.get_combined_minimum_size()
    var pos = $Num.rect_position
    $Num.rect_position = Vector2(pos.x - size.x / 2, pos.y - size.y / 2)
