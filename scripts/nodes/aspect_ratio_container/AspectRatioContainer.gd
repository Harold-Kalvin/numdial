extends Node2D

export(int, 1, 10000) var x = 9
export(int, 1, 10000) var y = 16

var screen_size = Vector2()
var size = Vector2()


func _ready():
    screen_size = get_viewport().get_visible_rect().size
    
    # set size
    if x <= y:
        if screen_size.x >= screen_size.y:
            size.y = screen_size.y
            size.x = x * size.y / y
        else:
            size.x = screen_size.x
            size.y = y * size.x / x
    else:
        if screen_size.x <= screen_size.y:
            size.x = screen_size.x
            size.y = y * size.x / x
        else:
            size.y = screen_size.y
            size.x = x * size.y / y
            
    # set position from size
    if size.y == screen_size.y:
        position.x = screen_size.x / 2 - size.x / 2
    if size.x == screen_size.x:
        position.y = screen_size.y / 2 - size.y / 2
