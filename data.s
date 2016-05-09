.data

_end: .asciiz "\n"
	.align 2
_buffer: .space 256
	.align 2
VReg: .space 3600
	length0: 	.word 	79
	String0: 	.asciiz 	"Sorry, the number n must be a number s.t. there exists i satisfying n=1+2+...+i"
	length1: 	.word 	12
	String1: 	.asciiz 	"Let's start!"
	length2: 	.word 	5
	String2: 	.asciiz 	"step "
	length3: 	.word 	1
	String3: 	.asciiz 	":"
	length4: 	.word 	7
	String4: 	.asciiz 	"Total: "
	length5: 	.word 	8
	String5: 	.asciiz 	" step(s)"
	length6: 	.word 	1
	String6: 	.asciiz 	" "
	length7: 	.word 	0
	String7: 	.asciiz 	""


.text

# copy the string in $a0 to buffer in $a1, with putting '\0' in the end of the buffer
###### Checked ######
# used $v0, $a0, $a1
_string_copy:
	_begin_string_copy:
	lb $v0, 0($a0)
	beqz $v0, _exit_string_copy
	sb $v0, 0($a1)
	add $a0, $a0, 1
	add $a1, $a1, 1
	j _begin_string_copy
	_exit_string_copy:
	sb $zero, 0($a1)
	jr $ra

# string arg in $a0
###### Checked ######
# Change(5/4): you don't need to preserve reg before calling it
func__print:
	li $v0, 4
	syscall
	jr $ra

# string arg in $a0
###### Checked ######
# Change(5/4): you don't need to preserve reg before calling it
func__println:
	li $v0, 4
	syscall
	la $a0, _end
	syscall
	jr $ra

# count the length of given string in $a0
###### Checked ######
# used $v0, $v1, $a0
_count_string_length:
	move $v0, $a0

	_begin_count_string_length:
	lb $v1, 0($a0)
	beqz $v1, _exit_count_string_length
	add $a0, $a0, 1
	j _begin_count_string_length

	_exit_count_string_length:
	sub $v0, $a0, $v0
	jr $ra

# non arg, string in $v0
###### Checked ######
# used $a0, $a1, $t0, $v0, (used in _count_string_length) $v1
func__getString:
	subu $sp, $sp, 4
	sw $ra, 0($sp)

	la $a0, _buffer
	li $a1, 255
	li $v0, 8
	syscall

	jal _count_string_length

	move $a1, $v0			# now $a1 contains the length of the string
	add $a0, $v0, 5			# total required space = length + 1('\0') + 1 word(record the length of the string)
	li $v0, 9
	syscall
	sw $a1, 0($v0)
	add $v0, $v0, 4
	la $a0, _buffer
	move $a1, $v0
	move $t0, $v0
	jal _string_copy
	move $v0, $t0

	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra

# non arg, int in $v0
###### Checked ######
# Change(5/4): you don't need to preserve reg before calling it
func__getInt:
	li $v0, 5
	syscall
	jr $ra

