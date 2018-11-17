%Gets the Board Value for Player
value(Board,Player,Value):-
    (
        (Player = p1,
        NextPlayer = p2);

        (Player = p2,
        NextPlayer = p1)
    ),
    valid_moves(Board,NextPlayer,Moves),
    length(Moves,Length),
    Value is -Length.

%Simulates a move done by Yuki, needed when Difficulty > 1
simulateMoveYuki(Player,Line,Col,Board,Value,NewBoard):-
    yuki(X,Y),
    (
        (X < 0,
        Y < 0,
        setPeca(Line,Col,y,Board,NewBoard));
    
        (OldX is X + 1,
        OldY is Y + 1,
        setPeca(OldX,OldY,w,Board,Next),
        setPeca(Line,Col,y,Next,NewBoard))
    ),
    retract(yuki(X,Y)),
    NewX is Line - 1,
    NewY is Col - 1,
    assert(yuki(NewX,NewY)),
    value(NewBoard,Player,Value).

%Simulates a move done by Mina, needed when Difficulty > 1
simulateMoveMina(Player,Line,Col,Board,Value,NewBoard):-
    mina(X,Y),
    beforeMina(Before),
    (
        (X < 0,
        Y < 0,
        getPeca(Line,Col,Board,After),
        setPeca(Line,Col,m,Board,NewBoard));

        (OldX is X + 1,
        OldY is Y + 1,
        setPeca(OldX,OldY,Before,Board,Next),
        getPeca(Line,Col,Board,After),
        setPeca(Line,Col,m,Next,NewBoard))
    ),
    retract(mina(X,Y)),
    retract(beforeMina(Before)),
    NewX is Line - 1,
    NewY is Col - 1,
    assert(mina(NewX,NewY)),
    assert(beforeMina(After)),
    value(NewBoard,Player,Value).

%Simulates a move and returns it's Value
simulateValue(Board,Player,Move,Value,NewBoard):-
    [Line,Col] = Move,
    players(P1,P2),
    (
        (Player=p1,
        Name = P1);
    
        (Player=p2,
        Name = P2)
    ),
    L is Line + 1,
    C is Col + 1,
    (
        (Name = y,
        simulateMoveYuki(Player,L,C,Board,Value,NewBoard));

        (Name = m,
        simulateMoveMina(Player,L,C,Board,Value,NewBoard))
    ).

%When Level > 1, it is called to get opponent best move
%and then called again to get best move after opponent move
bestNext(Board,Level,Player,Value,NextBoard):-
    valid_moves(Board,Player,Moves),
    random_shuffle(Moves,[],RandomMoves),
    best(Board,Level,Player,RandomMoves,_,-1000,_,Value,_,NextBoard).


best(Board,Level,Player,[],Move,MaxValue,Move,MaxValue,FinalBoard,FinalBoard):-
    (
        (Level =:= 1,
        simulateValue(Board,Player,Move,_,_));

        (true)
    ).

%Gets the best move for Player
%If Level =:= 1, just checks all valid moves and returns the best
%Else for every move also simulates oponent best next move and the Players best following move
best(Board,Level,Player,[Head|Tail],Move,Max,MaxMove,MaxValue,MaxBoard,FinalBoard):-
    (
        (Level =:= 1,
        !,
        yuki(YX,YY),
        mina(MX,MY),
        beforeMina(Before),
        simulateValue(Board,Player,Head,Value,NewBoard),
        retract(yuki(_,_)),
        retract(mina(_,_)),
        retract(beforeMina(_)),
        assert(yuki(YX,YY)),
        assert(mina(MX,MY)),
        assert(beforeMina(Before)));

        (yuki(YX,YY),
        mina(MX,MY),
        beforeMina(Before),
        simulateValue(Board,Player,Head,NextValue,NextBoard),
        (
            (NextValue =:= 0,
            Value is 0);

            ((
                (Player = p1,
                NextPlayer = p2);

                (Player = p2,
                NextPlayer = p1)
            ),
            NewLevel is Level - 2,
            bestNext(NextBoard,NewLevel,NextPlayer,NextNextValue,NextNextBoard),
            (
                (NextNextValue =:= 0,
                Value is -1000);

                (bestNext(NextNextBoard,NewLevel,Player,Value,NewBoard))
            ))
        ),
        retract(yuki(_,_)),
        retract(mina(_,_)),
        retract(beforeMina(_)),
        assert(yuki(YX,YY)),
        assert(mina(MX,MY)),
        assert(beforeMina(Before)))
    ),
    (
        (Value >= Max,
        !,
        best(Board,Level,Player,Tail,Move,Value,Head,MaxValue,NewBoard,FinalBoard));

        (best(Board,Level,Player,Tail,Move,Max,MaxMove,MaxValue,MaxBoard,FinalBoard))    
    ).

random_shuffle([],Random,Random).

%Takes a list and puts it in a random order
random_shuffle(Moves,ShuffledMoves,Random):-
    length(Moves,Length),
    random(0,Length,Rand),
    nth0(Rand,Moves,Move),
    delete(Moves,Move,NewMoves),
    append(ShuffledMoves,[Move],RandomMoves),
    random_shuffle(NewMoves,RandomMoves,Random).

%Choses the best move for Player
choose_move(Board,Level,Move):-
    nextPlayer(Player),
    valid_moves(Board,Player,Moves),
    random_shuffle(Moves,[],Random),
    yuki(YX,YY),
    mina(MX,MY),
    beforeMina(Before),
    best(Board,Level,Player,Random,Move,-1000,_,_,_,_),
    retract(yuki(_,_)),
    retract(mina(_,_)),
    retract(beforeMina(_)),
    assert(yuki(YX,YY)),
    assert(mina(MX,MY)),
    assert(beforeMina(Before)).