%Displays puzzle information
display_puzzle(Num,Piece1,Piece2,Lines,Cols):-
	write('Place '),
	write(Num),
	write(' '),
	writePiece(Piece1),
	write('s and '),
	writePiece(Piece2),
	write('s on a '),
	write(Lines),
	write('x'),
	write(Cols),
	write(' chess board.\n\n').

display_nl(Cols,Cols):-
	!.

%Displays a new board line
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

%Displays the chess board
display_board([Head|Tail],Col,Cols):-
	pieceCode(Piece,Head),
	write(Piece),
	write('|'),
	Next is Col + 1,
	display_board(Tail,Next,Cols).