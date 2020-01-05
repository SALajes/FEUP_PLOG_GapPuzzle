:- use_module(library(random)).
:- use_module(library(between)).
:- use_module(library(lists)).

:- include('internal_structure.pl').
:- include('solver.pl').


%--------process input---------
process_input(Value, Min, Max) :-
    repeat,
    read(Input),
    valid_input(Min, Max, Input),
    Value = Input.

process_input(Value, Min) :-
    repeat,
    read(Input),
    valid_input(Min, Input),
    Value = Input.

valid_input(Min, Max, Input):-
    number(Input),
    between(Min, Max, Input).

valid_input(_,_,_):-
    write('Insert valid option'), nl,
    false.

valid_input(Min, Input):-
    number(Input),
    Input >= Min.

valid_input(_):-
    write('Insert valid option'), nl,
    false.



%---------ask board restrictions-----------
ask_restrictions(Dimension, [H|T]):-
    valid_line_restrictions(row, Dimension, H),
    valid_line_restrictions(column, Dimension, T).

valid_line_restrictions(Line, Dimension, List):-
    repeat,
    write_message(Line),
    read(Input),
    is_list(Input),
    length(Input, N),
    N < Dimension,
    valid_restrictions(Dimension, Input),
    List = Input.

valid_restrictions(_, []).
valid_restrictions(Dimension, [H|T]):-
    nth1(1,H,L),
    between(1, Dimension, L),
    nth1(2,H,G),
    L1 is Dimension - 2,
    between(1, L1, G),
    valid_restrictions(Dimension, T).

write_message(row):-
    write('Insert row restrictions in the format: [[Row,Gap],[Row2,Gap2], ...]'), nl.

write_message(column):-
    write('Insert column restrictions in the format: [[Column,Gap],[Column2,Gap2], ...]'), nl.


%---------generate board restrictions-----------
generate_restrictions(Dimension, [H|T]) :-
    number_of_restrictions(OnRow, OnColumn, Dimension),
    generate(OnRow, Dimension, [], [], H),
    generate(OnColumn, Dimension, [], [], T).

%get number of restrictions
number_of_restrictions(OnRow, OnColumn, Dimension):-
    Rest is Dimension mod 2,
    get_restrictions_number(Rest, OnRow, OnColumn, Dimension).

get_restrictions_number(0, OnRow, OnColumn, Dimension):-
    OnRow is 2 + ((Dimension - 10)/2),
    OnColumn is OnRow - 1.

get_restrictions_number(1, OnRow, OnColumn, Dimension):-
    OnRow is 1 + ((Dimension - 9)/2),
    OnColumn is OnRow.

%generate restrictions
generate(0.0, _, _, AuxRestrictions, AuxRestrictions).
generate(Number, Dimension, AuxList, AuxRestrictions, Restrictions):-
    valid_line(AuxList, Dimension, Line),
    append(AuxList, [Line], AuxList2),
    MaxGap is Dimension - 2,
    random(1, MaxGap, Gap),
    append(AuxRestrictions, [[Line, Gap]], AuxRestrictions2),
    Number2 is Number - 1,
    generate(Number2, Dimension, AuxList2, AuxRestrictions2, Restrictions).

%get a valid line    
valid_line(AuxList, Dimension, Line):-
    repeat, 
    random(1, Dimension, Aux),
    \+member(Aux, AuxList),
    Line = Aux.


%---------MENU----------
menu(Value, Dimension):-
    write('----------------GAP PUZZLE----------------'), nl,
    write('Insert 1 to solve an original puzzle'), nl,
    write('Insert 2 to generate a puzzle'), nl,
    process_input(Value, 1, 2),
    write('Insert dimension'), nl,    
    process_input(Dimension, 9).

%---------OPTIONS----------
option(1, Board, Dimension, Restrictions):-
    init_board(Board, Dimension),
    ask_restrictions(Dimension, Restrictions).


option(2, Board, Dimension, Restrictions):-
    init_board(Board, Dimension),
    generate_restrictions(Dimension, Restrictions).

print_details(Dimension, [H|T]):-
    write('Dimension: '), write(Dimension), nl,
    write('Row Restrictions: '), write(H), nl,
    write('Column Restrictions: '), write(T), nl.


%---------START-----------
start:-
    menu(Value, Dimension),
    option(Value, Board, Dimension, Restrictions),
    print_details(Dimension, Restrictions),
    solver(_, Board, Dimension, Restrictions).