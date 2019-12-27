init_board(Board, Dimensions):-
    length(Board, Dimensions),
    maplist(length(Board, Dimensions)).

init_restrictions(Dimensions, BoardRestrictions):-
    random(Line, 1, Dimensions),
    random(Column, 1, Dimensions),
    