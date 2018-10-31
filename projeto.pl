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

display_game(Board,Player):-
    wins(W1,W2),
    format('~nWins: ~d-~d~n',[W1,W2]),
    treesEaten(T1,T2),
    format('Trees eaten: ~d-~d~n~n',[T1,T2]),
    display_board(0,Board),
    format('~n~nPlayer to move: ~p ',Player),
    display_player(Player),
    nl.

display_board(Counter,[Head]):-
    format('~d ',Counter),
    display_line(Head),
    nl,
    nl,
    write('   a  b  c  d  e  f  g  h  i  j ').

display_board(Counter,[Head|Tail]):-
    format('~d ',Counter),
    display_line(Head),
    nl,
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

checkYukiMove(L,C,T).

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
    ((Player = p1,
    NewT is T1 + 1,
    assert(treesEaten(NewT,T2)));
    (Player = p2,
    NewT is T2 + 1,
    assert(treesEaten(T1,NewT)))).

%TODO:CHECK NOT SEEN
checkMinaMove(L,C,T):-
    mina(X,Y),
    ((X = -1,
    Y = -1);
    (LDif is (L - (X + 1)),
    CDif is (C - (Y + 1)),
    ((LDif = 0,
    CDif \= 0);
    (LDif \= 0,
    CDif = 0);
    (LDif = CDif);
    (NewDif is Y + 1 - C,
    LDif = NewDif)))).


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

checkInput(Line,Col):-
    Line >= 0,
    Line =< 9,
    Col >= 0,
    Col =< 9.

%TODO: ADD REPEAT
joga:-
    tab(T),
    nextPlayer(P),
    display_game(T,P),
    write('Line: '),
    read(Line),
    write('Col: '),
    read(Char),
    char_code(Char,Code),
    Col is Code - 97,
    ((checkInput(Line,Col),
    play(Line,Col),
    joga);
    (nl,
    write('Wrong Move!!!'),
    nl,
    joga)).