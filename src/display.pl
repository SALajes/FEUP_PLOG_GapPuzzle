:- use_module(library(ansi_term)).
:- use_module(library(lists)).
:- include('internalstructure.pl').
:- include('utilities.pl').

%When the board is empty, prints the last line delimiter 
%(the consecutive dashes "-----")
display_board([], Row) :-
    print_dashed_line(Row),
    nl.

%Depending on the value or Row, prints the respective dashed line and 
%the line with the board contents
display_board([H|T], Row) :-
    print_dashed_line(Row),
    nl,
    Col is 1,
    print_row(H, Row, Col),
    nl,
    Row2 is Row+1,
    display_board(T, Row2).

%When there are no more columns of the same line to print, 
%prints the last vertical bar
print_row([], _, _) :-
    write('|').

%Depending on the Col of the same Row (Row is constant),  
%prints the respective cell
print_row([H|T], Row, Col) :-
    print_pipe(Row, Col),
    print_cell(H, Row, Col),
    Col2 is Col+1,
    print_row(T, Row, Col2).