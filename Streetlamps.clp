(deffacts
	(lamp x 3 y 5 brokenbulbs 2 lamp x 5 y 5 brokenbulbs 3 lamp x 4 y 3 brokenbulbs 1) 
	(warehouse x 2 y 3)
	(capacity-basket 3)
	(grid-size 5 5)
)


(deffunction start ()
        (reset)
	(printout t "Maximum depth:= " )
	(bind ?prof (read))
	(printout t "Search strategy " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then    (set-strategy breadth)
	       else   (set-strategy depth))
    (printout t " Execute run to start the program " crlf)

	(assert (max-depth ?prof))
	(assert (robot x 1 y 1 level 0 movement null basket 0 fact 0))
)


(defrule warehouse_arrive
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (warehouse x ?x y ?y)
	?f3 <- (capacity-basket ?c)
	=>
	(loop-for-count (1 ?c)
		(assert robot x ?x y ?y level ?n movement ?mov basket ?c fact ?)
	)
)

(defrule right
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	(max-depth ?prof)
	(test (not (member (create$ x (+ ?x 1) y ?y) $?A)))
	(test (<> (?x 5)))
	(test (neq ?mov left))
	(test (< ?n ?prof))
	=>
	(assert (robot x (+ ?x 1) y ?y level (+ ?n 1) movement right basket ?b fact ?))
)

(defrule up
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	(max-depth ?prof)
	(test (not (member (create$ x ?x y (+ ?y 1) $?A)))
	(test (<> (?y 5)))
	(test (neq ?mov down))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (+ ?y 1) level (+ ?n 1) movement up basket ?b fact ?))
)

(defrule down
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	(max-depth ?prof)
	(test (not (member (create$ x ?x y (- ?y 1) $?A)))
	(test (<> (?y 1)))
	(test (neq ?mov up))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (- ?y 1) level (+ ?n 1) movement down basket ?b fact ?))
)

(defrule left
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	(max-depth ?prof)
	(test (not (member (create$ x (- ?x 1) y ?y) $?A)))
	(test (<> (?x 1)))
	(test (neq ?mov right))
	(test (< ?n ?prof))
	=>
	(assert (robot x (- ?x 1) y ?y level (+ ?n 1) movement left basket ?b fact ?))
)

(defrule fixlamp
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp x ?xl y ?yl brokenbulbs ?)
	(test(or(
		(and(=()))
	)
	))





)
