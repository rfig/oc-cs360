# Rafael Figueroa -- 2012-02-03
# identity_theft.asm: asks name and age
# Registers used
# $v0	- used to store system calls
# $t0	- store user name
# $t1	- store user age
# $a0	- store arguments

	.text
main:				# start of program
	## gets user name
	la $a0, name		# load address of name into $a0
	li $v0, 4			# load print string into $v0
	syscall			# print name question
	
	li $v0, 8			# load read string into $v0
	la $a0, username	# puts user input into username
	li $a1, 64			# user input can be at most 64
	syscall			# get user name
	
	
	
	## gets user age
	la $a0, age		# load address of age into $a0
	li $v0, 4			# load print string into $v0
	syscall			# print name question
	
	li $v0, 8			# load request string into $v0
	la $a0, userage	# puts user input into userage
	li $a1, 64			# user input can be at most 64
	syscall			# get user name

	
	
	## prints user data
	la $a0, u_name	# loads u_name into $a0
	li $v0, 4			# load print string into $v0
	syscall			# prints string
	
	la $a0, username	# loads user name into $a0
	li $v0, 4			# load print string into $v0
	syscall			# prints string
	
	la $a0, u_age		# loads u_age into $a0
	li $v0, 4			# load print string into $v0
	syscall			# prints string
	
	la $a0, userage	# loads user age into $a0
	li $v0, 4			# load print string into $v0
	syscall			# prints string
	
	li $v0, 10			# loads end program int $v0
	syscall			# ends programs
	
	
	
	
# data for the program
	.data
name:		.asciiz "What is your name?: "
age:			.asciiz "How old are you?: "
u_name:		.asciiz "Your name is: "
u_age:		.asciiz "Your age is: "
username:	.space 64
userage:		.space 64