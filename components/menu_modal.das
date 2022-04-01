require daslib/media
require button

module menu_modal public


class MenuModal
    _x, _y, _width, _height : int
    _bg_color : uint
    _buttons : array<Button?>
    _is_enabled : bool = false

    def initialize(x, y, width, height : int; bg_color : uint; buttons : array<Button?>)
        _x = x
        _y = y
        _width = width
        _height = height
        _bg_color = bg_color
        for button in buttons
            _buttons |> push(button)

    def hide()
        _is_enabled = false
        for button in _buttons
            button._is_enabled = false
    
    def show()
        _is_enabled = true
        for button in _buttons
            button->enable()
    
    def render()
        enable_premultiplied_alpha_blend()
        fill_rect(_x, _y, _width, _height, _bg_color)
        disable_alpha_blend()
        return
