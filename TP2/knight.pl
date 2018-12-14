attackPositionsKnight(Matrix,Line,Col,Cols,Indexes,Positions):-
	LastLastLine is Line - 2,
	LastLine is Line - 1,
	NextLine is Line + 1,
	NextNextLine is Line + 2,
	LastLastCol is Col - 2,
	LastCol is Col - 1,
	NextCol is Col + 1,
	NextNextCol is Col + 2,
	UpUpLeft = [LastLastLine,LastCol],
	UpUpRight = [LastLastLine,NextCol],
	UpLeftLeft = [LastLine,LastLastCol],
	UpRightRight = [LastLine,NextNextCol],
	DownDownLeft = [NextNextLine,LastCol],
	DownDownRight = [NextNextLine,NextCol],
	DownLeftLeft = [NextLine,LastLastCol],
	DownRightRight = [NextLine,NextNextCol],
	Possible = [UpUpLeft, UpUpRight, UpLeftLeft, UpRightRight, DownDownLeft, DownDownRight, DownLeftLeft, DownRightRight],
	buildPositions(Matrix,Cols,Possible,[],Indexes,[],Positions).