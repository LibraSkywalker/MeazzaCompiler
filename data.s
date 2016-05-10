.data

_end: .asciiz "\n"
	.align 2
_buffer: .space 256
	.align 2
VReg: .space 3600


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
	li $4 24
	li $2 9
	syscall
	move $23 $2
	li $s0 99
	li $s1 100
	li $s2 101
	li $s3 102
	li $s5 0
	jal main_0
	li $2 10
	syscall

main_0:
	move $s6 $31
	jal func__getInt
	move $t2 $2
	li $t1 1
	bgt $t1 $t2 main_0_afterLoop

main_0_loop:
	li $t3 1
	bgt $t3 $t2 main_0_loop_afterLoop

main_0_loop_loop:
	li $t4 1
	bgt $t4 $t2 main_0_loop_loop_afterLoop

main_0_loop_loop_loop:
	li $t5 1
	bgt $t5 $t2 main_0_loop_loop_loop_afterLoop

main_0_loop_loop_loop_loop:
	li $t6 1
	bgt $t6 $t2 main_0_loop_loop_loop_loop_afterLoop

main_0_loop_loop_loop_loop_loop:
	li $t7 1
	bgt $t7 $t2 main_0_loop_loop_loop_loop_loop_afterLoop

main_0_loop_loop_loop_loop_loop_loop:
	beq $t1 $t3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal:
	beq $t1 $t4 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal:
	beq $t1 $t5 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal:
	beq $t1 $t6 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal:
	beq $t1 $t7 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal:
	beq $t1 $s0 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal:
	beq $t1 $s1 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal:
	beq $t1 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t1 $s3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $t4 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $t5 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $t6 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $t7 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $s0 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $s1 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t3 $s3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $t5 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $t6 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $t7 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $s0 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $s1 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t4 $s3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t5 $t6 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t5 $t7 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t5 $s0 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t5 $s1 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t5 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t5 $s3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t6 $t7 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t6 $s0 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t6 $s1 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t6 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t6 $s3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t7 $s0 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t7 $s1 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t7 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $t7 $s3 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $s1 $s2 main_0_loop_loop_loop_loop_loop_loop_shortcut

main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	bne $s0 $s3 main_0_loop_loop_loop_loop_loop_loop_normalEnd

main_0_loop_loop_loop_loop_loop_loop_shortcut:
	li $s4 0
	b main_0_loop_loop_loop_loop_loop_loop_next

main_0_loop_loop_loop_loop_loop_loop_normalEnd:
	li $s4 1

main_0_loop_loop_loop_loop_loop_loop_next:
	bne $s4 0 main_0_loop_loop_loop_loop_loop_loop_next_branch_then

main_0_loop_loop_loop_loop_loop_loop_next_branch_else:
	b main_0_loop_loop_loop_loop_loop_loop_next_afterBranch

main_0_loop_loop_loop_loop_loop_loop_next_branch_then:
	add $s5 $s5 1

main_0_loop_loop_loop_loop_loop_loop_next_afterBranch:

main_0_loop_loop_loop_loop_loop_loopTail:
	add $t7 $t7 1
	ble $t7 $t2 main_0_loop_loop_loop_loop_loop_loop

main_0_loop_loop_loop_loop_loop_afterLoop:

main_0_loop_loop_loop_loop_loopTail:
	add $t6 $t6 1
	ble $t6 $t2 main_0_loop_loop_loop_loop_loop

main_0_loop_loop_loop_loop_afterLoop:

main_0_loop_loop_loop_loopTail:
	add $t5 $t5 1
	ble $t5 $t2 main_0_loop_loop_loop_loop

main_0_loop_loop_loop_afterLoop:

main_0_loop_loop_loopTail:
	add $t4 $t4 1
	ble $t4 $t2 main_0_loop_loop_loop

main_0_loop_loop_afterLoop:

main_0_loop_loopTail:
	add $t3 $t3 1
	ble $t3 $t2 main_0_loop_loop

main_0_loop_afterLoop:

main_0_loopTail:
	add $t1 $t1 1
	ble $t1 $t2 main_0_loop

main_0_afterLoop:
	move $4 $s5
	jal func__toString
	move $4 $2
	jal func__println
	li $2 0
	move $31 $s6
	jr $ra
	move $31 $s6
	jr $ra

