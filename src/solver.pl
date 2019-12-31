:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- include('display.pl').
:- include('internal_structure.pl').

%--------------
restrict([], _, _):-!.
restrict(Board, Size, Size) :-
  Zeros is Size - 2,
  Ones is 2,
  nth1(Size, Board, Row),
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I1, Row, 1), element(I2, Row, 1),
  I1 #< I2 - 1,
  !.

restrict(Board, Index, Size) :-
  Zeros is Size - 2,
  Ones is 2,
  nth1(Index, Board, Row),
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I1, Row, 1), element(I2, Row, 1),
  I1 #< I2 - 1,
  NextIndex is Index + 1,
  nth1(NextIndex, Board, NextRow),
  element(I3, NextRow, 1), element(I4, NextRow, 1),
  I3 #< I4 - 1,
  abs(I1 - I3) #> 2,
  abs(I1 - I4) #> 2,
  abs(I2 - I3) #> 2,
  abs(I2 - I4) #> 2,
  restrict(Board, NextIndex, Size).

restrict_transpose([], _):-!.
restrict_transpose([H|T], Size) :-
  Zeros is Size - 2,
  Ones is 2,
  global_cardinality(H, [0-Zeros, 1-Ones]),
  restrict_transpose(T, Size).

puzzle(Variables, Dimension) :-
  Restrictions = [[[4,5]],[[1,2]]],
  init_board(Board, Dimension),
  append(Board, Variables),
  domain(Variables, 0, 1),
  restrict(Board, 1, Dimension),
  transpose(Board, NewBoard),
  restrict_transpose(NewBoard, Dimension),
  labeling([], Variables),
  print_board(Board, Dimension, Restrictions, 1).