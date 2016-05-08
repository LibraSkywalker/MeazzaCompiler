.data

_end: .asciiz "\n"
	.align 2
_buffer: .space 256
	.align 2
	length0: 	.word 	1
	String0: 	.asciiz 	" "
	length1: 	.word 	1
	String1: 	.asciiz 	"\n"


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
# Write: 4 2 23
main:
	li $4 4
	li $2 9
	syscall
	li $4 24
	li $2 9
	syscall
	move $23 $2
	jal main_0
	li $2 10
	syscall

# Read: 31 23 2 33 35 37 34 36 39 40 41 42 44 45 46 47 49 50 51 52 55
# Write: 32 33 30 35 37 34 36 39 40 4 2 41 42 44 45 46 47 49 50 51 52 55
main_0:
	move $32 $31
	jal func__getInt
	lw $33 0($23)
	la $30 0($23)
	move $33 $2
	sw $33 0($23)
	jal func__getInt
	lw $35 4($23)
	la $30 4($23)
	move $35 $2
	sw $35 4($23)
	jal func__getString
	lw $37 8($23)
	la $30 8($23)
	move $37 $2
	sw $37 8($23)
	lw $34 0($23)
	lw $36 4($23)
	add $39 $34 $36
	add $40 $39 5
	li $4 4
	li $2 9
	syscall
	sw $40 0($2)
	sll $4 $40 2
	li $2 9
	syscall
	move $41 $2
	lw $42 12($23)
	la $30 12($23)
	move $42 $41
	sw $42 12($23)
	lw $34 0($23)
	lw $36 4($23)
	add $44 $34 $36
	add $45 $44 5
	li $4 4
	li $2 9
	syscall
	sw $45 0($2)
	sll $4 $45 2
	li $2 9
	syscall
	move $46 $2
	lw $47 16($23)
	la $30 16($23)
	move $47 $46
	sw $47 16($23)
	lw $34 0($23)
	lw $36 4($23)
	add $49 $34 $36
	add $50 $49 5
	li $4 4
	li $2 9
	syscall
	sw $50 0($2)
	sll $4 $50 2
	li $2 9
	syscall
	move $51 $2
	lw $52 20($23)
	la $30 20($23)
	move $52 $51
	sw $52 20($23)
	li $55 1
	lw $34 0($23)
	bgt $55 $34 main_1

# Read: 23 55 53 58 59 2 30 57 43 61 62 60 48 64 65 63
# Write: 53 58 59 57 30 43 61 62 60 48 64 65 63
main_0_loop:
	jal func__getInt
	lw $53 20($23)
	mul $58 $55 4
	add $59 $53 $58
	lw $57 0($59)
	la $30 0($59)
	move $57 $2
	sw $57 0($30)
	lw $43 12($23)
	mul $61 $55 4
	add $62 $43 $61
	lw $60 0($62)
	la $30 0($62)
	li $60 0
	sw $60 0($30)
	lw $48 16($23)
	mul $64 $55 4
	add $65 $48 $64
	lw $63 0($65)
	la $30 0($65)
	li $63 0
	sw $63 0($30)

# Read: 55 23 34
# Write: 55 34
main_0_loopTail:
	add $55 $55 1
	lw $34 0($23)
	ble $55 $34 main_0_loop

# Read: 23 55 36
# Write: 55 36
main_1:
	li $55 1
	lw $36 4($23)
	bgt $55 $36 main_2

# Read: 23 55 69 38 2 34 71 53 73 74 70 30 72 75 43 77 78 76 79 48 81 82 80
# Write: 38 69 4 2 70 53 34 71 73 74 72 30 43 75 77 78 76 48 79 81 82 80
main_1_loop:
	lw $38 8($23)
	sub $69 $55 1
	move $4 $69
	move $2 $38
	jal func__string.ord
	move $70 $2
	lw $53 20($23)
	lw $34 0($23)
	add $71 $55 $34
	mul $73 $71 4
	add $74 $53 $73
	lw $72 0($74)
	la $30 0($74)
	move $72 $70
	sw $72 0($30)
	lw $43 12($23)
	lw $34 0($23)
	add $75 $55 $34
	mul $77 $75 4
	add $78 $43 $77
	lw $76 0($78)
	la $30 0($78)
	li $76 0
	sw $76 0($30)
	lw $48 16($23)
	lw $34 0($23)
	add $79 $55 $34
	mul $81 $79 4
	add $82 $48 $81
	lw $80 0($82)
	la $30 0($82)
	li $80 0
	sw $80 0($30)

# Read: 55 23 36
# Write: 55 36
main_1_loopTail:
	add $55 $55 1
	lw $36 4($23)
	ble $55 $36 main_1_loop

# Read: 23 34 86 55
# Write: 85 34 86 87 55
main_2:
	li $85 1
	lw $34 0($23)
	add $86 $34 1
	move $87 $86
	li $55 2
	lw $34 0($23)
	bgt $55 $34 main_3

