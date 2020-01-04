:- use_module(library(lists)).

print_board(Dimension, Solutions, Restrictions):-
    End is Dimension + 1,
    start_print(1, End, Dimension, Restrictions, Solutions).

start_print(End, End, Dimension,[_|T],_):-
    nth1(1, T, ColumnRestrictions),
    print_restrictioned_columns(1, Dimension, ColumnRestrictions),
    !.

start_print(Row, End, Dimension, Restrictions, [C1, C2|NextLines]):-
    print_row(1, End, C1, C2),
    is_restrictioned_row(Restrictions, Row),
    nl,
    NextRow is Row + 1,
    start_print(NextRow, End, Dimension, Restrictions, NextLines).

%-----------print restrictions-------------
%Row
is_restrictioned_row([H|_], Row):-
    search(H, Row).

%column
print_restrictioned_columns(Column, Column, _):- !.

print_restrictioned_columns(Column, Dimension, Restrictions):-
    search(Restrictions, Column),
    NextColumn is Column + 1,
    print_restrictioned_columns(NextColumn, Dimension, Restrictions),
    !.
    
%search restrictions for a specific row or columns
search([], _):- write('  ').

search([[N|T]|_], N):-
    write(' '),
    nth1(1,T,R),
    write(R),
    !.

search([_|T], N):-
    search(T, N).
    

%write cells
print_row(End, End, _, _).
print_row(Col, End, C1, C2):-
    write(' '),
    getCell(Col, C1, C2, Cell),
    write(Cell),
    NextCol is Col + 1,
    print_row(NextCol, End, C1, C2).

getCell(Col, Col,_, 1):-!.
getCell(Col, _, Col, 1):-!.
getCell(_, _, _, 0):-!.

