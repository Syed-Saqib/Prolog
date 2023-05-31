% Define the cities and their distances
dist(a, b, 10).
dist(a, c, 15).
dist(a, d, 20).
dist(b, c, 35).
dist(b, d, 25).
dist(c, d, 30).

% Predicate to find the shortest path
tsp(Start, Path, Distance) :-
    findall([P, D], tsp_path(Start, P, D), Paths),
    sort(Paths, SortedPaths),
    SortedPaths = [[Path, Distance]|_].

% Helper predicate to find all possible paths and their distances
tsp_path(Start, Path, Distance) :-
    findall([City, Dist], dist(Start, City, Dist), Neighbors),
    tsp_path(Start, Neighbors, [], Path, Distance).

% Base case: Visited all cities, return to the starting city
tsp_path(Start, [], [Start], [Start], 0).

% Recursive case: Visit each unvisited neighbor
tsp_path(Start, Neighbors, Visited, Path, Distance) :-
    select([City, Dist], Neighbors, Remaining),
    \+ member(City, Visited),
    tsp_path(City, Remaining, [City|Visited], SubPath, SubDistance),
    Distance is Dist + SubDistance,
    Path = [Start|SubPath].