# int arg in $a0
###### Checked ######
# Bug fixed(5/2): when the arg is a neg number
# Change(5/4): use less regs, you don't need to preserve reg before calling it
# used $v0, $v1
func__toString:
	subu $sp, $sp, 24
	sw $a0, 0($sp)
	sw $t0, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	sw $t3, 16($sp)
	sw $t5, 20($sp)

	# first count the #digits
	li $t0, 0			# $t0 = 0 if the number is a negnum
	bgez $a0, _skip_set_less_than_zero
	li $t0, 1			# now $t0 must be 1
	neg $a0, $a0
	_skip_set_less_than_zero:
	beqz $a0, _set_zero

	li $t1, 0			# the #digits is in $t1
	move $t2, $a0
	move $t3, $a0
	li $t5, 10

	_begin_count_digit:
	div $t2, $t5
	mflo $v0			# get the quotient
	mfhi $v1			# get the remainder
	bgtz $v0 _not_yet
	bgtz $v1 _not_yet
	j _yet
	_not_yet:
	add $t1, $t1, 1
	move $t2, $v0
	j _begin_count_digit

	_yet:
	beqz $t0, _skip_reserve_neg
	add $t1, $t1, 1
	_skip_reserve_neg:
	add $a0, $t1, 5
	li $v0, 9
	syscall
	sw $t1, 0($v0)
	add $v0, $v0, 4
	add $t1, $t1, $v0
	sb $zero, 0($t1)
	sub $t1, $t1, 1

	_continue_toString:
	div $t3, $t5
	mfhi $v1
	add $v1, $v1, 48	# in ascii 48 = '0'
	sb $v1, 0($t1)
	sub $t1, $t1, 1
	mflo $t3
	# bge $t1, $v0, _continue_toString
	bnez $t3, _continue_toString

	beqz $t0, _skip_place_neg
	li $v1, 45
	sb $v1, 0($t1)
	_skip_place_neg:
	# lw $ra, 0($sp)
	# addu $sp, $sp, 4

	lw $a0, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t5, 20($sp)

	addu $sp, $sp, 24
	jr $ra

	_set_zero:
	li $a0, 6
	li $v0, 9
	syscall
	li $a0, 1
	sw $a0, 0($v0)
	add $v0, $v0, 4
	li $a0, 48
	sb $a0, 0($v0)

	lw $a0, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $t3, 16($sp)
	lw $t5, 20($sp)

	addu $sp, $sp, 24
	jr $ra


# string arg in $v0
# the zero in the end of the string will not be counted
###### Checked ######
# you don't need to preserve reg before calling it
func__string.length:
	lw $v0, -4($v0)
	jr $ra

# string arg in $a0, left in $a1, right in $a2
###### Checked ######
# used $a0, $a1, $t0, $t1, $t2, $v1, $v0
func__string.substring:
	subu $sp, $sp, 4
	sw $ra, 0($sp)

	move $t0, $v0
	move $t3, $a0
	sub $t1, $a1, $a0
	add $t1, $t1, 1		# $t1 is the length of the substring
	add $a0, $t1, 5
	li $v0, 9
	syscall
	sw $t1, 0($v0)
	add $v1, $v0, 4

	add $a0, $t0, $t3
	add $t2, $t0, $a1
	lb $t1, 1($t2)		# store the ori_begin + right + 1 char in $t1
	sb $zero, 1($t2)	# change it to 0 for the convenience of copying
	move $a1, $v1
	jal _string_copy
	move $v0, $v1
	sb $t1, 1($t2)

	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra
# string arg in
###### Checked ######
# 16/5/4 Fixed a serious bug: can not parse negtive number
# used $v0, $v1
func__string.parseInt:
	move $a0, $v0
	li $v0, 0

	lb $t1, 0($a0)
	li $t2, 45
	bne $t1, $t2, _skip_parse_neg
	li $t1, 1			#if there is a '-' sign, $t1 = 1
	add $a0, $a0, 1
	j _skip_set_t1_zero

	_skip_parse_neg:
	li $t1, 0
	_skip_set_t1_zero:
	move $t0, $a0
	li $t2, 1

	_count_number_pos:
	lb $v1, 0($t0)
	bgt $v1, 57, _begin_parse_int
	blt $v1, 48, _begin_parse_int
	add $t0, $t0, 1
	j _count_number_pos

	_begin_parse_int:
	sub $t0, $t0, 1

	_parsing_int:
	blt $t0, $a0, _finish_parse_int
	lb $v1, 0($t0)
	sub $v1, $v1, 48
	mul $v1, $v1, $t2
	add $v0, $v0, $v1
	mul $t2, $t2, 10
	sub $t0, $t0, 1
	j _parsing_int

	_finish_parse_int:
	beqz $t1, _skip_neg
	neg $v0, $v0
	_skip_neg:

	jr $ra

# string arg in $a0, pos in $a1
###### Checked ######
# used $v0, $v1
func__string.ord:
	add $v0, $v0, $a0
	lb $v0, 0($v0)
	jr $ra

# array arg in $a0
# used $v0
func__array.size:
	lw $v0, -4($v0)
	jr $ra

