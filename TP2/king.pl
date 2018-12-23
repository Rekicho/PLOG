%Returns in Positions all attacks positions king has from [Line, Col] and their indexes in Indexes
attackPositionsKing(Matrix,Line,Col,Cols,Indexes,Positions):-
	LastLine is Line - 1,
	NextLine is Line + 1,
	LastCol is Col - 1,
	NextCol is Col + 1,
	UpLeft = [LastLine,LastCol],
	Up = [LastLine,Col],
	UpRight = [LastLine,NextCol],
	Left = [Line,LastCol],
	Right = [Line,NextCol],
	DownLeft = [NextLine,LastCol],
	Down = [NextLine, Col],
	DownRight = [NextLine,NextCol],
	Possible = [[UpLeft], [Up], [UpRight], [Left], [Right], [DownLeft], [Down], [DownRight]],
	buildPositions(Matrix,Cols,Possible,[],Indexes,[],Positions).