:- use_module(library(lists)).
:- reconsult('lists.pl').
:- reconsult('setup.pl').
:- reconsult('display.pl').
:- reconsult('io.pl').
:- reconsult('yuki.pl').
:- reconsult('mina.pl').

%TODO:
checkTrees(X,Y,MX,MY,T).

canSee(X,Y,MX,MY,T):-
    DX is abs(MX - X),
    DY is abs(MY - Y),
    ((coprime(DX,DY));
    (checkTrees(X,Y,MX,MY,T),
    fail)).

%CHECK VALID MOVES INSTEAD OF CHECK_YUKI_MOVE AND CHECK_MINA_MOVE
move(Move,Board,NewBoard):-
    [Line,Col] = Move,
    players(P1,P2),
    nextPlayer(Player),
    ((Player=p1,
    N = P1);
    (Player=p2,
    N = P2)),
    L is Line + 1,
    C is Col + 1,
    ((N = y,
    checkYukiMove(L,C,T),
    moveYuki(Player,L,C,Board,NewBoard));
    (N = m,
    checkMinaMove(L,C,T),
    moveMina(L,C,Board,NewBoard))),
    retract(nextPlayer(Player)),
    ((Player=p1,
    assert(nextPlayer(p2)));
    (Player=p2,
    assert(nextPlayer(p1)))).

%CHECK MINA YUKI NOT SAME POSITION
valid_moves(Board, Player, ListOfMoves):-
    players(P1,P2),
    ((Player = p1,
    Name = P1);
    (Player = p2,
    Name = P2)),
    ((Name=y,
    valid_moves_yuki(Board, ListOfMoves));
    (Name=m,
    valid_moves_mina(Board, ListOfMoves))).

%USE REPEAT
joga:-
    tab(T),
    nextPlayer(P),
    display_game(T,P),
    valid_moves(T,P,Moves),
    display_moves(Moves),
    getInput(Line,Col),
    ((checkInput(Line,Col),
    move([Line,Col], T, NewT),
    retract(tab(T)),
    assert(tab(NewT)));
    (write('\nWrong Move!!!\n'))),
    joga.
    