# string1 in $a0, string2 in $a1
###### Checked ######
# change(16/5/4): use less regs, you don't need to preserve reg before calling it
# used $v0, $v1
func__stringConcatenate:

	subu $sp, $sp, 24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $t0, 12($sp)
	sw $t1, 16($sp)
	sw $t2, 20($sp)

	lw $t0, -4($a0)		# $t0 is the length of lhs
	lw $t1, -4($a1)		# $t1 is the length of rhs
	add $t2, $t0, $t1

	move $t1, $a0

	add $a0, $t2, 5
	li $v0, 9
	syscall

	sw $t2, 0($v0)
	move $t2, $a1

	add $v0, $v0, 4
	move $v1, $v0

	move $a0, $t1
	move $a1, $v1
	jal _string_copy

	move $a0, $t2
	add $a1, $v1, $t0
	# add $a1, $a1, 1
	jal _string_copy

	move $v0, $v1
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $t0, 12($sp)
	lw $t1, 16($sp)
	lw $t2, 20($sp)
	addu $sp, $sp, 24
	jr $ra

# string1 in $a0, string2 in $a1
###### Checked ######
# change(16/5/4): use less regs, you don't need to preserve reg before calling it
# used $a0, $a1, $v0, $v1
func__stringIsEqual:
	# subu $sp, $sp, 8
	# sw $a0, 0($sp)
	# sw $a1, 4($sp)

	lw $v0, -4($a0)
	lw $v1, -4($a1)
	bne $v0, $v1, _not_equal

	_continue_compare_equal:
	lb $v0, 0($a0)
	lb $v1, 0($a1)
	beqz $v0, _equal
	bne $v0, $v1, _not_equal
	add $a0, $a0, 1
	add $a1, $a1, 1
	j _continue_compare_equal

	_not_equal:
	li $v0, 0
	j _compare_final

	_equal:
	li $v0, 1

	_compare_final:
	# lw $a0, 0($sp)
	# lw $a1, 4($sp)
	# addu $sp, $sp, 8
	jr $ra


# string1 in $a0, string2 in $a1
###### Checked ######
# change(16/5/4): use less regs, you don't need to preserve reg before calling it
# used $a0, $a1, $v0, $v1
func__stringLess:
	# subu $sp, $sp, 8
	# sw $a0, 0($sp)
	# sw $a1, 4($sp)

	_begin_compare_less:
	lb $v0, 0($a0)
	lb $v1, 0($a1)
	blt $v0, $v1, _less_correct
	bgt $v0, $v1, _less_false
	beqz $v0, _less_false
	add $a0, $a0, 1
	add $a1, $a1, 1
	j _begin_compare_less

	_less_correct:
	li $v0, 1
	j _less_compare_final

	_less_false:
	li $v0, 0

	_less_compare_final:

	# lw $a0, 0($sp)
	# lw $a1, 4($sp)
	# addu $sp, $sp, 8
	jr $ra

# string1 in $a0, string2 in $a1
# used $a0, $a1, $v0, $v1
func__stringLarge:
	subu $sp, $sp, 4
	sw $ra, 0($sp)

	jal func__stringLess

	xor $v0, $v0, 1

	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra

# string1 in $a0, string2 in $a1
# used $a0, $a1, $v0, $v1
func__stringLeq:
	subu $sp, $sp, 12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)

	jal func__stringLess

	bnez $v0, _skip_compare_equal_in_Leq

	lw $a0, 4($sp)
	lw $a1, 8($sp)
	jal func__stringIsEqual

	_skip_compare_equal_in_Leq:
	lw $ra, 0($sp)
	addu $sp, $sp, 12
	jr $ra

# string1 in $a0, string2 in $a1
# used $a0, $a1, $v0, $v1
func__stringGeq:
	subu $sp, $sp, 12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)

	jal func__stringLess

	beqz $v0, _skip_compare_equal_in_Geq

	lw $a0, 4($sp)
	lw $a1, 8($sp)
	jal func__stringIsEqual
	xor $v0, $v0, 1

	_skip_compare_equal_in_Geq:
	xor $v0, $v0, 1
	lw $ra, 0($sp)
	addu $sp, $sp, 12
	jr $ra

