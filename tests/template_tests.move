#[test_only]
module template::template_tests;
// uncomment this line to import the module
// use template::template;
// uncomment this line to call the init_for_testing
// use template::template::init_for_testing;

const ENotImplemented: u64 = 0;

#[test]
fun test_template() {
    use sui::test_scenario;
    use std::debug;
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

    scenario.end();
}

