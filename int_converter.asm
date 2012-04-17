# Rafael Figueroa
# int_converter.asm: Reads in a number as a string and prints it back out as integer
#
# Registers used
#	$v0		- syscall parameters
#	$a0		- sysacall arguments
#	$t0		- user input address
#	$t1		- byte that holds a digit
#	$t2		- holds 10 for new line character to know when to end input and used 
#			  for multiplication
#	$t3 		- holds converted number
# 	$t4		- lower limit of check
#	$t5		- upper limit of check
#	$t6		- negative number

	.text
main:
	## Read in user string
	la		$a0, string		# loads request into argument
	li		$v0, 4			# print_str argument into $v0
	syscall					# print request
	
	li		$v0, 8			# read_str argument into $v0
	la		$a0, userstring		# puts input into userstring
	li 		$a1, 64			# user input can be at most 64
	syscall					# gets user string
	
	la		$t0, userstring		# loads userstring address into $t0
	li 		$t2, 10			# loads new line value into $t2
	li		$t3, 0			# reinitialize $t3 if there was previous input
	li		$t4, 0x30			# load 0 ascii value into $t4
	li		$t5, 0x39			# load 9 ascii value into $t5
	li		$t6, 0			# reinitialize $t3 if previous input was negative
	lbu		$t1, 0($t0)		# load working byte from userstring
	beq 		$t1, 0x2D, neg_set	# checks if number is negative
	b		check			# skips neg_set if value is not negative
	
	
neg_set:
	## Indicates there is a negative input
	li		$t6, 1			# input is negative
	addiu	$t0, $t0, 1		# increment address location by 1


check:
	## Check if value is valid
	lbu		$t1, 0($t0)		# load working byte from userstring
	beq 		$t1, $t2, end		# exit program when end of input is reached
	bltu 		$t1, $t4, invalid	# if ascii value is below 0
	bgtu		$t1, $t5, invalid	# if ascii value is above 9
	b		convert			# process digit if value is valid


convert:	
	## Convert string into integer
	addiu	$t1, $t1, -0x30		# subtracts 48 from ascii number making it an integer
	mul		$t3, $t3, $t2		# multiply value by ten
	addiu	$t0, $t0, 1		# increment address location by 1
	beq		$t6, 1, neg_inc		# for negative numbers
	b		pos_inc			# for positive numbers
	
	
neg_inc:
	## For negative numbers
	sub		$t3, $t3, $t1		# subtract new digit
	b		check


pos_inc:
	## For positive numbers
	add		$t3, $t3, $t1		# add new digit
	b		check


invalid:
	## Displays invalid error message
	la		$a0, invalid_str		# load error message that value is invalid
	li		$v0, 4			# print_str argument into $v0
	syscall					# print error

	li		$v0, 10			# end program
	syscall
	
	
end:
	## For successful end of input
	addi		$t3, $t3, 5		# adds 5 to make sure it's an integer
	li		$v0, 1			# print_int argument into $v0
	move	$a0, $t3			# moves number into argument
	syscall
	
	li		$v0, 10			# end program
	syscall
	
	
	
	
	
	.data
string:		.asciiz "Insert an integer: "
invalid_str:	.asciiz "Value not valid.\n"
userstring:	.space 64