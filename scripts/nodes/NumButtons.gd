extends Node2D

onready var screen = $"/root/Screen"

const NUMBER_CHOICES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
const CIRCLE_RADIUS = 256
const CIRCLE_PER_WIDTH = 5
const CIRCLE_OFFSET_FACTOR = 1.4

var num_button = preload("res://scenes/NumButton.tscn")
var scaled_radius
var number_choices = []
var color_for_number = {
    0: "pink",
    1: "red",
    2: "orange",
    3: "yellow",
    4: "blue",
    5: "light_green",
    6: "light_violet",
    7: "green",
    8: "violet",
    9: "turquoise",
}
var gradients = {
    "pink": {
        1: preload("res://gradients/pink1.tres"),
        2: preload("res://gradients/pink2.tres"),
        3: preload("res://gradients/pink3.tres"),
    },
    "red": {
        1: preload("res://gradients/red1.tres"),
        2: preload("res://gradients/red2.tres"),
        3: preload("res://gradients/red3.tres"),
    },
    "orange": {
        1: preload("res://gradients/orange1.tres"),
        2: preload("res://gradients/orange2.tres"),
        3: preload("res://gradients/orange3.tres"),
    },
    "yellow": {
        1: preload("res://gradients/yellow1.tres"),
        2: preload("res://gradients/yellow2.tres"),
        3: preload("res://gradients/yellow3.tres"),
    },
    "blue": {
        1: preload("res://gradients/blue1.tres"),
        2: preload("res://gradients/blue2.tres"),
        3: preload("res://gradients/blue3.tres"),
    },
    "light_green": {
        1: preload("res://gradients/light_green1.tres"),
        2: preload("res://gradients/light_green2.tres"),
        3: preload("res://gradients/light_green3.tres"),
    },
    "light_violet": {
        1: preload("res://gradients/light_violet1.tres"),
        2: preload("res://gradients/light_violet2.tres"),
        3: preload("res://gradients/light_violet3.tres"),
    },
    "green": {
        1: preload("res://gradients/green1.tres"),
        2: preload("res://gradients/green2.tres"),
        3: preload("res://gradients/green3.tres"),
    },
    "violet": {
        1: preload("res://gradients/violet1.tres"),
        2: preload("res://gradients/violet2.tres"),
        3: preload("res://gradients/violet3.tres"),
    },
    "turquoise": {
        1: preload("res://gradients/turquoise1.tres"),
        2: preload("res://gradients/turquoise2.tres"),
        3: preload("res://gradients/turquoise3.tres"),
    },
}


func _ready():
    randomize()
    position = screen.main_block_position
    scaled_radius = screen.main_block_size.x / CIRCLE_PER_WIDTH


func create_all():
    number_choices += NUMBER_CHOICES
    number_choices.shuffle()
    var offset = scaled_radius * CIRCLE_OFFSET_FACTOR
    var pos = Vector2(screen.main_block_size.x / 2, screen.main_block_size.y / 2 - offset / 2)
    for i in range(number_choices.size()):
        if i == 4:
            pos.x = screen.main_block_size.x / 2 - offset
            pos.y = screen.main_block_size.y / 2
        elif i == 7:
            pos.x = screen.main_block_size.x / 2 + offset
            pos.y = screen.main_block_size.y / 2
        _create_button(number_choices[i], pos)
        pos.y += offset


func _create_button(num, position):
    var button = num_button.instance()
    button.init(num)
    button.position = position
    # scale
    var scale_component = scaled_radius / CIRCLE_RADIUS
    button.set_scale(Vector2(scale_component, scale_component))
    # set color corresponding to the number
    var color = color_for_number[num]
    button.get_node("BackCircle").material.set_shader_param("gradient", gradients[color][1])
    button.get_node("MiddleCircle").material.set_shader_param("gradient", gradients[color][2])
    button.get_node("FrontCircle").material.set_shader_param("gradient", gradients[color][3])
    # signal
    button.connect("pressed", self, "_on_button_pressed")
    add_child(button)


func _on_button_pressed(button):
    button.animate_click()