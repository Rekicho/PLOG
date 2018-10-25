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
:-dynamic before_mina/1.
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
before_mina(m). %In the start, there is nothing in the place where mina is
nextPlayer(p1).

display_game(Board,Player):-
    nl,
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

moveYuki(L,C,T,New):-
    %yuki(X,Y),
    setPeca(L,C,y,T,New).

moveMina(L,C,T,New):-
    %mina(X,Y),
    setPeca(L,C,m,T,New).

move(L,C,N,T,New):-
    (N = y,
    moveYuki(L,C,T,New));
    (N = m,
    moveMina(L,C,T,New)).

play(Line,Col):-
    players(P1,P2),
    nextPlayer(Player),
    tab(T),
    retract(nextPlayer(Player)),
    retract(tab(T)),
    ((Player=p1,
    N = P1);
    (Player=p2,
    N = P2)),
    L is Line + 1,
    C is Col + 1,
    move(L,C,N,T,New),
    assert(tab(New)),
    ((Player=p1,
    assert(nextPlayer(p2)));
    (Player=p2,
    assert(nextPlayer(p1)))).

%USE REPEAT
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
    play(Line,Col),
    joga.