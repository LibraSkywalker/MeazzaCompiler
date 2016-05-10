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

# Read: 2 23 32 34 36 38 40
# Write: 4 2 23 32 30 34 36 38 40
main:
	sub $29 $29 156
	li $4 4
	li $2 9
	syscall
	li $4 24
	li $2 9
	syscall
	move $23 $2
	lw $32 4($23)
	la $30 4($23)
	li $32 99
	sw $32 4($23)
	lw $34 8($23)
	la $30 8($23)
	li $34 100
	sw $34 8($23)
	lw $36 12($23)
	la $30 12($23)
	li $36 101
	sw $36 12($23)
	lw $38 16($23)
	la $30 16($23)
	li $38 102
	sw $38 16($23)
	lw $40 20($23)
	la $30 20($23)
	li $40 0
	sw $40 20($23)
	jal main_0
	li $2 10
	syscall

# Read: 31 23 2 43 46 44
# Write: 42 43 30 46 44
main_0:
	move $42 $31
	jal func__getInt
	lw $43 0($23)
	la $30 0($23)
	move $43 $2
	sw $43 0($23)
	li $46 1
	lw $44 0($23)
	bgt $46 $44 main_0_afterLoop

# Read: 23 48 44
# Write: 48 44
main_0_loop:
	li $48 1
	lw $44 0($23)
	bgt $48 $44 main_0_loop_afterLoop

# Read: 23 50 44
# Write: 50 44
main_0_loop_loop:
	li $50 1
	lw $44 0($23)
	bgt $50 $44 main_0_loop_loop_afterLoop

# Read: 23 52 44
# Write: 52 44
main_0_loop_loop_loop:
	li $52 1
	lw $44 0($23)
	bgt $52 $44 main_0_loop_loop_loop_afterLoop

# Read: 23 54 44
# Write: 54 44
main_0_loop_loop_loop_loop:
	li $54 1
	lw $44 0($23)
	bgt $54 $44 main_0_loop_loop_loop_loop_afterLoop

# Read: 23 56 44
# Write: 56 44
main_0_loop_loop_loop_loop_loop:
	li $56 1
	lw $44 0($23)
	bgt $56 $44 main_0_loop_loop_loop_loop_loop_afterLoop

# Read: 46 48
# Write:
main_0_loop_loop_loop_loop_loop_loop:
	beq $46 $48 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read: 46 50
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal:
	bne $46 $50 main_0_loop_loop_loop_loop_loop_loop_normalEnd

# Read:
# Write: 59
main_0_loop_loop_loop_loop_loop_loop_shortcut:
	li $59 0
	sw $31 0($29)
	b main_0_loop_loop_loop_loop_loop_loop_next

# Read:
# Write: 59
main_0_loop_loop_loop_loop_loop_loop_normalEnd:
	li $59 1
	sw $31 0($29)

# Read: 59
# Write:
main_0_loop_loop_loop_loop_loop_loop_next:
	lw $3 0($29)
	beq $59 0 main_0_loop_loop_loop_loop_loop_loop_next_shortcut

# Read: 46 52
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_normal:
	bne $46 $52 main_0_loop_loop_loop_loop_loop_loop_next_normalEnd

