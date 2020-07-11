extends Node

const ASPECT_X = 9
const ASPECT_Y = 16

var size = Vector2()
var main_block_size = Vector2()
var main_block_position = Vector2()


func _ready():
    size = get_viewport().get_visible_rect().size
    
    # set main_block_size
    if ASPECT_X <= ASPECT_Y:
        if size.x >= size.y:
            main_block_size.y = size.y
            main_block_size.x = ASPECT_X * main_block_size.y / ASPECT_Y
        else:
            main_block_size.x = size.x
            main_block_size.y = ASPECT_Y * main_block_size.x / ASPECT_X
    else:
        if size.x <= size.y:
            main_block_size.x = size.x
            main_block_size.y = ASPECT_Y * main_block_size.x / ASPECT_X
        else:
            main_block_size.y = size.y
            main_block_size.x = ASPECT_X * main_block_size.y / ASPECT_Y
            
    # set main_block_position from main_block_size
    if main_block_size.y == size.y:
        main_block_position.x = size.x / 2 - main_block_size.x / 2
    if main_block_size.x == size.x:
        main_block_position.y = size.y / 2 - main_block_size.y / 2
