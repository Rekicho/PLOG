:- use_module(library(lists)).

getPeca(Nlinha,Ncoluna,Tab,Peca):-
    nth1(Nlinha,Tab,Linha),
    nth1(Ncoluna,Linha,Peca).

setPeca(Nlinha,Ncoluna,Peca,TabIn,TabOut):-
    setPecaLinha(Nlinha,Ncoluna,Peca,TabIn,TabOut).

setPecaLinha(1,Ncoluna,Peca,[Linha|MaisLinhas],[NovaLinha|MaisLinhas]):-
    setPecaColuna(Ncoluna,Peca,Linha,NovaLinha).

setPecaLinha(N,Ncoluna,Peca,[Linha|MaisLinhas],[Linha|NovasLinhas]):-
    N>1,
    Next is N-1,
    setPecaLinha(Next,Ncoluna,Peca,MaisLinhas,NovasLinhas).

setPecaColuna(1,Peca,[_|Resto],[Peca|Resto]).

setPecaColuna(N,Peca,[Peca1|Resto],[Peca1|Mais]):-
    N>1,
    Next is N-1,
    setPecaColuna(Next,Peca,Resto,Mais).

:-dynamic wins/2.
:-dynamic treesEaten/2.
:-dynamic players/2.
:-dynamic tab/1.
:-dynamic yuki/2.
:-dynamic mina/2.
:-dynamic beforeMina/1.
:-dynamic nextPlayer/1.

wins(0,0).
treesEaten(0,0).
players(y,m).
tab([[t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t]]).
yuki(-1,-1).
mina(-1,-1).
%In the start, yuki and mina are not on the board
beforeMina(m). %In the start, there is nothing in the place where mina is
nextPlayer(p1).