# string1 in $a0, string2 in $a1
# used $a0, $a1, $v0, $v1
func__stringNeq:
	subu $sp, $sp, 4
	sw $ra, 0($sp)

	jal func__stringIsEqual

	xor $v0, $v0, 1

	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra

main:
	sub $29 $29 8
	li $4 4
	li $2 9
	syscall
	li $4 36
	li $2 9
	syscall
	move $23 $2
	lw $24 16($23)
	la $30 16($23)
	li $24 48271
	sw $24 16($23)
	lw $25 20($23)
	la $30 20($23)
	li $25 2147483647
	sw $25 20($23)
	lw $12 32($23)
	la $30 32($23)
	li $12 1
	sw $12 32($23)
	jal main_0
	li $2 10
	syscall

main_0:
	move $31 $31
	sw $31 0($29)
	li $s0 0
	li $s1 0
	li $31 0
	sw $31 4($29)
	li $13 3
	mul $14 $13 7
	mul $15 $14 10
	lw $7 0($23)
	la $30 0($23)
	move $7 $15
	sw $7 0($23)
	lw $6 4($23)
	la $30 4($23)
	li $6 0
	sw $6 4($23)
	li $4 4
	li $2 9
	syscall
	li $4 100
	sw $4 0($2)
	mul $4 $4 8
	li $2 9
	syscall
	move $5 $2
	lw $24 12($23)
	la $30 12($23)
	move $24 $5
	sw $24 12($23)
	lw $25 20($23)
	lw $12 16($23)
	div $13 $25 $12
	lw $14 24($23)
	la $30 24($23)
	move $14 $13
	sw $14 24($23)
	lw $25 20($23)
	lw $12 16($23)
	rem $15 $25 $12
	lw $7 28($23)
	la $30 28($23)
	move $7 $15
	sw $7 28($23)
	lw $t1 0($23)
	move $4 $t1
	jal func__pd
	xor $6 $2 1
	bne $6 0 main_0_branch_then

main_0_branch_else:
	b main_1

main_0_branch_then:
	la $4 String0
	jal func__println
	li $2 1
	lw $3 0($29)
	move $31 $3
	add $29 $29 8
	jr $ra

main_1:
	la $4 String1
	jal func__println
	li $4 3654898
	jal func__initialize
	jal func__random
	rem $4 $2 10
	add $5 $4 1
	lw $24 8($23)
	la $30 8($23)
	move $24 $5
	sw $24 8($23)
	lw $t2 8($23)
	move $4 $t2
	jal func__toString
	move $4 $2
	jal func__println
	lw $t2 8($23)
	sub $13 $t2 1
	bge $s0 $13 main_2

main_1_loop:
	jal func__random
	rem $14 $2 10
	add $25 $14 1
	lw $t3 12($23)
	mul $12 $s0 4
	add $15 $t3 $12
	lw $7 0($15)
	la $30 0($15)
	move $7 $25
	sw $7 0($30)
	lw $t3 12($23)
	mul $6 $s0 4
	add $4 $t3 $6
	lw $5 0($4)
	la $30 0($4)
	add $24 $5 $s1
	lw $t1 0($23)
	ble $24 $t1 main_3

main_1_loop_loop:
	jal func__random
	rem $13 $2 10
	add $14 $13 1
	lw $t3 12($23)
	mul $12 $s0 4
	add $15 $t3 $12
	lw $25 0($15)
	la $30 0($15)
	move $25 $14
	sw $25 0($30)

main_1_loop_loopTail:
	lw $t3 12($23)
	mul $7 $s0 4
	add $6 $t3 $7
	lw $4 0($6)
	la $30 0($6)
	add $5 $4 $s1
	lw $t1 0($23)
	bgt $5 $t1 main_1_loop_loop

main_3:
	lw $t3 12($23)
	mul $24 $s0 4
	add $13 $t3 $24
	lw $12 0($13)
	la $30 0($13)
	add $15 $s1 $12
	move $s1 $15

