require daslib/media
require utils/date
require time
require random
require components/player
require components/start_effects
require components/event_controller
require components/event_view
require components/ui/event_modal
require event


// options debugger            // uncomment for debug in VS Code
// require daslib/debug        // uncomment for debug in VS Code

let REGULAR_TEXT_COLOR: uint = 0xA9F5EB
let UI_BG_COLOR: uint = 0x243D39

var RAND_SEED: int4
var animation_state : int = 0
var player = new Player(0)
var event_controller = new EventController()
var event_view = new EventView()
var event_modal = new EventModal()

// 'initialize' runs once when game starts and every hot-reload
[export]
def initialize
    set_window_title("As It Is")
    set_resolution(1920, 1080)
    randomize_seed(RAND_SEED)
    apply_start_effects()
    init_events()
    event_controller->initialize_all_events()
    event_controller._event_view <- event_view
    event_controller._event_modal = event_modal
    event_controller._player = player
    return

// this function is called to update game data,
// dt - time elapsed since the previous update (in seconds)
[export]
def act(dt: float)

    if game_is_paused
        return

    update_input()

    date_scroll_out_timer += dt
    event_scroll_out_timer += dt
    event_controller._timestep_timer += dt

    if date_scroll_out_timer >= 90.0 / SCROLL_SPEED
        update_dates(1)
        player->pass_day()
        player->update_active_effects()
        animate_character()
        event_controller->detect_collision()
        date_scroll_out_timer = 0.0

    if event_scroll_out_timer >= 1080.0 / SCROLL_SPEED
        event_scroll_out_timer = 0.0

    if event_controller._timestep_timer >= 300.0 / SCROLL_SPEED
        event_controller->on_timestep_pass()

    return

// this function will be called every frame after 'act',
// you can draw anything in this function
[export]
def draw
    var width = get_screen_width()
    fill_rect(0, 0, 280, get_screen_height(), UI_BG_COLOR)
    fill_rect(280, 0, get_screen_width(), get_screen_height(), 0x3C6660)
    fill_rect(1640, 0, 279, get_screen_height(), UI_BG_COLOR)
    //line(280, 0, 280, 1080, REGULAR_TEXT_COLOR)
    //line(1640, 0, 1640, 1080, REGULAR_TEXT_COLOR)

    render_road()
    //render_rain()
    event_controller->update_view()
    render_dates()

    set_font_size(24)
    text_out(1670, 50, "Health: " + string(player._player_params.health) + "/100", REGULAR_TEXT_COLOR)
    text_out(1670, 80, "Age: " + string(player->get_age()), REGULAR_TEXT_COLOR)
    text_out(1670, 110, "Money: 2000", REGULAR_TEXT_COLOR)
    text_out(1670, 140, "Date: " + format_date(current_date, DateFormat ENG), REGULAR_TEXT_COLOR)
    //text_out(1640, 170, "Speed: " + string(SCROLL_SPEED), REGULAR_TEXT_COLOR)
    //text_out(1500, 200, "Time Passed: " + string(TIME_SUM), 0xA1A1A1)
    text_out(1670, 230, "Int: " + string(player._player_params.intelligence), REGULAR_TEXT_COLOR)

    fill_circle(width/2  + player._offset, 920, 30, 0xCCCC92)
    //fill_circle(1075 + player_offset, 921, 13, 0xCCCC92)
    //fill_circle(1125 + player_offset, 921, 13, 0xCCCC92)
    //dfill_rect(1074 + player_offset, 875, 52, 60, 0x272626)

    fill_rect(width/2 - 30 + player._offset, 951, 60, 60, 0xD61C4B)

    if animation_state == 0
        fill_rect(width/2 + 5 + player._offset, 1011, 25, 35, 0x114CCA)
        fill_rect(width/2 - 30 + player._offset, 1011, 25, 15, 0x1B346E)
    if animation_state == 1
        fill_rect(width/2 - 30 + player._offset, 1011, 25, 35, 0x114CCA)
        fill_rect(width/2 + 5 + player._offset, 1011, 25, 15, 0x1B346E)

    if !event_modal._is_closed
        var text = "For many people in Britain, the word “scouting” evokes images of boys in short trousers and girls in blue uniforms. Many people imagine that the Scout Association and its female counterpart the Guides Association are old-fashioned organisations from another age - associations for people who are more interested"
        event_modal->render_event_modal(510, 100, 900, 900, "Random event", text)

    return

def render_dates()
    for i in range(0, 14)
        text_out(80, get_screen_height() - 90 - i * 90 + int(date_scroll_out_timer * SCROLL_SPEED), format_date(dates[i], DateFormat ENG), REGULAR_TEXT_COLOR)

def render_road()
    var width = get_screen_width()
    var x0 = width
    var x1 = width / 2 - 140
    var x2 = width / 2 + 140

    fill_rect(x1, 0, -5, get_screen_height(),  REGULAR_TEXT_COLOR)
    fill_rect(x1, 0, 280, get_screen_height(),  0x6E564A)
    fill_rect(x2, 0, 5, get_screen_height(),  REGULAR_TEXT_COLOR)

def render_rain()
    for i in range(0, 255)
        var x : int = random_int(RAND_SEED)
        var y : int = random_int(RAND_SEED)
    
        while x < 280 || x > get_screen_width()
            x = random_int(RAND_SEED)
        
        while y < 0 || y > get_screen_height()
            y = random_int(RAND_SEED)

        line(x, y, x, y+15, 0xA1A1A1)

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