allMoves([
[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8],[0,9],
[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[1,9],
[2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[2,8],[2,9],
[3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],[3,8],[3,9],
[4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[4,8],[4,9],
[5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],[5,8],[5,9],
[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],[6,8],[6,9],
[7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],[7,8],[7,9],
[8,0],[8,1],[8,2],[8,3],[8,4],[8,5],[8,6],[8,7],[8,8],[8,9],
[9,0],[9,1],[9,2],[9,3],[9,4],[9,5],[9,6],[9,7],[9,8],[9,9]
]).

display_game(Board,Player):-
    wins(W1,W2),
    format('~nWins: ~d-~d~n',[W1,W2]),
    treesEaten(T1,T2),
    format('Trees eaten: ~d-~d~n~n',[T1,T2]),
    display_board(0,Board),
    format('~n~nPlayer to move: ~p ',Player),
    display_player(Player),
    write('\n').

display_board(Counter,[Head]):-
    format('~d ',Counter),
    display_line(Head),
    write('\n\n   a  b  c  d  e  f  g  h  i  j ').

display_board(Counter,[Head|Tail]):-
    format('~d ',Counter),
    display_line(Head),
    write('\n'),
    Next is Counter+1,
    display_board(Next,Tail).

display_line([Head]):-
    (Head = w,
    write('   '));
    format(' ~p ',Head).

display_line([Head|Tail]):-
    ((Head = w,
    write('   '));
    format(' ~p ',Head)),
    display_line(Tail).

display_player(Player):-
    players(P1,P2),
    ((Player=p1,
    write_name(P1));
    (Player=p2,
    write_name(P2))).

write_name(Name):-
    (Name=y,
    write('playing as Yuki'));
    (Name=m,
    write('playing as Mina')).

coprime(X,Y).%TODO

%CHECK NOT TREE
canSee(X,Y,MX,MY,T).
    DX is abs(MX - X),
    DY is abs(MY - Y),
    coprime(DX,DY).

moveYuki(P,L,C,T,New):-
    yuki(X,Y),
    treesEaten(T1,T2),
    ((X < 0,
    Y < 0,
    setPeca(L,C,y,T,New));
    (OldX is X + 1,
    OldY is Y + 1,
    setPeca(OldX,OldY,w,T,Next),
    setPeca(L,C,y,Next,New))),
    retract(yuki(X,Y)),
    retract(treesEaten(T1,T2)),
    NewX is L - 1,
    NewY is C - 1,
    assert(yuki(NewX,NewY)),
    ((P = p1,
    NewT is T1 + 1,
    assert(treesEaten(NewT,T2)));
    (P = p2,
    NewT is T2 + 1,
    assert(treesEaten(T1,NewT)))).


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

%TODO: Check Line not char, Check Col not number
checkInput(Line,Col):-
    Line >= 0,
    Line =< 9,
    Col >= 0,
    Col =< 9.

%LEGACY
checkYukiMove(L,C,T):-
    yuki(X,Y),
    getPeca(L,C,T,Peca),
    Peca = t,
    mina(MX,MY),
    NewX is L-1,
    NewY is C-1,
    canSee(NewX,NewY,MX,MY,T),
    ((X =:= -1,
    Y =:= -1);
    (LDif is (L - (X + 1)),
    CDif is (C - (Y + 1)),
    ((LDif =:= 0,
    abs(CDif) =:= 1);
    (abs(LDif) =:= 1,
    CDif =:= 0);
    (abs(LDif) =:= abs(CDif),
    abs(LDif) =:= 1)))).

valid_move_yuki(Board, Line, Col, Moves, NewMoves):-
    Line > 0,
    Line < 11,
    Col > 0,
    Col > 11,
    mina(MX,MY),
    ((canSee(Line-1,Col-1,MX,MY,Board),
    append(Moves,[Line-1,Col-1],NewMoves));
    (NewMoves = Moves)).

valid_moves_yuki(Board, ListOfMoves):-
    yuki(X,Y),
    NewX is X + 1,
    NewY is Y + 1,
    ((X =:= -1,
    Y =:= -1,
    allMoves(Moves),
    ListOfMoves = Moves);
    (valid_move_yuki(Board, NewX - 1, NewY - 1, [], Moves1),
    valid_move_yuki(Board, NewX - 1, NewY, Moves1, Moves2),
    valid_move_yuki(Board, NewX - 1, NewY + 1, Moves2, Moves3),
    valid_move_yuki(Board, NewX, NewY - 1, Moves3, Moves4),
    valid_move_yuki(Board, NewX, NewY + 1, Moves4, Moves5),
    valid_move_yuki(Board, NewX + 1, NewY - 1, Moves5, Moves6),
    valid_move_yuki(Board, NewX + 1, NewY, Moves6, Moves7),
    valid_move_yuki(Board, NewX + 1, NewY + 1, Moves7, ListOfMoves))).

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

%TODO
valid_move_mina(Board, Line, Col, Moves, NewMoves, DX, DY):-
    Line > 0,
    Line < 11,
    Col > 0,
    Col > 11,
    yuki(YX,YY),
    ((canSee(YX,YY,Line-1,Col-1,Board,
    MoreMoves = Moves));
    (append(Moves,[Line-1,Col-1],MoreMoves))),
    valid_move_mina(Board, Line + DX, Col + DY, MoreMoves, NewMoves, DX, DY).


valid_moves_mina(Board, ListOfMoves):-
    mina(X,Y),
    NewX is X + 1,
    NewY is Y + 1,
    ((X =:= -1,
    Y =:= -1,
    allMoves(Moves),
    ListOfMoves = Moves);
    (valid_move_mina(Board, NewX - 1, NewY - 1, [], Moves1, -1, -1),
    valid_move_mina(Board, NewX - 1, NewY, Moves1, Moves2, -1, 0),
    valid_move_mina(Board, NewX - 1, NewY+1, Moves2, Moves3, -1, 1),
    valid_move_mina(Board, NewX, NewY - 1, Moves3, Moves4, 0, -1),
    valid_move_mina(Board, NewX, NewY + 1, Moves4, Moves5, 0 , 1),
    valid_move_mina(Board, NewX + 1, NewY - 1, Moves5, Moves6, 1, -1),
    valid_move_mina(Board, NewX + 1, NewY, Moves6, Moves7, 1, 0),
    valid_move_mina(Board, NewX + 1, NewY + 1, Moves7, ListOfMoves, 1, 1))).

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

joga:-
    repeat,
    tab(T),
    nextPlayer(P),
    display_game(T,P),
    valid_moves(T,P,Moves),
    write('\nValid moves: \n\n'),
    write(Moves),
    write('\n\n'),
    write('Line: '),
    read(Line),
    write('Col: '),
    read(Char),
    char_code(Char,Code),
    Col is Code - 97,
    ((checkInput(Line,Col),
    play(Line,Col));
    (write('\nWrong Move!!!\n'))),
    joga.