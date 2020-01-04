:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- include('display.pl').

flatten([], Aux, Aux).
flatten([H|T], Aux, Flat) :-
    append(Aux, H, Aux2),
    flatten(T, Aux2, Flat).

print_board([]).
print_board([H|T]) :-
    write(H), nl, 
    print_board(T).

print_line([], _).
print_line([H1, H2|T], Counter) :-
    Counter2 is Counter + 1,
    write('I'), write(Counter), write(': '), write(H1), write('; '), write('I'), write(Counter2), write(': '), write(H2), nl, 
    NextCounter is Counter2 + 1,
    print_line(T, NextCounter).

constrain([V1, V2]) :-
    abs(V1 - V2) #> 1.

constrain([V1, V2, V3, V4|T]) :-
    abs(V1 - V2) #> 1,
    abs(V1 - V3) #> 1,
    abs(V1 - V4) #> 1,
    abs(V2 - V3) #> 1,
    abs(V2 - V4) #> 1,
    constrain([V3, V4|T]).

%solver(Variables, Size, Restrictions, Cardinality):-
test(Variables) :-
    Size = 9,
    Restrictions = [[[6,4]],[[1,4]]],
    NumVariables is Size*2,
    length(Variables, NumVariables),
    domain(Variables, 1, 9),
    Cardinality = [1-2, 2-2, 3-2, 4-2, 5-2, 6-2, 7-2, 8-2, 9-2],
    global_cardinality(Variables, Cardinality),
    
    element(11, Variables, V11), element(12, Variables, V12),
    abs(V11 - V12) #= 5,

    element(IX, Variables, 1),
    element(IY, Variables, 1),
    IY #>= IX,
    div((IY - IX), 2) #= 5,

    constrain(Variables),

    labeling([], Variables),
    print_board(Size, Variables, Restrictions).