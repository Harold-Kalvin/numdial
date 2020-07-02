extends Node2D

signal pressed

var num = 0
var animating = false


func _ready():
    $ClickArea.connect("input_event", self, "_on_click_area_input_event")

    set_num()
    set_num_position()


func init(num_arg):
    num = num_arg


func set_num():
    $Num.text = str(num)


func set_num_position():
    var size = $Num.get_combined_minimum_size()
    var pos = $Num.rect_position
    $Num.rect_position = Vector2(pos.x - size.x / 2, pos.y - size.y / 2)


func animate_click():
    if not animating:
        # scale up front circle
        if $FrontCircle.scale != $BackCircle.scale:
            animating = true
            $FrontCircleScaleTween.interpolate_property($FrontCircle, "scale", $FrontCircle.scale, $BackCircle.scale, 0.2, Tween.TRANS_QUINT, Tween.EASE_IN)
            $FrontCircleScaleTween.start()
            yield($FrontCircleScaleTween, "tween_completed")
            animating = false


func _on_click_area_input_event(_viewport, event, _shape_idx):
    if event is InputEventScreenTouch:
        if event.pressed:
            emit_signal("pressed", self)
