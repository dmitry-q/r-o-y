require daslib/media
require utils/date
require event
require player
require random
require time
require event_view
require ui/event_modal


module event_controller public


class EventController

    _player : Player?
    _event_view : EventView?
    _event_modal : EventModal?
    _all_events : array<Event?>
    _spawned_events : array<EventViewData>
    _available_events : array<Event?>
    _timestep : int
    _timestep_timer : float = 0.0


    def initialize_all_events()
        _all_events <- [{auto test_event}]
        push(_available_events, test_event)
        return


    def detect_collision() : bool
        for se in _spawned_events
            var date = se.spawned_at
            if date.day == current_date.day && date.month == current_date.month && date.year == current_date.year
                if sign(sign(_player._offset) + 1) == se.spawn_spot
                    on_event_happen(se)
                    return true

        return false


    def on_event_happen(event : EventViewData)
        var event_example = get_event_by_id(event.id)
        _player->register_event(event_example, event.spawned_at)
        _event_view->remove_from_render(event.spawned_at)
        game_is_paused = true
        _event_modal->show(event_example._name, event_example._description, event_example._effect_description)


    def update_view()
        if game_is_paused
            return
        _event_view->update()

    
    def push_event_to_render(event : EventViewData)
        var event_to_render : tuple<EventViewData; int>
        event_to_render._0 = event
        event_to_render._1 = event.spawn_spot
        _event_view->push_to_render(event_to_render)


    def update_available_events()
        order_available_events()
        update_timestep()
        return


    def on_timestep_pass() // int[2] : ids

        var rand_seed: int4
        randomize_seed(rand_seed)
        var first_spot_index : int
        _timestep_timer = 0.0

        first_spot_index = -1
        while first_spot_index < 0 || first_spot_index > 1
            first_spot_index = random_int(rand_seed)

        var spawned_event : EventViewData = spawn_event(0, first_spot_index)
        if spawned_event.id == 0
            return

        push_event_to_render(spawned_event)

        let event_example = get_event_by_id(spawned_event.id)
        if event_example._can_be_paired == true
            var event_to_pair = try_get_event_to_spawn_by_id(event_example._preferred_to_pair_event_id)

            if event_to_pair == null
                return
            else
                var pairing_event = spawn_event(event_to_pair._id, first_spot_index == 0 ? 1 : 0)
                push_event_to_render(pairing_event)
                return
        return


    def update_timestep()
        return


    def spawn_event(specific_event_id , spot : int) : EventViewData //left / right
        var screen_upper_date = dates[12]

        if specific_event_id != 0
            var specific_event = try_get_event_to_spawn_by_id(specific_event_id)

            var view_data : EventViewData = event_to_view_data(specific_event, screen_upper_date, spot)
            push(_spawned_events, view_data)
            update_available_events()
            return view_data //get by id from available

        var to_spawn : Event? = get_event_to_spawn()

        if to_spawn == null
            return [[EventViewData() id=0, spawned_at=current_date, spawn_spot=-1]]

        var view_data : EventViewData = event_to_view_data(to_spawn, screen_upper_date, spot)
        push(_spawned_events, view_data)
        update_available_events()
        return view_data


    def get_event_to_spawn() : Event?

        var rand_seed: int4
        randomize_seed(rand_seed)
        var x : int = random_int(rand_seed)

        while x < 1 || x > 100
            x = random_int(rand_seed)

        var len = length() <| _available_events
        for i in range(0, len)
            if _available_events[i] != null && _available_events[i]._spawn_chance >= x
                var event_to_spawn : Event? := _available_events[i]
                _available_events[i]._spawn_limit--
                try_erase_event_from_available(i)
                return event_to_spawn

        return null


    def try_get_event_to_spawn_by_id(event_id : int) : Event?
        var len = length() <| _available_events

        for i in range(0, len-1)
            if event_id == _available_events[i]._id
                _available_events[i]._spawn_limit--
                return _available_events[i]
        
        return null


    def order_available_events()
        return


    def try_erase_event_from_available(index : int)
        if _available_events[index] == null
            return
        if _available_events[index]._happen_limit <= get_event_happen_count(_available_events[index]._id) || (
                _available_events[index]._spawn_limit <= 0)
            erase(_available_events, index)


    def get_event_spawned_count(event_id : int) : int
        var count : int = 0
        var len = length() <| _spawned_events

        for i in range(0, len)
            if event_id == _spawned_events[i].id
                count++

        return count


    def get_event_happen_count(event_id : int) : int
        var count : int = 0
        var len = length() <| _player._events_happen

        for i in range(0, len)
            if event_id == _player._events_happen[i]._0
                count++

        return count


    def get_event_by_id(event_id : int) : Event?

        for event in _all_events
            if event._id == event_id
                return event

        return null