.data

_end: .asciiz "\n"
	.align 2
_buffer: .space 256
	.align 2
VReg: .space 3600
	length0: 	.word 	1
	String0: 	.asciiz 	" "
	length1: 	.word 	1
	String1: 	.asciiz 	" "


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
	li $4 12
	li $2 9
	syscall
	move $23 $2
	lw $24 0($23)
	la $30 0($23)
	li $24 1
	sw $24 0($23)
	lw $24 4($23)
	la $30 4($23)
	li $24 1
	sw $24 4($23)
	lw $24 8($23)
	la $30 8($23)
	li $24 1
	sw $24 8($23)
	jal main_0
	li $2 10
	syscall

main_0:
	move $s2 $31
	lw $t1 8($23)
	li $24 1
	sll $24 $24 29
	slt $24 $t1 $24
	lw $t1 8($23)
	li $25 1
	sll $25 $25 29
	neg $25 $25
	sgt $25 $t1 $25
	and $25 $24 $25
	beq $25 0 main_1

main_0_loop:
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	sub $14 $25 $14
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $25 $15
	add $15 $14 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	sub $25 $14 $25
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	add $14 $25 $14
	add $14 $15 $14
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $15 $25
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $25 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $25 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $16 $25
	add $25 $15 $25
	sub $25 $14 $25
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $15 $t1 $24
	lw $13 4($23)
	add $15 $15 $13
	add $15 $14 $15
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $14 $16
	sub $16 $15 $16
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	add $14 $15 $14
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $14 $15
	sub $15 $16 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	sub $14 $16 $14
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $14 $16
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $4 $t1 $24
	lw $13 4($23)
	add $4 $4 $13
	add $4 $14 $4
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	sub $14 $4 $14
	sub $14 $16 $14
	add $14 $15 $14
	sub $14 $25 $14
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $25 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $25 $16
	add $16 $15 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $15 $t1 $24
	lw $13 4($23)
	add $15 $15 $13
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	sub $25 $15 $25
	lw $t1 8($23)
	lw $24 0($23)
	sub $15 $t1 $24
	lw $13 4($23)
	add $15 $15 $13
	add $15 $25 $15
	add $15 $16 $15
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $16 $25
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $25 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $4 $24 $13
	sub $4 $25 $4
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $4 $25
	add $25 $16 $25
	sub $25 $15 $25
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $15 $16
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $16 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	lw $24 0($23)
	lw $13 4($23)
	add $4 $24 $13
	sub $4 $16 $4
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $4 $16
	add $16 $15 $16
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $4 $t1 $24
	lw $13 4($23)
	add $4 $4 $13
	add $4 $15 $4
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $4 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $4 $t1 $24
	lw $13 4($23)
	add $4 $4 $13
	lw $24 0($23)
	lw $13 4($23)
	add $5 $24 $13
	sub $5 $4 $5
	lw $t1 8($23)
	lw $24 0($23)
	sub $4 $t1 $24
	lw $13 4($23)
	add $4 $4 $13
	add $4 $5 $4
	add $4 $15 $4
	sub $4 $16 $4
	sub $4 $25 $4
	add $4 $14 $4
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $14 $25
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $14 $16
	sub $16 $25 $16
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	add $14 $25 $14
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	sub $25 $14 $25
	sub $25 $16 $25
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	sub $14 $16 $14
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $14 $16
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $15 $t1 $24
	lw $13 4($23)
	add $15 $15 $13
	add $15 $14 $15
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	sub $14 $15 $14
	sub $14 $16 $14
	add $14 $25 $14
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $25 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $16 $25
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $15 $t1 $24
	lw $13 4($23)
	add $15 $15 $13
	add $15 $16 $15
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $15 $16
	sub $16 $25 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $25 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $15 $25
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $5 $t1 $24
	lw $13 4($23)
	add $5 $5 $13
	add $5 $15 $5
	lw $24 0($23)
	lw $13 4($23)
	add $15 $24 $13
	sub $15 $5 $15
	sub $15 $25 $15
	add $15 $16 $15
	add $15 $14 $15
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $14 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	sub $25 $14 $25
	add $25 $16 $25
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	lw $24 0($23)
	lw $13 4($23)
	add $14 $24 $13
	sub $14 $16 $14
	lw $t1 8($23)
	lw $24 0($23)
	sub $16 $t1 $24
	lw $13 4($23)
	add $16 $16 $13
	add $16 $14 $16
	add $16 $25 $16
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	add $14 $25 $14
	lw $24 0($23)
	lw $13 4($23)
	add $25 $24 $13
	sub $25 $14 $25
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	lw $24 0($23)
	lw $13 4($23)
	add $5 $24 $13
	sub $5 $14 $5
	lw $t1 8($23)
	lw $24 0($23)
	sub $14 $t1 $24
	lw $13 4($23)
	add $14 $14 $13
	add $14 $5 $14
	add $14 $25 $14
	sub $14 $16 $14
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $16 $25
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $25 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	lw $24 0($23)
	lw $13 4($23)
	add $5 $24 $13
	sub $5 $25 $5
	lw $t1 8($23)
	lw $24 0($23)
	sub $25 $t1 $24
	lw $13 4($23)
	add $25 $25 $13
	add $25 $5 $25
	add $25 $16 $25
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	lw $t1 8($23)
	lw $24 0($23)
	sub $5 $t1 $24
	lw $13 4($23)
	add $5 $5 $13
	add $5 $16 $5
	lw $24 0($23)
	lw $13 4($23)
	add $16 $24 $13
	sub $16 $5 $16
	lw $t1 8($23)
	lw $24 0($23)
	sub $5 $t1 $24
	lw $13 4($23)
	add $5 $5 $13
	lw $24 0($23)
	lw $13 4($23)
	add $6 $24 $13
	sub $6 $5 $6
	lw $t1 8($23)
	lw $24 0($23)
	sub $5 $t1 $24
	lw $13 4($23)
	add $5 $5 $13
	add $5 $6 $5
	add $5 $16 $5
	sub $5 $25 $5
	sub $5 $14 $5
	add $5 $15 $5
	sub $5 $4 $5
	lw $24 0($23)
	la $30 0($23)
	move $24 $5
	sw $24 0($23)
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	sub $5 $24 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $24 $4
	add $4 $5 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	sub $24 $5 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	add $5 $24 $5
	add $5 $4 $5
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $4 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $24 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $24 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $15 $24
	add $24 $4 $24
	sub $24 $5 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $13 4($23)
	add $4 $4 $13
	add $4 $5 $4
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $5 $15
	sub $15 $4 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	add $5 $4 $5
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $5 $4
	sub $4 $15 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	sub $5 $15 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $5 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $13 4($23)
	add $14 $14 $13
	add $14 $5 $14
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	sub $5 $14 $5
	sub $5 $15 $5
	add $5 $4 $5
	sub $5 $24 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $24 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $24 $15
	add $15 $4 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $13 4($23)
	add $4 $4 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	sub $24 $4 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $13 4($23)
	add $4 $4 $13
	add $4 $24 $4
	add $4 $15 $4
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $15 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $24 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $14 $t2 $13
	sub $14 $24 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $14 $24
	add $24 $15 $24
	sub $24 $4 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $4 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $15 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $14 $t2 $13
	sub $14 $15 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $14 $15
	add $15 $4 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $13 4($23)
	add $14 $14 $13
	add $14 $4 $14
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $14 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $13 4($23)
	add $14 $14 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $25 $t2 $13
	sub $25 $14 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $13 4($23)
	add $14 $14 $13
	add $14 $25 $14
	add $14 $4 $14
	sub $14 $15 $14
	sub $14 $24 $14
	add $14 $5 $14
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $5 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $5 $15
	sub $15 $24 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	add $5 $24 $5
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	sub $24 $5 $24
	sub $24 $15 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	sub $5 $15 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $5 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $13 4($23)
	add $4 $4 $13
	add $4 $5 $4
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	sub $5 $4 $5
	sub $5 $15 $5
	add $5 $24 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $24 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $15 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $13 4($23)
	add $4 $4 $13
	add $4 $15 $4
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $4 $15
	sub $15 $24 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $24 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $4 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $13 4($23)
	add $25 $25 $13
	add $25 $4 $25
	lw $t2 0($23)
	lw $13 4($23)
	add $4 $t2 $13
	sub $4 $25 $4
	sub $4 $24 $4
	add $4 $15 $4
	add $4 $5 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $5 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	sub $24 $5 $24
	add $24 $15 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $5 $t2 $13
	sub $5 $15 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $15 $t1 $t2
	lw $13 4($23)
	add $15 $15 $13
	add $15 $5 $15
	add $15 $24 $15
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	add $5 $24 $5
	lw $t2 0($23)
	lw $13 4($23)
	add $24 $t2 $13
	sub $24 $5 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $25 $t2 $13
	sub $25 $5 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $13 4($23)
	add $5 $5 $13
	add $5 $25 $5
	add $5 $24 $5
	sub $5 $15 $5
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $15 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $24 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $25 $t2 $13
	sub $25 $24 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $13 4($23)
	add $24 $24 $13
	add $24 $25 $24
	add $24 $15 $24
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $13 4($23)
	add $25 $25 $13
	add $25 $15 $25
	lw $t2 0($23)
	lw $13 4($23)
	add $15 $t2 $13
	sub $15 $25 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $13 4($23)
	add $25 $25 $13
	lw $t2 0($23)
	lw $13 4($23)
	add $16 $t2 $13
	sub $16 $25 $16
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $13 4($23)
	add $25 $25 $13
	add $25 $16 $25
	add $25 $15 $25
	sub $25 $24 $25
	sub $25 $5 $25
	add $25 $4 $25
	sub $25 $14 $25
	lw $13 4($23)
	la $30 4($23)
	move $13 $25
	sw $13 4($23)
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	sub $25 $13 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $13 $14
	add $14 $25 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	sub $13 $25 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	add $25 $13 $25
	add $25 $14 $25
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $14 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $13 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $13 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $4 $13
	add $13 $14 $13
	sub $13 $25 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $t3 4($23)
	add $14 $14 $t3
	add $14 $25 $14
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $25 $4
	sub $4 $14 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	add $25 $14 $25
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $25 $14
	sub $14 $4 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	sub $25 $4 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $25 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $t3 4($23)
	add $5 $5 $t3
	add $5 $25 $5
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	sub $25 $5 $25
	sub $25 $4 $25
	add $25 $14 $25
	sub $25 $13 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $13 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $13 $4
	add $4 $14 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $t3 4($23)
	add $14 $14 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	sub $13 $14 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $t3 4($23)
	add $14 $14 $t3
	add $14 $13 $14
	add $14 $4 $14
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $4 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $13 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $5 $t2 $t3
	sub $5 $13 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $5 $13
	add $13 $4 $13
	sub $13 $14 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $14 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $4 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $5 $t2 $t3
	sub $5 $4 $5
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $5 $4
	add $4 $14 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $t3 4($23)
	add $5 $5 $t3
	add $5 $14 $5
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $5 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $t3 4($23)
	add $5 $5 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $24 $t2 $t3
	sub $24 $5 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $5 $t1 $t2
	lw $t3 4($23)
	add $5 $5 $t3
	add $5 $24 $5
	add $5 $14 $5
	sub $5 $4 $5
	sub $5 $13 $5
	add $5 $25 $5
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $25 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $25 $4
	sub $4 $13 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	add $25 $13 $25
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	sub $13 $25 $13
	sub $13 $4 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	sub $25 $4 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $25 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $t3 4($23)
	add $14 $14 $t3
	add $14 $25 $14
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	sub $25 $14 $25
	sub $25 $4 $25
	add $25 $13 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $13 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $4 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $14 $t1 $t2
	lw $t3 4($23)
	add $14 $14 $t3
	add $14 $4 $14
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $14 $4
	sub $4 $13 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $13 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $14 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $t3 4($23)
	add $24 $24 $t3
	add $24 $14 $24
	lw $t2 0($23)
	lw $t3 4($23)
	add $14 $t2 $t3
	sub $14 $24 $14
	sub $14 $13 $14
	add $14 $4 $14
	add $14 $25 $14
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $25 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	sub $13 $25 $13
	add $13 $4 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $25 $t2 $t3
	sub $25 $4 $25
	lw $t1 8($23)
	lw $t2 0($23)
	sub $4 $t1 $t2
	lw $t3 4($23)
	add $4 $4 $t3
	add $4 $25 $4
	add $4 $13 $4
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	add $25 $13 $25
	lw $t2 0($23)
	lw $t3 4($23)
	add $13 $t2 $t3
	sub $13 $25 $13
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $24 $t2 $t3
	sub $24 $25 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $25 $t1 $t2
	lw $t3 4($23)
	add $25 $25 $t3
	add $25 $24 $25
	add $25 $13 $25
	sub $25 $4 $25
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $4 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $13 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $24 $t2 $t3
	sub $24 $13 $24
	lw $t1 8($23)
	lw $t2 0($23)
	sub $13 $t1 $t2
	lw $t3 4($23)
	add $13 $13 $t3
	add $13 $24 $13
	add $13 $4 $13
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $t3 4($23)
	add $24 $24 $t3
	add $24 $4 $24
	lw $t2 0($23)
	lw $t3 4($23)
	add $4 $t2 $t3
	sub $4 $24 $4
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $t3 4($23)
	add $24 $24 $t3
	lw $t2 0($23)
	lw $t3 4($23)
	add $15 $t2 $t3
	sub $15 $24 $15
	lw $t1 8($23)
	lw $t2 0($23)
	sub $24 $t1 $t2
	lw $t3 4($23)
	add $24 $24 $t3
	add $24 $15 $24
	add $24 $4 $24
	sub $24 $13 $24
	sub $24 $25 $24
	add $24 $14 $24
	sub $24 $5 $24
	lw $t1 8($23)
	la $30 8($23)
	move $t1 $24
	sw $t1 8($23)

main_0_loopTail:
	lw $t4 8($23)
	li $24 1
	sll $24 $24 29
	slt $24 $t4 $24
	lw $t4 8($23)
	li $25 1
	sll $25 $25 29
	neg $25 $25
	sgt $25 $t4 $25
	and $25 $24 $25
	bne $25 0 main_0_loop

main_1:
	lw $t2 0($23)
	move $4 $t2
	jal func__toString
	move $4 $2
	la $5 String0
	jal func__stringConcatenate
	move $s0 $2
	lw $t3 4($23)
	move $4 $t3
	jal func__toString
	move $4 $s0
	move $5 $2
	jal func__stringConcatenate
	move $24 $2
	move $4 $24
	la $5 String1
	jal func__stringConcatenate
	move $s1 $2
	lw $t4 8($23)
	move $4 $t4
	jal func__toString
	move $4 $s1
	move $5 $2
	jal func__stringConcatenate
	move $24 $2
	move $4 $24
	jal func__println
	li $2 0
	move $31 $s2
	jr $ra
	move $31 $s2
	jr $ra

