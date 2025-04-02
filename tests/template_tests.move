#[test_only]
module template::template_tests;

#[test]
fun test_template() {
    use sui::test_scenario;
    use template::template::{init, make_game_challenge, next, PlayerCap, Game};

    let first_player: address = @0x0001;
    let second_player: address = @0x0002;

    let mut scenario = test_scenario::begin(@0xAAAA);
    {
        init(scenario.ctx());
    };

    scenario.next_tx(second_player);
    {
        make_game_challenge(first_player, scenario.ctx())
    };

    scenario.next_tx(first_player);
    {
        let mut game = scenario.take_shared<Game>();
        let cap = scenario.take_from_sender<PlayerCap>();

        //  | |
        // -+-+-
        //  |O|
        // -+-+-
        //  | |
        next(&mut game, &cap, 5);

        test_scenario::return_shared(game);
        scenario.return_to_sender(cap);
    };

    scenario.next_tx(second_player);
    {
        let mut game = scenario.take_shared<Game>();
        let cap = scenario.take_from_sender<PlayerCap>();

        //  | |X
        // -+-+-
        //  |O|
        // -+-+-
        //  | |
        next(&mut game, &cap, 3);

        test_scenario::return_shared(game);
        scenario.return_to_sender(cap);
    };

    scenario.next_tx(first_player);
    {
        let mut game = scenario.take_shared<Game>();
        let cap = scenario.take_from_sender<PlayerCap>();

        //  | |X
        // -+-+-
        //  |O|
        // -+-+-
        //  |O|
        next(&mut game, &cap, 8);

        test_scenario::return_shared(game);
        scenario.return_to_sender(cap);
    };

    scenario.next_tx(second_player);
    {
        let mut game = scenario.take_shared<Game>();
        let cap = scenario.take_from_sender<PlayerCap>();

        //  | |X
        // -+-+-
        //  |O|X
        // -+-+-
        //  |O|
        next(&mut game, &cap, 6);

        test_scenario::return_shared(game);
        scenario.return_to_sender(cap);
    };

    scenario.next_tx(first_player);
    {
        let mut game = scenario.take_shared<Game>();
        let cap = scenario.take_from_sender<PlayerCap>();

        //  |O|X
        // -+-+-
        //  |O|X
        // -+-+-
        //  |O|
        next(&mut game, &cap, 2);

        test_scenario::return_shared(game);
        scenario.return_to_sender(cap);
    };

    scenario.end();
}
