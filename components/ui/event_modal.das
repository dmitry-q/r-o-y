require daslib/media
require math
require button
require strings
require daslib/strings_boost
require event_view

module event_modal public

let DESCRIPTION_ROW_LIMIT : int = 53

var game_is_paused : bool = false

class EventModal

    _title : string = "Random event"
    _description : string = "Random description"
    _effect_description : string = "Random effect"
    _is_enabled : bool = false
    _continue_button : Button?
    _icon_id : int
    _icon_to_render : ImageHandle
    
    def EventModal()
        var button : Button? = new Button()
        EventModal`set(self, button)


    def set(continue_button : Button?)
        _continue_button = continue_button


    def show(title, description, effect_description : string; icon_id : int; icon : ImageHandle)
        _title = to_upper(title)
        _description = description
        _effect_description = effect_description
        _icon_to_render = icon
        _is_enabled = true
        _continue_button._is_enabled = true
        return


    def render_event_modal(x : int; y : int; width : int; height: int)

        if !_continue_button._is_enabled
            _is_enabled = false
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

        text_out(x + 122, y+30, _title, 0xA9F5EB)
        
        set_font_size(24)

        fill_rect(x+30, y+180, width-58, height-290, border_color)
        fill_rect(x+32, y+182, width-62, height-294, 0x162523)

        render_icon(_icon_to_render, x + 64, y + 72, 72.0)

        _continue_button->render_button(x + width - 275, y + height - 80, 250, 55, "ДАЛЕЕ")
        
        text_out(x + 52, y + height - 168, _effect_description, 0xA9F5EB)

        var words : array<string> <- split(_description, " ")
        var new_row = ""
        var row_index = 0

        for i in range(0, length(words) + 1) // Do smth with latin symbols length
            if i == length(words)
                text_out(x + 52, y + 200 + 32 * row_index, new_row, 0xA9F5EB)
            elif length(replace(new_row, " ", "")) / 2 + length(words[i]) < DESCRIPTION_ROW_LIMIT
                new_row += words[i] + " "
            else
                text_out(x + 52, y + 200 + 32 * row_index, new_row, 0xA9F5EB)
                row_index++
                new_row = words[i] + " "