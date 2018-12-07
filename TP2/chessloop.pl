:- use_module(library(clpfd)).

%puzzle(2,n,k,2,3).
%puzzle(3,n,k,4,5).

restrict([],_,_).

restrict([Head|Tail],Code1,Code2):-
	Head #= 32 #\/ Head #= Code1 #\/ Head #= Code2,
	restrict(Tail,Code1,Code2).

display_nl(Cols,Cols):-
	!.

display_nl(Col,Cols):-
	!,
	write('--'),
	Next is Col + 1,
	display_nl(Next,Cols).

display_board([],_,_):-
	!.

display_board(Matrix,Cols,Cols):-
	!,
	nl,
	display_nl(0,Cols),
	nl,
	display_board(Matrix,0,Cols).

display_board([Head|Tail],Col,Cols):-
	char_code(Piece,Head),
	write(Piece),
	write('|'),
	Next is Col + 1,
	display_board(Tail,Next,Cols).


chessloop(Matrix):-
	puzzle(Num,Piece1,Piece2,Lines,Cols),
	char_code(Piece1,Code1),
	char_code(Piece2,Code2),
	Size is Lines * Cols,
	length(Matrix,Size),
	Max is max(Code1, Code2),
	domain(Matrix,32,Max),
	restrict(Matrix,Code1,Code2),
	count(Code1,Matrix,#=,Num),
	count(Code2,Matrix,#=,Num),
	%restrictAttack(Matrix,0,0,Cols),
	labeling([],Matrix),
	display_board(Matrix,0,Cols).	