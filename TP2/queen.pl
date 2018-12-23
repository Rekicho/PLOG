%Returns in Positions all attacks positions queen has from [Line, Col] and their indexes in Indexes
attackPositionsQueen(Matrix,Line,Col,Cols,Indexes,Positions):-
	length(Matrix,Size),
	Lines is Size div Cols,
	LastLine is Line - 1,
	NextLine is Line + 1,
	LastCol is Col - 1,
	NextCol is Col + 1,
	buildPossibleUpLeft(LastLine,LastCol,[],UpLeft),
	buildPossibleUp(LastLine,Col,[],Up),
	buildPossibleUpRight(NextCol,Cols,LastLine,[],UpRight),
	buildPossibleLeft(LastCol,Line,[],Left),
	buildPossibleRight(NextCol,Cols,Line,[],Right),
	buildPossibleDownLeft(NextLine,Lines,LastCol,[],DownLeft),
	buildPossibleDown(NextLine,Lines,Col,[],Down),
	buildPossibleDownRight(NextLine,Lines,NextCol,Cols,[],DownRight),
	Possible = [UpLeft,Up,UpRight,Left,Right,DownLeft,Down,DownRight],
	buildPositions(Matrix,Cols,Possible,[],Indexes,[],Positions).