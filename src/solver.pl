:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- include('display.pl').

% :- spy(get_neighbours).

flatten([], Aux, Aux).
flatten([H|T], Aux, Flat) :-
    append(Aux, H, Aux2),
    flatten(T, Aux2, Flat).

%--------------
%first restriction
two_line_restrictions(Board):-
  sum_restriction(Board),
  transpose(Board, NewBoard),
  sum_restriction(NewBoard).

sum_restriction([]).
sum_restriction([H|T]):-
  sum(H, #=, 2),
  sum_restriction(T). 

%--------------
%second restriction
neighbour_restrictions([], _, _, _).
neighbour_restrictions([H|T], Board, Dimension, CurrentLine):-
  element(P1,H,1),
  element(P2,H,1),
  P1#\=P2,
  get_neighbours(Board, CurrentLine, P1, Dimension, Neighbours1),
  sum(Neighbours1, #=, 0),
  get_neighbours(Board, CurrentLine, P2, Dimension, Neighbours2),
  sum(Neighbours2, #=, 0),
  CurrentLine2 #= CurrentLine+1,
  neighbour_restrictions(T, Board, Dimension, CurrentLine2).


%------------------------------
%--------GET NEIGHBOURS--------

%--------FIRST LINE--------
%first column
get_neighbours(Board, 1, 1, _, Neighbours):-
  get_cell(Board, N1, 1, 2),
  get_cell(Board, N2, 2, 1),
  get_cell(Board, N3, 2, 2),
  Neighbours = [N1,N2,N3],
  !.

%last column
get_neighbours(Board, 1, Dimension, Dimension, Neighbours):-
  N #= Dimension-1,
  get_cell(Board, N1, 1, N),
  get_cell(Board, N2, 2, N),
  get_cell(Board, N3, 2, Dimension),
  Neighbours = [N1,N2,N3],
  !.

%other cases
get_neighbours(Board, 1, Col, _, Neighbours):-
  C1 #= Col-1,
  C2 #= Col+1,
  get_cell(Board, N1, 1, C1),
  get_cell(Board, N3, 1, C2),
  get_cell(Board, N4, 2, C1),
  get_cell(Board, N5, 2, Col),
  get_cell(Board, N6, 2, C2),
  Neighbours = [N1,N3,N4,N5,N6],
  !.

%----------LAST LINE----------
%first column
get_neighbours(Board, Dimension, 1, Dimension, Neighbours):-
  N #= Dimension-1,
  get_cell(Board, N1, N, 1),
  get_cell(Board, N2, N, 2),
  get_cell(Board, N3, Dimension, 2),
  Neighbours = [N1,N2,N3],
  !.

%last column
get_neighbours(Board, Dimension, Dimension, Dimension, Neighbours):-
  N #= Dimension-1,
  get_cell(Board, N1, N, N),
  get_cell(Board, N2, N, Dimension),
  get_cell(Board, N3, Dimension, N),
  Neighbours = [N1,N2,N3],
  !.

%other cases
get_neighbours(Board, Dimension, Col, Dimension, Neighbours):-
  N #= Dimension-1,
  C1 #= Col-1,
  C2 #= Col+1,
  get_cell(Board, N1, N, C1),
  get_cell(Board, N2, N, Col),
  get_cell(Board, N3, N, C2),
  get_cell(Board, N4, Dimension, C1),
  get_cell(Board, N6, Dimension, C2),
  Neighbours = [N1,N2,N3,N4,N6],
  !.

%--------FIRST COLUMN-------
get_neighbours(Board, Row, 1, _, Neighbours):-
  R1 #= Row-1,
  R2 #= Row+1,
  get_cell(Board, N1, R1, 1),
  get_cell(Board, N2, R1, 2),
  get_cell(Board, N4, Row, 2),
  get_cell(Board, N5, R2, 1),
  get_cell(Board, N6, R2, 2),
  Neighbours = [N1,N2,N4,N5,N6],
  !.

%--------LAST COLUMN-------
get_neighbours(Board, Row, Dimension, Dimension, Neighbours):-
  N #= Dimension-1,
  R1 #= Row-1,
  R2 #= Row+1,
  get_cell(Board, N1, R1, N),
  get_cell(Board, N2, R1, Dimension),
  get_cell(Board, N4, Row, N),
  get_cell(Board, N5, R2, N),
  get_cell(Board, N6, R2, Dimension),
  Neighbours = [N1,N2,N4,N5,N6],
  !.

%--------OTHER CASES------
get_neighbours(Board, Row, Col, _, Neighbours):-
  R1 #= Row-1,
  R2 #= Row+1,
  C1 #= Col-1,
  C2 #= Col+1,
  get_cell(Board, N1, R1, C1),
  get_cell(Board, N2, R1, Col),
  get_cell(Board, N3, R1, C2),
  get_cell(Board, N4, Row, C1),
  get_cell(Board, N6, Row, C2),
  get_cell(Board, N7, R2, C1),
  get_cell(Board, N8, R2, Col),
  get_cell(Board, N9, R2, C2),
  Neighbours = [N1,N2,N3,N4,N6,N7,N8,N9],
  !.

%--------------
%third restriction


%--------------
get_cell(Board, Cell, Row, Column):-
  nth1(Row, Board, R),
  nth1(Column, R, Cell).

%--------------
puzzle :-
  Dimension = 9,
  Restrictions = [[[4,5]],[[1,2]]],
  Board = [[A1, A2, A3, A4, A5, A6, A7, A8, A9],
           [B1, B2, B3, B4, B5, B6, B7, B8, B9],
           [C1, C2, C3, C4, C5, C6, C7, C8, C9],
           [D1, D2, D3, D4, D5, D6, D7, D8, D9],
           [E1, E2, E3, E4, E5, E6, E7, E8, E9],
           [F1, F2, F3, F4, F5, F6, F7, F8, F9],
           [G1, G2, G3, G4, G5, G6, G7, G8, G9],
           [H1, H2, H3, H4, H5, H6, H7, H8, H9],
           [I1, I2, I3, I4, I5, I6, I7, I8, I9]],
  flatten(Board, [], Variables),
  domain(Variables, 0, 1),
  two_line_restrictions(Board),
  neighbour_restrictions(Board, Board, Dimension, 1),
  % gap_restrictions(Board, Restrictions),
  labeling([], Variables),
  print_board(Board, Dimension, Restrictions, 1).