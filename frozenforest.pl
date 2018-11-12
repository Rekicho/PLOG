:- use_module(library(lists)).
:- reconsult('lists.pl').
:- reconsult('setup.pl').
:- reconsult('display.pl').
:- reconsult('io.pl').
:- reconsult('yuki.pl').
:- reconsult('mina.pl').

%CHECK NOT TREE
canSee(X,Y,MX,MY,T):-
    DX is abs(MX - X),
    DY is abs(MY - Y),
    coprime(DX,DY).

move(P,L,C,N,T,New):-
    (N = y,
    checkYukiMove(L,C,T),
    moveYuki(P,L,C,T,New));
    (N = m,
    checkMinaMove(L,C,T),
    moveMina(L,C,T,New)).

play(Line,Col):-
    players(P1,P2),
    nextPlayer(Player),
    tab(T),
    ((Player=p1,
    N = P1);
    (Player=p2,
    N = P2)),
    L is Line + 1,
    C is Col + 1,
    move(Player,L,C,N,T,New),
    retract(nextPlayer(Player)),
    retract(tab(T)),
    assert(tab(New)),
    ((Player=p1,
    assert(nextPlayer(p2)));
    (Player=p2,
    assert(nextPlayer(p1)))).

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

%FIX REPEAT
joga:-
    repeat,
    tab(T),
    nextPlayer(P),
    display_game(T,P),
    valid_moves(T,P,Moves),
    display_moves(Moves),
    getInput(Line,Col),
    ((checkInput(Line,Col),
    play(Line,Col));
    (write('\nWrong Move!!!\n'))),
    joga.
    