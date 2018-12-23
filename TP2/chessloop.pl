:- use_module(library(clpfd)).
:- use_module(library(random)).

:- reconsult('puzzles.pl').
:- reconsult('display.pl').
:- reconsult('pieces.pl').
:- reconsult('king.pl').
:- reconsult('knight.pl').
:- reconsult('rook.pl').
:- reconsult('bishop.pl').
:- reconsult('queen.pl').

buildPositionsChildren(_,_,[],Indexes,Indexes,Positions,Positions):-
	!.

%Gets valid positions value in a direction
buildPositionsChildren(Matrix,Cols,[Head|Tail],TempInd,Indexes,Temp,Positions):-
	[Line,Col] = Head,
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
	buildPositionsChildren(Matrix,Cols,Tail,NextInd,Indexes,Next,Positions).

buildPositionsChildren(Matrix,Cols,[_|Tail],TempInd,Indexes,Temp,Positions):-
	buildPositionsChildren(Matrix,Cols,Tail,TempInd,Indexes,Temp,Positions).

buildPositions(_,_,[],Indexes,Indexes,Positions,Positions):-
	!.

%Gets valid positions value in all directions
buildPositions(Matrix,Cols,[Head|Tail],TempInd,Indexes,Temp,Positions):-
	Head \= [[]],
	buildPositionsChildren(Matrix,Cols,Head,[],ChildIndexes,[],ChildPositions),
	ChildIndexes \= [],
	!,
	append(TempInd,ChildIndexes,NextInd),
	append(Temp,[ChildPositions],Next),
	buildPositions(Matrix,Cols,Tail,NextInd,Indexes,Next,Positions).

buildPositions(Matrix,Cols,[_|Tail],TempInd,Indexes,Temp,Positions):-
	buildPositions(Matrix,Cols,Tail,TempInd,Indexes,Temp,Positions).

subCountCode(_,_,[],CodeCount):-
	!,
	CodeCount #= 0.

