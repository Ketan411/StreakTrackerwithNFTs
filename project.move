module StreakTracker::Tracker {
    use aptos_framework::signer;
    use aptos_framework::token;
    
    struct Streak has key, store {
        count: u64,
    }

    public fun increment_streak(user: &signer) {
        if (!exists<Streak>(signer::address_of(user))) {
            move_to(user, Streak { count: 1 });
        } else {
            let streak = borrow_global_mut<Streak>(signer::address_of(user));
            streak.count = streak.count + 1;
        }
    }

    public fun claim_nft(user: &signer, name: vector<u8>, uri: vector<u8>) {
        let streak = borrow_global<Streak>(signer::address_of(user));
        assert!(streak.count >= 7, 1); // Require a streak of at least 7 days

        token::create_token(
            user, name, name, uri, 1, signer::address_of(user),
            0, 0, 0, vector[], vector[], vector[]
        );
    }
}
