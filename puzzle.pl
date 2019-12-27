:- use_module(library(lists)).
:- use_module(library(clpfd)).

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
  domain(Row, 0, 1),
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
  domain(Row, 0, 1), 
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

puzzle :-
  Board = [[A1, A2, A3, A4, A5, A6, A7, A8, A9],
           [B1, B2, B3, B4, B5, B6, B7, B8, B9],
           [C1, C2, C3, C4, C5, C6, C7, C8, C9],
           [D1, D2, D3, D4, D5, D6, D7, D8, D9],
           [E1, E2, E3, E4, E5, E6, E7, E8, E9],
           [F1, F2, F3, F4, F5, F6, F7, F8, F9],
           [G1, G2, G3, G4, G5, G6, G7, G8, G9],
           [H1, H2, H3, H4, H5, H6, H7, H8, H9],
           [I1, I2, I3, I4, I5, I6, I7, I8, I9]],
  restrict(Board, 1, 9),
  transpose(Board, NewBoard),
  restrict(NewBoard, 1, 9),
  labeling([], 
    [A1, A2, A3, A4, A5, A6, A7, A8, A9,
     B1, B2, B3, B4, B5, B6, B7, B8, B9, 
     C1, C2, C3, C4, C5, C6, C7, C8, C9,
     D1, D2, D3, D4, D5, D6, D7, D8, D9, 
     E1, E2, E3, E4, E5, E6, E7, E8, E9, 
     F1, F2, F3, F4, F5, F6, F7, F8, F9, 
     G1, G2, G3, G4, G5, G6, G7, G8, G9, 
     H1, H2, H3, H4, H5, H6, H7, H8, H9,
     I1, I2, I3, I4, I5, I6, I7, I8, I9]),
  print_board(Board).