# Read:
# Write: 61
main_0_loop_loop_loop_loop_loop_loop_next_shortcut:
	li $61 0
	sw $31 4($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next

# Read:
# Write: 61
main_0_loop_loop_loop_loop_loop_loop_next_normalEnd:
	li $61 1
	sw $31 4($29)

# Read: 61
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next:
	lw $3 4($29)
	beq $61 0 main_0_loop_loop_loop_loop_loop_loop_next_next_shortcut

# Read: 46 54
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_normal:
	bne $46 $54 main_0_loop_loop_loop_loop_loop_loop_next_next_normalEnd

# Read:
# Write: 63
main_0_loop_loop_loop_loop_loop_loop_next_next_shortcut:
	li $63 0
	sw $31 8($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next

# Read:
# Write: 63
main_0_loop_loop_loop_loop_loop_loop_next_next_normalEnd:
	li $63 1
	sw $31 8($29)

# Read: 63
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next:
	lw $3 8($29)
	beq $63 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_shortcut

# Read: 46 56
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_normal:
	bne $46 $56 main_0_loop_loop_loop_loop_loop_loop_next_next_next_normalEnd

# Read:
# Write: 65
main_0_loop_loop_loop_loop_loop_loop_next_next_next_shortcut:
	li $65 0
	sw $31 12($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next

# Read:
# Write: 65
main_0_loop_loop_loop_loop_loop_loop_next_next_next_normalEnd:
	li $65 1
	sw $31 12($29)

# Read: 65
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next:
	lw $3 12($29)
	beq $65 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_shortcut

# Read: 23 46 33
# Write: 33
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_normal:
	lw $33 4($23)
	bne $46 $33 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_normalEnd

# Read:
# Write: 67
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_shortcut:
	li $67 0
	sw $31 16($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next

# Read:
# Write: 67
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_normalEnd:
	li $67 1
	sw $31 16($29)

# Read: 67
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next:
	lw $3 16($29)
	beq $67 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_shortcut

# Read: 23 46 35
# Write: 35
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_normal:
	lw $35 8($23)
	bne $46 $35 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_normalEnd

# Read:
# Write: 69
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_shortcut:
	li $69 0
	sw $31 20($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next

# Read:
# Write: 69
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_normalEnd:
	li $69 1
	sw $31 20($29)

# Read: 69
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next:
	lw $3 20($29)
	beq $69 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_shortcut

# Read: 23 46 37
# Write: 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_normal:
	lw $37 12($23)
	bne $46 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_normalEnd

# Read:
# Write: 71
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_shortcut:
	li $71 0
	sw $31 24($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next

# Read:
# Write: 71
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_normalEnd:
	li $71 1
	sw $31 24($29)

# Read: 71
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next:
	lw $3 24($29)
	beq $71 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_shortcut

# Read: 23 46 39
# Write: 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	bne $46 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 73
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_shortcut:
	li $73 0
	sw $31 28($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next

# Read:
# Write: 73
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_normalEnd:
	li $73 1
	sw $31 28($29)

# Read: 73
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next:
	lw $3 28($29)
	beq $73 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_shortcut

# Read: 48 50
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_normal:
	bne $48 $50 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 75
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_shortcut:
	li $75 0
	sw $31 32($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next

# Read:
# Write: 75
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_normalEnd:
	li $75 1
	sw $31 32($29)

# Read: 75
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next:
	lw $3 32($29)
	beq $75 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_shortcut

# Read: 48 52
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_normal:
	bne $48 $52 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 77
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_shortcut:
	li $77 0
	sw $31 36($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 77
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_normalEnd:
	li $77 1
	sw $31 36($29)

# Read: 77
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next:
	lw $3 36($29)
	beq $77 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 48 54
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_normal:
	bne $48 $54 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 79
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $79 0
	sw $31 40($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 79
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $79 1
	sw $31 40($29)

# Read: 79
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 40($29)
	beq $79 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 48 56
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $48 $56 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 81
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $81 0
	sw $31 44($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 81
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $81 1
	sw $31 44($29)

# Read: 81
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 44($29)
	beq $81 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 48 33
# Write: 33
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	bne $48 $33 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 83
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $83 0
	sw $31 48($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 83
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $83 1
	sw $31 48($29)

# Read: 83
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 48($29)
	beq $83 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 48 35
# Write: 35
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	bne $48 $35 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 85
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $85 0
	sw $31 52($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 85
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $85 1
	sw $31 52($29)

# Read: 85
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 52($29)
	beq $85 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 48 37
# Write: 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	bne $48 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 87
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $87 0
	sw $31 56($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 87
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $87 1
	sw $31 56($29)

# Read: 87
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 56($29)
	beq $87 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 48 39
# Write: 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	bne $48 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 89
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $89 0
	sw $31 60($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 89
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $89 1
	sw $31 60($29)

# Read: 89
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 60($29)
	beq $89 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 50 52
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $50 $52 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 91
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $91 0
	sw $31 64($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 91
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $91 1
	sw $31 64($29)

# Read: 91
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 64($29)
	beq $91 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 50 54
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $50 $54 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 93
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $93 0
	sw $31 68($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 93
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $93 1
	sw $31 68($29)

# Read: 93
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 68($29)
	beq $93 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 50 56
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $50 $56 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 95
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $95 0
	sw $31 72($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 95
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $95 1
	sw $31 72($29)

# Read: 95
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 72($29)
	beq $95 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 50 33
# Write: 33
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	bne $50 $33 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 97
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $97 0
	sw $31 76($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 97
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $97 1
	sw $31 76($29)

# Read: 97
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 76($29)
	beq $97 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 50 35
# Write: 35
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	bne $50 $35 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 99
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $99 0
	sw $31 80($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 99
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $99 1
	sw $31 80($29)

# Read: 99
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 80($29)
	beq $99 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 50 37
# Write: 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	bne $50 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 101
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $101 0
	sw $31 84($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 101
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $101 1
	sw $31 84($29)

# Read: 101
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 84($29)
	beq $101 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 50 39
# Write: 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	bne $50 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 103
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $103 0
	sw $31 88($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 103
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $103 1
	sw $31 88($29)

# Read: 103
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 88($29)
	beq $103 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 52 54
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $52 $54 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 105
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $105 0
	sw $31 92($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 105
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $105 1
	sw $31 92($29)

# Read: 105
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 92($29)
	beq $105 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 52 56
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $52 $56 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 107
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $107 0
	sw $31 96($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 107
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $107 1
	sw $31 96($29)

# Read: 107
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 96($29)
	beq $107 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 52 33
# Write: 33
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	bne $52 $33 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 109
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $109 0
	sw $31 100($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 109
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $109 1
	sw $31 100($29)

# Read: 109
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 100($29)
	beq $109 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 52 35
# Write: 35
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	bne $52 $35 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 111
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $111 0
	sw $31 104($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 111
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $111 1
	sw $31 104($29)

# Read: 111
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 104($29)
	beq $111 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 52 37
# Write: 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	bne $52 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 113
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $113 0
	sw $31 108($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 113
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $113 1
	sw $31 108($29)

# Read: 113
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 108($29)
	beq $113 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 52 39
# Write: 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	bne $52 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 115
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $115 0
	sw $31 112($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 115
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $115 1
	sw $31 112($29)

# Read: 115
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 112($29)
	beq $115 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 54 56
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	bne $54 $56 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 117
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $117 0
	sw $31 116($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 117
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $117 1
	sw $31 116($29)

# Read: 117
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 116($29)
	beq $117 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 54 33
# Write: 33
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	bne $54 $33 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 119
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $119 0
	sw $31 120($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 119
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $119 1
	sw $31 120($29)

# Read: 119
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 120($29)
	beq $119 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 54 35
# Write: 35
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	bne $54 $35 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 121
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $121 0
	sw $31 124($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 121
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $121 1
	sw $31 124($29)

# Read: 121
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 124($29)
	beq $121 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 54 37
# Write: 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	bne $54 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 123
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $123 0
	sw $31 128($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 123
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $123 1
	sw $31 128($29)

# Read: 123
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 128($29)
	beq $123 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 54 39
# Write: 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	bne $54 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 125
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $125 0
	sw $31 132($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 125
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $125 1
	sw $31 132($29)

# Read: 125
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 132($29)
	beq $125 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 56 33
# Write: 33
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	bne $56 $33 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 127
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $127 0
	sw $31 136($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 127
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $127 1
	sw $31 136($29)

# Read: 127
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 136($29)
	beq $127 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 56 35
# Write: 35
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	bne $56 $35 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 129
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $129 0
	sw $31 140($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 129
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $129 1
	sw $31 140($29)

# Read: 129
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 140($29)
	beq $129 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 56 37
# Write: 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	bne $56 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 131
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $131 0
	sw $31 144($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 131
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $131 1
	sw $31 144($29)

# Read: 131
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 144($29)
	beq $131 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 56 39
# Write: 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	bne $56 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 133
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $133 0
	sw $31 148($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 133
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $133 1
	sw $31 148($29)

# Read: 133
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 148($29)
	beq $133 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 35 37
# Write: 35 37
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	lw $37 12($23)
	bne $35 $37 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 135
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $135 0
	sw $31 152($29)
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 135
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $135 1
	sw $31 152($29)

# Read: 135
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	lw $3 152($29)
	beq $135 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read: 23 33 39
# Write: 33 39
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	lw $39 16($23)
	bne $33 $39 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write: 137
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $137 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write: 137
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $137 1

# Read: 137
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	bne $137 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_branch_then

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_branch_else:
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_afterBranch

# Read: 23 41
# Write: 41 139
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_branch_then:
	lw $41 20($23)
	add $41 $41 1
	sw $41 20($23)

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_afterBranch:

# Read: 56 23 44
# Write: 140 56 44
main_0_loop_loop_loop_loop_loop_loopTail:
	add $56 $56 1
	lw $44 0($23)
	ble $56 $44 main_0_loop_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_afterLoop:

# Read: 54 23 44
# Write: 142 54 44
main_0_loop_loop_loop_loop_loopTail:
	add $54 $54 1
	lw $44 0($23)
	ble $54 $44 main_0_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_afterLoop:

# Read: 52 23 44
# Write: 144 52 44
main_0_loop_loop_loop_loopTail:
	add $52 $52 1
	lw $44 0($23)
	ble $52 $44 main_0_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_afterLoop:

# Read: 50 23 44
# Write: 146 50 44
main_0_loop_loop_loopTail:
	add $50 $50 1
	lw $44 0($23)
	ble $50 $44 main_0_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_afterLoop:

# Read: 48 23 44
# Write: 148 48 44
main_0_loop_loopTail:
	add $48 $48 1
	lw $44 0($23)
	ble $48 $44 main_0_loop_loop

# Read:
# Write:
main_0_loop_afterLoop:

# Read: 46 23 44
# Write: 150 46 44
main_0_loopTail:
	add $46 $46 1
	lw $44 0($23)
	ble $46 $44 main_0_loop

# Read: 23 41 2 42
# Write: 41 4 2 31
main_0_afterLoop:
	lw $41 20($23)
	move $4 $41
	jal func__toString
	move $4 $2
	jal func__println
	li $2 0
	move $31 $42
	add $29 $29 156
	jr $ra
	move $31 $42
	add $29 $29 156
	jr $ra

# local: 2 23 32 34 36 38 40 31 43
# localSaved: 46 44 48 50 52 54 56
# global: 33 35 37 39 137 41 42
# Save in address: 59 61 63 65 67 69 71 73 75 77 79 81 83 85 87 89 91 93 95 97 99 101 103 105 107 109 111 113 115 117 119 121 123 125 127 129 131 133 135
# times: $4: 4  $2: 7  $23: 62  $32: 3  $30: 6  $34: 3  $36: 3  $38: 3  $40: 3  $31: 3  $42: 3  $43: 3  $46: 15  $44: 24  $48: 15  $50: 15  $52: 15  $54: 15  $56: 15  $59: 3  $61: 3  $63: 3  $65: 3  $33: 14  $67: 3  $35: 14  $69: 3  $37: 14  $71: 3  $39: 14  $73: 3  $75: 3  $77: 3  $79: 3  $81: 3  $83: 3  $85: 3  $87: 3  $89: 3  $91: 3  $93: 3  $95: 3  $97: 3  $99: 3  $101: 3  $103: 3  $105: 3  $107: 3  $109: 3  $111: 3  $113: 3  $115: 3  $117: 3  $119: 3  $121: 3  $123: 3  $125: 3  $127: 3  $129: 3  $131: 3  $133: 3  $135: 3  $137: 3  $41: 7  $139: 1  $140: 1  $142: 1  $144: 1  $146: 1  $148: 1  $150: 1 
# local: 2 23 32 34 36 38 40 31 43
# localSaved: 46 44 48 50 52 54 56
# global: 33 35 37 39 137 41 42
# Save in address: 59 61 63 65 67 69 71 73 75 77 79 81 83 85 87 89 91 93 95 97 99 101 103 105 107 109 111 113 115 117 119 121 123 125 127 129 131 133 135
# times: $4: 4  $2: 7  $23: 62  $32: 3  $30: 6  $34: 3  $36: 3  $38: 3  $40: 3  $31: 3  $42: 3  $43: 3  $46: 15  $44: 24  $48: 15  $50: 15  $52: 15  $54: 15  $56: 15  $59: 3  $61: 3  $63: 3  $65: 3  $33: 14  $67: 3  $35: 14  $69: 3  $37: 14  $71: 3  $39: 14  $73: 3  $75: 3  $77: 3  $79: 3  $81: 3  $83: 3  $85: 3  $87: 3  $89: 3  $91: 3  $93: 3  $95: 3  $97: 3  $99: 3  $101: 3  $103: 3  $105: 3  $107: 3  $109: 3  $111: 3  $113: 3  $115: 3  $117: 3  $119: 3  $121: 3  $123: 3  $125: 3  $127: 3  $129: 3  $131: 3  $133: 3  $135: 3  $137: 3  $41: 7  $139: 1  $140: 1  $142: 1  $144: 1  $146: 1  $148: 1  $150: 1 
