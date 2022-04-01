require daslib/media
require time
require random
require constants
require components/scene
require components/date
require components/player
require components/event_view
require components/event_modal
require components/button
require components/game_over
require components/sound_collection
require event_controller
require event
require constants
require globals
require content/start_effects


module game public


enum Weather
    NO
    RAIN
    SNOW


class Game : Scene

    rand_seed: int4
    animation_state : int = 0
    player : Player?
    event_controller : EventController?
    event_view : EventView?
    event_modal : EventModal?
    game_over_modal : GameOver?
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

        player = new Player(0)
        event_controller = new EventController()
        event_view = new EventView()
        event_modal = new EventModal()
        menu_button = new Button()
        game_over_modal = new GameOver()

        event_controller._event_view <- event_view
        event_controller._event_modal = event_modal
        event_controller._game_over_modal = game_over_modal
        event_controller._player = player
        player._date_of_birth = start_date

        event_controller->initialize()

        player._on_player_death <- @ <| () : void
            event_controller->show_game_over_modal()
            play_music_track(11)

        event_modal._on_death <- @ <| () : void
            invoke(player._on_player_death)

        menu_button._on_click <- @ <| () : void
            invoke(set_current_scene, "main_menu")
        
        menu_button._is_enabled = true

        game_is_paused = false
        apply_start_effects()
        handle_music(player->get_age())


    def finalize
        unsafe
            delete player
        unsafe
            delete event_controller
    
    
    def override act(dt:float)
        
        if game_is_paused
            return

        update_input()

        date_scroll_out_timer += dt
        event_scroll_out_timer += dt
        event_controller._timestep_timer += dt

        if date_scroll_out_timer >= 90.0 / SCROLL_SPEED
            update_speed()
            update_dates(1)
            player->pass_date()
            animate_character()
            event_controller->detect_collision()
            date_scroll_out_timer = 0.0

        if event_scroll_out_timer >= 1080.0 / SCROLL_SPEED
            event_scroll_out_timer = 0.0

        if event_controller._timestep_timer >= float(event_controller._timestep / DATE_STEP) / SCROLL_SPEED
            event_controller->on_timestep_pass()


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
        event_controller->update_view()
        render_dates()
        render_info()

        //fill_rect(width/2 + player._offset - 30, 920, 60, 60, 0xD61C4B)

        fill_circle(width/2 + player._offset, 920, 30, 0xCCCC92)

        //fill_circle(1075 + player_offset, 921, 13, 0xCCCC92)
        //fill_circle(1125 + player_offset, 921, 13, 0xCCCC92)


        fill_rect(width/2 - 30 + player._offset, 951, 60, 60, 0xD61C4B)

        if animation_state == 0
            fill_rect(width/2 + 5 + player._offset, 1011, 25, 35, 0x114CCA)
            fill_rect(width/2 - 30 + player._offset, 1011, 25, 15, 0x1B346E)
        if animation_state == 1
            fill_rect(width/2 - 30 + player._offset, 1011, 25, 35, 0x114CCA)
            fill_rect(width/2 + 5 + player._offset, 1011, 25, 15, 0x1B346E)

        if current_bg_color == BG_COLOR_WINTER
            render_weather(Weather SNOW)
        elif current_bg_color == BG_COLOR_AUTUMN
            render_weather(Weather RAIN)

        if game_over_modal._is_enabled
            game_over_modal->render(510, 100, 900, 900)
        if event_modal._is_enabled
            event_modal->render_event_modal(510, 100, 900, 900)


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

        text_out(x, anchors[1] + y_offset * 1, t("hp") + "" + string(player._player_params.health) + "/100", REGULAR_TEXT_COLOR)
        text_out(x, anchors[1] + y_offset * 2, t("pp") + "" + string(player._player_params.mental_health) + "/100", REGULAR_TEXT_COLOR)
        
        text_out(x, anchors[2] + y_offset * 1, t("age") + "" + string(player->get_age()), REGULAR_TEXT_COLOR)
        text_out(x, anchors[2] + y_offset * 2, t("money") + "" + string(player._player_params.money), REGULAR_TEXT_COLOR)
        text_out(x, anchors[2] + y_offset * 3, t("infl") + "" + string(player._player_params.influence), REGULAR_TEXT_COLOR)
        //text_out(1440, 170, "Speed: " + string(SCROLL_SPEED), REGULAR_TEXT_COLOR)
        //text_out(1440, 200, "Acc: " + string(SCROLL_ACCELERATION), REGULAR_TEXT_COLOR)
        //text_out(1440, 230, "Jerk: " + string(time_jerk), REGULAR_TEXT_COLOR)
        //text_out(1500, 200, "Time Passed: " + string(TIME_SUM), 0xA1A1A1)
        text_out(x, anchors[3] + y_offset * 1, t("will") + "" + string(player._player_params.willpower), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 2, t("str") + "" + string(player._player_params.strength), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 3, t("per") + "" + string(player._player_params.perception), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 4, t("end") + "" + string(player._player_params.endurance), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 5, t("cha") + "" + string(player._player_params.charisma), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 6, t("int") + "" + string(player._player_params.intelligence), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 7, t("agi") + "" + string(player._player_params.agility), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 8, t("luck") + "" + string(player._player_params.luck), REGULAR_TEXT_COLOR)


        set_font_size(12)

        text_out(x, anchors[4] + y_offset / 2  * 1 + 1, t("s.eru") + "" + string(player._player_skills.erudition), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 2 + 2, t("s.emp") + "" + string(player._player_skills.empathy), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 3 + 3, t("s.rhe") + "" + string(player._player_skills.rhetoric), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 4 + 4, t("s.ent") + "" + string(player._player_skills.enterprise), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 5 + 5, t("s.sur") + "" + string(player._player_skills.survivalist), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 6 + 6, t("s.art") + "" + string(player._player_skills.art), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 7 + 7, t("s.mus") + "" + string(player._player_skills.music), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 8 + 8, t("s.mat") + "" + string(player._player_skills.math), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 9 + 9, t("s.nla") + "" + string(player._player_skills.native_language), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 10 + 10, t("s.fla") + "" + string(player._player_skills.foreign_languages), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 11 + 11, t("s.phy") + "" + string(player._player_skills.physics), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 12 + 12, t("s.lit") + "" + string(player._player_skills.literature), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 13 + 13, t("s.tec") + "" + string(player._player_skills.technology), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 14 + 14, t("s.inf") + "" + string(player._player_skills.computer_science), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 15 + 15, t("s.geo") + "" + string(player._player_skills.geography), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 16 + 16, t("s.soc") + "" + string(player._player_skills.social_studies), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 17 + 17, t("s.che") + "" + string(player._player_skills.chemistry), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 18 + 18, t("s.ath") + "" + string(player._player_skills.athletics), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 19 + 19, t("s.swi") + "" + string(player._player_skills.swimming), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 20 + 20, t("s.dri") + "" + string(player._player_skills.driving), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 21 + 21, t("s.mar") + "" + string(player._player_skills.martial_arts), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 22 + 22, t("s.cwe") + "" + string(player._player_skills.cold_weapons), REGULAR_TEXT_COLOR)
        text_out(x, anchors[4] + y_offset / 2  * 23 + 23, t("s.fir") + "" + string(player._player_skills.firearms), REGULAR_TEXT_COLOR)

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

    def animate_character()
        if animation_state < 1
            animation_state++
        else
            animation_state = 0

    def update_input()
        if get_key(VK_ESCAPE)
            schedule_quit_game()

        let left = get_key(VK_A) || get_key(VK_LEFT)
        let right = get_key(VK_D) || get_key(VK_RIGHT)

        if left && player._offset >= -99
            player._offset -= 6
        elif right && player._offset <= 99
            player._offset += 6

    def apply_start_effects()
        player->add_effect(DEFAULT_TIME_JERK_EFFECT)
        player->add_effect(DEFAULT_AGING)
        player->add_effect(DEFAULT_DEMENTIA)
        player->add_effect(POCKET_MONEY_CHILD)
        player->add_effect(POCKET_MONEY_TEENAGER)
        player->add_effect(SPEND_POCKET_MONEY_CHILD)
        player->add_effect(SPEND_POCKET_MONEY_TEENAGER)