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

:-dynamic tab/1.
:-dynamic nextPlayer/1.
:-dynamic treesEaten/2.
:-dynamic wins/2.
	
tab([[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t],[t,t,t,t,t,t,t,t,t,t]]).
nextPlayer(y).
treesEaten(0,0).
wins(0).

display_game(Board,Player):-
    display_board(Board),
    format('~n~nPlayer to move: ~p~n',Player).

display_board([Head]):-
    write('------------------------------'),
    nl,
    display_line(Head),
    nl,
    write('------------------------------').

display_board([Head|Tail]):-
    write('------------------------------'),
    nl,
    display_line(Head),
    nl,
    display_board(Tail).

display_line([Head]):-
    format('|~p|',Head).

display_line([Head|Tail]):-
    format('|~p|',Head),
    display_line(Tail).

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