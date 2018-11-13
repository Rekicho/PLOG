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

translate_moves([],NewMoves,NewMoves).

translate_moves([Head|Tail],PastMoves,NewMoves):-
    [X|Y] = Head,
    Code is Y + 97,
    char_code(Char,Code),
    append(PastMoves,[[X,Char]],MoreMoves),
    translate_moves(Tail,MoreMoves,NewMoves).

display_moves(Moves):-
    write('\nValid moves: \n\n'),
    translate_moves(Moves,[],NewMoves),
    write(NewMoves),
    write('\n\n').

display_winner(Winner):-
    write('\n'),
    write(Winner),
    write(' won '),
    display_player(Winner),
    write('!!!\n').
