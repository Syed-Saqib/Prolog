% Define the capacities of the jugs
jug(4). % Jug A can hold 4 gallons
jug(3). % Jug B can hold 3 gallons

% Define the goal state
goal(2, 0). % We want 2 gallons in Jug A and 0 gallons in Jug B

% Define the initial state
initial(0, 0). % Both jugs are empty at the start

% Define the actions that can be performed
action(fill(X), State, NewState) :- % Fill a jug from the infinite supply
    jug(X), % X is a valid jug
    State = (A, B), % The current state of the jugs
    (X = 4 -> NewState = (4, B) ; NewState = (A, 3)). % The new state after filling

action(empty(X), State, NewState) :- % Empty a jug to the ground
    jug(X), % X is a valid jug
    State = (A, B), % The current state of the jugs
    (X = 4 -> NewState = (0, B) ; NewState = (A, 0)). % The new state after emptying

action(pour(X, Y), State, NewState) :- % Pour from one jug to another
    jug(X), jug(Y), X \= Y, % X and Y are valid and distinct jugs
    State = (A, B), % The current state of the jugs
    (X = 4 ->
        (B + A > 3 -> NewState = (B + A - 3, 3) ; NewState = (0, B + A)) ; % Pour from A to B
        (A + B > 4 -> NewState = (4, A + B - 4) ; NewState = (A + B, 0))). % Pour from B to A

% Define the search algorithm using depth-first search
search(State, _, []) :- goal(State). % If the current state is the goal state, we are done
search(State, Visited, [Action | Actions]) :- % Otherwise, we need to find an action and more actions
    action(Action, State, NewState), % Find an action that leads to a new state
    \+ member(NewState, Visited), % Make sure the new state is not visited before
    search(NewState, [NewState | Visited], Actions). % Recursively search for more actions from the new state

% Define the main predicate that prints the solution
solve :-
    initial(State), % Get the initial state
    search(State, [State], Actions), % Search for the actions from the initial state
    write('The solution is:'), nl,
    write_actions(Actions). % Write the actions

% Define a helper predicate that writes the actions in a readable way
write_actions([]) :- !. % No more actions to write
write_actions([fill(X) | Actions]) :- % Write a fill action
    format('Fill ~w gallon jug~n', [X]), % Use format to print with variables
    write_actions(Actions). % Write more actions
write_actions([empty(X) | Actions]) :- % Write an empty action
    format('Empty ~w gallon jug~n', [X]),
    write_actions(Actions).
write_actions([pour(X, Y) | Actions]) :- % Write a pour action
    format('Pour from ~w gallon jug to ~w gallon jug~n', [X, Y]),
    write_actions(Actions).
