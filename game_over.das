require daslib/media
require math
require button
require strings
require daslib/strings_boost
require event
require event_view
require event_modal
require sound_manager
require date
require time
require globals

module game_over public


let DESCRIPTION_ROW_LIMIT : int = 52

var is_game_over : bool = false

class GameOver

    _title : string = t("gameover")
    _is_enabled : bool

    _restart_button : Button?
    _menu_button : Button?
    _icon_to_render : ImageHandle
    _events_happen : array<EventViewData>
    _x, _y, _width, _height : int


    def initialize(x, y, width, height : int)
        _x = x
        _y = y
        _width = width
        _height = height


    def GameOver()
        var restart_button : Button? = new Button()
        var menu_button : Button? = new Button()
        GameOver`set(self, restart_button, menu_button)


    def set(restart_button, menu_button : Button?)
        _restart_button = restart_button
        _menu_button = menu_button
        _icon_to_render = create_managed_image("assets/icons/18.png")
        _menu_button._on_click <- @ <| () : void
            invoke(set_current_scene, "main_menu")


    def show(events_happen : array<EventViewData>)
        set_sound_volume(playing_music, 0.03)
        _is_enabled = true
        _restart_button._is_enabled = true
        _menu_button->enable()
        _events_happen := events_happen
        game_is_paused = true
        return


    def render()
        if !_is_enabled
            return
        var border_color = 0xA9F5EB
        var color = 0x243D39
        var bg_color = make_color32(0, 0, 0, 180)

        enable_premultiplied_alpha_blend()
        
        fill_rect(0, 0, get_screen_width(), get_screen_height(), bg_color)

        disable_alpha_blend()

        fill_rect(_x, _y, _width, _height, border_color)
        fill_rect(_x+2, _y+2, _width-4, _height-4, color)

        fill_rect(_x+30, _y+140, _width-58, 2, border_color)
        set_font_size(72)

        text_out(_x + 235, _y+30, _title, 0xA9F5EB)

        set_font_size(24)

        fill_rect(_x+30, _y+180, _width-58, _height-290, border_color)
        fill_rect(_x+32, _y+182, _width-62, _height-294, 0x162523)

        render_icon(_icon_to_render, _x + 64, _y + 72, 75.0)

        set_font_size(18)

        var i = length(_events_happen) - 1
        var msg_y = 0
        
        while i >= 0
            render_icon(_events_happen[i].icon, _x + 83, _y + 236 + 32 * msg_y, 20.0)
            text_out(_x + 83, _y + 200 + 32 * msg_y, format_date(_events_happen[i].spawned_at, DateFormat RU) + " - " + _events_happen[i].log_message, 0xA9F5EB)
            i--
            msg_y++
            if msg_y > 17
                break

        set_font_size(24)
        //_restart_button->render_button(x + width / 2 + 15, y + height - 80, 405, 55, "РЕСТАРТ")
        _menu_button->render_button(_x + 30, _y + _height - 80, 840, 55, t("quit"), 2) //x + width / 2 + 15
        //_restart_button->render_button(x + width - 280, y + height - 80, 250, 55, "ВЫЙТИ")
