(defglobal ?*nod-gen* = 0)

(deffacts data
	(warehouse x 2 y 3)
	(capacity-basket 6)
	(grid-size 5 5)
	(robot x 1 y 1 level 0 basket tipoB A 0 tipoB B 0 lamp x 3 y 5 brokenbulbs 2 tipoL A lamp x 5 y 5 brokenbulbs 2 tipoL B lamp x 4 y 3 brokenbulbs 3 tipoL A)
	(take 0 1 2 3 4 5 6)
	(takeh 0 1 2 3 4 5 6)
)

(deffunction start ()
    (reset)
	(printout t "Maximum depth:= " )
	(bind ?prof (read))
	(printout t "Search strategy " crlf "    1.- Breadth" crlf "    2.- Depth" crlf )
	(bind ?a (read))
	(if (= ?a 1)
	       then   (set-strategy breadth)
	       else   (set-strategy depth))
    (printout t " Execute run to start the program " crlf)

	(assert (max-depth ?prof))
	
)

(defrule right
	?f1 <- (robot x ?x y ?y level ?n $?A)
	?f2 <- (grid-size ?gx ?)
	(max-depth ?prof)
	(test (not (member$ (create$ x (+ ?x 1) y ?y) $?A)))
	(test (<> ?x ?gx))
	(test (< ?n ?prof))
	=>
	(assert (robot x (+ ?x 1) y ?y level (+ ?n 1) $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule left
	?f1 <- (robot x ?x y ?y level ?n $?A)
	(max-depth ?prof)
	(test (not (member$ (create$ x (- ?x 1) y ?y) $?A)))
	(test (<> ?x 1))
	(test (< ?n ?prof))
	=>
	(assert (robot x (- ?x 1) y ?y level (+ ?n 1) $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule up
	?f1 <- (robot x ?x y ?y level ?n $?A)
	?f2 <- (grid-size ? ?gy)
	(max-depth ?prof)
	(test (not (member$ (create$ x ?x y (+ ?y 1)) $?A)))
	(test (<> ?y ?gy))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (+ ?y 1) level (+ ?n 1) $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule down
	?f1 <- (robot x ?x y ?y level ?n $?A)
	(max-depth ?prof)
	(test (not (member$ (create$ x ?x y (- ?y 1)) $?A)))
	(test (<> ?y 1))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (- ?y 1) level (+ ?n 1) $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule warehouse_arrive
	?f1 <- (robot x ?x y ?y level ?n basket tipoB A ?b1 tipoB B ?b2 $?A)
	?f2 <- (warehouse x ?x y ?y)
	?f3 <- (capacity-basket ?c)
	?f4 <- (take $? ?t $?)
	?f5 <- (takeh $? ?t2 $?)
	(max-depth ?prof)
	(test (>= ?c (+ ?t2 (+ (+ ?t ?b1) ?b2))))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y ?y level (+ ?n 1) basket tipoB A (+ ?t ?b1) tipoB B (+ ?t2 ?b2) $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule fixlamp
	?f1 <- (robot x ?x y ?y level ?n basket $?l1 tipoB ?t ?b1 $?l lamp x ?xl y ?yl brokenbulbs ?bk tipoL ?t $?r)
	(max-depth ?prof)
	(test (>= ?b1 ?bk))
	(test(or
		(and(= ?xl (+ ?x 1)) (= ?yl ?y))
		(and(= ?xl (- ?x 1)) (= ?yl ?y))
		(and(= ?xl ?x) (= ?yl (+ ?y 1)))
		(and(= ?xl ?x) (= ?yl (- ?y 1)))
	))
	(test (< ?n ?prof))

	=>
	(assert (robot x ?x y ?y level (+ ?n 1) basket $?l1 tipoB ?t (- ?b1 ?bk) $?l $?r))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule end
	(declare (salience 100))
	?f1 <- (robot x ? y ? level ?n basket tipoB A 0 tipoB B 0)

	=>
	(printout t "SOLUTION FOUND AT LEVEL " ?n crlf)
    (printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
    
    (halt)
)
