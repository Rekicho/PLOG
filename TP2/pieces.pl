attackPositions(Matrix,107,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsKing(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,110,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsKnight(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,114,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsRook(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,98,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsBishop(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,113,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsQueen(Matrix,Line,Col,Cols,Indexes,Positions).