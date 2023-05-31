


% TSP.pl

% Facts about the cities and their distances.
city(a).
city(b).
city(c).
city(d).
city(e).

distance(a,b,10).
distance(a,c,20).
distance(a,d,30).
distance(a,e,40).
distance(b,c,50).
distance(b,d,60).
distance(b,e,70).
distance(c,d,80).
distance(c,e,90).
distance(d,e,100).

% Finds the shortest path that visits all cities.
shortest_path(Path) :-
  all_paths(Path, 0),
  min_path(Path).

% Generates all possible paths that visit all cities.
all_paths(Path, Total) :-
  member(a, Path),
  all_paths([a|Path], Total).
all_paths(Path, Total) :-
  member(b, Path),
  all_paths([b|Path], Total).
all_paths(Path, Total) :-
  member(c, Path),
  all_paths([c|Path], Total).
all_paths(Path, Total) :-
  member(d, Path),
  all_paths([d|Path], Total).
all_paths(Path, Total) :-
  member(e, Path),
  all_paths([e|Path], Total).
all_paths(Path, Total) :-
  not(member(a, Path)),
  not(member(b, Path)),
  not(member(c, Path)),
  not(member(d, Path)),
  not(member(e, Path)),
  Total = 0.

% Finds the path with the minimum total distance.
min_path(Path) :-
  all_paths(Path1, Total1),
  all_paths(_, Total2),
  Total1 < Total2,
  Path = Path1.
min_path(Path) :-
  all_paths(Path1, Total1),
  all_paths(_, Total2),
  Total1 = Total2,
  Path = Path1.
