%LEGACY
checkMinaMove(L,C,T):-
    mina(X,Y),
    yuki(YX,YY),
    NewX is L-1,
    NewY is C-1,
    %not(canSee(YX,YY,NewX,NewY,T)), %CHECK NOT
    ((X = -1,
    Y = -1);
    (LDif is (L - (X + 1)),
    CDif is (C - (Y + 1)),
    ((LDif = 0,
    CDif \= 0);
    (LDif \= 0,
    CDif = 0);
    (abs(LDif) =:= abs(CDif))))).


moveMina(L,C,T,New):-
    mina(X,Y),
    beforeMina(Before),
    ((X < 0,
    Y < 0,
    getPeca(L,C,T,After),
    setPeca(L,C,m,T,New));
    (OldX is X + 1,
    OldY is Y + 1,
    setPeca(OldX,OldY,Before,T,Next),
    getPeca(L,C,T,After),
    setPeca(L,C,m,Next,New))),
    retract(mina(X,Y)),
    retract(beforeMina(Before)),
    NewX is L - 1,
    NewY is C - 1,
    assert(mina(NewX,NewY)),
    assert(beforeMina(After)).

valid_move_mina(Board, X, Y, Moves, NewMoves, DX, DY):-
    ((X > -1,
    X < 10,
    Y > -1,
    Y < 10,
    ((yuki(YX,YY),
    canSee(YX,YY,X,Y,Board),
    MoreMoves = Moves);
    (append(Moves,[X,Y],MoreMoves))),
    NextX is X + DX,
    NextY is Y + DY, 
    valid_move_mina(Board, NextX, NextY, MoreMoves, NewMoves, DX, DY));
    (NewMoves = Moves)).

%TODO
checkSeen(Moves,ListOfMoves):-
    ListOfMoves = Moves.

valid_moves_mina(Board, ListOfMoves):-
    mina(X,Y),
    ((X =:= -1,
    Y =:= -1,
    allMoves(Moves),
    checkSeen(Moves,ListOfMoves));
    (LastX is X - 1,
    LastY is Y - 1,
    NextX is X + 1,
    NextY is Y + 1,
    valid_move_mina(Board, LastX, LastY, [], Moves1, -1, -1),
    valid_move_mina(Board, LastX, Y, Moves1, Moves2, -1, 0),
    valid_move_mina(Board, LastX, NextY, Moves2, Moves3, -1, 1),
    valid_move_mina(Board, X, LastY, Moves3, Moves4, 0, -1),
    valid_move_mina(Board, X, NextY, Moves4, Moves5, 0 , 1),
    valid_move_mina(Board, NextX, LastY, Moves5, Moves6, 1, -1),
    valid_move_mina(Board, NextX, Y, Moves6, Moves7, 1, 0),
    valid_move_mina(Board, NextX, NextY, Moves7, ListOfMoves, 1, 1))).