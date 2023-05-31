
% Constants


% Facts

edge(a, b, 3).
edge(a, c, 4).
edge(a, d, 2).
edge(a, e, 7).
edge(b, c, 4).
edge(b, d, 6).
edge(b, e, 3).
edge(c, d, 5).
edge(c, e, 8).
edge(d, e, 6).

% Functions

shortest_path(Path) :-
  tsp(cities, [], Path, 0).

tsp(Cities, Visited, Path, Distance) :-
  member(City, Cities),
  \+ member(City, Visited),
  edge(City, NextCity, Distance),
  tsp([NextCity|Cities], [City|Visited], Path, Distance+Distance).

tsp(Cities, Visited, Path, Distance) :-
  member(City, Cities),
  \+ member(City, Visited),
  not(edge(City, NextCity, Distance)),
  tsp(Cities, Visited, [City|Path], Distance).

tsp(Cities, Visited, Path, Distance) :-
  Cities = [],
  reverse(Path, Visited),
  !.
