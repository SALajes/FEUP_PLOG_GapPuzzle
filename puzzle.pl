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
restrict(Board, 1, Size) :-
  Zeros is Size - 2,
  Ones is 2,
  nth1(1, Board, Row),
  nth1(2, Board, NextRow),
  domain(Row, 0, 1),
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I1, Row, 1), element(I2, Row, 1),
  I1 #\= I2,
  abs(I1 - I2) #> 1,
  element(I3, NextRow, 1), element(I4, NextRow, 1),
  I3 #\= I4,
  abs(I1 - I3) #> 2,
  abs(I1 - I4) #> 2,
  abs(I2 - I3) #> 2,
  abs(I2 - I4) #> 2,
  restrict(Board, 2, Size).
% I1 and I2 are the indexes of the filled cells in the 
% previous row.
% I5 and I6 are the indexes of the filled cells in the 
% next row.
restrict(Board, Size, Size) :-
  Zeros is Size - 2,
  Ones is 2,
  PrevIndex is Size - 1,
  nth1(PrevIndex, Board, PrevRow),
  nth1(Size, Board, Row),
  domain(Row, 0, 1),
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I3, Row, 1), element(I4, Row, 1),
  I3 #\= I4,
  abs(I3 - I4) #> 1,
  element(I1, PrevRow, 1), element(I2, PrevRow, 1),
  I1 #\= I2,
  abs(I3 - I1) #> 3,
  abs(I3 - I2) #> 3,
  abs(I4 - I1) #> 3,
  abs(I4 - I2) #> 3.
restrict(Board, Index, Size) :-
  Index > 1, Index < Size,
  Zeros is Size - 2,
  Ones is 2,
  PrevIndex is Index - 1,
  NextIndex is Index + 1,
  nth1(PrevIndex, Board, PrevRow),
  nth1(Index, Board, Row),
  nth1(NextIndex, Board, NextRow),
  domain(Row, 0, 1), 
  global_cardinality(Row, [0-Zeros, 1-Ones]),
  element(I3, Row, 1), element(I4, Row, 1),
  I3 #\= I4,
  abs(I3 - I4) #> 1,
  element(I1, PrevRow, 1), element(I2, PrevRow, 1),
  I1 #\= I2,
  abs(I3 - I1) #> 3,
  abs(I3 - I2) #> 3,
  abs(I4 - I1) #> 3,
  abs(I4 - I2) #> 3,
  element(I5, NextRow, 1), element(I6, NextRow, 1),
  I5 #\= I6,
  abs(I3 - I5) #> 3,
  abs(I3 - I6) #> 3,
  abs(I4 - I5) #> 3,
  abs(I4 - I6) #> 3,
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