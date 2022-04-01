require daslib/media
require components/scene
require components/globals
require main_menu
require game


//options debugger            // uncomment for debug in VS Code
//require daslib/debug        // uncomment for debug in VS Code

var scenes : table<string; Scene?>
var current_scene : Scene?

[export]
def initialize
    set_window_title("R.O.Y")
    set_resolution(1920, 1080)
    set_vsync_enabled(true)

    lang = Language RU
    dict_RU <- initialize_locales_RU()
    dict_EN <- initialize_locales_EN()
    create_scenes()

    set_current_scene <- @ <| (name : string) : void
        scenes[name]->initialize()
        current_scene = scenes[name]

    invoke(set_current_scene, "main_menu")
    return


[export]
def act(dt: float)
    current_scene->act(dt)
    return


[export]
def draw
    current_scene->render()
    return


def create_scenes()
    scenes["game"] = new Game()
    scenes["main_menu"] = new MainMenu()
