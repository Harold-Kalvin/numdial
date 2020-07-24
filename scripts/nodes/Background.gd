extends TextureRect

onready var screen = $"/root/Screen"


func _ready():
    if texture:
        rect_size = screen.size