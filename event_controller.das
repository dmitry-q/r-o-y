require daslib/media
require date
require event
require player
require random
require time
require components/event_view
require components/event_modal
require components/game_over
require content/events/baby_pack
require components/sound_collection


module event_controller public


class EventController

    _player : Player?
    _event_view : EventView?
    _event_modal : EventModal?
    _game_over_modal : GameOver?
    _all_events : array<Event?>
    _spawned_events : array<EventViewData>
    _available_events : array<Event?>
    _timestep : int
    _timestep_timer : float = 0.0

    def initialize()
        init_baby_pack()
        init_baby_pack_2()
        _all_events <- [{auto e_0001; e_0002; e_0003; e_0004; e_0005; e_0006; e_0007; e_0008; e_0009; e_0010; e_0011; e_0012; e_0012_1; e_0012_2; e_0013;
                        e_0014; e_0015; e_0016; e_0017; e_0020}]

        add_events_fit_by_age(_player->get_age())
        update_available_events()
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

        if event_example._happen_limit <= get_event_happen_count(event.id)
            _event_view->remove_from_render(event.spawned_at)
            return

        var is_success = _player->validate_player_params(event_example._required_params_for_success) && (
                         _player->validate_player_skills(event_example._required_skills_for_success))

        var fit_log_message = is_success ? event_example._log_message.on_success : event_example._log_message.on_fail

        _player->register_event(event_example, event.spawned_at, event_example._icon, fit_log_message, is_success)
        _event_view->remove_from_render(event.spawned_at)
        update_available_events()
        game_is_paused = true

        var fit_description = is_success ? event_example._description.on_success : event_example._description.on_fail
        var fit_effect_description = is_success ? event_example._effect_description.on_success : event_example._effect_description.on_fail
        var is_player_dead = _player._is_dead
        
        _event_modal->show(event_example._name, fit_description, fit_effect_description, event_example._id, event_example._icon, is_player_dead)

        play_sound(collect)
        if is_success
            play_sound(modal_open_neutral, 0.3)
        else
            play_sound(modal_open_fail, 0.3)


    def update_view()
        if game_is_paused
            return
        _event_view->update()


    def show_game_over_modal()
        _game_over_modal->show(_player._events_happen)

    
    def push_event_to_render(event : EventViewData)
        var event_to_render : tuple<EventViewData; int>
        event_to_render._0 = event
        event_to_render._1 = event.spawn_spot
        _event_view->push_to_render(event_to_render)


    def update_available_events()
        add_events_fit_by_age(_player->get_age())
        _available_events <- validate_available_events()
        order_available_events()
        update_timestep()
        return

    def add_events_fit_by_age(age : int)
        for event in _all_events
            if event._min_age <= age && (event._max_age >= age || event._max_age == -1)
                var i = find_index(_available_events, event)
                if i < 0 
                    _available_events |> push(event)


    def validate_available_events() : array<Event?>
        let age = _player->get_age()
        var new_array : array<Event?>
        for event in _available_events
            if event._min_age <= age && event._max_age >= age && event._happen_limit > get_event_happen_count(event._id) && event._spawn_limit > 0
                if _player->validate_happen_events(event._required_events_ids) && (
                        _player->validate_player_params(event._required_params_for_spawn) && _player->validate_player_skills(event._required_skills_for_spawn))
                    new_array |> push(event)

        return <- new_array


    def on_timestep_pass() // int[2] : ids

        var rand_seed: int4
        randomize_seed(rand_seed)
        var first_spot_index : int
        _timestep_timer = 0.0

        validate_available_events()

        first_spot_index = -1
        while first_spot_index < 0 || first_spot_index > 1
            first_spot_index = random_int(rand_seed)

        var spawned_event : EventViewData = spawn_event(0, first_spot_index)
        if spawned_event.id == 0
            update_timestep()
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

        var rand_seed: int4
        randomize_seed(rand_seed)

        var age = _player->get_age()
        var age_in_days = _player._player_params.age_in_days
        var count = get_possible_events_to_spawn_count()
        var distance = 365

        // for event in _available_events
        //     if event._min_age == 0 && event._max_age == -1
        //         count = count - event._spawn_limit

        var step : int
        
        if count > 12
            step = 1
        else
            step = distance / count

        if step <= 1
            step = random_int(rand_seed)
            while step < 2 || step > 11
                step = random_int(rand_seed)

        _timestep = step * 90

        return


    def spawn_event(specific_event_id , spot : int) : EventViewData //left / right
        var screen_upper_date = dates[12]

        if specific_event_id != 0
            var specific_event = try_get_event_to_spawn_by_id(specific_event_id)

            var view_data : EventViewData = event_to_view_data(specific_event, screen_upper_date, spot, specific_event._icon)
            push(_spawned_events, view_data)
            update_available_events()
            return view_data //get by id from available

        var to_spawn : Event? = get_event_to_spawn()

        if to_spawn == null
            return [[EventViewData() id=0, spawned_at=current_date, spawn_spot=-1]]

        var view_data : EventViewData = event_to_view_data(to_spawn, screen_upper_date, spot, to_spawn._icon)
        push(_spawned_events, view_data)
        update_available_events()
        return view_data


    def get_event_to_spawn() : Event?

        var rand_seed: int4
        randomize_seed(rand_seed)
        var x : int = random_int(rand_seed)

        while x < 1 || x > 100
            x = random_int(rand_seed)

        var candidates : array<Event?>

        for event in _available_events
            var chance = event._spawn_chance
            if event != null && chance != 0 && chance >= x
                push(candidates, event)

        if length(candidates) < 1
            return null

        x = random_int(rand_seed)
        while x < 0 || x > length(candidates) - 1
            x = random_int(rand_seed)

        candidates[x]._spawn_limit = candidates[x]._spawn_limit > 0 ? candidates[x]._spawn_limit-1 : 0
        return candidates[x]


    def try_get_event_to_spawn_by_id(event_id : int) : Event?
        var len = length() <| _available_events

        for i in range(0, len-1)
            if event_id == _available_events[i]._id
                _available_events[i]._spawn_limit = _available_events[i]._spawn_limit > 0 ? _available_events[i]._spawn_limit-1 : 0
                return _available_events[i]
        
        return null


    def order_available_events()
        return


    def get_event_spawned_count(event_id : int) : int
        var count : int = 0

        for event in _spawned_events
            if event_id == event.id
                count++

        return count


    def get_event_happen_count(event_id : int) : int
        var count : int = 0
        var len = length() <| _player._events_happen

        for i in range(0, len)
            if event_id == _player._events_happen[i].id
                count++

        return count

    
    def get_possible_events_to_spawn_count() : int
        var count : int = 0
        for event in _available_events
            count += event._spawn_limit
        
        return count


    def get_event_by_id(event_id : int) : Event?

        for event in _all_events
            if event._id == event_id
                return event

        return null