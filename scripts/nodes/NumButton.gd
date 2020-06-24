extends Node2D

signal pressed

var num_str = ""


func _ready():
    $ClickArea.connect("input_event", self, "_on_click_area_input_event")

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


func _on_click_area_input_event(_viewport, event, _shape_idx):
    if event is InputEventScreenTouch:
        if event.pressed:
            emit_signal("pressed", self)
