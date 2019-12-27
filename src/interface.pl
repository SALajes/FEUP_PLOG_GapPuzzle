%PROCESS DIMENSIONS
process_dimensions(Dimension) :-
    repeat,
    write('Insert dimension of the board.'),
    nl,
    read(Input),
    valid_dimension(Input),
    Dimension = Input.

valid_dimension(Input):-
    number(Input),
    Input >= 5,
    !.

valid_dimension(Input):-
    write('Insert valid dimension.\n'),
    nl,
    false.

%PROCESS BOARD RESTRICTIONS
process_restrictions(Dimensions, [H|T]) :-
    repeat,
    write('Insert restrictions of the board.'),
    nl,
    read(Input),
    valid_restriction(H),
    Dimensions = Input.

valid_restrictions(Input):-
    number(Input),
    Input >= 5,
    !.

valid_dimension(Input):-
    print_invalid_input().



start():-
    process_dimensions(Dimensions),
    process_restrictions(Board_Restrictions),
    init_board(Board, Dimensions),
    display_board(Board).
    %solver(Board, Board_Restrictions).