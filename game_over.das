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
        _menu_button._is_enabled = true
        _events_happen := events_happen
        return


    def render(x : int; y : int; width : int; height: int)

        if !_restart_button._is_enabled || !_menu_button._is_enabled
            _is_enabled = false
            game_is_paused = false
            set_sound_volume(playing_music, DEFAULT_MUSIC_VOLUME)
            return
        else
            game_is_paused = true

        var border_color = 0xA9F5EB
        var color = 0x243D39
        var bg_color = make_color32(0, 0, 0, 180)

        enable_premultiplied_alpha_blend()
        
        fill_rect(0, 0, get_screen_width(), get_screen_height(), bg_color)

        disable_alpha_blend()

        fill_rect(x, y, width, height, border_color)
        fill_rect(x+2, y+2, width-4, height-4, color)

        fill_rect(x+30, y+140, width-58, 2, border_color)
        set_font_size(72)

        text_out(x + 235, y+30, _title, 0xA9F5EB)

        set_font_size(24)

        fill_rect(x+30, y+180, width-58, height-290, border_color)
        fill_rect(x+32, y+182, width-62, height-294, 0x162523)

        render_icon(_icon_to_render, x + 64, y + 72, 75.0)

        set_font_size(18)

        var i = length(_events_happen) - 1
        var msg_y = 0
        
        while i >= 0
            render_icon(_events_happen[i].icon, x + 83, y + 236 + 32 * msg_y, 20.0)
            text_out(x + 83, y + 200 + 32 * msg_y, format_date(_events_happen[i].spawned_at, DateFormat RU) + " - " + _events_happen[i].log_message, 0xA9F5EB)
            i--
            msg_y++
            if msg_y > 17
                break

        set_font_size(24)
        //_restart_button->render_button(x + width / 2 + 15, y + height - 80, 405, 55, "РЕСТАРТ")
        _menu_button->render_button(x + 30, y + height - 80, 840, 55, t("quit"), 2) //x + width / 2 + 15
        //_restart_button->render_button(x + width - 280, y + height - 80, 250, 55, "ВЫЙТИ")
