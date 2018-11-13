:- use_module(library(lists)).

:- reconsult('lists.pl').
:- reconsult('setup.pl').
:- reconsult('display.pl').
:- reconsult('io.pl').
:- reconsult('yuki.pl').
:- reconsult('mina.pl').

not( X ) :- X, !, fail.
not( _ ).

gcd(X,Y,G):-
    X = Y,
    !,
    G = X.

gcd(X,Y,G):-
    X < Y,
    !,
    NextY is Y - X,
    gcd(X,NextY,G).

gcd(X,Y,G):-
    X > Y,
    !,
    gcd(Y, X, G).

coprime(X,Y):-
    X > 0,
    Y > 0,
    !,
    gcd(X,Y,G),
    G = 1.

untilZero(0,List,List,_).

untilZero(Num,List,FullList,Coord):-
    Next is Num - 1,
    ((Coord = x,
    !,
    append(List,[[Num,0]],NextList));
    (Coord = y,
    !,
    append(List,[[0,Num]],NextList))),
    untilZero(Next,NextList,FullList,Coord).

allpoints(X,Y,_,DX,DY,List,List):-
    (floor(X) >= DX,
    !);
    (floor(Y) >= DY,
    !).

allpoints(X,Y,M,DX,DY,Points,List):-
    ((FY is floor(Y),
    CY is ceiling(Y),
    FY =:= CY,
    !,
    append(Points,[[X,FY]],MorePoints));
    (MorePoints = Points)),
    NextX is X + 1,
    NextY is Y + M,
    allpoints(NextX,NextY,M,DX,DY,MorePoints,List).

possibleTrees(DX,DY,List):-
    ((DX =:= 0,
    !,
    LastY is DY - 1,
    untilZero(LastY,[],List,y));
    (DY =:= 0,
    !,
    LastX is DX - 1,
    untilZero(LastX,[],List,x));
    (M is DY/DX,
    allpoints(1,M,M,DX,DY,[],List))).

changeSign(_,_,[],NewList,NewList).

changeSign(SX,SY,[Head|Tail],LastList,NewList):-
    [X|Y] = Head,
    NewX is X * SX,
    NewY is Y * SY,
    append(LastList,[[NewX,NewY]],List),
    changeSign(SX,SY,Tail,List,NewList).

checkTree(_,_,_,[]):-
    fail.

checkTree(X,Y,Board,[Head|Tail]):-
    [DX|DY] = Head,
    Line is X + DX + 1,
    Col is Y + DY + 1,
    getPeca(Line,Col,Board,Peca),
    ((Peca = t);
    (checkTree(X,Y,Board,Tail))).

checkTrees(X,Y,MX,MY,Board,DX,DY):-
    possibleTrees(DX,DY,List),
    ((DX = 0,
    !,
    SX is 0,
    SY is floor((MY - Y)/DY));
    (DY = 0,
    !,
    SY is 0,
    SX is floor((MX - X)/DX));
    (SX is floor((MX - X)/DX),
    SY is floor((MY - Y)/DY))),
    changeSign(SX,SY,List,[],NewList),
    checkTree(X,Y,Board,NewList).

canSee(X,Y,MX,MY,Board):-
    DX is abs(MX - X),
    DY is abs(MY - Y),
    ((coprime(DX,DY));
    (not(checkTrees(X,Y,MX,MY,Board,DX,DY)))).

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
    