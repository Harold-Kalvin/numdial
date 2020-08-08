extends Node2D

onready var screen = $"/root/Screen"
onready var game = $"/root/Game"

const NUMBER_CHOICES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
const CIRCLE_RADIUS = 256
const CIRCLE_PER_WIDTH = 5
const CIRCLE_OFFSET_FACTOR = 1.4

var buttons = []
var number_choices = []

var _num_button = preload("res://scenes/NumButton.tscn")
var _scaled_radius
var _positions = []
var _shuffle_position = Vector2()
var _last_button_pressed
var _click_enabled = true
var _color_for_number = {
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
var _gradients = {
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
    position = screen.main_block_position
    _scaled_radius = screen.main_block_size.x / CIRCLE_PER_WIDTH


func init(total_buttons: int = 10):
    _generate_all_positions()

    # remove existing buttons
    if buttons:
        for button in buttons:
            button.queue_free()
        buttons.clear()

    # create buttons
    number_choices.clear()
    number_choices += NUMBER_CHOICES.slice(0, total_buttons-1)
    number_choices.shuffle()
    for i in number_choices.size():
        buttons.append(_create_button(number_choices[i], _positions[i]))


func animate_scale_up_on_last_button_pressed():
    yield(_last_button_pressed.animate_scale_up(), "completed")
    _last_button_pressed = null


func animate_scale_down_on_all_buttons():
    var scale_duration = 0.2
    for button in buttons:
        button.animate_scale_down(scale_duration)
    yield(get_tree().create_timer(scale_duration + 0.05), "timeout")


func animate_shuffle(buttons_to_inject: int = 0):
    var buttons_clone = [] + buttons
    var button_in_center = null
    var move_duration = 0.5
    var wait_before_new_position = 0.20
    
    # move all buttons at the same position
    for button in buttons_clone:
        button.animate_move(_shuffle_position, move_duration)
        # button at the center must be at the top of the button pile
        if _shuffle_position == button.position:
            button_in_center = button
            button_in_center.set_z_index(1)
    yield(get_tree().create_timer(move_duration + wait_before_new_position), "timeout")
    
    # inject new buttons if needed
    if buttons_to_inject > 0:
        _inject_buttons(buttons_to_inject, _shuffle_position)
        buttons_clone.clear()
        buttons_clone += buttons

    # prepare new positions
    var new_positions = [] + _positions.slice(0, buttons.size()-1)
    new_positions.shuffle()
    
    # force button at the center to change position
    for new_position in new_positions:
        if new_position != button_in_center.position:
            button_in_center.animate_move(new_position, move_duration)
            new_positions.erase(new_position)
            buttons_clone.erase(button_in_center)
            break

    # move all other buttons to their new position
    for i in buttons_clone.size():
        buttons_clone[i].animate_move(new_positions[i], move_duration)
    yield(get_tree().create_timer(move_duration), "timeout")
    button_in_center.set_z_index(0)


func enable_click():
    _click_enabled = true


func disable_click():
    _click_enabled = false


func _inject_buttons(total: int, position: Vector2):
    if buttons.size() + total <= NUMBER_CHOICES.size():
        var new_number_choices = NUMBER_CHOICES.slice(buttons.size(), buttons.size() - 1 + total)
        for num in new_number_choices:
            buttons.append(_create_button(num, position))


func _generate_all_positions():
    var x_offset = _scaled_radius * CIRCLE_OFFSET_FACTOR
    var x_left = screen.main_block_size.x / 2 - x_offset
    var x_middle = screen.main_block_size.x / 2
    var x_right = screen.main_block_size.x / 2 + x_offset
    var y_offset = x_offset / 2
    var y_middle = screen.main_block_size.y / 2

    _positions.clear()
    _shuffle_position = Vector2(x_middle, y_middle + y_offset)
    _positions.append(_shuffle_position)
    _positions.append(Vector2(x_left, y_middle + y_offset * 2))
    _positions.append(Vector2(x_right, y_middle + y_offset * 2))
    _positions.append(Vector2(x_middle, y_middle + y_offset * 3))
    _positions.append(Vector2(x_left, y_middle))
    _positions.append(Vector2(x_right, y_middle))
    _positions.append(Vector2(x_left, y_middle + y_offset * 4))
    _positions.append(Vector2(x_right, y_middle + y_offset * 4))
    _positions.append(Vector2(x_middle, y_middle - y_offset))
    _positions.append(Vector2(x_middle, y_middle + y_offset * 5))


func _create_button(num, position):
    var button = _num_button.instance()
    button.init(num)
    button.position = position
    # scale
    var scale_component = _scaled_radius / CIRCLE_RADIUS
    button.set_scale(Vector2(scale_component, scale_component))
    # set color corresponding to the number
    var color = _color_for_number[num]
    button.get_node("BackCircle").material.set_shader_param("gradient", _gradients[color][1])
    button.get_node("MiddleCircle").material.set_shader_param("gradient", _gradients[color][2])
    button.get_node("FrontCircle").material.set_shader_param("gradient", _gradients[color][3])
    # signal
    button.connect("pressed", self, "_on_button_pressed")
    add_child(button)
    return button


func _on_button_pressed(button):
    if not button.already_pressed and _click_enabled:
        _last_button_pressed = button
        game.dial(button.num)
