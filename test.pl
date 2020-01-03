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

constrain([I1, I2]) :-
    abs(I1 - I2) #> 1.

constrain([I1, I2, I3, I4|T]) :-
    abs(I1 - I2) #> 1,
    abs(I1 - I3) #> 1,
    abs(I1 - I4) #> 1,
    abs(I2 - I3) #> 1,
    abs(I2 - I4) #> 1,
    constrain([I3, I4|T]).

print_line([], _).
print_line([H1, H2|T], Counter) :-
    Counter2 is Counter + 1,
    write('I'), write(Counter), write(': '), write(H1), write('; '), write('I'), write(Counter2), write(': '), write(H2), nl, 
    NextCounter is Counter2 + 1,
    print_line(T, NextCounter).

% get_column_values([], _, _, AuxList, AuxList).
% get_column_values([Value|T], Value, Counter, [Counter|AuxList], List).
% get_column_values([_|T], Value, Counter, AuxList, List) :-
%     NewCounter is Counter + 1,
%     get_column_values(T, Value, NewCounter, AuxList, List).

indices(List, E, Is) :-
    findall(N, nth1(N, List, E), Is).

test(Variables, Size) :-
    NumVariables is Size*2,
    length(Variables, NumVariables),
    domain(Variables, 1, 9),
    global_cardinality(Variables, [1-2, 2-2, 3-2, 4-2, 5-2, 6-2, 7-2, 8-2, 9-2]),

    element(15, Variables, I15), element(16, Variables, I16),
    abs(I15 - I16) #= 5,

    element(IX, Variables, 3),
    element(IY, Variables, 3),
    IX #\= IY,
    abs(IX - IY) #= 6,

    constrain(Variables),
    
    labeling([], Variables),
    print_line(Variables, 1).
