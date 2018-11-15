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

simulateMoveYuki(Player,Line,Col,Board,Value):-
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
    value(NewBoard, Player,Value),
    retract(yuki(NewX,NewY)),
    assert(yuki(X,Y)).

simulateMoveMina(Player,Line,Col,Board,Value):-
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
    NewX is Line - 1,
    NewY is Col - 1,
    assert(mina(NewX,NewY)),
    value(NewBoard, Player,Value),
    retract(mina(NewX,NewY)),
    assert(mina(X,Y)).


simulateValue(Board,Player,Move,Value):-
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
        simulateMoveYuki(Player,L,C,Board,Value));

        (Name = m,
        simulateMoveMina(Player,L,C,Board,Value))
    ).

best(_,_,[],Move,_,Move).

best(Board,Player,[Head|Tail],Move,Max,MaxMove):-
    simulateValue(Board,Player,Head,Value),
    (
        (Value > Max,
        !,
        best(Board,Player,Tail,Move,Value,Head));

        (best(Board,Player,Tail,Move,Max,MaxMove))    
    ).
    
%TRANSLATE MOVE
choose_move(Board, _, Move):-
    nextPlayer(Player),
    valid_moves(Board,Player,Moves),
    Minimum is -1000,
    best(Board,Player,Moves,Move,Minimum,_).