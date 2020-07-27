extends Node2D

signal pressed

var num = 0
var already_pressed = false

var _default_upscale
var _default_downscale


func _ready():
    $ClickArea.connect("input_event", self, "_on_click_area_input_event")
    _default_upscale = $BackCircle.scale
    _default_downscale = $FrontCircle.scale
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


func animate_scale_up(duration: float = 0.2):
    if $FrontCircle.scale != _default_upscale:
        already_pressed = true
        $FrontCircleScaleTween.interpolate_property($FrontCircle, "scale", $FrontCircle.scale, _default_upscale, duration, Tween.TRANS_QUINT, Tween.EASE_IN)
        $FrontCircleScaleTween.start()
        yield($FrontCircleScaleTween, "tween_completed")
        return
    yield(get_tree(), "idle_frame")


func animate_scale_down(duration: float = 0.2):
    if $FrontCircle.scale != _default_downscale:
        already_pressed = false
        $FrontCircleScaleTween.interpolate_property($FrontCircle, "scale", $FrontCircle.scale, _default_downscale, duration, Tween.TRANS_QUINT, Tween.EASE_IN)
        $FrontCircleScaleTween.start()
        yield($FrontCircleScaleTween, "tween_completed")
        return
    yield(get_tree(), "idle_frame")


func animate_move(new_pos: Vector2, duration: float = 0.5):
    if self.position != new_pos:
        $MoveTween.interpolate_property(self, "position", self.position, new_pos, duration, Tween.TRANS_QUINT, Tween.EASE_OUT)
        $MoveTween.start()
        yield($MoveTween, "tween_completed")
        return
    yield(get_tree(), "idle_frame")


func _on_click_area_input_event(_viewport, event, _shape_idx):
    if event is InputEventScreenTouch:
        if event.pressed:
            emit_signal("pressed", self)
