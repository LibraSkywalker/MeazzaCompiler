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

# Read:
# Write:
main_0:
	move $42 $31
	jal func__getInt
	lw $43 0($23)
	la $30 0($23)
	move $43 $2
	sw $43 0($23)
	li $46 1
	lw $44 0($23)
	sle $47 $46 $44
	beq $47 0 main_0_afterLoop

# Read:
# Write:
main_0_loop:
	li $48 1
	lw $44 0($23)
	sle $49 $48 $44
	beq $49 0 main_0_loop_afterLoop

# Read:
# Write:
main_0_loop_loop:
	li $50 1
	lw $44 0($23)
	sle $51 $50 $44
	beq $51 0 main_0_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop:
	li $52 1
	lw $44 0($23)
	sle $53 $52 $44
	beq $53 0 main_0_loop_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop_loop:
	li $54 1
	lw $44 0($23)
	sle $55 $54 $44
	beq $55 0 main_0_loop_loop_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop:
	li $56 1
	lw $44 0($23)
	sle $57 $56 $44
	beq $57 0 main_0_loop_loop_loop_loop_loop_afterLoop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop:
	sne $58 $46 $48
	beq $58 0 main_0_loop_loop_loop_loop_loop_loop_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normal:
	sne $60 $46 $50
	bne $60 0 main_0_loop_loop_loop_loop_loop_loop_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_shortcut:
	li $59 0
	b main_0_loop_loop_loop_loop_loop_loop_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_normalEnd:
	li $59 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next:
	beq $59 0 main_0_loop_loop_loop_loop_loop_loop_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_normal:
	sne $62 $46 $52
	bne $62 0 main_0_loop_loop_loop_loop_loop_loop_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_shortcut:
	li $61 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_normalEnd:
	li $61 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next:
	beq $61 0 main_0_loop_loop_loop_loop_loop_loop_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_normal:
	sne $64 $46 $54
	bne $64 0 main_0_loop_loop_loop_loop_loop_loop_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_shortcut:
	li $63 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_normalEnd:
	li $63 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next:
	beq $63 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_normal:
	sne $66 $46 $56
	bne $66 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_shortcut:
	li $65 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_normalEnd:
	li $65 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next:
	beq $65 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_normal:
	lw $33 4($23)
	sne $68 $46 $33
	bne $68 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_shortcut:
	li $67 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_normalEnd:
	li $67 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next:
	beq $67 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_normal:
	lw $35 8($23)
	sne $70 $46 $35
	bne $70 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_shortcut:
	li $69 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_normalEnd:
	li $69 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next:
	beq $69 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_normal:
	lw $37 12($23)
	sne $72 $46 $37
	bne $72 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_shortcut:
	li $71 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_normalEnd:
	li $71 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next:
	beq $71 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	sne $74 $46 $39
	bne $74 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_shortcut:
	li $73 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_normalEnd:
	li $73 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next:
	beq $73 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_normal:
	sne $76 $48 $50
	bne $76 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_shortcut:
	li $75 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_normalEnd:
	li $75 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next:
	beq $75 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_normal:
	sne $78 $48 $52
	bne $78 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_shortcut:
	li $77 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_normalEnd:
	li $77 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next:
	beq $77 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_normal:
	sne $80 $48 $54
	bne $80 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $79 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $79 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next:
	beq $79 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $82 $48 $56
	bne $82 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $81 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $81 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $81 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	sne $84 $48 $33
	bne $84 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $83 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $83 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $83 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	sne $86 $48 $35
	bne $86 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $85 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $85 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $85 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	sne $88 $48 $37
	bne $88 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $87 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $87 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $87 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	sne $90 $48 $39
	bne $90 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $89 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $89 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $89 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $92 $50 $52
	bne $92 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $91 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $91 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $91 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $94 $50 $54
	bne $94 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $93 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $93 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $93 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $96 $50 $56
	bne $96 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $95 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $95 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $95 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	sne $98 $50 $33
	bne $98 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $97 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $97 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $97 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	sne $100 $50 $35
	bne $100 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $99 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $99 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $99 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	sne $102 $50 $37
	bne $102 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $101 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $101 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $101 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	sne $104 $50 $39
	bne $104 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $103 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $103 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $103 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $106 $52 $54
	bne $106 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $105 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $105 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $105 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $108 $52 $56
	bne $108 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $107 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $107 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $107 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	sne $110 $52 $33
	bne $110 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $109 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $109 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $109 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	sne $112 $52 $35
	bne $112 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $111 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $111 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $111 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	sne $114 $52 $37
	bne $114 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $113 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $113 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $113 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	sne $116 $52 $39
	bne $116 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $115 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $115 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $115 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	sne $118 $54 $56
	bne $118 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $117 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $117 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $117 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	sne $120 $54 $33
	bne $120 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $119 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $119 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $119 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	sne $122 $54 $35
	bne $122 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $121 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $121 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $121 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	sne $124 $54 $37
	bne $124 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $123 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $123 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $123 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	sne $126 $54 $39
	bne $126 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $125 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $125 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $125 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	sne $128 $56 $33
	bne $128 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $127 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $127 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $127 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	sne $130 $56 $35
	bne $130 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $129 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $129 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $129 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $37 12($23)
	sne $132 $56 $37
	bne $132 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $131 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $131 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $131 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $39 16($23)
	sne $134 $56 $39
	bne $134 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $133 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $133 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $133 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $35 8($23)
	lw $37 12($23)
	sne $136 $35 $37
	bne $136 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $135 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $135 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	beq $135 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normal:
	lw $33 4($23)
	lw $39 16($23)
	sne $138 $33 $39
	bne $138 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_shortcut:
	li $137 0
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_normalEnd:
	li $137 1

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next:
	bne $137 0 main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_branch_then

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_branch_else:
	b main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_afterBranch

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_branch_then:
	lw $41 20($23)
	move $139 $41
	add $41 $41 1
	sw $41 20($23)

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loop_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_next_afterBranch:

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_loopTail:
	move $140 $56
	add $56 $56 1
	lw $44 0($23)
	sle $141 $56 $44
	bne $141 0 main_0_loop_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loop_loop_loop_loopTail:
	move $142 $54
	add $54 $54 1
	lw $44 0($23)
	sle $143 $54 $44
	bne $143 0 main_0_loop_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loop_loop_loopTail:
	move $144 $52
	add $52 $52 1
	lw $44 0($23)
	sle $145 $52 $44
	bne $145 0 main_0_loop_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loop_loopTail:
	move $146 $50
	add $50 $50 1
	lw $44 0($23)
	sle $147 $50 $44
	bne $147 0 main_0_loop_loop_loop

# Read:
# Write:
main_0_loop_loop_afterLoop:

# Read:
# Write:
main_0_loop_loopTail:
	move $148 $48
	add $48 $48 1
	lw $44 0($23)
	sle $149 $48 $44
	bne $149 0 main_0_loop_loop

# Read:
# Write:
main_0_loop_afterLoop:

# Read:
# Write:
main_0_loopTail:
	move $150 $46
	add $46 $46 1
	lw $44 0($23)
	sle $151 $46 $44
	bne $151 0 main_0_loop

# Read:
# Write:
main_0_afterLoop:
	lw $41 20($23)
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
