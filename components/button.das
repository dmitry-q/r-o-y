require sound_collection
require daslib/media
require math


module button public


class Button

    _is_enabled : bool = false
    _on_click : lambda<() : void>

    def render_button(x : int; y : int; width : int; height: int; text: string)

        var pos = get_mouse_position()
        var color = 0xA9F5EB
        var text_color = 0x000000

        if (pos.x >= float(x) && pos.x <= float(x + width) && pos.y >= float(y) && pos.y <= float(y + height))
            color = 0x5FC2B5
            text_color = 0xFFFFFF
            if get_mouse_button_up(MB_LEFT)
                disable()
                invoke(_on_click)
        else
            text_color = 0x000000
        
        fill_rect(x, y, width, height, color)

        var font_size = get_current_font_size()
        var w = int(float(font_size * length(replace(text, " ", "")) / 2) * 0.58)
        var tx = clamp(width - w, 0, get_screen_width()) - 1

        text_out(x +tx / 2, y + height/2 - font_size / 2 - 2, text, text_color)

        return

    def disable()
        _is_enabled = false
        play_sound(click)
        return