%Puzzle Information
%In case ID is negative generates a random puzzle
puzzle(ID,Num,Piece1,Piece2,Lines,Cols):-	
	ID < 0,
	!,
	repeat,
	random(2,6,Lines),
	random(3,9,Cols),
	random(2,6,Num),
	random(1,6,Code1),
	random(1,6,Code2),
	Code1 =\= Code2,
	!,
	pieceCode(Piece1,Code1),
	pieceCode(Piece2,Code2).

puzzle(0,2,r,b,2,3).
puzzle(1,2,n,k,2,3).
puzzle(2,3,n,k,4,5).
puzzle(3,2,r,k,2,4).
puzzle(4,3,r,k,4,5).
puzzle(5,2,b,n,3,3).
puzzle(6,4,b,n,4,4).
puzzle(7,4,b,n,3,5).
puzzle(8,4,b,k,4,6).
puzzle(9,4,b,k,5,5).
puzzle(10,3,n,r,3,4).
puzzle(11,5,n,r,3,8).
puzzle(12,2,n,q,2,4).
puzzle(13,3,n,q,3,6).
puzzle(14,3,n,q,4,5).
puzzle(15,4,n,q,4,7).