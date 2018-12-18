buildPossibleUp(0,_,Up,Up):-
	!.

buildPossibleUp(Line,Col,Temp,Up):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextUp),
	Next is Line - 1,
	buildPossibleUp(Next,Col,NextUp,Up).

buildPossibleLeft(0,_,Left,Left):-
	!.

buildPossibleLeft(Col,Line,Temp,Left):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextLeft),
	Next is Col - 1,
	buildPossibleLeft(Next,Line,NextLeft,Left).

buildPossibleRight(Col,Cols,_,Right,Right):-
	Col > Cols,
	!.

buildPossibleRight(Col,Cols,Line,Temp,Right):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextRight),
	Next is Col + 1,
	buildPossibleRight(Next,Cols,Line,NextRight,Right).

buildPossibleDown(Line,Lines,_,Down,Down):-
	Line > Lines,
	!.

buildPossibleDown(Line,Lines,Col,Temp,Down):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextDown),
	Next is Line + 1,
	buildPossibleDown(Next,Lines,Col,NextDown,Down).

attackPositionsRook(Matrix,Line,Col,Cols,Indexes,Positions):-
	length(Matrix,Size),
	Lines is Size div Cols,
	LastLine is Line - 1,
	NextLine is Line + 1,
	LastCol is Col - 1,
	NextCol is Col + 1,
	buildPossibleUp(LastLine,Col,[],Up),
	buildPossibleLeft(LastCol,Line,[],Left),
	buildPossibleRight(NextCol,Cols,Line,[],Right),
	buildPossibleDown(NextLine,Lines,Col,[],Down),
	Possible = [Up,Left,Right,Down],
	buildPositions(Matrix,Cols,Possible,[],Indexes,[],Positions).