%Counts if code apears (1) or not (0) in a list
subCountCode(CountCode,OtherCode,[Head|Tail],CodeCount):-
	domain([CodeCount],0,1),
	subCountCode(CountCode,OtherCode,Tail,Temp),
	(Head #= CountCode #/\ CodeCount #= 1)
	#\/
	(Head #= 0 #/\ CodeCount #= Temp)
	#\/
	(Head #= OtherCode #/\ CodeCount #= 0).

countCode(_,_,[],_,CodeCount):-
	!,
	CodeCount #= 0.

%Counts in how many directions CountCode appears
countCode(CountCode,OtherCode,List,PositionCode,CodeCount):-
	[Head|Tail] = List,
	length(List,Max),
	domain([CodeCount],0,Max),
	subCountCode(CountCode,OtherCode,Head,Temp),
	countCode(CountCode,OtherCode,Tail,PositionCode,Rest),
	CodeCount #= Temp + Rest.

matrixtoList([],List,List):-
	!.

%Builds a list from a matrix
matrixtoList([Head|Tail],Temp,List):-
	append(Temp,Head,Next),
	matrixtoList(Tail,Next,List).

restrict(_,_,_,Line,Lines,_,_,_,_,_):-
	Line > Lines,
	!.

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Col > Cols,
	!,
	NextLine is Line + 1,
	restrict(Matrix,Code1,Code2,NextLine,Lines,1,Cols,LoopMatrix,Loop,LoopIndex).

%Applies problem restrictions to all board positions.
restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	attackPositions(Matrix,Code1,Line,Col,Cols,Indexes1,AttackPositions1),
	attackPositions(Matrix,Code2,Line,Col,Cols,Indexes2,AttackPositions2),
	countCode(Code2,Code1,AttackPositions1,Code1,Attack1),
	matrixtoList(AttackPositions1,[],ListAttackPositions1),
	element(LoopIndex1,ListAttackPositions1,LoopCode2),
	element(LoopIndex1,Indexes1,Index1),
	countCode(Code1,Code2,AttackPositions2,Code2,Attack2),
	matrixtoList(AttackPositions2,[],ListAttackPositions2),
	element(LoopIndex2,ListAttackPositions2,LoopCode1),
	element(LoopIndex2,Indexes2,Index2),
	countCode(Code1,Code2,AttackPositions1,Code1,Defend1),
	countCode(Code2,Code1,AttackPositions2,Code2,Defend2),
	!,
	element(Index,LoopMatrix,LoopMatrixElement),
	element(LoopIndex,Loop,LoopElement),
		(Element #= 0 #/\ NewLoopIndex #= LoopIndex)
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
	countCode(Code1,Code2,AttackPositions2,Code2,Attack2),
	matrixtoList(AttackPositions2,[],ListAttackPositions2),
	element(LoopIndex2,ListAttackPositions2,LoopCode1),
	element(LoopIndex2,Indexes2,Index2),
	countCode(Code1,Code2,AttackPositions1,Code1,Defend1),
	countCode(Code2,Code1,AttackPositions2,Code2,Defend2),
	!,
	element(Index,LoopMatrix,LoopMatrixElement),
	element(LoopIndex,Loop,LoopElement),
		(Element #= 0 #/\ NewLoopIndex #= LoopIndex)
		#\/ 
		(Element #= Code2 #/\ LoopCode1 #= Code1 #/\ LoopMatrixElement #= LoopIndex #/\ LoopElement #= Index2 #/\ NewLoopIndex #= LoopIndex + 1 #/\ Attack2 #= 1 #/\ Defend2 #= 0 #/\ Defend1 #= 1),
	NextCol is Col + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	attackPositions(Matrix,Code1,Line,Col,Cols,Indexes1,AttackPositions1),
	attackPositions(Matrix,Code2,Line,Col,Cols,_,AttackPositions2),
	countCode(Code2,Code1,AttackPositions1,Code1,Attack1),
	matrixtoList(AttackPositions1,[],ListAttackPositions1),
	element(LoopIndex1,ListAttackPositions1,LoopCode2),
	element(LoopIndex1,Indexes1,Index1),
	countCode(Code1,Code2,AttackPositions1,Code1,Defend1),
	countCode(Code2,Code1,AttackPositions2,Code2,Defend2),
	!,
	element(Index,LoopMatrix,LoopMatrixElement),
	element(LoopIndex,Loop,LoopElement),
		(Element #= 0 #/\ NewLoopIndex #= LoopIndex)
		#\/ 
		(Element #= Code1 #/\ LoopCode2 #= Code2 #/\ LoopMatrixElement #= LoopIndex #/\ LoopElement #= Index1 #/\ NewLoopIndex #= LoopIndex + 1 #/\ Attack1 #= 1 #/\ Defend1 #= 0 #/\ Defend2 #= 1),
	NextCol is Col + 1,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

restrict(Matrix,Code1,Code2,Line,Lines,Col,Cols,LoopMatrix,Loop,LoopIndex):-
	Index is ((Line - 1) * Cols) + Col,
	element(Index,Matrix,Element),
	Element #= 0,
	NextCol is Col + 1,
	NewLoopIndex #= LoopIndex,
	restrict(Matrix,Code1,Code2,Line,Lines,NextCol,Cols,LoopMatrix,Loop,NewLoopIndex).

buildCircuit(_,_,_,Index,Size):-
	Index > Size,
	!.

%Buils the circuit needed to ensure "loop" 
buildCircuit(Circuit,LoopMatrix,Loop,Index,LoopSize):-
	element(Index,Circuit,Element),
	element(Index,Loop,LoopElement),
	element(LoopElement,LoopMatrix,CircuitElement),
	Element #= CircuitElement,
	NextIndex is Index + 1,
	buildCircuit(Circuit,LoopMatrix,Loop,NextIndex,LoopSize).

%Solve a chessloop puzzle with a given ID
%If the id is negative, generates a random puzzle
chessloop(ID):-
	puzzle(ID,Num,Piece1,Piece2,Lines,Cols),
	!,
	display_puzzle(Num,Piece1,Piece2,Lines,Cols),
	pieceCode(Piece1,Code1),
	pieceCode(Piece2,Code2),
	Size is Lines * Cols,
	length(Matrix,Size),
	Max is max(Code1, Code2),
	domain(Matrix,0,Max),
	count(Code1,Matrix,#=,Num),
	count(Code2,Matrix,#=,Num),
	length(LoopMatrix,Size),
	length(Loop,Size),
	restrict(Matrix,Code1,Code2,1,Lines,1,Cols,LoopMatrix,Loop,1),
	CircuitSize is Num * 2,
	length(Circuit,CircuitSize),
	buildCircuit(Circuit,LoopMatrix,Loop,1,CircuitSize),
	circuit(Circuit),
	labeling([ff,down,step],Matrix),
	!,
	display_board(Matrix,0,Cols).