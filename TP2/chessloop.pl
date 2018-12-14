:- use_module(library(clpfd)).

:- reconsult('puzzles.pl').
:- reconsult('pieces.pl').
:- reconsult('king.pl').
:- reconsult('knight.pl').
:- reconsult('rook.pl').
:- reconsult('bishop.pl').
:- reconsult('queen.pl').

buildPositions(_,_,[],Indexes,Indexes,Positions,Positions):-
	!.

buildPositions(Matrix,Cols,[Head|Tail],TempInd,Indexes,Temp,Positions):-
	[Line|Col] = Head,
	Line > 0,
	length(Matrix,Size),
	Line =< Size div Cols, 
	Col > 0,
	Col =< Cols,
	!,
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	append(TempInd,[Index],NextInd),
	append(Temp,[Element],Next),
	buildPositions(Matrix,Cols,Tail,NextInd,Indexes,Next,Positions).

buildPositions(Matrix,Cols,[_|Tail],TempInd,Indexes,Temp,Positions):-
	buildPositions(Matrix,Cols,Tail,TempInd,Indexes,Temp,Positions).

buildAllPositions(_,AllPositions,[],[],AllPositions):-
	!.

buildAllPositions(Indexes,Positions,[HeadIndex|TailIndex],[HeadPosition|TailPosition],AllPositions):-
	member(HeadIndex,Indexes),
	!,
	append(Indexes,[HeadIndex],NewIndexes),
	append(Positions,[HeadPosition],NewPositions),
	buildAllPositions(NewIndexes,NewPositions,TailIndex,TailPosition,AllPositions).

buildAllPositions(Indexes,Positions,[_|TailIndex],[_|TailPosition],AllPositions):-
	buildAllPositions(Indexes,Positions,TailIndex,TailPosition,AllPositions).

restrict(_,_,_,Line,Lines,_,_):-
	Line > Lines,
	!.

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols):-
	Col > Cols,
	!,
	NextLine is Line + 1,
	restrict(Matrix,Code1,Code2,NextLine,Lines,1,Cols).

%Checking the one atacked is not the one attacking
restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	attackPositions(Matrix,Code1,Line,Col,Cols,Indexes1,AttackPositions1),
	attackPositions(Matrix,Code2,Line,Col,Cols,Indexes2,AttackPositions2),
	buildAllPositions(Indexes1,AttackPositions1,Indexes2,AttackPositions2,AllPositions),
	count(Code2,AttackPositions1,#=,Attack1),
	count(Code1,AttackPositions2,#=,Attack2),
	count(Code1,AttackPositions1,#=,Defend1),
	count(Code2,AttackPositions2,#=,Defend2),
	count(Code1,AllPositions,#=,All1),
	count(Code2,AllPositions,#=,All2),
		Element #= 32 
		#\/ 
		(Element #= Code1 #/\ Attack1 #= 1 #/\ Defend1 #= 0 #/\ Defend2 #= 1 #/\ All2 #\= 2)
		#\/ 
		(Element #= Code2 #/\ Attack2 #= 1 #/\ Defend2 #= 0 #/\ Defend1 #= 1 #/\ All1 #\= 2),
	NextCol is Col + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols).

display_nl(Cols,Cols):-
	!.

display_nl(Col,Cols):-
	!,
	write('--'),
	Next is Col + 1,
	display_nl(Next,Cols).

display_board([],_,_):-
	nl,
	nl,
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
	!,
	char_code(Piece1,Code1),
	char_code(Piece2,Code2),
	Size is Lines * Cols,
	length(Matrix,Size),
	Max is max(Code1, Code2),
	domain(Matrix,32,Max),
	restrict(Matrix,Code1,Code2,1,Lines,1,Cols),
	count(Code1,Matrix,#=,Num),
	count(Code2,Matrix,#=,Num),
	labeling([],Matrix),
	display_board(Matrix,0,Cols).	