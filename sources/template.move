/// Module: template
module template::template;

// === Errors ===
const ENotYourTurn: u64 = 1;
const EInvalidPos: u64 = 2;
const EAlreadySettleDown: u64 = 3;

// === Structs ===
public struct Game has key {
    id: UID,

    first_player: ID,
    second_player: ID,

    next_player: ID,

    pos_1: Option<ID>,
    pos_2: Option<ID>,
    pos_3: Option<ID>,
    pos_4: Option<ID>,
    pos_5: Option<ID>,
    pos_6: Option<ID>,
    pos_7: Option<ID>,
    pos_8: Option<ID>,
    pos_9: Option<ID>,

    winner: Option<ID>,
}

public struct PlayerCap has key, store {
    id: UID,
}

// === Public-Mutative Functions ===
fun init(_ctx: &TxContext) { }

// === Public-View Functions ===
public fun complete(self: &Game): bool {
    self.winner.is_some()
}

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
        pos_1: option::none<ID>(),
        pos_2: option::none<ID>(),
        pos_3: option::none<ID>(),
        pos_4: option::none<ID>(),
        pos_5: option::none<ID>(),
        pos_6: option::none<ID>(),
        pos_7: option::none<ID>(),
        pos_8: option::none<ID>(),
        pos_9: option::none<ID>(),
        winner: option::none<ID>(),
    });

    transfer::transfer(first_player, to);
    transfer::transfer(second_player, tx_context::sender(ctx));
}

public entry fun next(game: &mut Game, player: &PlayerCap, pos: u8) {
    assert!(game.next_player == object::id(player), ENotYourTurn);
    assert!(game.winner.is_none(), EAlreadySettleDown);

    if (object::id(player) == game.first_player) {
        game.next_player = game.second_player;
    } else {
        game.next_player = game.first_player;
    };

    if(pos == 1 && game.pos_1.is_none() ) {
        game.pos_1 = option::some(object::id(player));
    } else if (pos == 2 && game.pos_2.is_none()) {
        game.pos_2 = option::some(object::id(player));
    } else if (pos == 3 && game.pos_3.is_none()) {
        game.pos_3 = option::some(object::id(player));
    } else if (pos == 4 && game.pos_4.is_none()) {
        game.pos_4 = option::some(object::id(player));
    } else if (pos == 5 && game.pos_5.is_none()) {
        game.pos_5 = option::some(object::id(player));
    } else if (pos == 6 && game.pos_6.is_none()) {
        game.pos_6 = option::some(object::id(player));
    } else if (pos == 7 && game.pos_7.is_none()) {
        game.pos_7 = option::some(object::id(player));
    } else if (pos == 8 && game.pos_8.is_none()) {
        game.pos_8 = option::some(object::id(player));
    } else if (pos == 9 && game.pos_9.is_none()) {
        game.pos_9 = option::some(object::id(player));
    } else {
        abort EInvalidPos
    };

    game.settle_down(pos);
}

// === Private Functions ===
fun settle_down(self: &mut Game, pos: u8) {
    if (pos == 1) {
        if (self.pos_1 == self.pos_2 && self.pos_1 == self.pos_3) {
            self.winner = self.pos_1;
        } else if (self.pos_1 == self.pos_4 && self.pos_1 == self.pos_6) {
            self.winner = self.pos_1;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 2){
        if (self.pos_2 == self.pos_1 && self.pos_2 == self.pos_3) {
            self.winner = self.pos_2;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 3){
        if (self.pos_3 == self.pos_1 && self.pos_3 == self.pos_2) {
            self.winner = self.pos_3;
        } else if (self.pos_3 == self.pos_6 && self.pos_3 == self.pos_9) {
            self.winner = self.pos_3;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 4){
        if (self.pos_4 == self.pos_1 && self.pos_4 == self.pos_7) {
            self.winner = self.pos_4;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 5){
        if (self.pos_5 == self.pos_1 && self.pos_5 == self.pos_9) {
            self.winner = self.pos_5;
        } else if (self.pos_5 == self.pos_2 && self.pos_5 == self.pos_8) {
            self.winner = self.pos_5;
        } else if (self.pos_5 == self.pos_3 && self.pos_5 == self.pos_7) {
            self.winner = self.pos_5;
        } else if (self.pos_5 == self.pos_4 && self.pos_5 == self.pos_6) {
            self.winner = self.pos_5;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 6){
        if (self.pos_6 == self.pos_3 && self.pos_6 == self.pos_9) {
            self.winner = self.pos_6;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 7){
        if (self.pos_7 == self.pos_1 && self.pos_7 == self.pos_4) {
            self.winner = self.pos_7;
        } else if (self.pos_7 == self.pos_8 && self.pos_7 == self.pos_9) {
            self.winner = self.pos_7;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 8){
        if (self.pos_8 == self.pos_7 && self.pos_8 == self.pos_9) {
            self.winner = self.pos_8;
        } else {
            self.winner = option::none<ID>();
        }
    } else if (pos == 9){
        if (self.pos_9 == self.pos_3 && self.pos_9 == self.pos_6) {
            self.winner = self.pos_9;
        } else if (self.pos_9 == self.pos_8 && self.pos_9 == self.pos_7) {
            self.winner = self.pos_9;
        } else {
            self.winner = option::none<ID>();
        }
    } else {
        self.winner = option::none<ID>();
    }
}

// === Test Functions ===
// The setup function can use in the test packages, it is current practice
#[test_only]
public fun init_for_testing(ctx: &TxContext) {
    init(ctx);
}
