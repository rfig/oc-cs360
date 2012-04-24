# Rafael Figueroa
# qb_rating.asm: calculates quarterback passer rating
#
# Registers used:
#
#	$f0		- number of completions
#	$f1		- number of attempts
#	$f2		- number of yards
#	$f3		- number of touchdowns
#	$f4		- number of interceptions
#	$f5		- intermediate calculations
# 	$f6		- for calculating mm



	.text
main:
	l.s		$f0, comp	# load completions into $f0
	l.s		$f1, att		# load attempts into $f1
	l.s		$f2, yards		# load yards into $f2
	l.s		$f3, td		# load touchdowns into $f3
	l.s		$f4, int		# load interceptions into $f4
	
	## Compute variable a
	li.s		$f5, 0.3		# for subtraction
	div.s 	$f0, $f0, $f1	# divide completions by attempts
	sub.s	$f0, $f0, $f5	# subtract comp/att - .3
	li.s		$f5, 5.0		# for multiplying
	mul.s	$f0, $f0, $f5	# $f0 now holds a
	s.s		$f0, comp	# store a in comp
	
	## Compute variable b
	li.s		$f5, 3.0		# for subtraction
	div.s		$f2, $f2, $f1	# divide yards by attempts
	sub.s	$f2, $f2, $f5	# subtract yards/att - 3.0
	li.s		$f5, 0.25		# for multiplying
	mul.s	$f2, $f2, $f5	# $f2 now holds b
	s.s		$f2, yards		# store b in yards

	## Compute variable c
	div.s		$f3, $f3, $f1	# divide touchdowns by attempts
	li.s		$f5, 20.0		# for multiplying
	mul.s	$f3, $f3, $f5	# $f3 now holds c
	s.s		$f3, td		# store c in td
	
	## Compute variable d
	div.s		$f4, $f4, $f1	# divide interceptions by attempts
	li.s		$f5, 25.0		# for multiplying
	mul.s	$f4, $f4, $f5	# multiply int/att and 25
	li.s		$f5, 2.375	# for subtraction
	sub.s	$f4, $f5, $f4	# $f4 now holds d
	s.s		$f4, int		# store d in int
	
	l.s		$f6, comp	# load a into $f6
	jal		mm
	s.s		$f6, comp	# save mm(a) into comp
	
	l.s		$f6, yards		# load b into $f6
	jal		mm
	s.s		$f6, yards		# save mm(b) into yards
	
	l.s		$f6, td		# load c into $f6
	jal		mm
	s.s		$f6, td		# save mm(c) into td
	
	l.s		$f6, int		# load d into $f6
	jal		mm
	s.s		$f6, int		# save mm(d) into int
	
	b		rating
	
mm:
	## Do min max comparisons
	li.s		$f5, 2.375	# for comparison
	c.lt.s		$f6, $f5		# compare number to 2.375
	bc1t		max			# if less than 2.375, go to max
	li.s		$f6, 2.375	# else set $f6 to 2.375
	jr		$ra			# return

max:
	li.s		$f5, 0.0		# for next comparison
	c.lt.s		$f6, $f5		# compare number to zero
	bc1t		zero			# if number is less than zero, make number zero
	jr		$ra			# else return
	
zero:
	li.s		$f6, 0.0		# make number zero
	jr		$ra			# return
	
	
rating:
	## Add together the calculated mm
	li.s		$f6, 0.0		# $f6 will hold qb rating
	l.s		$f5, comp	# load mm(a) into $f5
	add.s	$f6, $f6, $f5	# add mm(a)
	l.s		$f5, yards		# load mm(b) into $f5
	add.s	$f6, $f6, $f5	# add mm(b)
	l.s		$f5, td		# load mm(c) into $f5
	add.s	$f6, $f6, $f5	# add mm(c)
	l.s		$f5, int		# load mm(d) into $f5
	add.s	$f6, $f6, $f5	# add mm(d)
	
	li.s		$f5, 6.0		# for division
	div.s		$f6, $f6, $f5	# divide sum of all mm by 6
	li.s		$f5, 100.0	# for multiplication
	mul.s	$f6, $f6, $f5	# multiply quotient by 100 for qb rating
	
	mov.s	$f12, $f6		# move qb rating into $f12 for printing
	li		$v0, 2		# load print float into syscall parameter
	syscall				# print qb rating
	
	li		$v0, 10		# end program
	syscall
	
	
	.data
comp:		.float 106.0
att:			.float 163.0
yards:		.float 1219.0
td:			.float 9.0
int:			.float 1.0