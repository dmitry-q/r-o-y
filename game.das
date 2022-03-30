require daslib/media
require utils/date
require time
require random
require constants
require components/player
require components/event_view
require components/event_modal
require components/game_over
require components/sound_collection
require event_controller
require event
require content/start_effects


module game public

enum Weather
    NO
    RAIN
    SNOW


class Game

    RAND_SEED: int4
    animation_state : int = 0
    player = new Player(0)
    event_controller = new EventController()
    event_view = new EventView()
    event_modal = new EventModal()
    game_over_modal = new GameOver()
    current_bg_color : uint

    def initialize()

        randomize_seed(RAND_SEED)
        apply_start_effects()
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

        handle_music(player->get_age())

    
    def act(dt:float)
        
        if game_is_paused
            return

        update_input()

        date_scroll_out_timer += dt
        event_scroll_out_timer += dt
        event_controller._timestep_timer += dt

        if date_scroll_out_timer >= 90.0 / SCROLL_SPEED
            update_dates(1)
            player->pass_date()
            animate_character()
            event_controller->detect_collision()
            date_scroll_out_timer = 0.0

        if event_scroll_out_timer >= 1080.0 / SCROLL_SPEED
            event_scroll_out_timer = 0.0

        if event_controller._timestep_timer >= float(event_controller._timestep / DATE_STEP * 2) / SCROLL_SPEED
            event_controller->on_timestep_pass()


    def render()
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

        let x = 1660
        let anchors <- [{auto 955; 0; 395; 100}]
        let y_offset = 32
        let skills_start_y = 0

        set_font_size(30)

        text_out(x + 50, anchors[0], "Сегодня:", REGULAR_TEXT_COLOR)
        text_out(x + 30, anchors[0] + 40, format_date(current_date, DateFormat RU), REGULAR_TEXT_COLOR)

        set_font_size(24)

        text_out(x, anchors[1] + y_offset * 1, "Здоровье: " + string(player._player_params.health) + "/100", REGULAR_TEXT_COLOR)
        text_out(x, anchors[1] + y_offset * 2, "Психика:  " + string(player._player_params.mental_health) + "/100", REGULAR_TEXT_COLOR)
        
        text_out(x, anchors[2] + y_offset * 1, "Возраст:  " + string(player->get_age()), REGULAR_TEXT_COLOR)
        text_out(x, anchors[2] + y_offset * 2, "Деньги:   " + string(player._player_params.money), REGULAR_TEXT_COLOR)
        text_out(x, anchors[2] + y_offset * 3, "Влияние:  " + string(player._player_params.influence), REGULAR_TEXT_COLOR)
        //text_out(1640, 170, "Speed: " + string(SCROLL_SPEED), REGULAR_TEXT_COLOR)
        //text_out(1500, 200, "Time Passed: " + string(TIME_SUM), 0xA1A1A1)
        text_out(x, anchors[3] + y_offset * 1, "Воля:          " + string(player._player_params.willpower), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 2, "Сила:          " + string(player._player_params.strength), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 3, "Восприятие:    " + string(player._player_params.perception), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 4, "Выносливость:  " + string(player._player_params.endurance), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 5, "Харизма:       " + string(player._player_params.charisma), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 6, "Интеллект:     " + string(player._player_params.intelligence), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 7, "Ловкость:      " + string(player._player_params.agility), REGULAR_TEXT_COLOR)
        text_out(x, anchors[3] + y_offset * 8, "Удача:         " + string(player._player_params.luck + 0), REGULAR_TEXT_COLOR)

        var i = 0
        set_font_size(14)
        for event in event_controller._available_events
            text_out(1440, 80 + i * 26, event._name + " " + string(event._spawn_limit) + " " + string(event_controller->get_event_spawned_count(event._id)), REGULAR_TEXT_COLOR)
            i++

        text_out(1440, 40, string(event_controller._timestep / 90), REGULAR_TEXT_COLOR)
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
            var x : int = random_int(RAND_SEED)
            var y : int = random_int(RAND_SEED)
        
            while x < 282 || x > get_screen_width() - 282
                x = random_int(RAND_SEED)
            
            while y < 0 || y > get_screen_height()
                y = random_int(RAND_SEED)

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
        player->add_effect(DEFAULT_AGING)
        player->add_effect(DEFAULT_TIME_JERK_EFFECT)
        player->add_effect(DEFAULT_DEMENTIA)