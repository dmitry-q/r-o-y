require daslib/media
require date
require time
require event

module event_view public

let default_icon_color = make_color32(255, 255, 255, 255)

class EventView
    _events : array<tuple<EventViewData; int2>>

    def push_to_render(event: tuple<EventViewData; int>)

        let width = get_screen_width() / 2
        let height = -34
        var event_to_push : tuple<EventViewData; int2>
        event_to_push._0 = event._0

        if event._1 == 0
            event_to_push._1 = int2(width - 60, height)
        else
            event_to_push._1 = int2(width + 60, height)

        push(_events, event_to_push)


    def remove_from_render(by_date : Date)
        for e in _events
            let date = e._0.spawned_at
            if date.day == current_date.day && date.month == current_date.month && date.year == current_date.year
                e._0.id = 0

    def update()
        let screen_height = get_screen_height()
        var len = length(_events)

        for i in range(0, len)
            var width = get_screen_width() / 2
            var height = int()

            if _events[i]._1.y > screen_height + 34
                //erase(_events, i)
                continue

            if _events[i]._0.id != 0
                _events[i]._1.y = int(float(_events[i]._1.y) + SCROLL_SPEED * get_delta_time())
                render_icon(_events[i]._0.icon, _events[i]._1.x, _events[i]._1.y, 68.0)


def render_icon(icon: ImageHandle; x, y : int; size : float)
    enable_premultiplied_alpha_blend()
    icon |> premultiply_alpha()
    icon |> draw_image(float(x) - 34.0, float(y) - 34.0, default_icon_color, size)
    disable_alpha_blend() 
