.data

_end: .asciiz "\n"
	.align 2
_buffer: .space 256
	.align 2
VReg: .space 3600
	length0: 	.word 	13
	String0: 	.asciiz 	"no solution!\n"


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
	li $4 4
	li $2 9
	syscall
	li $4 64
	li $2 9
	syscall
	move $23 $2
	li $4 4
	li $2 9
	syscall
	li $24 12000
	sw $24 0($2)
	mul $4 $24 8
	li $2 9
	syscall
	move $25 $2
	lw $10 32($23)
	la $30 32($23)
	move $10 $25
	sw $10 32($23)
	li $4 4
	li $2 9
	syscall
	li $11 12000
	sw $11 0($2)
	mul $4 $11 8
	li $2 9
	syscall
	move $12 $2
	lw $13 36($23)
	la $30 36($23)
	move $13 $12
	sw $13 36($23)
	jal main_0
	li $2 10
	syscall

main_0:
	move $s0 $31
	li $4 106
	jal func__origin
	jal func__getInt
	lw $14 0($23)
	la $30 0($23)
	move $14 $2
	sw $14 0($23)
	lw $15 0($23)
	sub $7 $15 1
	lw $6 20($23)
	la $30 20($23)
	move $6 $7
	sw $6 20($23)
	lw $4 16($23)
	la $30 16($23)
	move $4 $6
	sw $4 16($23)
	lw $5 56($23)
	la $30 56($23)
	li $5 0
	sw $5 56($23)
	lw $20 56($23)
	lw $15 0($23)
	bge $20 $15 main_0_next

main_0_loop:
	lw $21 60($23)
	la $30 60($23)
	li $21 0
	sw $21 60($23)
	lw $22 60($23)
	lw $15 0($23)
	bge $22 $15 main_0_loop_next

main_0_loop_loop:
	li $24 1
	neg $25 $24
	lw $10 52($23)
	lw $20 56($23)
	mul $11 $20 4
	add $12 $10 $11
	lw $13 0($12)
	lw $22 60($23)
	mul $14 $22 4
	add $7 $13 $14
	lw $6 0($7)
	la $30 0($7)
	move $6 $25
	sw $6 0($30)

main_0_loop_loopTail:
	lw $22 60($23)
	add $22 $22 1
	sw $22 60($23)
	lw $22 60($23)
	lw $15 0($23)
	blt $22 $15 main_0_loop_loop

main_0_loop_next:

main_0_loopTail:
	lw $20 56($23)
	add $20 $20 1
	sw $20 56($23)
	lw $20 56($23)
	lw $15 0($23)
	blt $20 $15 main_0_loop

main_0_next:
	lw $t1 4($23)
	lw $4 40($23)
	bgt $t1 $4 main_0_next_next

main_0_next_loop:
	lw $5 32($23)
	lw $t1 4($23)
	mul $21 $t1 4
	add $24 $5 $21
	lw $11 0($24)
	la $30 0($24)
	lw $12 24($23)
	la $30 24($23)
	move $12 $11
	sw $12 24($23)
	lw $13 36($23)
	lw $t1 4($23)
	mul $14 $t1 4
	add $7 $13 $14
	lw $25 0($7)
	la $30 0($7)
	lw $6 28($23)
	la $30 28($23)
	move $6 $25
	sw $6 28($23)
	lw $10 52($23)
	lw $22 24($23)
	mul $20 $22 4
	add $15 $10 $20
	lw $5 0($15)
	lw $21 28($23)
	mul $24 $21 4
	add $11 $5 $24
	lw $12 0($11)
	la $30 0($11)
	lw $13 48($23)
	la $30 48($23)
	move $13 $12
	sw $13 48($23)
	lw $22 24($23)
	sub $14 $22 1
	move $4 $14
	lw $21 28($23)
	sub $7 $21 2
	move $5 $7
	jal func__addList
	lw $22 24($23)
	sub $25 $22 1
	move $4 $25
	lw $21 28($23)
	add $6 $21 2
	move $5 $6
	jal func__addList
	lw $22 24($23)
	add $20 $22 1
	move $4 $20
	lw $21 28($23)
	sub $15 $21 2
	move $5 $15
	jal func__addList
	lw $22 24($23)
	add $5 $22 1
	move $4 $5
	lw $21 28($23)
	add $24 $21 2
	move $5 $24
	jal func__addList
	lw $22 24($23)
	sub $11 $22 2
	move $4 $11
	lw $21 28($23)
	sub $12 $21 1
	move $5 $12
	jal func__addList
	lw $22 24($23)
	sub $13 $22 2
	move $4 $13
	lw $21 28($23)
	add $14 $21 1
	move $5 $14
	jal func__addList
	lw $22 24($23)
	add $7 $22 2
	move $4 $7
	lw $21 28($23)
	sub $25 $21 1
	move $5 $25
	jal func__addList
	lw $22 24($23)
	add $6 $22 2
	move $4 $6
	lw $21 28($23)
	add $20 $21 1
	move $5 $20
	jal func__addList
	lw $15 44($23)
	beq $15 1 main_0_next_loop_branch_then

main_0_next_loop_branch_else:
	b main_0_next_loop_next

main_0_next_loop_branch_then:
	b main_0_next_next

