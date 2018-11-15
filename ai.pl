value(Board, Player, Value):-
    (
        (Player = p1,
        NextPlayer = p2);

        (Player = p2,
        NextPlayer = p1)
    ),
    valid_moves(Board,NextPlayer,Moves),
    length(Moves,Length),
    Value is -Length.