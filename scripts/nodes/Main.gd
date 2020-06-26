extends Node2D

const NUMBER_CHOICES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
const BUTTON_SPRITE_WIDTH = 512 * 0.4 # margins included

var num_button = preload("res://scenes/NumButton.tscn")
var screen_size
var number_choices = []


func _ready():
    randomize()
    screen_size = get_viewport().get_visible_rect().size
    create_num_buttons()


func create_num_button(num, position):
    var button = num_button.instance()
    button.position = position
    button.init(num)
    button.connect("pressed", self, "_on_num_button_pressed")
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
