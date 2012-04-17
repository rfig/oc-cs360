# Rafael Figueroa
# rps.asm: Rock, paper, scissors game in mips
#
# 	$v0		- syscall parameter
# 	$a0		- argument for syscall
# 	$a1		- argument for syscall
# 	$t0-$t4	- registers used to generate random number and for determining 
#			  user choice
#	$t5		- holds ten for division
#	$t6		- holds computer choice
#	$t7		- holds user choice




	.text
main:
	## Get use input
	la 		$a0, request		# loads request string inot argument
	li		$v0, 4			# loads print_str into $v0
	syscall
	
	la		$a0, input		# loads address of where to put user input
	li		$a1, 4			# maximum size of input
	li		$v0, 8			# loads read_str into $v0
	syscall
	
	la		$t0, input			# loads address of user input
	lbu		$t0, 0($t0)		# loads input as byte
	beq		$t0, 114, u_rock	# user chose rock
	beq		$t0, 112, u_paper	# user chose paper
	beq		$t0, 115, u_scissors	# user chose scissors
	b		invalid
	
	##  interprets user choice as integer
u_rock:	
	li		$t7, 0			# 0 is rock
	b		random

u_paper:
	li		$t7, 1			# 1 is paper
	b		random

u_scissors:
	li		$t7, 2			# 2 is scissors
	
	
	##  calculates random number
random:
	lw	 	$t1, m_w			# load first seed
	lw		$t2, m_z			# load second seed
	
	## m_z = 36969 * (m_z & 65535) + (m_z >> 16);
	srl		$t3, $t2, 16		# m_z >> 16
	and 		$t4, $t2, 65535	# m_z & 65535
	li		$t0, 36969		# $t4 = 36969
	multu	$t0, $t4			# 36969 * (m_z & 65535)
	mflo		$t0				# puts result into $t0
	addu	$t2, $t0, $t3		# m_z = 36969 * (m_z & 65535) + (m_z >> 16)
	sw		$t2, m_z			# stores new m_z
	
	## m_w = 18000 * (m_w & 65535) + (m_w >> 16);
	srl		$t3, $t1, 16		# m_w >> 16
	and 		$t4, $t1, 65535	# m_w & 65535
	li		$t0, 18000		# $t4 = 18000
	multu	$t0, $t4			# 18000 * (m_w & 65535)
	mflo		$t0				# puts result into $t0
	addu	$t2, $t0, $t3		# m_w = 18000 * (m_w & 65535) + (m_w >> 16)
	sw		$t2, m_w			# stores new m_w
	
	## return (m_z << 16) + m_w;
	lw 		$t1, m_w			# load first seed
	lw 		$t2, m_z			# load second seed
	sll		$t3, $t2, 16		# (m_z << 16)
	addu	$t0, $t1, $t3		# (m_z << 16) + m_w
	
	## print result
	li		$v0, 1			# print_int param into $v0
	move 	$a0, $t0			# move generated number into argument
	syscall					# print generated number
	
	jal		newline
	
	li		$t5, 10
	divu		$t0, $t5			# divde by ten and get remainder
	mfhi		$t6				# put remainder into $t6
	
	li		$v0, 1			# print_int param into $v0
	move 	$a0, $t6			# move remainder into argument
	syscall					# print number
	
	jal		newline
	
	
	##  computer chooses rock
rock:
	##  $t6 is 9, 8, or 7 computer uses rock
	blt		$t6, 7, paper		
	
	la		$a0,	c_rock		# loads message that computer chose rock
	li		$v0, 4
	syscall					# prints message
	jal		newline
	
	beq		$t7, 2, lose		# if user chose scissors
	beq		$t7, 1, win		# if user chose paper
	b		adraw			# otherwise a draw
	
	
	##  computer chooses paper
paper:
	##  $t6 is 6, 5, or 4 computer uses paper
	blt		$t6, 4, scissors
	
	la		$a0,	c_paper		# loads message that computer chose paper
	li		$v0, 4
	syscall					# prints message
	jal		newline
	
	beq		$t7, 0, lose		# if user chose rock
	beq		$t7, 2, win		# if user chose scissors
	b		adraw			# otherwise a draw
	
	
	##  computer chooses scissors
scissors:
	##  $t6 is 3, 2, or 1 computer uses scissors else reroll
	beqz		$t6, random
	
	la		$a0,	c_scissors		# loads message that computer chose scissors
	li		$v0, 4
	syscall					# prints message
	jal		newline
	
	beq		$t7, 1, lose		# if user chose paper
	beq		$t7, 0, win		# if user chose rock
	b		adraw			# otherwise a draw
	
	
	##  outcome of battle
lose:						# user loses
	la		$a0,	loser
	li		$v0, 4
	syscall
	b		end
win:						# user wins
	la		$a0,	winner
	li		$v0, 4
	syscall
	b		end
adraw:					# a draw
	la		$a0,	draw
	li		$v0, 4
	syscall
	b		end
	
	
	##  input is invalid
invalid:
	li		$v0, 4			# print_str param into $v0
	la		$a0, invalid_input	# load invalid message into argument
	syscall					# print invalid message
	
	##  end of program
end:
	jal		newline
	li	 	$v0, 10			# ends program
	syscall

	##  it just prints a newline
newline:
	la		$a0, nl
	li		$v0, 4
	syscall
	jr		$ra


	.data
m_w:		.word 31893
m_z:			.word 67049
nl:			.asciiz "\n"
request:		.asciiz "Enter your choice (r or p or s): "
input:		.space 4
invalid_input:	.asciiz "Input is invalid"
c_rock:		.asciiz "Computer has chosen rock"
c_paper:		.asciiz "Computer has chosen paper"
c_scissors:	.asciiz "Computer has chosen scissors"
winner:		.asciiz "You Win"
loser:		.asciiz "You Lose"
draw:		.asciiz "A draw"