main_1_loopTail:
	add $s0 $s0 1
	lw $t2 8($23)
	sub $14 $t2 1
	blt $s0 $14 main_1_loop

main_2:
	lw $t1 0($23)
	sub $25 $t1 $s1
	lw $t3 12($23)
	lw $t2 8($23)
	sub $7 $t2 1
	mul $6 $7 4
	add $4 $t3 $6
	lw $5 0($4)
	la $30 0($4)
	move $5 $25
	sw $5 0($30)
	jal func__show
	jal func__merge
	jal func__win
	xor $24 $2 1
	beq $24 0 main_4

main_2_loop:
	lw $3 4($29)
	add $31 $3 1
	sw $31 4($29)
	lw $3 4($29)
	move $4 $3
	jal func__toString
	la $4 String2
	move $5 $2
	jal func__stringConcatenate
	move $13 $2
	move $4 $13
	la $5 String3
	jal func__stringConcatenate
	move $12 $2
	move $4 $12
	jal func__println
	jal func__move
	jal func__merge
	jal func__show

main_2_loopTail:
	jal func__win
	xor $15 $2 1
	bne $15 0 main_2_loop

main_4:
	lw $3 4($29)
	move $4 $3
	jal func__toString
	la $4 String4
	move $5 $2
	jal func__stringConcatenate
	move $14 $2
	move $4 $14
	la $5 String5
	jal func__stringConcatenate
	move $7 $2
	move $4 $7
	jal func__println
	li $2 0
	lw $3 0($29)
	move $31 $3
	add $29 $29 8
	jr $ra
	lw $3 0($29)
	move $31 $3
	add $29 $29 8
	jr $ra

func__random:
	sub $29 $29 8
	move $31 $31
	sw $31 4($29)
	lw $24 16($23)
	lw $s2 32($23)
	lw $25 24($23)
	rem $9 $s2 $25
	mul $10 $24 $9
	lw $11 28($23)
	lw $s2 32($23)
	lw $25 24($23)
	div $12 $s2 $25
	mul $13 $11 $12
	sub $14 $10 $13
	move $31 $14
	sw $31 0($29)
	lw $3 0($29)
	bge $3 0 func__random_branch_then

func__random_branch_else:
	lw $15 20($23)
	lw $3 0($29)
	add $7 $3 $15
	lw $s2 32($23)
	la $30 32($23)
	move $s2 $7
	sw $s2 32($23)
	b func__random_0

func__random_branch_then:
	lw $6 32($23)
	la $30 32($23)
	lw $3 0($29)
	move $6 $3
	sw $6 32($23)

func__random_0:
	lw $4 32($23)
	move $2 $4
	lw $3 4($29)
	move $31 $3
	add $29 $29 8
	jr $ra
	lw $3 4($29)
	move $31 $3
	add $29 $29 8
	jr $ra

func__initialize:
	move $24 $31
	move $25 $4
	lw $9 32($23)
	la $30 32($23)
	move $9 $25
	sw $9 32($23)
	move $31 $24
	jr $ra

func__swap:
	move $24 $31
	move $25 $4
	move $10 $5
	lw $t1 12($23)
	mul $11 $25 4
	add $12 $t1 $11
	lw $13 0($12)
	la $30 0($12)
	move $14 $13
	lw $t1 12($23)
	mul $15 $10 4
	add $7 $t1 $15
	lw $6 0($7)
	la $30 0($7)
	lw $t1 12($23)
	mul $4 $25 4
	add $5 $t1 $4
	lw $11 0($5)
	la $30 0($5)
	move $11 $6
	sw $11 0($30)
	lw $t1 12($23)
	mul $12 $10 4
	add $13 $t1 $12
	lw $15 0($13)
	la $30 0($13)
	move $15 $14
	sw $15 0($30)
	move $31 $24
	jr $ra

func__pd:
	sub $29 $29 8
	move $31 $31
	sw $31 4($29)
	move $31 $4
	sw $31 0($29)
	lw $24 4($23)
	lw $2 0($29)
	bgt $24 $2 func__pd_0

