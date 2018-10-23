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
:-dynamic nextPlayer/1.

wins(0,0).
treesEaten(1,0).
players(y,m).
tab([[t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,y,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,m,t,t],
    [t,t,t,t,t,t,t,t,t,t]]).
nextPlayer(p1).

display_game(Board,Player):-
    display_board(0,Board),
    format('~n~nPlayer to move: ~p ',Player),
    display_player(Player),
    nl.

display_board(Counter,[Head]):-
    write('  ------------------------------'),
    nl,
    format('~d ',Counter),
    display_line(Head),
    nl,
    write('  ------------------------------'),
    nl,
    write('   0  1  2  3  4  5  6  7  8  9 ').

display_board(Counter,[Head|Tail]):-
    write('  ------------------------------'),
    nl,
    format('~d ',Counter),
    display_line(Head),
    nl,
    Next is Counter+1,
    display_board(Next,Tail).

display_line([Head]):-
    format('|~p|',Head).

display_line([Head|Tail]):-
    format('|~p|',Head),
    display_line(Tail).

display_player(Player):-
    players(P1,P2),
    (Player=p1,
    write_name(P1));
    (Player=p2,
    write_name(P2)).

write_name(Name):-
    (Name=y,
    write('playing as Yuki'));
    (Name=m,
    write('playing as Mina')).

move(Line,Col):-
    nextPlayer(N),
    tab(T),
    retract(nextPlayer(N)),
    retract(tab(T)),
    setPeca(Line,Col,N,T,New),
    assert(tab(New)),
    (N = y,
    assert(nextPlayer(m)));
    (N = m,
    assert(nextPlayer(y))).

joga(_):-
    read(Line),
    read(Col),
    move(Line,Col).