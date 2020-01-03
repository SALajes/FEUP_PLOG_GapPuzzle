:- use_module(library(clpfd)).

:- include('display.pl').

%delete this
:- include('internal_structure.pl').


%--------------
restrict([], _, _):-!.
restrict([Row|_], Size, Size, [RowRestrictions|_]) :-
  Zeros is Size - 2,
  Ones is 2,
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I1, Row, 1), element(I2, Row, 1),
  gap_restriction(Size, I1, I2, RowRestrictions).
  

restrict([Row, NextRow|T], Index, Size, [RowRestrictions|_]) :-
  Zeros is Size - 2,
  Ones is 2,
  NextIndex is Index + 1,
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I1, Row, 1), element(I2, Row, 1),
  gap_restriction(Index, I1, I2, RowRestrictions),
  element(I3, NextRow, 1), element(I4, NextRow, 1),
  abs(I3 - I4) #> 1,
  abs(I1 - I3) #> 2,
  abs(I1 - I4) #> 2,
  abs(I2 - I3) #> 2,
  abs(I2 - I4) #> 2,
  restrict([NextRow|T], NextIndex, Size, [RowRestrictions|_]).

%restrict columns
restrict_columns([], _,_,_).
restrict_columns([Column|T], Index, Size, [_|ColumnRestrictions]) :-
  Zeros is Size - 2,
  Ones is 2,
  global_cardinality(Column, [0-Zeros, 1-Ones]),
  element(I1, Column, 1), element(I2, Column, 1),
  gap_restriction(Index, I1, I2, ColumnRestrictions),
  NextIndex is Index + 1,
  restrict_columns(T, NextIndex, Size, [_|ColumnRestrictions]).

%set row or column gap
gap_restriction(Index, I1, I2, Restrictions):-
  get_gap(Index, Restrictions, Gap),
  abs(I1 - I2) #= Gap + 1,
  !.

gap_restriction(_, I1, I2, _):-
  abs(I1 - I2) #> 1.

get_gap(_, [], _):- false.
get_gap(Index, [H|_], Gap):-
  nth1(1,H,Index),
  nth1(2,H,Gap),
  !.

get_gap(Index,[_|T], Gap):-
  get_gap(Index, T, Gap).


%-----SOLVER-----
%solver(Variables, Dimension, Board, Restrictions) :-
solver(Variables, Dimension) :-
  Restrictions = [[[9,4]],[[3,4]]],
  init_board(Board, Dimension),
  append(Board, Variables),
  domain(Variables, 0, 1),
  restrict(Board, 1, Dimension, Restrictions),
  transpose(Board, NewBoard),
  restrict_columns(NewBoard, 1, Dimension, Restrictions),
  labeling([], Variables),
  print_board(Board, Dimension, Restrictions, 1).