func__pd_loop:
	lw $24 4($23)
	lw $24 4($23)
	add $25 $24 1
	mul $9 $24 $25
	div $10 $9 2
	lw $3 0($29)
	beq $3 $10 func__pd_loop_branch_then

func__pd_loop_branch_else:
	b func__pd_1

func__pd_loop_branch_then:
	li $2 1
	lw $3 4($29)
	move $31 $3
	add $29 $29 8
	jr $ra

func__pd_1:

func__pd_loopTail:
	lw $24 4($23)
	add $24 $24 1
	sw $24 4($23)
	lw $24 4($23)
	lw $2 0($29)
	ble $24 $2 func__pd_loop

func__pd_0:
	li $2 0
	lw $3 4($29)
	move $31 $3
	add $29 $29 8
	jr $ra
	lw $3 4($29)
	move $31 $3
	add $29 $29 8
	jr $ra

func__show:
	sub $29 $29 4
	move $31 $31
	sw $31 0($29)
	li $s3 0
	lw $t1 8($23)
	bge $s3 $t1 func__show_0

func__show_loop:
	lw $t2 12($23)
	mul $24 $s3 4
	add $25 $t2 $24
	lw $11 0($25)
	la $30 0($25)
	move $4 $11
	jal func__toString
	move $4 $2
	la $5 String6
	jal func__stringConcatenate
	move $12 $2
	move $4 $12
	jal func__print

func__show_loopTail:
	add $s3 $s3 1
	lw $t1 8($23)
	blt $s3 $t1 func__show_loop

func__show_0:
	la $4 String7
	jal func__println
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra

func__win:
	sub $29 $29 4
	move $31 $31
	sw $31 0($29)
	li $4 4
	li $2 9
	syscall
	li $24 100
	sw $24 0($2)
	mul $4 $24 8
	li $2 9
	syscall
	move $25 $2
	move $t4 $25
	lw $t1 8($23)
	lw $14 4($23)
	bne $t1 $14 func__win_branch_then

func__win_branch_else:
	b func__win_0

func__win_branch_then:
	li $2 0
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra

func__win_0:
	li $t2 0
	lw $t1 8($23)
	bge $t2 $t1 func__win_1

func__win_0_loop:
	lw $t3 12($23)
	mul $15 $t2 4
	add $7 $t3 $15
	lw $6 0($7)
	la $30 0($7)
	mul $4 $t2 4
	add $5 $t4 $4
	lw $24 0($5)
	la $30 0($5)
	move $24 $6
	sw $24 0($30)

func__win_0_loopTail:
	add $t2 $t2 1
	lw $t1 8($23)
	blt $t2 $t1 func__win_0_loop

func__win_1:
	li $t5 0
	lw $t1 8($23)
	sub $25 $t1 1
	bge $t5 $25 func__win_2

func__win_1_loop:
	add $14 $t5 1
	move $t2 $14
	lw $t1 8($23)
	bge $t2 $t1 func__win_3

func__win_1_loop_loop:
	mul $15 $t5 4
	add $7 $t4 $15
	lw $4 0($7)
	la $30 0($7)
	mul $5 $t2 4
	add $6 $t4 $5
	lw $24 0($6)
	la $30 0($6)
	bgt $4 $24 func__win_1_loop_loop_branch_then

func__win_1_loop_loop_branch_else:
	b func__win_4

func__win_1_loop_loop_branch_then:
	mul $25 $t5 4
	add $14 $t4 $25
	lw $15 0($14)
	la $30 0($14)
	move $7 $15
	mul $5 $t2 4
	add $6 $t4 $5
	lw $4 0($6)
	la $30 0($6)
	mul $24 $t5 4
	add $25 $t4 $24
	lw $14 0($25)
	la $30 0($25)
	move $14 $4
	sw $14 0($30)
	mul $15 $t2 4
	add $5 $t4 $15
	lw $6 0($5)
	la $30 0($5)
	move $6 $7
	sw $6 0($30)

func__win_4:

func__win_1_loop_loopTail:
	add $t2 $t2 1
	lw $t1 8($23)
	blt $t2 $t1 func__win_1_loop_loop

func__win_3:

