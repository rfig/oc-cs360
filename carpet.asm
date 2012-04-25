# Rafael Figueroa
# carpet.asm: calculates carpet needed as well as price
#

	.text
main:
	li		$t1, 0		# for later comparison
	
	## Get price per square foot
	la 		$a0, price		# load room message
	li		$v0, 4		# load print string into syscall
	syscall
	li		$v0, 6		# load read float
	syscall
	mov.s 	$f1, $f0		# price per square foot in $f1

	## Get number of rooms
	la 		$a0, room	# load room message
	li		$v0, 4		# load print string into syscall
	syscall
	li		$v0, 5		# load read int
	syscall
	move 	$t0, $v0		# number of rooms in $t0
	
	
dim:
	## Gets dimensions of each room
	beq		$t0, $t1, end	# if all rooms have been asked for, continue
	addi		$t1, $t1, 1	# add to increment
	
	la 		$a0, room2	# load room2 message
	li		$v0, 4		# load print string into syscall
	syscall
	move	$a0, $t1		# room we are asking for
	li		$v0, 1		# load print int into syscall
	syscall
	la		$a0, nl		# load newline
	li		$v0, 4		# load print int into syscall
	syscall
	
	la 		$a0, roomx	# load room length message
	li		$v0, 4		# load print string into syscall
	syscall
	li		$v0, 6		# load read float
	syscall
	mov.s 	$f2, $f0		# room length in $f2
	
	la 		$a0, roomy	# load room width message
	li		$v0, 4		# load print string into syscall
	syscall
	li		$v0, 6		# load read float
	syscall
	
	mul.s 	$f2, $f2, $f0	# room width by room length
	add.s	$f3, $f3, $f2	# add square feet of room to total square feet
	b		dim			# loop
	
	
end:
	la 		$a0, sqfeet	# load total square feet message
	li		$v0, 4		# load print string into syscall
	syscall
	
	mov.s	$f12, $f3		# move square feet into argument
	li		$v0, 2		# load print float into param
	syscall
	la		$a0, nl		# load newline
	li		$v0, 4		# load print int into syscall
	syscall
	
	mul.s	$f3, $f3, $f1	# multiply total square feet by price per square foot
	
	la 		$a0, cost		# load estimated cost message
	li		$v0, 4		# load print string into syscall
	syscall
	
	mov.s	$f12, $f3		# move cost into argument
	li		$v0, 2		# load print float into param
	syscall
	
	li		$v0, 10
	syscall				# end program


	.data
room:		.asciiz "How many rooms are there? "
room2:		.asciiz "For room "
roomx:		.asciiz "What is the length of the room? "
roomy:		.asciiz "What is the width of the room? "
price:		.asciiz "Price per square foot? "
sqfeet:		.asciiz "Total number of square feet: " 
cost:			.asciiz "The estimated price in dollars is: "
nl:			.asciiz "\n"
