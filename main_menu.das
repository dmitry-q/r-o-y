require daslib/media
require scene
require button
require globals
require sound_manager
require menu_modal
require player_params
require constants

module main_menu public


class MainMenu : Scene

    _scroll_speed : float = 35.0
    _scroll_timer : float = 0.0

    _modals : array<MenuModal?>
    _current_modal_index : int = 0
    _show_next_modal : lambda<(step : int) : void>
    _increment_param : lambda<(index : int) : void>
    _decrement_param : lambda<(index : int) : void>
    _params_titles : array<string>
    _free_points : int = 0
    _params_input : table<int; int>

    def override initialize()
        let w = get_screen_width()
        let h = get_screen_height()

        play_music_track(0)
        set_antialiasing(4)


        for x in each_enum(PK AGE)
            if int(x) < 6
                pass
            _params_input[int(x)] = 4

        _params_titles <- [{auto t("params.will"); t("params.str"); t("params.per"); t("params.end"); t("params.cha"); t("params.int"); t("params.agi"); t("params.LUC")}]

        var main_modal = new MenuModal()
        var main_modal_buttons : array<Button?>
        var lang_modal = new MenuModal()
        var lang_modal_buttons : array<Button?>
        var mode_modal = new MenuModal()
        var mode_modal_buttons : array<Button?>
        var params_modal = new MenuModal()
        var params_modal_buttons : array<Button?>

        // MAIN
        var new_game_button = new Button()
        new_game_button._on_click <- @ <| () : void             //invoke(set_current_scene, "game")
            invoke(_show_next_modal, 1)
        main_modal_buttons |> push(new_game_button)

        var about_button = new Button()
        about_button._is_active = false
        main_modal_buttons |> push(about_button)

        var quit_button = new Button()
        quit_button._on_click <- @ <| () : void
            schedule_quit_game()
        main_modal_buttons |> push(quit_button)

        main_modal->initialize(w / 2 - 330, h / 2 + 82, 660, 336, make_color32(15, 0, 22, 177), main_modal_buttons)
        _modals |> push(main_modal)

        // LANGUAGE
        var ru_button = new Button()
        ru_button._on_click <- @ <| () : void
            invoke(_show_next_modal, 2)
        lang_modal_buttons |> push(ru_button)

        var en_button = new Button()
        en_button._is_active = false
        lang_modal_buttons |> push(en_button)

        lang_modal->initialize(510, 0, 900, 1080, make_color32(15, 0, 22, 200), lang_modal_buttons)
        _modals |> push(lang_modal)

        // MODE
        var turbo_button = new Button()
        turbo_button._on_click <- @ <| () : void
            invoke(_show_next_modal, 3) //invoke(set_current_scene, "game")
        mode_modal_buttons |> push(turbo_button)

        var day_by_day_button = new Button()
        day_by_day_button._is_active = false
        mode_modal_buttons |> push(day_by_day_button)

        mode_modal->initialize(510, 0, 900, 1080, make_color32(15, 0, 22, 200), mode_modal_buttons)
        _modals |> push(mode_modal)

        // PARAMS //
        // WILL
        var min_wil_button = new Button()
        params_modal_buttons |> push(min_wil_button)
        var max_wil_button = new Button()
        params_modal_buttons |> push(max_wil_button)
        // STR
        var min_str_button = new Button()
        params_modal_buttons |> push(min_str_button)
        var max_str_button = new Button()
        params_modal_buttons |> push(max_str_button)
        // PER
        var min_per_button = new Button()
        params_modal_buttons |> push(min_per_button)
        var max_per_button = new Button()
        params_modal_buttons |> push(max_per_button)
        // END
        var min_end_button = new Button()
        params_modal_buttons |> push(min_end_button)
        var max_end_button = new Button()
        params_modal_buttons |> push(max_end_button)
        // CHA
        var min_cha_button = new Button()
        params_modal_buttons |> push(min_cha_button)
        var max_cha_button = new Button()
        params_modal_buttons |> push(max_cha_button)
        // INT
        var min_int_button = new Button()
        params_modal_buttons |> push(min_int_button)
        var max_int_button = new Button()
        params_modal_buttons |> push(max_int_button)
        // AGI
        var min_agi_button = new Button()
        params_modal_buttons |> push(min_agi_button)
        var max_agi_button = new Button()
        params_modal_buttons |> push(max_agi_button)
        // LUC
        var min_luc_button = new Button()
        params_modal_buttons |> push(min_luc_button)
        var max_luc_button = new Button()
        params_modal_buttons |> push(max_luc_button)

        // SUBMIT
        var submit_button = new Button()
        submit_button._on_click <- @ <| () : void
            self->submit_params()
            invoke(set_current_scene, "game")
        params_modal_buttons |> push(submit_button)

        params_modal->initialize(510, 0, 900, 1080, make_color32(15, 0, 22, 200), params_modal_buttons)
        _modals |> push(params_modal)

        for button in _modals[3]._buttons
            button._disable_on_click = false

        var params_buttons_len = length(_modals[3]._buttons)
        for i in range(0, params_buttons_len)
            if i == params_buttons_len - 1
                continue
            if i % 2 > 0
                _modals[3]._buttons[i]._on_click <- @ <| () : void
                    invoke(_increment_param, i / 2 + 6)
            else
                _modals[3]._buttons[i]._on_click <- @ <| () : void
                    invoke(_decrement_param, i / 2 + 6)

        // OTHER
        _show_next_modal <- @ <| (step : int) : void
            _modals[_current_modal_index]->hide()
            _current_modal_index = step
            _modals[_current_modal_index]->show()

        _increment_param <- @ <| (index : int) : void
            if _free_points > 0
                if _params_input[index] > 0 && _params_input[index] < 10
                    _params_input[index]++
                    _free_points--

        _decrement_param <- @ <| (index : int) : void
            if _params_input[index] > 1
                _params_input[index]--
                _free_points++

        for modal in _modals
            modal->hide()

        _current_modal_index = 0

        _modals[_current_modal_index]->show()

        return

    def override act(dt: float)

        if get_key(VK_ESCAPE)
            schedule_quit_game()

        _scroll_timer += dt
        if _scroll_timer >= 32.0 / _scroll_speed
            _scroll_timer = 0.0
        return


    def override render()
        let w = get_screen_width()
        let h = get_screen_height()

        fill_rect(0, 0, w, h / 2, 0x281135)
        fill_circle(w / 2, h / 2 + 30, 330, 0xE79B28)
        fill_rect(0, h / 2, w, h, 0x1B0322)

        for i in range(0, 17)
            fill_rect(0, h / 2, w, int(_scroll_speed * _scroll_timer / 2.0), 0x441452)
            fill_rect(0, h / 2 + i * 32 + int(_scroll_speed * _scroll_timer), w, 16, 0x441452)

        if _current_modal_index == 0
            render_logo()

        _modals[_current_modal_index]->render()

        set_font_name("mono")
        if _current_modal_index == 0
            _modals[0]._buttons[0]->render_button(w / 2 - 300, h / 2 + 112, 600, 75, "NEW GAME", 5)
            _modals[0]._buttons[1]->render_button(w / 2 - 300, h / 2 + 212, 600, 75, "CREDITS", 4)
            _modals[0]._buttons[2]->render_button(w / 2 - 300, h / 2 + 312, 600, 75, "EXIT", 2)
        if _current_modal_index == 1
            set_font_size(88)
            text_out(w / 2 - 398, 430, "CHOOSE LANGUAGE", REGULAR_TEXT_COLOR)
            set_font_size(35)
            _modals[1]._buttons[0]->render_button(w / 2 - 300, h / 2 + 112, 600, 75, "РУССКИЙ", 0)
            _modals[1]._buttons[1]->render_button(w / 2 - 300, h / 2 + 212, 600, 75, "ENGLISH", 4)
        if _current_modal_index == 2
            set_font_size(88)
            text_out(w / 2 - 373, 430, t("mode"), REGULAR_TEXT_COLOR)
            set_font_size(35)
            _modals[2]._buttons[0]->render_button(w / 2 - 300, h / 2 + 112, 600, 75, "TURBO", 3)
            _modals[2]._buttons[1]->render_button(w / 2 - 300, h / 2 + 212, 600, 75, "DAY BY DAY", 6)
        if _current_modal_index == 3
            set_font_size(55)
            text_out(w / 2 - 365, 80, t("params.title"), REGULAR_TEXT_COLOR)
            set_font_size(30)

            text_out(w / 2 - 230, 250, t("params.available") + ": " + string(_free_points), REGULAR_TEXT_COLOR)

            var i : int = 0
            for button in _modals[3]._buttons

                if i == 16
                    button->render_button(w / 2 - 125, 930, 250, 60, t("params.start"), 0)
                    continue

                var x_offset = 0
                var y_offset = i/2 * 64
                var button_text = "-"
                var title_index = i/2

                if i % 2 > 0
                    x_offset = 400
                    button_text = "+"
                    text_out(w / 2 - 160, 360 + y_offset, _params_titles[title_index], REGULAR_TEXT_COLOR)
                    text_out(w / 2 - 300, 360 + y_offset, string(_params_input[title_index+6]), REGULAR_TEXT_COLOR)
                
                button->render_button(w / 2 - 225 + x_offset, 355 + y_offset, 50, 50, button_text, 1)
                i++
        
        return

    def render_logo()
        let w = get_screen_width()
        let h = get_screen_height()

        set_font_name("sans")
        set_font_size(352)
        text_out(w / 4 + 37, 58, "R.O.Y", 0xFF0062)
        set_font_size(355)
        text_out(w / 4 + 30, 50, "R.O.Y", 0xFFFFFF)

        set_font_size(35)
        text_out(w / 4 + 360, 493, "Road Of Yours", 0xFF0062)
        set_font_size(35)
        text_out(w / 4 + 360, 490, "Road Of Yours", 0xFFFFFF)


    def submit_params
        params_to_set <- _params_input