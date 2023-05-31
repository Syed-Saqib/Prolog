% Define the capacities of the jugs
capacity(1, 3). % Jug 1 can hold 3 liters
capacity(2, 4). % Jug 2 can hold 4 liters

% Define the goal state
goal(state(_, 0)).  % Jug 2 has 0 liters

% Define the initial state
initial(state(0, 0)). % Both jugs are empty

% Define the possible actions
action(fill(X)) :- % Fill a jug from the tap
    capacity(X, _). % The jug has a capacity

action(empty(_)). % Empty a jug to the drain

action(pour(X, Y)) :- % Pour from one jug to another
    capacity(X, _), % The source jug has a capacity
    capacity(Y, _), % The target jug has a capacity
    X \= Y. % The jugs are different

% Define the effects of the actions
effect(fill(X), state(A, _), state(A, Max)) :- % Filling a jug from the tap
    capacity(X, Max). % The maximum capacity of the jug

effect(empty(_), state(A, _), state(A, 0)) . % Emptying a jug to the drain

effect(pour(X, Y), state(A, B), state(NewA, NewB)) :- % Pouring from one jug to another
    amount(X, state(A, B), Source), % The amount in the source jug
    amount(Y, state(A, B), Target), % The amount in the target jug
    capacity(Y, Max), % The maximum capacity of the target jug
    Transfer is min(Source, Max - Target), % The amount that can be transferred
    Source > 0, % The source jug is not empty
    Target < Max, % The target jug is not full
    NewA is A - Transfer, % The new amountin the source jug
    NewB is B + Transfer, % % The new amountin the target jug

% Define some helper predicates
amount(1, state(A, _), A). % The amount in Jug 1 is the first element of the state pair
amount(2, state(_, B), B). % The amount in Jug 2 is the second element of the state pair

% Define the search algorithm (depth-first search)
solve :- % To solve the problem,
    initial(InitialState), % Get the initial state
    path([InitialState], [], Sol), % Find a path from the initial state to a goal state
    reverse(Sol, RevSol), % Reverse the path to get the correct order of actions
    write_sol(RevSol). % Write the solution to the standard output

path([S|_], _, []) :-
    goal(S). % If the current state is a goal state, then there is no action needed

path([S|Visited], History, [A|Actions]) :-
    action(A), % Choose an action
    effect(A, S, S1), % Apply the effect of the action to get a new state
    \+ member(S1, Visited), % Check that the new state has not been visited before
    path([S1,S|Visited], [A|History], Actions). % Continue searching from the new state

write_sol([]) :- nl. % If there are no more actions to write, print a new line

write_sol([A|Actions]) :-
    write_sol(Actions), % Write the remaining actions first (to get the correct order)
    write(A), nl. % Write the current action and a new line