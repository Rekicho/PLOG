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

restrict(_,_,_,Line,Lines,_,_,_,_,_):-
	Line > Lines,
	!.

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Col > Cols,
	!,
	NextLine is Line + 1,
	restrict(Matrix,Code1,Code2,NextLine,Lines,1,Cols,LoopMatrix,Loop,LoopIndex).

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	attackPositions(Matrix,Code1,Line,Col,Cols,Indexes1,AttackPositions1),
	attackPositions(Matrix,Code2,Line,Col,Cols,Indexes2,AttackPositions2),
	count(Code2,AttackPositions1,#=,Attack1),
	element(LoopIndex1,AttackPositions1,LoopCode2),
	element(LoopIndex1,Indexes1,Index1),
	count(Code1,AttackPositions2,#=,Attack2),
	element(LoopIndex2,AttackPositions2,LoopCode1),
	element(LoopIndex2,Indexes2,Index2),
	!,
	count(Code1,AttackPositions1,#=,Defend1),
	count(Code2,AttackPositions2,#=,Defend2),
	element(Index,LoopMatrix,LoopMatrixElement),
	element(LoopIndex,Loop,LoopElement),
		(Element #= 32 #/\ NewLoopIndex #= LoopIndex)
		#\/ 
		(Element #= Code1 #/\ LoopCode2 #= Code2 #/\ LoopMatrixElement #= LoopIndex #/\ LoopElement #= Index1 #/\ NewLoopIndex #= LoopIndex + 1 #/\ Attack1 #= 1 #/\ Defend1 #= 0 #/\ Defend2 #= 1)
		#\/ 
		(Element #= Code2 #/\ LoopCode1 #= Code1 #/\ LoopMatrixElement #= LoopIndex #/\ LoopElement #= Index2 #/\ NewLoopIndex #= LoopIndex + 1 #/\ Attack2 #= 1 #/\ Defend2 #= 0 #/\ Defend1 #= 1),
	NextCol is Col + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	attackPositions(Matrix,Code1,Line,Col,Cols,_,AttackPositions1),
	attackPositions(Matrix,Code2,Line,Col,Cols,Indexes2,AttackPositions2),
	count(Code1,AttackPositions2,#=,Attack2),
	element(LoopIndex2,AttackPositions2,LoopCode1),
	element(LoopIndex2,Indexes2,Index2),
	!,
	count(Code1,AttackPositions1,#=,Defend1),
	count(Code2,AttackPositions2,#=,Defend2),
	element(Index,LoopMatrix,LoopMatrixElement),
	element(LoopIndex,Loop,LoopElement),
		(Element #= 32 #/\ NewLoopIndex #= LoopIndex)
		#\/ 
		(Element #= Code2 #/\ LoopCode1 #= Code1 #/\ LoopMatrixElement #= LoopIndex #/\ LoopElement #= Index2 #/\ NewLoopIndex #= LoopIndex + 1 #/\ Attack2 #= 1 #/\ Defend2 #= 0 #/\ Defend1 #= 1),
	NextCol is Col + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	attackPositions(Matrix,Code1,Line,Col,Cols,Indexes1,AttackPositions1),
	attackPositions(Matrix,Code2,Line,Col,Cols,_,AttackPositions2),
	count(Code2,AttackPositions1,#=,Attack1),
	element(LoopIndex1,AttackPositions1,LoopCode2),
	element(LoopIndex1,Indexes1,Index1),
	!,
	count(Code1,AttackPositions1,#=,Defend1),
	count(Code2,AttackPositions2,#=,Defend2),
	element(Index,LoopMatrix,LoopMatrixElement),
	element(LoopIndex,Loop,LoopElement),
		(Element #= 32 #/\ NewLoopIndex #= LoopIndex)
		#\/ 
		(Element #= Code1 #/\ LoopCode2 #= Code2 #/\ LoopMatrixElement #= LoopIndex #/\ LoopElement #= Index1 #/\ NewLoopIndex #= LoopIndex + 1 #/\ Attack1 #= 1 #/\ Defend1 #= 0 #/\ Defend2 #= 1),
	NextCol is Col + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	Element #= 32,
	NextCol is Col + 1,
	NewLoopIndex #= LoopIndex + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

buildCircuit(_,_,_,Index,Size):-
	Index > Size,
	!.

buildCircuit(Circuit,LoopMatrix,Loop,Index,LoopSize):-
	element(Index,Circuit,Element),
	element(Index,Loop,LoopElement),
	element(LoopElement,LoopMatrix,CircuitElement),
	Element #= CircuitElement,
	NextIndex is Index + 1,
	buildCircuit(Circuit,LoopMatrix,Loop,NextIndex,LoopSize).

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

chessloop(ID,Matrix):-
	puzzle(ID,Num,Piece1,Piece2,Lines,Cols),
	!,
	char_code(Piece1,Code1),
	char_code(Piece2,Code2),
	Size is Lines * Cols,
	length(Matrix,Size),
	Max is max(Code1, Code2),
	domain(Matrix,32,Max),
	count(Code1,Matrix,#=,Num),
	count(Code2,Matrix,#=,Num),
	length(LoopMatrix,Size),
	length(Loop,Size),
	restrict(Matrix,Code1,Code2,1,Lines,1,Cols,LoopMatrix,Loop,1),
	CircuitSize is Num * 2,
	length(Circuit,CircuitSize),
	buildCircuit(Circuit,LoopMatrix,Loop,1,CircuitSize),
	circuit(Circuit),
	labeling([],Matrix),
	display_board(Matrix,0,Cols).	