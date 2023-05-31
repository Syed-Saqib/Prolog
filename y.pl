
water_jugs :-
 SmallCapacity = 3,
 LargeCapacity = 4,
 Reservoir is SmallCapacity + LargeCapacity + 1,
 volume( small, Capacities, SmallCapacity ),
 volume( large, Capacities, LargeCapacity ),
 volume( reservoir, Capacities, Reservoir ),
 volume( small, Start, 0 ),
 volume( large, Start, 0 ),
 volume( reservoir, Start, Reservoir ),
 volume( large, End, 2 ),
 water_jugs_solution( Start, Capacities, End, Solution ),
 phrase( narrative(Solution, Capacities, End), Chars ),
 put_chars( Chars ).
water_jugs_solution( Start, Capacities, End, Solution ) :-
 solve_jugs( [start(Start)], Capacities, [], End, Solution ).
solve_jugs( [Node|Nodes], Capacities, Visited, End, Solution ) :-
 node_state( Node, State ),
 ( State = End ->
 Solution = Node
 ; otherwise ->
 findall(
 Successor,
 successor(Node, Capacities, Visited, Successor),
 Successors
 ),
 append( Nodes, Successors, NewNodes ),
 solve_jugs( NewNodes, Capacities, [State|Visited], End, Solution )
 ).
successor( Node, Capacities, Visited, Successor ) :-
 node_state( Node, State ),
 Successor = node(Action,State1,Node),
 jug_transition( State, Capacities, Action, State1 ),
 \+ member( State1, Visited ).
jug_transition( State0, Capacities, empty_into(Source,Target), State1 ) :-
 volume( Source, State0, Content0 ),
 Content0 > 0,
 jug_permutation( Source, Target, Unused ),
 volume( Target, State0, Content1 ),
 volume( Target, Capacities, Capacity ),
 Content0 + Content1 =< Capacity,
 volume( Source, State1, 0 ),
 volume( Target, State1, Content2 ),
 Content2 is Content0 + Content1,
 volume( Unused, State0, Unchanged ),
 volume( Unused, State1, Unchanged ).
jug_transition( State0, Capacities, fill_from(Source,Target), State1 ) :-
 volume( Source, State0, Content0 ),
 Content0 > 0,
 jug_permutation( Source, Target, Unused ),
 volume( Target, State0, Content1 ),
 volume( Target, Capacities, Capacity ),
 Content1 < Capacity,
 Content0 + Content1 > Capacity,
 volume( Source, State1, Content2 ),
 volume( Target, State1, Capacity ),
 Content2 is Content0 + Content1 - Capacity,
 volume( Unused, State0, Unchanged ),
 volume( Unused, State1, Unchanged ).
volume( small, jugs(Small, _Large, _Reservoir), Small ).
volume( large, jugs(_Small, Large, _Reservoir), Large ).
volume( reservoir, jugs(_Small, _Large, Reservoir), Reservoir ).
jug_permutation( Source, Target, Unused ) :-
 select( Source, [small, large, reservoir], Residue ),
 select( Target, Residue, [Unused] ).
node_state( start(State), State ).
node_state( node(_Transition, State, _Predecessor), State ).
narrative( start(Start), Capacities, End ) -->
 "Given three jugs with capacities of:", newline,
 literal_volumes( Capacities ),
 "To obtain the result:", newline,
 literal_volumes( End ),
 "Starting with:", newline,
 literal_volumes( Start ),
 "Do the following:", newline.
narrative( node(Transition, Result, Predecessor), Capacities, End ) -->
 narrative( Predecessor, Capacities, End ),
 literal_action( Transition, Result ).
literal_volumes( Volumes ) -->
 indent, literal( Volumes ), ";", newline.
literal_action( Transition, Result ) -->
 indent, "- ", literal( Transition ), " giving:", newline,
 indent, indent, literal( Result ), newline.
literal( empty_into(From,To) ) -->
 "Empty the ", literal( From ), " into the ",
 literal( To ).
literal( fill_from(From,To) ) -->
 "Fill the ", literal( To ), " from the ",
 literal( From ).
literal( jugs(Small,Large,Reservoir) ) -->
 literal_number( Small ), " gallons in the small jug, ",
 literal_number( Large ), " gallons in the large jug and ",
 literal_number( Reservoir ), " gallons in the reservoir".
literal( small ) --> "small jug".
literal( large ) --> "large jug".
literal( reservoir ) --> "reservoir".
literal_number( Number, Plus, Minus ) :-
 number( Number ),
 number_chars( Number, Chars ),
 append( Chars, Minus, Plus ). 
