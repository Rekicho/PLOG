buildPossibleUpLeft(0,_,UpLeft,UpLeft):-
	!.

buildPossibleUpLeft(_,0,UpLeft,UpLeft):-
	!.

%Return in UpLeft all possible board positions in upleft diagonal from [Line, Col]
buildPossibleUpLeft(Line,Col,Temp,UpLeft):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextUpLeft),
	NextLine is Line - 1,
	NextCol is Col - 1,
	buildPossibleUpLeft(NextLine,NextCol,NextUpLeft,UpLeft).

buildPossibleUpRight(_,_,0,UpRight,UpRight):-
	!.

buildPossibleUpRight(Col,Cols,_,UpRight,UpRight):-
	Col > Cols,
	!.

%Return in UpRight all possible board positions in upright diagonal from [Line, Col]
buildPossibleUpRight(Col,Cols,Line,Temp,UpRight):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextUpRight),
	NextLine is Line - 1,
	NextCol is Col + 1,
	buildPossibleUpRight(NextCol,Cols,NextLine,NextUpRight,UpRight).

buildPossibleDownLeft(_,_,0,DownLeft,DownLeft):-
	!.

buildPossibleDownLeft(Line,Lines,_,DownLeft,DownLeft):-
	Line > Lines,
	!.

%Return in DownLeft all possible board positions in downleft diagonal from [Line, Col]
buildPossibleDownLeft(Line,Lines,Col,Temp,DownLeft):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextDownLeft),
	NextLine is Line + 1,
	NextCol is Col - 1,
	buildPossibleDownLeft(NextLine,Lines,NextCol,NextDownLeft,DownLeft).

buildPossibleDownRight(Line,Lines,_,_,DownRight,DownRight):-
	Line > Lines,
	!.

buildPossibleDownRight(_,_,Col,Cols,DownRight,DownRight):-
	Col > Cols,
	!.

%Return in DownRight all possible board positions in downright diagonal from [Line, Col]
buildPossibleDownRight(Line,Lines,Col,Cols,Temp,DownRight):-
	Pos = [Line,Col],
	append(Temp,[Pos],NextDownRight),
	NextLine is Line + 1,
	NextCol is Col + 1,
	buildPossibleDownRight(NextLine,Lines,NextCol,Cols,NextDownRight,DownRight).

%Returns in Positions all attacks positions bishop has from [Line, Col] and their indexes in Indexes
attackPositionsBishop(Matrix,Line,Col,Cols,Indexes,Positions):-
	length(Matrix,Size),
	Lines is Size div Cols,
	LastLine is Line - 1,
	NextLine is Line + 1,
	LastCol is Col - 1,
	NextCol is Col + 1,
	buildPossibleUpLeft(LastLine,LastCol,[],UpLeft),
	buildPossibleUpRight(NextCol,Cols,LastLine,[],UpRight),
	buildPossibleDownLeft(NextLine,Lines,LastCol,[],DownLeft),
	buildPossibleDownRight(NextLine,Lines,NextCol,Cols,[],DownRight),
	Possible = [UpLeft,UpRight,DownLeft,DownRight],
	buildPositions(Matrix,Cols,Possible,[],Indexes,[],Positions).