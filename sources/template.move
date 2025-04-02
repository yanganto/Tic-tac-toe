/// Module: template
module template::template;

// === Imports ===

// === Errors ===
const ENotYourTurn: u64 = 1;

// === Constants ===

// === Structs ===
public struct Game has key {
    id: UID,

    first_player: ID,
    second_player: ID,

    next_player: ID,
}

public struct PlayerCap has key, store {
    id: UID,
}

// === Method Aliases ===

// === Public-Mutative Functions ===
fun init(_ctx: &TxContext) { }

// === Public-View Functions ===

// === Admin Functions ===

// === Public-Package Functions ===
public entry fun make_game_challenge(
    to: address,
    ctx: &mut TxContext,
) {
    let first_player = PlayerCap {
        id: object::new(ctx),
    };
    let second_player = PlayerCap {
        id: object::new(ctx),
    };

    transfer::share_object(Game {
        id: object::new(ctx),
        first_player: object::id(&first_player),
        second_player: object::id(&second_player),
        next_player: object::id(&first_player),
    });

    transfer::transfer(first_player, to);
    transfer::transfer(second_player, tx_context::sender(ctx));
}

public entry fun next(game: &mut Game, player: &PlayerCap, _pos: u8) {
    assert!(game.next_player == object::id(player), ENotYourTurn);
    if (object::id(player) == game.first_player) {
        game.next_player = game.second_player;
    } else {
        game.next_player = game.first_player;
    }

}


// === Private Functions ===

// === Test Functions ===
// The setup function can use in the test packages, it is current practice
#[test_only]
public fun init_for_testing(ctx: &TxContext) {
    init(ctx);
}
