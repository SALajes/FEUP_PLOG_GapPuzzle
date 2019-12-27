:- use_module(library(ansi_term)).
:- use_module(library(lists)).

display(Board, Restrictions):-
    length(Board, N),
    print_board(Board, N, Restrictions, 1).

print_board([], Dimensions, [_|T], _):-
    nth1(1, T, ColumnRestrictions),
    printRestrictionedColumns(1, Dimensions, ColumnRestrictions),
    !.

print_board([H|T], Dimensions, Restrictions, Row) :-
  writeRow(H), 
  isRestrictionedRow(Restrictions, Row),
  nl,
  NextRow is Row + 1,
  print_board(T, Dimensions, Restrictions, NextRow).

%-----------print restrictions-------------
%Row
isRestrictionedRow([H|_], Row):-
    search(H, Row).

%column
printRestrictionedColumns(Column, Column, _):- !.

printRestrictionedColumns(Column, Dimensions, Restrictions):-
    search(Restrictions, Column),
    NextColumn is Column + 1,
    printRestrictionedColumns(NextColumn, Dimensions, Restrictions),
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
writeRow([]).
writeRow([H|T]):-
    define_color(H, Color),
    print_cell(Color),
    writeRow(T).

define_color(1, black):- !.
define_color(0, white).

print_cell(Color):-
    write(' '), 
    ansi_format([fg(Color)], '~c', [9606]).

