require daslib/media
require date
require time
require event

module event_view public

let default_icon_color = make_color32(255, 255, 255, 255)

class EventView
    _events : array<EventViewData>

    def push_to_render(event: EventViewData)

        var event_to_push = event
        let width = get_screen_width() / 2
        event_to_push.pos.y = -34

        if event.spawn_spot == 0
            event_to_push.pos = int2(width - 60, event_to_push.pos.y)
        else
            event_to_push.pos = int2(width + 60, event_to_push.pos.y)

        push(_events, event_to_push)


    def remove_from_render(by_date : Date)
        for e in _events
            let date = e.spawned_at
            if date.day == by_date.day && date.month == by_date.month && date.year == by_date.year
                e.id = 0


    def update()
        let screen_height = get_screen_height()

        for e in _events
            if e.id != 0
                e.pos.y = int(float(e.pos.y) + SCROLL_SPEED * get_delta_time())
                render_icon(e.icon, e.pos.x, e.pos.y, 68.0)
            if e.pos.y > screen_height + 34
                remove_from_render(e.spawned_at)


def render_icon(icon: ImageHandle; x, y : int; size : float)
    enable_premultiplied_alpha_blend()
    icon |> premultiply_alpha()
    icon |> draw_image(float(x) - 34.0, float(y) - 34.0, default_icon_color, size)
    disable_alpha_blend() 
