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

move(Move,Board,NewBoard):-
    [Line,Col] = Move,
    players(P1,P2),
    nextPlayer(Player),
    valid_moves(Board, Player, Moves),
    find(Move,Moves),
    ((Player=p1,
    Name = P1);
    (Player=p2,
    Name = P2)),
    L is Line + 1,
    C is Col + 1,
    ((Name = y,
    moveYuki(Player,L,C,Board,NewBoard));
    (Name = m,
    moveMina(L,C,Board,NewBoard))),
    retract(nextPlayer(Player)),
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
    valid_moves_yuki(Board, ListOfMoves),
    !);
    (Name=m,
    valid_moves_mina(Board, ListOfMoves),
    !)).

until_valid_move(Moves, Board, NewBoard):-
    repeat,
    display_moves(Moves),
    getInput(Line,Col),
    checkInput(Line,Col),
    move([Line,Col], Board, NewBoard).

game_over(Board,Winner):-
    nextPlayer(Player),
    valid_moves(Board,Player,Moves),
    length(Moves,L),
    L =:= 0,
    ((Player = p1,
    Winner = p2);
    (Player = p2,
    Winner = p1)).

%USE REPEAT
play:-
    prompt(_, ''),
    repeat,
    tab(Board),
    nextPlayer(Player),
    display_game(Board,Player),
    valid_moves(Board,Player,Moves),
    until_valid_move(Moves,Board,NewBoard),
    retract(tab(Board)),
    assert(tab(NewBoard)),
    ((game_over(NewBoard,Winner),
    display_winner(Winner));
    (play)).
    