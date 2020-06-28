extends Node2D

const NUMBER_CHOICES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
const BUTTON_SPRITE_WIDTH = 512 * 0.4 # margins included

var num_button = preload("res://scenes/NumButton.tscn")
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
var screen_size
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


func _ready():
    randomize()
    screen_size = get_viewport().get_visible_rect().size
    create_num_buttons()


func create_num_button(num, position):
    var button = num_button.instance()
    button.position = position
    button.init(num)
    button.connect("pressed", self, "_on_num_button_pressed")
    # set color corresponding to the number
    var color = color_for_number[num]
    button.get_node("BackCircle").material.set_shader_param("gradient", gradients[color][1])
    button.get_node("MiddleCircle").material.set_shader_param("gradient", gradients[color][2])
    button.get_node("FrontCircle").material.set_shader_param("gradient", gradients[color][3])
    add_child(button)


func create_num_buttons():
    number_choices += NUMBER_CHOICES
    number_choices.shuffle()
    var pos = Vector2(screen_size.x / 2, screen_size.y / 2 - BUTTON_SPRITE_WIDTH / 2)
    for i in range(number_choices.size()):
        if i == 4:
            pos.x = screen_size.x / 2 - BUTTON_SPRITE_WIDTH
            pos.y = screen_size.y / 2
        elif i == 7:
            pos.x = screen_size.x / 2 + BUTTON_SPRITE_WIDTH
            pos.y = screen_size.y / 2
        create_num_button(number_choices[i], pos)
        pos.y += BUTTON_SPRITE_WIDTH


func _on_num_button_pressed(button):
    button.animate_click()