# Read: 85 55 2
# Write: 4 5 85
main_2_loop:
	move $4 $85
	move $5 $55
	jal func__merge
	move $85 $2

# Read: 55 23 34
# Write: 55 34
main_2_loopTail:
	add $55 $55 1
	lw $34 0($23)
	ble $55 $34 main_2_loop

# Read: 23 34 91 36 55 92
# Write: 34 91 55 36 92
main_3:
	lw $34 0($23)
	add $91 $34 2
	move $55 $91
	lw $34 0($23)
	lw $36 4($23)
	add $92 $34 $36
	bgt $55 $92 main_4

# Read: 87 55 2
# Write: 4 5 87
main_3_loop:
	move $4 $87
	move $5 $55
	jal func__merge
	move $87 $2

# Read: 55 23 34 36 95
# Write: 55 34 36 95
main_3_loopTail:
	add $55 $55 1
	lw $34 0($23)
	lw $36 4($23)
	add $95 $34 $36
	ble $55 $95 main_3_loop

# Read: 23 85 53 98 99 97 2 87 34 100 101 102 103 38 104 32
# Write: 53 98 99 97 30 4 38 34 100 101 102 103 5 2 104 31
main_4:
	lw $53 20($23)
	mul $98 $85 4
	add $99 $53 $98
	lw $97 0($99)
	la $30 0($99)
	move $4 $97
	jal func__toString
	move $4 $2
	jal func__print
	la $4 String0
	jal func__print
	lw $38 8($23)
	lw $34 0($23)
	sub $100 $87 $34
	sub $101 $100 1
	move $4 $101
	lw $34 0($23)
	sub $102 $87 $34
	sub $103 $102 1
	move $5 $103
	move $2 $38
	jal func__string.substring
	move $104 $2
	move $4 $104
	jal func__print
	la $4 String1
	jal func__print
	move $4 $85
	move $5 $87
	jal func__merge
	move $4 $2
	jal func__toString
	move $4 $2
	jal func__println
	li $2 0
	move $31 $32
	jr $ra
	move $31 $32
	jr $ra

# local: 2 31 23 33 35 37 39 40 41 42 44 45 46 47 49 50 51 52 53 58 59 30 57 43 61 62 60 48 64 65 63 69 71 73 74 70 72 75 77 78 76 79 81 82 80 86 91 92 95 98 99 97 100 101 102 103 104
# localSaved: 34 36 38
# global: 55 85 87 32
# Save in address:
# times: $4: 20  $2: 30  $23: 51  $31: 3  $32: 3  $33: 3  $30: 19  $35: 3  $37: 3  $34: 32  $36: 14  $39: 2  $40: 3  $41: 2  $42: 3  $44: 2  $45: 3  $46: 2  $47: 3  $49: 2  $50: 3  $51: 2  $52: 3  $55: 29  $53: 6  $58: 2  $59: 3  $57: 3  $43: 4  $61: 2  $62: 3  $60: 3  $48: 4  $64: 2  $65: 3  $63: 3  $38: 4  $69: 2  $70: 2  $71: 2  $73: 2  $74: 3  $72: 3  $75: 2  $77: 2  $78: 3  $76: 3  $79: 2  $81: 2  $82: 3  $80: 3  $85: 5  $86: 2  $87: 6  $5: 4  $91: 2  $92: 2  $95: 2  $98: 2  $99: 3  $97: 2  $100: 2  $101: 2  $102: 2  $103: 2  $104: 2 
# Read: 31 4 5 109 106
# Write: 105 106 107 109
func__merge:
	sub $29 $29 8
	move $105 $31
	sw $31 4($29)
	move $106 $4
	sw $31 0($29)
	move $107 $5
	li $109 0
	lw $2 0($29)
	beq $109 $106 func__merge_branch_then

# Read:
# Write:
func__merge_branch_else:
	b func__merge_0

# Read: 107 105
# Write: 2 31
func__merge_branch_then:
	move $2 $107
	lw $3 4($29)
	move $31 $105
	add $29 $29 8
	jr $ra

# Read: 111 107
# Write: 111
func__merge_0:
	li $111 0
	beq $111 $107 func__merge_0_branch_then

# Read:
# Write:
func__merge_0_branch_else:
	b func__merge_1

# Read: 106 105
# Write: 2 31
func__merge_0_branch_then:
	lw $3 0($29)
	move $2 $106
	lw $3 4($29)
	move $31 $105
	add $29 $29 8
	jr $ra

# Read: 23 106 53 113 114 107 116 117 112 115
# Write: 53 113 114 112 30 116 117 115
func__merge_1:
	lw $53 20($23)
	lw $3 0($29)
	mul $113 $106 4
	add $114 $53 $113
	lw $112 0($114)
	la $30 0($114)
	lw $53 20($23)
	mul $116 $107 4
	add $117 $53 $116
	lw $115 0($117)
	la $30 0($117)
	blt $112 $115 func__merge_1_branch_then

