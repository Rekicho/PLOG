:-dynamic wins/2.
:-dynamic treesEaten/2.
:-dynamic players/2.
:-dynamic tab/1.
:-dynamic yuki/2.
:-dynamic mina/2.
:-dynamic beforeMina/1.
:-dynamic nextPlayer/1.

wins(0,0).
treesEaten(0,0).
players(y,m).
tab([[t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t],
    [t,t,t,t,t,t,t,t,t,t]]).
yuki(-1,-1).
mina(-1,-1).
%In the start, yuki and mina are not on the board
beforeMina(m). %In the start, there is nothing in the place where mina is
nextPlayer(p1).

allMoves([
[0,0],[0,1],[0,2],[0,3],[0,4],[0,5],[0,6],[0,7],[0,8],[0,9],
[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[1,8],[1,9],
[2,0],[2,1],[2,2],[2,3],[2,4],[2,5],[2,6],[2,7],[2,8],[2,9],
[3,0],[3,1],[3,2],[3,3],[3,4],[3,5],[3,6],[3,7],[3,8],[3,9],
[4,0],[4,1],[4,2],[4,3],[4,4],[4,5],[4,6],[4,7],[4,8],[4,9],
[5,0],[5,1],[5,2],[5,3],[5,4],[5,5],[5,6],[5,7],[5,8],[5,9],
[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7],[6,8],[6,9],
[7,0],[7,1],[7,2],[7,3],[7,4],[7,5],[7,6],[7,7],[7,8],[7,9],
[8,0],[8,1],[8,2],[8,3],[8,4],[8,5],[8,6],[8,7],[8,8],[8,9],
[9,0],[9,1],[9,2],[9,3],[9,4],[9,5],[9,6],[9,7],[9,8],[9,9]
]).

%Faster hardcoded than calculated at run time
%FINISH COPRIMES
%coprime(0,0):- 
    %fail.
%coprime(0,_).
%coprime(_,0).
coprime(_,_).