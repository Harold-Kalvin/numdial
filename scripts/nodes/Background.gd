extends TextureRect


func _ready():
    if texture:
        rect_size = get_viewport().get_visible_rect().size