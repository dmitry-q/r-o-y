require daslib/media
require game

//options debugger            // uncomment for debug in VS Code
//require daslib/debug        // uncomment for debug in VS Code

var game : Game?

[export]
def initialize
    set_window_title("R.O.Y")
    set_resolution(1920, 1080)
    set_vsync_enabled(true)
    game = new Game()
    game->initialize()
    return


[export]
def act(dt: float)
    game->act(dt)
    return


[export]
def draw
    game->render()
    return
