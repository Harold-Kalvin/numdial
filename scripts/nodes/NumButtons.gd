extends Node2D

onready var screen = $"/root/Screen"
onready var game = $"/root/Game"

const NUMBER_CHOICES = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
const CIRCLE_RADIUS = 256
const CIRCLE_PER_WIDTH = 5
const CIRCLE_OFFSET_FACTOR = 1.4

var _num_button = preload("res://scenes/NumButton.tscn")
var _buttons = []
var _displayed_buttons = []
var _positions = []
var _shuffle_position = Vector2()
var _scaled_radius
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
    add_buttons(total_buttons)
    display_buttons()


func add_buttons(total: int, common_position: Vector2 = Vector2()):
    """Adds new buttons to the list without displaying the corresponding nodes."""
    if _buttons.size() + total <= NUMBER_CHOICES.size():
        var numbers_to_add = NUMBER_CHOICES.slice(_buttons.size(), _buttons.size() - 1 + total)
        for i in numbers_to_add.size():
            var position = common_position if common_position else _positions[i]
            _buttons.append(_create_button(numbers_to_add[i], position))


func remove_buttons(total: int):
    """Removes buttons from the list without freeing the corresponding nodes."""
    if _buttons.size() - total > 0:
        var numbers_to_remove = [] + NUMBER_CHOICES.slice(_buttons.size(), _buttons.size() - total, -1)
        for i in range(_buttons.size() - 1, -1, -1):
            if (_buttons[i].num in numbers_to_remove):
                _buttons.remove(i)
        

func display_buttons():
    """Displays the button nodes that are yet to be displayed."""
    for button in _buttons:
        if not (button in _displayed_buttons):
            _displayed_buttons.append(button)
            add_child(button)


func free_buttons():
    """Frees the button nodes that are yet to be freed."""
    for i in range(_displayed_buttons.size() - 1, -1, -1):
        if not (_displayed_buttons[i] in _buttons):
            _displayed_buttons[i].queue_free()
            _displayed_buttons.remove(i)


func get_total():
    """Returns the current number of buttons."""
    return _buttons.size()


func get_number_choices():
    """Returns the current numbers."""
    return NUMBER_CHOICES.slice(0, _buttons.size()-1)


func get_shuffle_position():
    """Returns the position where all the buttons reunites to shuffle."""
    return _shuffle_position


func animate_scale_up_on_last_button_pressed():
    """Animates the scale up of the last button pressed."""
    yield(_last_button_pressed.animate_scale_up(), "completed")
    _last_button_pressed = null


func animate_scale_down_on_all_buttons():
    """Animates the scale down of all the buttons."""
    var scale_duration = 0.2
    for button in _displayed_buttons:
        button.animate_scale_down(scale_duration)
    yield(get_tree().create_timer(scale_duration + 0.05), "timeout")


func animate_shuffle():
    """Animates the buttons shuffling."""
    var buttons_clone = [] + _displayed_buttons
    var button_in_center = null
    var move_duration = 0.25
    var wait_before_new_position = 0.20
    
    # move all buttons at the same position
    var last_button = null
    for i in range(buttons_clone.size() - 1, -1, -1):
        var button = buttons_clone[i]
        # button at the center must be at the top of the button pile
        if _shuffle_position == button.position:
            button_in_center = button
            button_in_center.set_z_index(1)
        else:
            if last_button:
                button.animate_move(_shuffle_position, move_duration)
            else:
                last_button = button
    yield(last_button.animate_move(_shuffle_position, move_duration), "completed")
    
    # display or free buttons if needed
    if _displayed_buttons.hash() != _buttons.hash():
        var size_diff = _buttons.size() - _displayed_buttons.size()
        if size_diff > 0:
            display_buttons()
        elif size_diff < 0:
            free_buttons()
        buttons_clone.clear()
        buttons_clone += _displayed_buttons
        if !(button_in_center in buttons_clone):
            button_in_center = buttons_clone[0]
    yield(get_tree().create_timer(wait_before_new_position), "timeout")

    # prepare new positions
    var new_positions = [] + _positions.slice(0, _buttons.size()-1)
    new_positions.shuffle()
    
    # force button at the center to change position
    for new_position in new_positions:
        if new_position != button_in_center.position:
            button_in_center.animate_move(new_position, move_duration)
            new_positions.erase(new_position)
            buttons_clone.erase(button_in_center)
            break

    # move all other buttons to their new position
    last_button = buttons_clone.pop_back()
    var last_position = new_positions.pop_back()
    for i in buttons_clone.size():
        buttons_clone[i].animate_move(new_positions[i], move_duration)
    yield(last_button.animate_move(last_position, move_duration), "completed")
    
    # button at the center must be at the top of the button pile
    button_in_center.set_z_index(0)


func enable_click():
    """Enables the click on a button."""
    _click_enabled = true
    
    
func disable_click():
    """Disables the click on a button."""
    _click_enabled = false


func _generate_all_positions():
    """Generates all the possible positions of a button."""
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
    """Creates a button."""
    var button = _num_button.instance()
    button.num = num
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
    return button


func _on_button_pressed(button):
    if not button.already_pressed and _click_enabled:
        _last_button_pressed = button
        game.dial(button.num)
