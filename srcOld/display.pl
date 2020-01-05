:- use_module(library(lists)).

print_board([], Dimension, [_|T], _):-
    nth1(1, T, ColumnRestrictions),
    print_restrictioned_columns(1, Dimension, ColumnRestrictions),
    !.

print_board([H|T], Dimension, Restrictions, Row) :-
  write_row(H), 
  is_restrictioned_row(Restrictions, Row),
  nl,
  NextRow is Row + 1,
  print_board(T, Dimension, Restrictions, NextRow).

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
write_row([]).
write_row([H|T]):-
    write(' '),
    write(H),
    write_row(T).
