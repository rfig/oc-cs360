# Rafael Figueroa
# qb_ratingv2.asm: calculates quarterback passer rating
#

	.text
main:
	l.s		$f0, att		# load attempts into $f0
	l.s		$f1, comp	# load completions into $f1
	li.s		$f3, 0.0		# the passer rating

	
	## Compute variable a
	div.s 	$f1, $f1, $f0	# divide completions by attempts
	li.s		$f2, 0.3		# for subtraction
	sub.s	$f1, $f1, $f2	# subtract comp/att - .3
	li.s		$f2, 5.0		# for multiplying
	mul.s	$f1, $f1, $f2	# $f1 now holds a
	jal		mm			# checks if number is between 0 and 2.375
	add.s	$f3, $f3, $f1	# add in mm(a)
	
	
	l.s		$f1, yards		# load yards into $f1
	## Compute variable b
	div.s		$f1, $f1, $f0	# divide yards by attempts
	li.s		$f2, 3.0		# for subtraction
	sub.s	$f1, $f1, $f2	# subtract yards/att - 3.0
	li.s		$f2, 0.25		# for multiplying
	mul.s	$f1, $f1, $f2	# $f1 now holds b
	jal		mm			# checks if number is between 0 and 2.375
	add.s	$f3, $f3, $f1	# add in mm(b)


	l.s		$f1, td		# load touchdowns into $f1
	## Compute variable c
	div.s		$f1, $f1, $f0	# divide touchdowns by attempts
	li.s		$f2, 20.0		# for multiplying
	mul.s	$f1, $f1, $f2	# $f1 now holds c
	jal		mm			# checks if number is between 0 and 2.375
	add.s	$f3, $f3, $f1	# add in mm(c)


	l.s		$f1, int		# load interceptions into $f1
	## Compute variable d
	div.s		$f1, $f1, $f0	# divide interceptions by attempts
	li.s		$f2, 25.0		# for multiplying
	mul.s	$f1, $f1, $f2	# multiply int/att and 25
	li.s		$f2, 2.375	# for subtraction
	sub.s	$f1, $f2, $f1	# $f1 now holds d
	jal		mm			# checks if number is between 0 and 2.375
	add.s	$f3, $f3, $f1	# add in mm(d)
	
	
	## Final calculations
	li.s		$f2, 6.0		# for division
	div.s		$f3, $f3, $f2	# divide sum of all mm by 6
	li.s		$f2, 100.0	# for multiplication
	mul.s	$f3, $f3, $f2	# multiply quotient by 100 for qb rating
	
	mov.s	$f12, $f3		# move qb rating into $f12 for printing
	li		$v0, 2		# load print float into syscall parameter
	syscall				# print qb rating
	
	li		$v0, 10		# end program
	syscall
	
	
mm:
	## Do min max comparisons
	li.s		$f2, 2.375	# for comparison
	c.lt.s		$f1, $f2		# compare number to 2.375
	bc1t		max			# if less than 2.375, go to max
	li.s		$f1, 2.375	# else set $f1 to 2.375
	jr		$ra			# return

max:
	li.s		$f2, 0.0		# for next comparison
	c.lt.s		$f1, $f2		# compare number to zero
	bc1t		zero			# if number is less than zero, make number zero
	jr		$ra			# else return
	
zero:
	li.s		$f1, 0.0		# make number zero
	jr		$ra			# return
	
	
	
	.data
att:			.float 163.0
comp:		.float 106.0
yards:		.float 1219.0
td:			.float 9.0
int:			.float 1.0