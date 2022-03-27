require date
require daslib/media


module sound_collection public


let DEFAULT_MUSIC_VOLUME : float = 0.12

let click <- create_managed_sound("assets/sfx/click.mp3")
let modal_open_fail <- create_managed_sound("assets/sfx/modal_open_fail.mp3")
let modal_open_neutral <- create_managed_sound("assets/sfx/modal_open_neutral.mp3")
let collect <- create_managed_sound("assets/sfx/collect.wav")

var current_music : PcmSound
var playing_music : PlayingSoundHandle

def handle_music(current_date: Date; date_of_birth: Date; age : int)
    if current_date.day == date_of_birth.day && current_date.month == date_of_birth.month
        var track : int 
        if age < 1
            track = 1
        elif age > 0 && age < 4
            track = 2
        elif age > 3 && age < 7
            track = 3
        elif age > 6 && age < 13
            track = 4
        elif age > 12 && age < 20
            track = 5
        elif age > 19 && age < 23
            track = 6
        elif age > 22 && age < 36
            track = 7
        elif age > 35 && age < 60
            track = 8
        elif age > 59 && age < 75
            track = 9
        elif age > 74 && age < 90
            track = 10
        else
            track = 11

        delete(current_music)
        current_music <- create_sound("assets/music/{track}.mp3")
        playing_music = current_music |> play_sound_loop(DEFAULT_MUSIC_VOLUME)