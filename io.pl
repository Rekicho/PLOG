checkInput(Line,Col):-
    Line >= 0,
    Line =< 9,
    Col >= 0,
    Col =< 9.

getInput(Line,Col):-
    write('Line: '),
    read(Line),
    write('Col: '),
    read(Char),
    number(Line),
    not(number(Char)),
    char_code(Char,Code),
    Col is Code - 97.

getOption(Option):-
    write('\n\nOption: '),
    read(Option),
    number(Option).