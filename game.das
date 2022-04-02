require daslib/media
require time
require random
require constants
require scene
require date
require player
require player_params
require event_view
require event_modal
require button
require game_over
require sound_manager
require event_controller
require event
require constants
require globals
require global_effects


module game public


enum Weather
    NO
    RAIN
    SNOW


class Game : Scene

    rand_seed: int4
    _player : Player?
    _event_controller : EventController?
    event_modal : EventModal?
    _game_over_modal : GameOver?
    current_bg_color : uint
    menu_button : Button?

    def override initialize()
        set_antialiasing(0)
        randomize_seed(rand_seed)
    
        start_date = set_start_date(0, 0, 2000)
        current_date = start_date
        dates = initialize_dates(current_date)
        SCROLL_SPEED = 250.0
        SCROLL_ACCELERATION  = 1.00
        time_jerk = 0.0

        _player = new Player(0)
        _event_controller = new EventController()
        menu_button = new Button()
        _game_over_modal = new GameOver()

        _event_controller._event_modal = event_modal
        _event_controller._game_over_modal = _game_over_modal
        _event_controller._player = _player
        _player._date_of_birth = start_date

        _event_controller->initialize()
        _game_over_modal->initialize(510, 100, 900, 900)

        _player._on_player_death <- @ <| () : void
            _event_controller->show_game_over_modal()
            play_music_track(11)

        menu_button._on_click <- @ <| () : void
            invoke(set_current_scene, "main_menu")
        
        menu_button._is_enabled = true

        game_is_paused = false
        apply_start_effects()
        update_music(_player->get_age())


    def finalize
        unsafe
            delete _player
        unsafe
            delete _event_controller
    
    
    def override act(dt:float)
        
        if game_is_paused
            return

        _player->act()
        update_input()

        date_scroll_out_timer += dt
        event_scroll_out_timer += dt
        _event_controller._timestep_timer += dt

        if date_scroll_out_timer >= 90.0 / SCROLL_SPEED
            update_speed()
            update_dates(1)
            _player->pass_date()
            _player->animate()
            _event_controller->detect_collision()
            date_scroll_out_timer = 0.0

        if event_scroll_out_timer >= 1080.0 / SCROLL_SPEED
            event_scroll_out_timer = 0.0

        if _event_controller._timestep_timer >= float(float(_event_controller._timestep)) / 3.5 / SCROLL_SPEED
            _event_controller->on_timestep_pass()


    def override render()
        var width = get_screen_width()
        fill_rect(0, 0, 280, get_screen_height(), UI_BG_COLOR)

        if current_date.month < 2 || current_date.month > 10
            current_bg_color = BG_COLOR_WINTER
        elif current_date.month < 5 && current_date.month > 1
            current_bg_color = BG_COLOR_SPRING
        elif current_date.month < 8 && current_date.month > 4
            current_bg_color = BG_COLOR_SUMMER
        else
            current_bg_color = BG_COLOR_AUTUMN
        
        fill_rect(280, 0, get_screen_width(), get_screen_height(), current_bg_color)

        fill_rect(1640, 0, 279, get_screen_height(), UI_BG_COLOR)
        line(280, 0, 280, 1080, REGULAR_TEXT_COLOR)
        line(1640, 0, 1640, 1080, REGULAR_TEXT_COLOR)

        render_road()
        _event_controller->update_view()
        _player->render()
        render_dates()
        render_info()


        if current_bg_color == BG_COLOR_WINTER
            render_weather(Weather SNOW)
        elif current_bg_color == BG_COLOR_AUTUMN
            render_weather(Weather RAIN)

        _event_controller->render()
        _game_over_modal->render()


    def render_dates()
        for i in range(0, 14)
            text_out(68, get_screen_height() - 90 - i * 90 + int(date_scroll_out_timer * SCROLL_SPEED), format_date(dates[i], DateFormat RU), REGULAR_TEXT_COLOR)


    def render_info()

        var x = 1660
        let anchors <- [{auto 955; 0; 395; 100; 525}]
        let y_offset = 32
        let skills_start_y = 0

        set_font_size(30)

        text_out(x + 50, anchors[0], t("today") + ":", REGULAR_TEXT_COLOR)
        text_out(x + 30, anchors[0] + 40, format_date(current_date, DateFormat RU), REGULAR_TEXT_COLOR)

        set_font_size(24)

        text_out(x, anchors[1] + y_offset * 1, t("hp") + "" + string(_player._params[pk(ParamKey HEALTH)]) + "/100", REGULAR_TEXT_COLOR)
        text_out(x, anchors[1] + y_offset * 2, t("pp") + "" + string(_player._params[pk(ParamKey MENTAL)]) + "/100", REGULAR_TEXT_COLOR)
        
        text_out(x, anchors[2] + y_offset * 1, t("age") + "" + string(_player->get_age()), REGULAR_TEXT_COLOR)
        text_out(x, anchors[2] + y_offset * 2, t("money") + "" + string(_player._params[pk(ParamKey MONEY)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[2] + y_offset * 3, t("infl") + "" + string(_player._params[pk(ParamKey INFLUENCE)]), REGULAR_TEXT_COLOR)
        //text_out(1440, 170, "Speed: " + string(SCROLL_SPEED), REGULAR_TEXT_COLOR)
        //text_out(1440, 200, "Acc: " + string(SCROLL_ACCELERATION), REGULAR_TEXT_COLOR)
        //text_out(1440, 230, "Jerk: " + string(time_jerk), REGULAR_TEXT_COLOR)
        //text_out(1500, 200, "Time Passed: " + string(TIME_SUM), 0xA1A1A1)
        text_out(x, anchors[3] + y_offset * 1, t("will") + "" + string(_player._params[pk(ParamKey WILLPOWER)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 2, t("str") + "" + string(_player._params[pk(ParamKey STRENGHT)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 3, t("per") + "" + string(_player._params[pk(ParamKey PERCEPTION)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 4, t("end") + "" + string(_player._params[pk(ParamKey ENDURANCE)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 5, t("cha") + "" + string(_player._params[pk(ParamKey CHARISMA)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 6, t("int") + "" + string(_player._params[pk(ParamKey INTELLIGENCE)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 7, t("agi") + "" + string(_player._params[pk(ParamKey AGILITY)]), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 8, t("luck") + "" + string(_player._params[pk(ParamKey LUCK)]), REGULAR_TEXT_COLOR)


        set_font_size(12)

        text_out(x, anchors[4] + y_offset / 2  * 1 + 1, t("s.eru") + "" + string(_player._skills.erudition), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 2 + 2, t("s.emp") + "" + string(_player._skills.empathy), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 3 + 3, t("s.rhe") + "" + string(_player._skills.rhetoric), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 4 + 4, t("s.ent") + "" + string(_player._skills.enterprise), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 5 + 5, t("s.sur") + "" + string(_player._skills.survivalist), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 6 + 6, t("s.art") + "" + string(_player._skills.art), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 7 + 7, t("s.mus") + "" + string(_player._skills.music), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 8 + 8, t("s.mat") + "" + string(_player._skills.math), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 9 + 9, t("s.nla") + "" + string(_player._skills.native_language), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 10 + 10, t("s.fla") + "" + string(_player._skills.foreign_languages), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 11 + 11, t("s.phy") + "" + string(_player._skills.physics), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 12 + 12, t("s.lit") + "" + string(_player._skills.literature), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 13 + 13, t("s.tec") + "" + string(_player._skills.technology), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 14 + 14, t("s.inf") + "" + string(_player._skills.computer_science), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 15 + 15, t("s.geo") + "" + string(_player._skills.geography), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 16 + 16, t("s.soc") + "" + string(_player._skills.social_studies), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 17 + 17, t("s.che") + "" + string(_player._skills.chemistry), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 18 + 18, t("s.ath") + "" + string(_player._skills.athletics), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 19 + 19, t("s.swi") + "" + string(_player._skills.swimming), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 20 + 20, t("s.dri") + "" + string(_player._skills.driving), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 21 + 21, t("s.mar") + "" + string(_player._skills.martial_arts), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 22 + 22, t("s.cwe") + "" + string(_player._skills.cold_weapons), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 23 + 23, t("s.fir") + "" + string(_player._skills.firearms), REGULAR_TEXT_COLOR)

        set_font_size(30)
        set_font_name("sans")
        menu_button->render_button(1580, 24, 42, 42, "X", 1)

        // var i = 0
        // set_font_size(14)
        // for event in event_controller._available_events
        //     text_out(1440, 80 + i * 26, event._name + " " + string(event._spawn_limit) + " " + string(event_controller->get_event_spawned_count(event._id)), REGULAR_TEXT_COLOR)
        //     i++

        // text_out(1440, 40, string(event_controller._timestep / 90), REGULAR_TEXT_COLOR)
        set_font_name("mono")
        set_font_size(24)


    def render_road()
        var width = get_screen_width()
        var x0 = width
        var x1 = width / 2 - 140
        var x2 = width / 2 + 140

        fill_rect(x1, 0, -5, get_screen_height(),  0xFCF6F4)
        fill_rect(x1, 0, 280, get_screen_height(),  0x524A47) //0x6E564A
        fill_rect(x2, 0, 5, get_screen_height(),  0xFCF6F4)

    def render_weather(weather : Weather)
        for i in range(0, 95)
            var x : int = random_int(rand_seed)
            var y : int = random_int(rand_seed)
        
            while x < 282 || x > get_screen_width() - 282
                x = random_int(rand_seed)
            
            while y < 0 || y > get_screen_height()
                y = random_int(rand_seed)

            if weather == Weather RAIN
                line(x, y, x, y+105, 0xA1A1A1)
            
            elif weather == Weather SNOW
                fill_circle(x, y, 4, 0xFFFFFF)


    def update_input()
        if get_key(VK_ESCAPE)
            schedule_quit_game()

        let left = get_key(VK_A) || get_key(VK_LEFT)
        let right = get_key(VK_D) || get_key(VK_RIGHT)

        if left && _player._offset >= -99
            _player._offset -= 6
        elif right && _player._offset <= 99
            _player._offset += 6


    def apply_start_effects()
        _player->add_effect(DEFAULT_TIME_JERK_EFFECT)
        _player->add_effect(DEFAULT_AGING)
        _player->add_effect(DEFAULT_DEMENTIA)
        _player->add_effect(POCKET_MONEY_CHILD)
        _player->add_effect(POCKET_MONEY_TEENAGER)
        _player->add_effect(SPEND_POCKET_MONEY_CHILD)
        _player->add_effect(SPEND_POCKET_MONEY_TEENAGER)