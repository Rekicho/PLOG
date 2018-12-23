%Gets piece ID
pieceCode(' ',0).
pieceCode(n,1).
pieceCode(b,2).
pieceCode(k,3).
pieceCode(r,4).
pieceCode(q,5).

%Writes piece description
writePiece(n):-
	write('knight').

writePiece(b):-
	write('bishop').

writePiece(k):-
	write('king').

writePiece(r):-
	write('rook').

writePiece(q):-
	write('queen').

%Returns in Positions all attacks positions a given piece has from [Line, Col] and their indexes in Indexes
attackPositions(Matrix,3,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsKing(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,1,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsKnight(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,4,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsRook(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,2,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsBishop(Matrix,Line,Col,Cols,Indexes,Positions).

attackPositions(Matrix,5,Line,Col,Cols,Indexes,Positions):-
	!,
	attackPositionsQueen(Matrix,Line,Col,Cols,Indexes,Positions).