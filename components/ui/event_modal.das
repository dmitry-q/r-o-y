require daslib/media
require math
require button
require strings
require daslib/strings_boost

module event_modal public

let DESCRIPTION_ROW_LIMIT : int = 52

var game_is_paused : bool = false
var continue_button = new Button()

class EventModal
    _is_closed : bool = true

    def render_event_modal(x : int; y : int; width : int; height: int; title, description: string)

        if continue_button._is_closed
            _is_closed = true
            game_is_paused = false
            return
        else
            game_is_paused = true

        var border_color = 0xA9F5EB
        var color = 0x243D39
        var bg_color = make_color32(0, 0, 0, 155)

        enable_premultiplied_alpha_blend()
        
        fill_rect(0, 0, get_screen_width(), get_screen_height(), bg_color)

        disable_alpha_blend()

        fill_rect(x, y, width, height, border_color)
        fill_rect(x+2, y+2, width-4, height-4, color)

        fill_rect(x+30, y+140, width-58, 2, border_color)
        set_font_size(72)

        text_out(x + 30, y+30, to_upper(title), 0xA9F5EB)
        
        set_font_size(24)

        fill_rect(x+30, y+180, width-58, height-290, border_color)
        fill_rect(x+32, y+182, width-62, height-294, 0x162523)

        continue_button->render_button(x + width - 275, y + height - 80, 250, 55, "CONTINUE")

        var words : array<string> <- split(description, " ")
        var new_row = ""
        var row_index = 0

        for i in range(0, length(words))
            if i == length(words) - 1
                new_row += words[i] + " "
                text_out(x + 52, y + 200 + 32 * row_index, new_row, 0xA9F5EB)
                return

            if length(new_row) + length(words[i]) < DESCRIPTION_ROW_LIMIT
                new_row += words[i] + " "
            else
                text_out(x + 52, y + 200 + 32 * row_index, new_row, 0xA9F5EB)
                row_index++
                new_row = words[i] + " "