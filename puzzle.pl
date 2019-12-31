:- use_module(library(lists)).
:- use_module(library(clpfd)).

flatten([], Aux, Aux).
flatten([H|T], Aux, Flat) :-
    append(Aux, H, Aux2),
    flatten(T, Aux2, Flat).

print_board([]).
print_board([H|T]) :-
  write(H), nl, 
  print_board(T).

flatten([], []) :- !.
flatten([L|Ls], FlatL) :-
    !,
    flatten(L, NewL),
    flatten(Ls, NewLs),
    append(NewL, NewLs, FlatL).
flatten(L, [L]).

restrict([], _, _).
restrict(Board, Size, Size) :-
  Zeros is Size - 2,
  Ones is 2,
  nth1(Size, Board, Row),
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I3, Row, 1), element(I4, Row, 1),
  I3 #\= I4,
  abs(I3 - I4) #> 1.

restrict(Board, Index, Size) :-
  Index < Size,
  Zeros is Size - 2,
  Ones is 2,
  NextIndex is Index + 1,
  nth1(Index, Board, Row),
  nth1(NextIndex, Board, NextRow),
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I1, Row, 1), element(I2, Row, 1),
  abs(I1 - I2) #> 1,
  element(I3, NextRow, 1), element(I4, NextRow, 1),
  abs(I1 - I3) #> 3,
  abs(I1 - I4) #> 3,
  abs(I2 - I3) #> 3,
  abs(I2 - I4) #> 3,
  NewIndex is Index + 1,
  restrict(Board, NewIndex, Size).

puzzle(Variables) :-
  length(Board, 9),
  maplist(same_length(Board), Board),
  flatten(Board, [], Variables),
  domain(Variables, 0, 1),
  restrict(Board, 1, 9),
  transpose(Board, NewBoard),
  restrict(NewBoard, 1, 9),
  labeling([], Variables),
  print_board(Board).