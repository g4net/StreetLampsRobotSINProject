(defglobal ?*nod-gen* = 0)


(deffacts
	(warehouse x 2 y 3)
	(capacity-basket 3)
	(grid-size 5 5)
	(robot x 1 y 1 level 0 movement null basket 0 lamp x 3 y 5 brokenbulbs 2 lamp x 5 y 5 brokenbulbs 3 lamp x 4 y 3 brokenbulbs 1)
	(take 1 2 3)
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
	
)


(defrule warehouse_arrive
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b $?)
	?f2 <- (warehouse x ?x y ?y)
	?f3 <- (capacity-basket ?c)
	?f4 <- (take $? ?t $?)
	(test (>= ?c (+ ?t ?b)))
	=>
	(assert robot x ?x y ?y level ?n movement ?mov basket (+ ?t ?b) $?)
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule right
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	?f3 <- (grid-size ?gx ?)
	(max-depth ?prof)
	(test (not (member (create$ x (+ ?x 1) y ?y) $?A)))
	(test (<> (?x ?gx)))
	(test (neq ?mov left))
	(test (< ?n ?prof))
	=>
	(assert (robot x (+ ?x 1) y ?y level (+ ?n 1) movement right basket ?b fact ?))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule up
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	?f3 <- (grid-size ? ?gy)
	(max-depth ?prof)
	(test (not (member (create$ x ?x y (+ ?y 1) $?A)))
	(test (<> (?y ?gy)))
	(test (neq ?mov down))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (+ ?y 1) level (+ ?n 1) movement up basket ?b fact ?))
	(bind ?*nod-gen* (+ ?*nod-gen* 1)))
)

(defrule down
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- (lamp $?A)
	?f3 <- (grid-size ?gx ?)
	(max-depth ?prof)
	(test (not (member (create$ x ?x y (- ?y 1) $?A)))
	(test (<> (?y 1)))
	(test (neq ?mov up))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (- ?y 1) level (+ ?n 1) movement down basket ?b fact ?))
	(bind ?*nod-gen* (+ ?*nod-gen* 1)))
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
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule fixlamp
	?f1 <- (robot x ?x y ?y level ?n movement ?mov basket ?b fact ?)
	?f2 <- ($?l lamp x ?xl y ?yl brokenbulbs ?bk $?r)
	(test(and(>= (b bk)) >(bk 0)))
	(test(or(
		(and((= x1 (+ x 1)) (= y1 y)))
		(and((= x1 (- x 1)) (= y1 y)))
		(and((= x1 x) (= y1 (+ y 1))))
		(and((= x1 x) (= y1 (- y 1))))
	)
	))

	=>
	(assert (robot x ?x y ?y level (+ ?n 1) movement ?mov basket (- ?b ?bk) fact ?))
	(assert ($?l $?r))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule end
	declare (salience 100)
	?f1 <- (robot x ? y ? level ?n movement ? basket ?b)
	(test (= 0 ?b))

	=>

	(printout t "SOLUTION FOUND AT LEVEL " ?n crlf)
    (printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
    
    (halt)

)
