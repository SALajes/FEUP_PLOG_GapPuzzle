:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- include('display.pl').

row_constraints([], _).
row_constraints([H|T], Variables):-
    nth1(1,H,Row),
    nth1(2,H,Gap),
    Position2 is Row*2,
    Position1 is Position2 - 1,
    element(Position1, Variables, Value1),
    element(Position2, Variables, Value2),
    Value2 - Value1 #= Gap + 1,
    row_constraints(T, Variables).

column_constraints([], _).
column_constraints([[Col,Gap]|T], Variables):-
    element(Position1, Variables, Col),
    element(Position2, Variables, Col),
    Position2 #> Position1,
    div(Position2, 2) + mod(Position2, 2) - (div(Position1, 2) + mod(Position1, 2)) #= Gap + 1,
    column_constraints(T, Variables).

constrain([V1, V2]) :-
    V2 #> 1 + V1.

constrain([V1, V2, V3, V4|T]) :-
    V2 #> 1 + V1,
    (V3 #> 1 + V1 #\/ V1 #> 1 + V3),
    (V4 #> 1 + V1 #\/ V1 #> 1 + V4),
    (V3 #> 1 + V2 #\/ V2 #> 1 + V3),
    (V4 #> 1 + V2 #\/ V2 #> 1 + V4),
    constrain([V3, V4|T]).

solver(Variables, Size, Restrictions, Cardinality):-
    domain(Variables, 1, Size),
    global_cardinality(Variables, Cardinality),

    nth1(1, Restrictions, RowRestrictions),
    row_constraints(RowRestrictions, Variables),

    nth1(2, Restrictions, ColumnRestrictions),

    column_constraints(ColumnRestrictions, Variables),

    constrain(Variables),

    labeling([], Variables),
    print_board(Size, Variables, Restrictions).