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

# Read:
# Write:
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

# Read:
# Write:
main_0:
	move $42 $31
	jal func__getInt
	move $43 $2
	li $45 1
	sle $46 $45 $43
	beq $46 0 main_0_afterLoop

# Read:
# Write:
main_0_loop:
	li $47 1
	sle $48 $47 $43
	beq $48 0 main_0_loop_afterLoop

# Read:
# Write:
main_0_loop_loop:
	li $49 1
	sle $50 $49 $43
	beq $50 0 main_0_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop:
	li $51 1
	sle $52 $51 $43
	beq $52 0 main_0_loop_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop_loop:
	li $53 1
	sle $54 $53 $43
	beq $54 0 main_0_loop_loop_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop:
	li $55 1
	sle $56 $55 $43
	beq $56 0 main_0_loop_loop_loop_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop:
	sne $57 $45 $47
	beq $57 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal:
	sne $59 $45 $49
	beq $59 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal:
	sne $61 $45 $51
	beq $61 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal:
	sne $63 $45 $53
	beq $63 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal:
	sne $65 $45 $55
	beq $65 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal:
	sne $67 $45 $33
	beq $67 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal:
	sne $69 $45 $35
	beq $69 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal:
	sne $71 $45 $37
	beq $71 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $73 $45 $39
	beq $73 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $75 $47 $49
	beq $75 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $77 $47 $51
	beq $77 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $79 $47 $53
	beq $79 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $81 $47 $55
	beq $81 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $83 $47 $33
	beq $83 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $85 $47 $35
	beq $85 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $87 $47 $37
	beq $87 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $89 $47 $39
	beq $89 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $91 $49 $51
	beq $91 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $93 $49 $53
	beq $93 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $95 $49 $55
	beq $95 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $97 $49 $33
	beq $97 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $99 $49 $35
	beq $99 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $101 $49 $37
	beq $101 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $103 $49 $39
	beq $103 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $105 $51 $53
	beq $105 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $107 $51 $55
	beq $107 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $109 $51 $33
	beq $109 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $111 $51 $35
	beq $111 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $113 $51 $37
	beq $113 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $115 $51 $39
	beq $115 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $117 $53 $55
	beq $117 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $119 $53 $33
	beq $119 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $121 $53 $35
	beq $121 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $123 $53 $37
	beq $123 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $125 $53 $39
	beq $125 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $127 $55 $33
	beq $127 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $129 $55 $35
	beq $129 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $131 $55 $37
	beq $131 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $133 $55 $39
	beq $133 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $135 $35 $37
	beq $135 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal_normal:
	sne $137 $33 $39
	bne $137 0 main_0_loop_loop_loop_loop_loop_loop_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_shortcut:
	li $58 0
	b main_0_loop_loop_loop_loop_loop_loop_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normalEnd:
	li $58 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next:
	bne $58 0 main_0_loop_loop_loop_loop_loop_loop_next_branch_then

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_branch_else:
	b main_0_loop_loop_loop_loop_loop_loop_next_afterBranch

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_branch_then:
	move $138 $41
	add $41 $41 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_afterBranch:

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loopTail:
	move $139 $55
	add $55 $55 1
	sle $140 $55 $43
	bne $140 0 main_0_loop_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loop_loop_loop_loopTail:
	move $141 $53
	add $53 $53 1
	sle $142 $53 $43
	bne $142 0 main_0_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loop_loop_loopTail:
	move $143 $51
	add $51 $51 1
	sle $144 $51 $43
	bne $144 0 main_0_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loop_loopTail:
	move $145 $49
	add $49 $49 1
	sle $146 $49 $43
	bne $146 0 main_0_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loopTail:
	move $147 $47
	add $47 $47 1
	sle $148 $47 $43
	bne $148 0 main_0_loop_loop

# Read:
# Write:
main_0_loop_afterLoop:

# Read:
# Write:
main_0_loopTail:
	move $149 $45
	add $45 $45 1
	sle $150 $45 $43
	bne $150 0 main_0_loop

# Read:
# Write:
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

# local:
# localSaved:
# global:
# Save in address:
# times:
# local:
# localSaved:
# global:
# Save in address:
# times:
