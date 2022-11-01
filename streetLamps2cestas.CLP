(deffacts initial
  (grid_size 5 5)
  (warehouse_position ltype A 2 3 ltype B 5 1)
  (basket_capacity 3)
  (pick 1 2 3)
  
  (problem robot 1 1 broken 3 5 b 2 ltype A broken 4 3 b 3 ltype B broken 5 5 b 2 ltype B bulbs ltype A 0 ltype B 0 level 0)
  )

  ;A CAMBIAR
  ;Facts estáticos HECHO
  ;Fact dinámico HECHO
  ;Reglas de movimiento HECHO
  ;Regla pick up
  ;Regla fix lamp

(defglobal ?*nod-gen* = 0)

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
	
	(assert (max-depth ?prof)))

  (defrule right
    (problem robot ?x ?y $?A bulbs $?b level ?level)
    (test (not (member (create$ (+ ?x 1) ?y) ?A)))
    (grid_size ?max_x ?)
    (max-depth ?prof)
    (test (<= (+ ?x 1) ?max_x))
    (test (< ?level ?prof))
    ;(test (neq ?mov left))
    =>
    (assert (problem robot (+ ?x 1) ?y $?A bulbs $?b level (+ ?level 1)))
    (bind ?*nod-gen* (+ ?*nod-gen* 1)))

  (defrule left
    (problem robot ?x ?y $?A bulbs $?b level ?level)
    (test (not (member (create$ (- ?x 1) ?y ) ?A)))
    (max-depth ?prof)
    (test (>= (- ?x 1) 1))
    (test (< ?level ?prof))
    ;(test (neq ?mov right))
    =>
    (assert (problem robot (- ?x 1) ?y $?A bulbs $?b level (+ ?level 1)))
    (bind ?*nod-gen* (+ ?*nod-gen* 1)))

    (defrule up
    (problem robot ?x ?y $?A bulbs $?b level ?level)
    (test (not (member (create$ ?x (+ ?y 1)) ?A)))
    (grid_size ? ?max_y)
    (max-depth ?prof)
    (test (<= (+ ?y 1) ?max_y))
    (test (< ?level ?prof))
    ;(test (neq ?mov down))
    =>
    (assert (problem robot ?x (+ ?y 1) $?A bulbs $?b level (+ ?level 1)))
    (bind ?*nod-gen* (+ ?*nod-gen* 1)))

    (defrule down
    (problem robot ?x ?y $?A bulbs $?b level ?level)
    (test (not (member (create$ ?x (- ?y 1)) ?A)))
    (max-depth ?prof)
    (test (>= (- ?y 1) 1))
    (test (< ?level ?prof))
    ;(test (neq ?mov up))
    =>
    (assert (problem robot ?x (- ?y 1) $?A bulbs $?b level (+ ?level 1)))
    (bind ?*nod-gen* (+ ?*nod-gen* 1)))
    
    (defrule pick_bulbs
    (problem robot ?x ?y $?A bulbs $?bl ltype ?ltype ?b $?br level ?level)
    (warehouse_position $?wl ltype ?ltype ?w1 ?w2 $?wr)
    (pick $? ?n $?)
    (basket_capacity ?bk)
    (max-depth ?prof)
    (test (and (= ?x ?w1) (= ?y ?w2)))
    (test (<= (+ ?b ?n) ?bk))
    (test (< ?level ?prof))
    =>
    (assert (problem robot ?x ?y $?A bulbs $?bl ltype ?ltype (+ ?b ?n) $?br level (+ ?level 1)))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
    )

    (defrule fix_lamp
    (problem robot ?x ?y $?antes broken ?b1 ?b2 b ?bbulbs ltype ?ltype $?despues bulbs $?bl ltype ?ltype ?b $?br level ?level)
    (max-depth ?prof)
    (test (or (and (= ?x ?b1) (= (+ ?y 1) ?b2)) (and (= ?x ?b1) (= (- ?y 1) ?b2)) (and (= (+ ?x 1) ?b1) (= ?y ?b2)) (and (= (- ?x 1) ?b1) (= ?y ?b2))))
    (test (>= ?b ?bbulbs))
    (test (< ?level ?prof))
    =>
    (assert (problem robot ?x ?y $?antes $?despues bulbs $?bl ltype ?ltype (- ?b ?bbulbs) $?br level (+ ?level 1)))
    (bind ?*nod-gen* (+ ?*nod-gen* 1))
    )

    (defrule goal
    (declare (salience 100))
    (problem robot ?x ?y bulbs ltype A 0 ltype B 0 level ?level)
    =>
    (halt)
    (printout t "Solution found in level "  ?level  " with " ?*nod-gen* " nodes." crlf))