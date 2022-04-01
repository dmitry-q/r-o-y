require sound_manager
require daslib/media
require math
require globals


module button public


class Button

    _is_enabled : bool = false
    _is_active : bool = true
    _on_click : lambda<() : void>
    _has_to_be_enabled : bool = false
    _disable_on_click : bool = true

    def render_button(x : int; y : int; width : int; height: int; text: string; correct_spaces: int)
        if _has_to_be_enabled
            _is_enabled = true
            _has_to_be_enabled = false
            return

        if !_is_enabled
            return

        var color = 0xA9F5EB
        var inactive_color = make_color32(19, 105, 85, 80)
        var text_color = 0x000000
        var pos = get_mouse_position()

        if _is_enabled && _is_active && (pos.x >= float(x) && pos.x <= float(x + width) && pos.y >= float(y) && pos.y <= float(y + height))
            color = 0x5FC2B5
            text_color = 0xFFFFFF
            if get_mouse_button_up(MB_LEFT)
                disable()
        else
            text_color = 0x000000
        
        if _is_active
            fill_rect(x, y, width, height, color)
        else
            enable_premultiplied_alpha_blend()
            fill_rect(x, y, width, height, inactive_color)
            disable_alpha_blend()

        var font_size = get_current_font_size()
        var w = lang == Language RU ? int(float(font_size * (length(replace(text, " ", "")) / 2 + correct_spaces)) * 0.58) : int(float(font_size * (length(text))) * 0.58)
        var tx = clamp(width - w, 0, get_screen_width()) - 1

        text_out(x +tx / 2, y + height/2 - font_size / 2 - 2, text, text_color)

        return

    
    def enable()
        _has_to_be_enabled = true

    def disable()
        if _disable_on_click
            _is_enabled = false
        play_sound(click)
        if _on_click != null
            invoke(_on_click)
        return