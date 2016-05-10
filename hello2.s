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

# Read: 2
# Write: 4 2 23 33 35 37 39 41
main:
	li $4 4
	li $2 9
	syscall
	li $4 24
	li $2 9
	syscall
	move $23 $2
	li $33 99
	li $35 100
	li $37 101
	li $39 102
	li $41 0
	jal main_0
	li $2 10
	syscall

# Read: 31 2 45 43
# Write: 42 43 45
main_0:
	move $42 $31
	jal func__getInt
	move $43 $2
	li $45 1
	bgt $45 $43 main_0_afterLoop

# Read: 47 43
# Write: 47
main_0_loop:
	li $47 1
	bgt $47 $43 main_0_loop_afterLoop

# Read: 49 43
# Write: 49
main_0_loop_loop:
	li $49 1
	bgt $49 $43 main_0_loop_loop_afterLoop

# Read: 51 43
# Write: 51
main_0_loop_loop_loop:
	li $51 1
	bgt $51 $43 main_0_loop_loop_loop_afterLoop

# Read: 53 43
# Write: 53
main_0_loop_loop_loop_loop:
	li $53 1
	bgt $53 $43 main_0_loop_loop_loop_loop_afterLoop

# Read: 55 43
# Write: 55
main_0_loop_loop_loop_loop_loop:
	li $55 1
	bgt $55 $43 main_0_loop_loop_loop_loop_loop_afterLoop

# Read: 45 47
# Write:
main_0_loop_loop_loop_loop_loop_loop:
	beq $45 $47 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 49
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal:
	beq $45 $49 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 51
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal:
	beq $45 $51 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 53
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal:
	beq $45 $53 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 55
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal:
	beq $45 $55 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 33
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal:
	beq $45 $33 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 35
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal:
	beq $45 $35 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal:
	beq $45 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 45 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $45 $39 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 49
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $49 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 51
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $51 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 53
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $53 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 55
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $55 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 33
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $33 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 35
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $35 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 47 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $47 $39 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 51
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $51 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 53
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $53 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 55
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $55 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 33
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $33 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 35
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $35 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 49 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $49 $39 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 51 53
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $51 $53 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 51 55
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $51 $55 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 51 33
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $51 $33 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 51 35
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $51 $35 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 51 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $51 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 51 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $51 $39 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 53 55
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $53 $55 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 53 33
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $53 $33 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 53 35
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $53 $35 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 53 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $53 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 53 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $53 $39 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 55 33
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $55 $33 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 55 35
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $55 $35 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 55 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $55 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 55 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $55 $39 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 35 37
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	beq $35 $37 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 33 39
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	bne $33 $39 main_0_loop_loop_loop_loop_loop_loop_normalEnd

# Read:
# Write: 58
main_0_loop_loop_loop_loop_loop_loop_shortcut:
	li $58 0
	b main_0_loop_loop_loop_loop_loop_loop_next

# Read:
# Write: 58
main_0_loop_loop_loop_loop_loop_loop_normalEnd:
	li $58 1

# Read: 58
# Write:
main_0_loop_loop_loop_loop_loop_loop_next:
	bne $58 0 main_0_loop_loop_loop_loop_loop_loop_next_branch_then

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_branch_else:
	b main_0_loop_loop_loop_loop_loop_loop_next_afterBranch

# Read: 41
# Write: 138 41
main_0_loop_loop_loop_loop_loop_loop_next_branch_then:
	add $41 $41 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_afterBranch:

# Read: 55 43
# Write: 139 55
main_0_loop_loop_loop_loop_loop_loopTail:
	add $55 $55 1
	ble $55 $43 main_0_loop_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_afterLoop:

# Read: 53 43
# Write: 141 53
main_0_loop_loop_loop_loop_loopTail:
	add $53 $53 1
	ble $53 $43 main_0_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_afterLoop:

# Read: 51 43
# Write: 143 51
main_0_loop_loop_loop_loopTail:
	add $51 $51 1
	ble $51 $43 main_0_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_afterLoop:

# Read: 49 43
# Write: 145 49
main_0_loop_loop_loopTail:
	add $49 $49 1
	ble $49 $43 main_0_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_afterLoop:

# Read: 47 43
# Write: 147 47
main_0_loop_loopTail:
	add $47 $47 1
	ble $47 $43 main_0_loop_loop

# Read:
# Write:
main_0_loop_afterLoop:

# Read: 45 43
# Write: 149 45
main_0_loopTail:
	add $45 $45 1
	ble $45 $43 main_0_loop

# Read: 41 2 42
# Write: 4 2 31
main_0_afterLoop:
	move $4 $41
	jal func__toString
	move $4 $2
	jal func__println
	li $2 0
	move $31 $42
	jr $ra
	move $31 $42
	jr $ra

# local: 2 31
# localSaved: 45 43 47 49 51 53 55
# global: 33 35 37 39 58 41 42
# Save in address:
# times: $4: 4  $2: 7  $23: 1  $33: 8  $35: 8  $37: 8  $39: 8  $41: 5  $31: 3  $42: 3  $43: 13  $45: 15  $47: 15  $49: 15  $51: 15  $53: 15  $55: 15  $58: 3  $138: 1  $139: 1  $141: 1  $143: 1  $145: 1  $147: 1  $149: 1 
# local: 2 31
# localSaved: 45 43 47 49 51 53 55
# global: 33 35 37 39 58 41 42
# Save in address:
# times: $4: 4  $2: 7  $23: 1  $33: 8  $35: 8  $37: 8  $39: 8  $41: 5  $31: 3  $42: 3  $43: 13  $45: 15  $47: 15  $49: 15  $51: 15  $53: 15  $55: 15  $58: 3  $138: 1  $139: 1  $141: 1  $143: 1  $145: 1  $147: 1  $149: 1 