# Read:
# Write:
func__merge_1_branch_else:
	b func__merge_2

# Read: 106 107 120
# Write: 120 106 107
func__merge_1_branch_then:
	lw $3 0($29)
	move $120 $106
	move $106 $107
	sw $31 0($29)
	move $107 $120

# Read: 23 106 48 122 123 121 107 125 126 2 30 124 43 128 129 127 132 133 135 136 131 134 138 139 130 137 105
# Write: 48 122 123 121 30 4 5 125 126 124 43 128 129 127 130 132 133 131 135 136 134 138 139 137 2 31
func__merge_2:
	lw $48 16($23)
	lw $3 0($29)
	mul $122 $106 4
	add $123 $48 $122
	lw $121 0($123)
	la $30 0($123)
	move $4 $121
	move $5 $107
	jal func__merge
	lw $48 16($23)
	lw $3 0($29)
	mul $125 $106 4
	add $126 $48 $125
	lw $124 0($126)
	la $30 0($126)
	move $124 $2
	sw $124 0($30)
	lw $43 12($23)
	lw $3 0($29)
	mul $128 $106 4
	add $129 $43 $128
	lw $127 0($129)
	la $30 0($129)
	move $130 $127
	lw $48 16($23)
	lw $3 0($29)
	mul $132 $106 4
	add $133 $48 $132
	lw $131 0($133)
	la $30 0($133)
	lw $43 12($23)
	lw $3 0($29)
	mul $135 $106 4
	add $136 $43 $135
	lw $134 0($136)
	la $30 0($136)
	move $134 $131
	sw $134 0($30)
	lw $48 16($23)
	lw $3 0($29)
	mul $138 $106 4
	add $139 $48 $138
	lw $137 0($139)
	la $30 0($139)
	move $137 $130
	sw $137 0($30)
	lw $3 0($29)
	move $2 $106
	lw $3 4($29)
	move $31 $105
	add $29 $29 8
	jr $ra
	lw $3 4($29)
	move $31 $105
	add $29 $29 8
	jr $ra

# local: 31 4 5 109 111 23 53 113 114 116 117 112 115 120 48 122 123 121 125 126 2 30 124 43 128 129 127 132 133 135 136 131 134 138 139 130 137
# localSaved: 107
# global:
# Save in address: 106 105
# times: $31: 5  $105: 5  $4: 2  $106: 13  $5: 2  $107: 7  $109: 2  $2: 4  $111: 2  $23: 8  $53: 4  $113: 2  $114: 3  $112: 2  $30: 11  $116: 2  $117: 3  $115: 2  $120: 2  $48: 8  $122: 2  $123: 3  $121: 2  $125: 2  $126: 3  $124: 3  $43: 4  $128: 2  $129: 3  $127: 2  $130: 2  $132: 2  $133: 3  $131: 2  $135: 2  $136: 3  $134: 3  $138: 2  $139: 3  $137: 3 
# local: 2 31 23 33 35 37 39 40 41 42 44 45 46 47 49 50 51 52 53 58 59 30 57 43 61 62 60 48 64 65 63 69 71 73 74 70 72 75 77 78 76 79 81 82 80 86 91 92 95 98 99 97 100 101 102 103 104 4 5 109 111 113 114 116 117 112 115 120 122 123 121 125 126 124 128 129 127 132 133 135 136 131 134 138 139 130 137
# localSaved: 34 36 38 107
# global: 55 85 87 32
# Save in address: 106 105
# times: $4: 22  $2: 34  $23: 59  $31: 8  $32: 3  $33: 3  $30: 30  $35: 3  $37: 3  $34: 32  $36: 14  $39: 2  $40: 3  $41: 2  $42: 3  $44: 2  $45: 3  $46: 2  $47: 3  $49: 2  $50: 3  $51: 2  $52: 3  $55: 29  $53: 10  $58: 2  $59: 3  $57: 3  $43: 8  $61: 2  $62: 3  $60: 3  $48: 12  $64: 2  $65: 3  $63: 3  $38: 4  $69: 2  $70: 2  $71: 2  $73: 2  $74: 3  $72: 3  $75: 2  $77: 2  $78: 3  $76: 3  $79: 2  $81: 2  $82: 3  $80: 3  $85: 5  $86: 2  $87: 6  $5: 6  $91: 2  $92: 2  $95: 2  $98: 2  $99: 3  $97: 2  $100: 2  $101: 2  $102: 2  $103: 2  $104: 2  $105: 5  $106: 13  $107: 7  $109: 2  $111: 2  $113: 2  $114: 3  $112: 2  $116: 2  $117: 3  $115: 2  $120: 2  $122: 2  $123: 3  $121: 2  $125: 2  $126: 3  $124: 3  $128: 2  $129: 3  $127: 2  $130: 2  $132: 2  $133: 3  $131: 2  $135: 2  $136: 3  $134: 3  $138: 2  $139: 3  $137: 3 