main_0_next_loop_next:
	lw $t1 4($23)
	add $5 $t1 1
	lw $t1 4($23)
	la $30 4($23)
	move $t1 $5
	sw $t1 4($23)

main_0_next_loopTail:
	lw $24 4($23)
	lw $4 40($23)
	ble $24 $4 main_0_next_loop

main_0_next_next:
	lw $15 44($23)
	beq $15 1 main_0_next_next_branch_then

main_0_next_next_branch_else:
	la $4 String0
	jal func__print
	b main_0_next_next_next

main_0_next_next_branch_then:
	lw $10 52($23)
	lw $11 16($23)
	mul $12 $11 4
	add $13 $10 $12
	lw $14 0($13)
	lw $7 20($23)
	mul $25 $7 4
	add $22 $14 $25
	lw $6 0($22)
	la $30 0($22)
	move $4 $6
	jal func__toString
	move $4 $2
	jal func__println

main_0_next_next_next:
	li $2 0
	move $31 $s0
	jr $ra
	move $31 $s0
	jr $ra

func__origin:
	move $t5 $31
	move $t1 $4
	li $4 4
	li $2 9
	syscall
	sw $t1 0($2)
	mul $4 $t1 8
	li $2 9
	syscall
	move $24 $2
	lw $25 52($23)
	la $30 52($23)
	move $25 $24
	sw $25 52($23)
	lw $14 56($23)
	la $30 56($23)
	li $14 0
	sw $14 56($23)
	lw $t2 56($23)
	bge $t2 $t1 func__origin_next

func__origin_loop:
	li $4 4
	li $2 9
	syscall
	sw $t1 0($2)
	mul $4 $t1 8
	li $2 9
	syscall
	move $15 $2
	lw $t3 52($23)
	lw $t2 56($23)
	mul $7 $t2 4
	add $6 $t3 $7
	lw $4 0($6)
	la $30 0($6)
	move $4 $15
	sw $4 0($30)
	lw $5 60($23)
	la $30 60($23)
	li $5 0
	sw $5 60($23)
	lw $t4 60($23)
	bge $t4 $t1 func__origin_loop_next

func__origin_loop_loop:
	lw $t3 52($23)
	lw $t2 56($23)
	mul $20 $t2 4
	add $21 $t3 $20
	lw $22 0($21)
	lw $t4 60($23)
	mul $24 $t4 4
	add $25 $22 $24
	lw $14 0($25)
	la $30 0($25)
	li $14 0
	sw $14 0($30)

func__origin_loop_loopTail:
	lw $t4 60($23)
	add $t4 $t4 1
	sw $t4 60($23)
	lw $t4 60($23)
	blt $t4 $t1 func__origin_loop_loop

func__origin_loop_next:

func__origin_loopTail:
	lw $t2 56($23)
	add $t2 $t2 1
	sw $t2 56($23)
	lw $t2 56($23)
	blt $t2 $t1 func__origin_loop

func__origin_next:
	move $31 $t5
	jr $ra

func__check:
	move $24 $31
	move $25 $4
	move $9 $5
	slt $10 $25 $9
	sge $11 $25 0
	and $12 $10 $11
	move $2 $12
	move $31 $24
	jr $ra
	move $31 $24
	jr $ra

func__addList:
	move $s3 $31
	move $s1 $4
	move $s2 $5
	move $4 $s1
	lw $24 0($23)
	move $5 $24
	jal func__check
	move $4 $s2
	lw $24 0($23)
	move $5 $24
	jal func__check
	and $25 $2 $2
	lw $t1 52($23)
	mul $10 $s1 4
	add $11 $t1 $10
	lw $12 0($11)
	mul $13 $s2 4
	add $14 $12 $13
	lw $15 0($14)
	la $30 0($14)
	li $7 1
	neg $6 $7
	seq $4 $15 $6
	and $5 $25 $4
	bne $5 0 func__addList_branch_then

func__addList_branch_else:
	b func__addList_next

func__addList_branch_then:
	lw $20 40($23)
	add $21 $20 1
	lw $20 40($23)
	la $30 40($23)
	move $20 $21
	sw $20 40($23)
	lw $22 32($23)
	lw $24 40($23)
	mul $10 $24 4
	add $11 $22 $10
	lw $12 0($11)
	la $30 0($11)
	move $12 $s1
	sw $12 0($30)
	lw $13 36($23)
	lw $24 40($23)
	mul $14 $24 4
	add $7 $13 $14
	lw $15 0($7)
	la $30 0($7)
	move $15 $s2
	sw $15 0($30)
	lw $6 48($23)
	add $25 $6 1
	lw $t1 52($23)
	mul $4 $s1 4
	add $5 $t1 $4
	lw $21 0($5)
	mul $20 $s2 4
	add $22 $21 $20
	lw $10 0($22)
	la $30 0($22)
	move $10 $25
	sw $10 0($30)
	lw $11 16($23)
	seq $12 $s1 $11
	lw $24 20($23)
	seq $13 $s2 $24
	and $14 $12 $13
	bne $14 0 func__addList_branch_then_branch_then

func__addList_branch_then_branch_else:
	b func__addList_branch_then_next

func__addList_branch_then_branch_then:
	lw $7 44($23)
	la $30 44($23)
	li $7 1
	sw $7 44($23)

func__addList_branch_then_next:

func__addList_next:
	move $31 $s3
	jr $ra

