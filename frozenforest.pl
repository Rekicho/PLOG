:- use_module(library(lists)).
:- use_module(library(random)).

:- reconsult('lists.pl').
:- reconsult('setup.pl').
:- reconsult('display.pl').
:- reconsult('io.pl').
:- reconsult('yuki.pl').
:- reconsult('mina.pl').
:- reconsult('ai.pl').

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
    (
        (Coord = x,
        !,
        append(List,[[Num,0]],NextList));

        (Coord = y,
        !,
        append(List,[[0,Num]],NextList))
    ),

    untilZero(Next,NextList,FullList,Coord).

allpoints(X,Y,_,DX,DY,List,List):-
    (floor(X) >= DX,
    !);
    (floor(Y) >= DY,
    !).

allpoints(X,Y,M,DX,DY,Points,List):-
    (
        (FY is floor(Y),
        CY is ceiling(Y),
        FY =:= CY,
        append(Points,[[X,FY]],MorePoints));

        (MorePoints = Points)
    ),
    NextX is X + 1,
    NextY is Y + M,
    allpoints(NextX,NextY,M,DX,DY,MorePoints,List).

possibleTrees(DX,DY,List):-
    (
        (DX =:= 0,
        !,
        LastY is DY - 1,
        untilZero(LastY,[],List,y));

        (DY =:= 0,
        !,
        LastX is DX - 1,
        untilZero(LastX,[],List,x));

        (M is DY/DX,
        allpoints(1,M,M,DX,DY,[],List))
    ).

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
    (
        (Peca = t);

        (checkTree(X,Y,Board,Tail))
    ).

checkTrees(X,Y,MX,MY,Board,DX,DY):-
    possibleTrees(DX,DY,List),
    (
        (DX = 0,
        !,
        SX is 0,
        SY is floor((MY - Y)/DY));

        (DY = 0,
        !,
        SY is 0,
        SX is floor((MX - X)/DX));

        (SX is floor((MX - X)/DX),
        SY is floor((MY - Y)/DY))
    ),
    changeSign(SX,SY,List,[],NewList),
    checkTree(X,Y,Board,NewList).

canSee(X,Y,MX,MY,Board):-
    DX is abs(MX - X),
    DY is abs(MY - Y),
    (
        (coprime(DX,DY));
    
        (not(checkTrees(X,Y,MX,MY,Board,DX,DY)))
    ).

move(Move,Board,NewBoard):-
    [X,Y] = Move,
    players(P1,P2),
    nextPlayer(Player),
    valid_moves(Board, Player, Moves),
    member(Move,Moves),
    (
        (Player=p1,
        Name = P1);
    
        (Player=p2,
        Name = P2)
    ),
    Line is X + 1,
    Col is Y + 1,
    (
        (Name = y,
        moveYuki(Player,Line,Col,Board,NewBoard));

        (Name = m,
        moveMina(Line,Col,Board,NewBoard))
    ),
    retract(nextPlayer(Player)),
    (
        (Player=p1,
        assert(nextPlayer(p2)));

        (Player=p2,
        assert(nextPlayer(p1)))
    ).

valid_moves(Board, Player, ListOfMoves):-
    players(P1,P2),
    (
        (Player = p1,
        Name = P1);

        (Player = p2,
        Name = P2)
    ),
    (
        (Name=y,
        valid_moves_yuki(Board, ListOfMoves),
        !);

        (Name=m,
        valid_moves_mina(Board, ListOfMoves),
        !)
    ).

player_move(Moves, Board, NewBoard):-
    repeat,
        display_moves(Moves),
        getInput(Line,Col),
        checkInput(Line,Col),
        move([Line,Col], Board, NewBoard),
        !.

game_over(Board,Winner):-
    nextPlayer(Player),
    valid_moves(Board,Player,Moves),
    length(Moves,L),
    L =:= 0,
    retract(wonAs(_)),
    (
        (Player = p1,
        wins(W1,W2),
        NewWin is W2 + 1,
        retract(wins(W1,W2)),
        assert(wins(W1,NewWin)),
        players(_,P2),
        assert(wonAs(P2)),
        Winner = p2);

        (Player = p2,
        wins(W1,W2),
        NewWin is W1 + 1,
        retract(wins(W1,W2)),
        assert(wins(NewWin,W2)),
        players(P1,_),
        assert(wonAs(P1)),
        Winner = p1)
    ).

solve_tie(Winner):-
    treesEaten(T1,T2),
    wonAs(Name),
    (
        (Name = y,
        solve_Yuki_tie(T1,T2,Winner));

        (Name = m,
        solve_Mina_tie(T1,T2,Winner))
    ).

match_over(Winner):-
    wins(W1,W2),
    Wins is W1 + W2,
    Wins =:= 2,
    (
        (
            W1 > W2,
            Winner = p1
        );

        (
            W1 < W2,
            Winner = p2
        );

        (solve_tie(Winner))
    ).

player_or_ai(Player, Difficulty):-
    difficulty(D1,D2),
    (
        (Player = p1,
        !,
        Difficulty is D1);

        (Player = p2,
        !,
        Difficulty is D2)
    ).

ai_move(Moves,Difficulty,Board,NewBoard):-
    display_moves(Moves),
    choose_move(Board, Difficulty, Move),
    display_AI_move(Move),
    move(Move, Board, NewBoard).

game:-
    display_separator,
    board(Board),
    nextPlayer(Player),
    display_game(Board,Player),
    valid_moves(Board,Player,Moves),
    player_or_ai(Player, Difficulty),
    (
        (Difficulty =:= -1,
        !,
        player_move(Moves,Board,NewBoard));

        ai_move(Moves,Difficulty,Board,NewBoard)
    ),
    retract(board(Board)),
    assert(board(NewBoard)),
    (
        (game_over(NewBoard,Winner),
        display_game_winner(Winner),
        (
            (match_over(MatchWinner),
            wins(W1,W2),
            format('~nWins: ~d-~d~n',[W1,W2]),
            treesEaten(T1,T2),
            format('Trees eaten: ~d-~d~n~n',[T1,T2]),
            display_board(0,NewBoard),
            display_match_winner(MatchWinner));

            (change_game,
            game)
        ));

        (game)
    ).

play:-
    prompt(_, ''),
    display_main_menu,
    getOption(Option),
    (
        (Option =:= 0);

        (Option =:= 1,
        new_game_menu,
        play);

        (Option =:= 2,
        (
            (match_over(_),
            write('\n\nSaved game is over\n\n'),
            play);

            (true)
        ),
        game,
        play);

        (play)
    ).

new_game_menu:-
    display_new_game_menu,
    getOption(Option),
    (
        (Option =:= 0);

        (Option =:= 1,
        setup(-1,-1),
        game);

        (Option =:= 2,
        pvAI_menu);

        (Option =:= 3,
        aivAI_menu);

        (new_game_menu)
    ).

pvAI_menu:-
    display_PvAI_menu,
    getOption(Option),
    (
        (Option =:= 0);

        (Option =:= 1,
        setup(-1,1),
        game);

        (Option =:= 2,
        setup(-1,3),
        game);

        (pvAI_menu)
    ).

aivAI_menu:-
    display_AIvAI_menu,
    getOption(Option),
    (
        (Option =:= 0);

        (Option =:= 1,
        setup(1,1),
        game);

        (Option =:= 2,
        setup(1,3),
        game);

        (Option =:= 3,
        setup(3,3),
        game);

        (aivAI_menu)
    ).