func__win_1_loopTail:
	add $t5 $t5 1
	lw $t1 8($23)
	sub $24 $t1 1
	blt $t5 $24 func__win_1_loop

func__win_2:
	li $t5 0
	lw $t1 8($23)
	bge $t5 $t1 func__win_5

func__win_2_loop:
	mul $25 $t5 4
	add $4 $t4 $25
	lw $14 0($4)
	la $30 0($4)
	add $15 $t5 1
	bne $14 $15 func__win_2_loop_branch_then

func__win_2_loop_branch_else:
	b func__win_6

func__win_2_loop_branch_then:
	li $2 0
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra

func__win_6:

func__win_2_loopTail:
	add $t5 $t5 1
	lw $t1 8($23)
	blt $t5 $t1 func__win_2_loop

func__win_5:
	li $2 1
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra

func__merge:
	sub $29 $29 4
	move $31 $31
	sw $31 0($29)
	li $s4 0
	lw $t1 8($23)
	bge $s4 $t1 func__merge_0

func__merge_loop:
	lw $t2 12($23)
	mul $24 $s4 4
	add $25 $t2 $24
	lw $12 0($25)
	la $30 0($25)
	beq $12 0 func__merge_loop_branch_then

func__merge_loop_branch_else:
	b func__merge_1

func__merge_loop_branch_then:
	add $13 $s4 1
	move $s5 $13
	lw $t1 8($23)
	bge $s5 $t1 func__merge_2

func__merge_loop_branch_then_loop:
	lw $t2 12($23)
	mul $14 $s5 4
	add $15 $t2 $14
	lw $7 0($15)
	la $30 0($15)
	bne $7 0 func__merge_loop_branch_then_loop_branch_then

func__merge_loop_branch_then_loop_branch_else:
	b func__merge_3

func__merge_loop_branch_then_loop_branch_then:
	move $4 $s4
	move $5 $s5
	jal func__swap
	b func__merge_2

func__merge_3:

func__merge_loop_branch_then_loopTail:
	add $s5 $s5 1
	lw $t1 8($23)
	blt $s5 $t1 func__merge_loop_branch_then_loop

func__merge_2:

func__merge_1:

func__merge_loopTail:
	add $s4 $s4 1
	lw $t1 8($23)
	blt $s4 $t1 func__merge_loop

func__merge_0:
	li $s4 0
	lw $t1 8($23)
	bge $s4 $t1 func__merge_4

func__merge_0_loop:
	lw $t2 12($23)
	mul $6 $s4 4
	add $4 $t2 $6
	lw $5 0($4)
	la $30 0($4)
	beq $5 0 func__merge_0_loop_branch_then

func__merge_0_loop_branch_else:
	b func__merge_5

func__merge_0_loop_branch_then:
	lw $t1 8($23)
	la $30 8($23)
	move $t1 $s4
	sw $t1 8($23)
	b func__merge_0

func__merge_5:

func__merge_0_loopTail:
	add $s4 $s4 1
	lw $t3 8($23)
	blt $s4 $t3 func__merge_0_loop

func__merge_4:
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra

func__move:
	sub $29 $29 4
	move $31 $31
	sw $31 0($29)
	li $s6 0
	lw $t1 8($23)
	bge $s6 $t1 func__move_0

func__move_loop:
	lw $t2 12($23)
	mul $24 $s6 4
	add $25 $t2 $24
	lw $11 0($25)
	la $30 0($25)
	sub $11 $11 1
	sw $11 0($30)
	add $12 $s6 1
	move $s6 $12

func__move_loopTail:
	lw $t1 8($23)
	blt $s6 $t1 func__move_loop

func__move_0:
	lw $t1 8($23)
	lw $t2 12($23)
	lw $t1 8($23)
	mul $13 $t1 4
	add $14 $t2 $13
	lw $15 0($14)
	la $30 0($14)
	move $15 $t1
	sw $15 0($30)
	lw $t1 8($23)
	add $t1 $t1 1
	sw $t1 8($23)
	lw $3 0($29)
	move $31 $3
	add $29 $29 4
	jr $ra

