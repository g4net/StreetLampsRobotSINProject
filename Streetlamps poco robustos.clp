(defglobal ?*nod-gen* = 0)

(deffacts data
	(warehouse x 2 y 3)
	(capacity-basket 3)
	(grid-size 5 5)
	(robot x 1 y 1 dur 0 level 0 basket 0 lamp x 3 y 5 brokenbulbs 2 lamp x 5 y 5 brokenbulbs 2 lamp x 4 y 3 brokenbulbs 3)
	(take 1 2 3)
	(taller x 5 y 1)
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
	?f1 <- (robot x ?x y ?y dur ?d level ?n basket ?b $?A)
	?f2 <- (grid-size ?gx ?)
	(max-depth ?prof)
	(test (not (member$ (create$ x (+ ?x 1) y ?y) $?A)))
	(test (<> ?x ?gx))
	(test (< ?n ?prof))
	=>
	(assert (robot x (+ ?x 1) y ?y dur ?d level (+ ?n 1) basket ?b $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule left
	?f1 <- (robot x ?x y ?y dur ?d level ?n basket ?b $?A)
	(max-depth ?prof)
	(test (not (member$ (create$ x (- ?x 1) y ?y) $?A)))
	(test (<> ?x 1))
	(test (< ?n ?prof))
	=>
	(assert (robot x (- ?x 1) y ?y dur ?d level (+ ?n 1) basket ?b $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule up
	?f1 <- (robot x ?x y ?y dur ?d level ?n basket ?b $?A)
	?f2 <- (grid-size ? ?gy)
	(max-depth ?prof)
	(test (not (member$ (create$ x ?x y (+ ?y 1)) $?A)))
	(test (<> ?y ?gy))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (+ ?y 1) dur ?d level (+ ?n 1) basket ?b $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule down
	?f1 <- (robot x ?x y ?y dur ?d level ?n basket ?b $?A)
	(max-depth ?prof)
	(test (not (member$ (create$ x ?x y (- ?y 1)) $?A)))
	(test (<> ?y 1))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y (- ?y 1) dur ?d level (+ ?n 1) basket ?b $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule warehouse_arrive
	?f1 <- (robot x ?x y ?y dur ?d level ?n basket ?b $?A)
	?f2 <- (warehouse x ?x y ?y)
	?f3 <- (capacity-basket ?c)
	?f4 <- (take $? ?t $?)
	(max-depth ?prof)
	(test (>= ?c (+ ?t ?b)))
	(test (< ?n ?prof))
	=>
	(assert (robot x ?x y ?y dur ?d level (+ ?n 1) basket (+ ?t ?b) $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule taller
	?f1 <- (robot x ?x y ?y dur 2 level ?n basket ?b $?A)
	?f2 <- (taller x ?x y ?y)
	(max-depth ?prof)
	(test (< ?n ?prof))

	=>
	(assert (robot x ?x y ?y dur 0 level (+ ?n 1) basket ?b $?A))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)

(defrule fixlamp
	?f1 <- (robot x ?x y ?y dur ?d level ?n basket ?b $?l lamp x ?xl y ?yl brokenbulbs ?bk $?r)
	(max-depth ?prof)
	(test(> 2 ?d))
	(test(>= ?b ?bk))
	(test(or
		(and(= ?xl (+ ?x 1)) (= ?yl ?y))
		(and(= ?xl (- ?x 1)) (= ?yl ?y))
		(and(= ?xl ?x) (= ?yl (+ ?y 1)))
		(and(= ?xl ?x) (= ?yl (- ?y 1)))
	))
	(test (< ?n ?prof))

	=>
	(assert (robot x ?x y ?y dur (+ ?d 1) level (+ ?n 1) basket (- ?b ?bk) $?l $?r))
	(bind ?*nod-gen* (+ ?*nod-gen* 1))
)



(defrule end
	(declare (salience 100))
	?f1 <- (robot x ? y ? dur ? level ?n basket 0)

	=>
	(printout t "SOLUTION FOUND AT LEVEL " ?n crlf)
    (printout t "NUMBER OF EXPANDED NODES OR TRIGGERED RULES " ?*nod-gen* crlf)
    
    (halt)
)
