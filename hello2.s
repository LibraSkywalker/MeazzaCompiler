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

# Read: 2 23 32 34 36
# Write: 4 2 23 32 30 34 36
main:
	sub $29 $29 8
	li $4 4
	li $2 9
	syscall
	li $4 36
	li $2 9
	syscall
	move $23 $2
	lw $32 16($23)
	la $30 16($23)
	li $32 48271
	sw $32 16($23)
	lw $34 20($23)
	la $30 20($23)
	li $34 2147483647
	sw $34 20($23)
	lw $36 32($23)
	la $30 32($23)
	li $36 1
	sw $36 32($23)
	jal main_0
	li $2 10
	syscall

# Read: 31 46 45 23 47 48 50 2 52 53 54 35 33 56 57 59 60 49 62
# Write: 38 40 42 44 46 45 47 48 30 50 4 2 52 53 54 35 33 56 57 59 60 49 62
main_0:
	move $38 $31
	sw $31 0($29)
	li $40 0
	li $42 0
	li $44 0
	sw $31 4($29)
	li $46 3
	mul $45 $46 7
	mul $47 $45 10
	lw $48 0($23)
	la $30 0($23)
	move $48 $47
	sw $48 0($23)
	lw $50 4($23)
	la $30 4($23)
	li $50 0
	sw $50 4($23)
	li $4 4
	li $2 9
	syscall
	li $52 100
	sw $52 0($2)
	mul $4 $52 8
	li $2 9
	syscall
	move $53 $2
	lw $54 12($23)
	la $30 12($23)
	move $54 $53
	sw $54 12($23)
	lw $35 20($23)
	lw $33 16($23)
	div $56 $35 $33
	lw $57 24($23)
	la $30 24($23)
	move $57 $56
	sw $57 24($23)
	lw $35 20($23)
	lw $33 16($23)
	rem $59 $35 $33
	lw $60 28($23)
	la $30 28($23)
	move $60 $59
	sw $60 28($23)
	lw $49 0($23)
	move $4 $49
	jal func__pd
	xor $62 $2 1
	bne $62 0 main_0_branch_then

# Read:
# Write:
main_0_branch_else:
	b main_1

# Read: 38
# Write: 4 2 31
main_0_branch_then:
	la $4 String0
	jal func__println
	li $2 1
	lw $3 0($29)
	move $31 $38
	add $29 $29 8
	jr $ra

# Read: 2 63 23 64 65 66 40 67
# Write: 4 63 64 65 30 66 67
main_1:
	la $4 String1
	jal func__println
	li $4 3654898
	jal func__initialize
	jal func__random
	rem $63 $2 10
	add $64 $63 1
	lw $65 8($23)
	la $30 8($23)
	move $65 $64
	sw $65 8($23)
	lw $66 8($23)
	move $4 $66
	jal func__toString
	move $4 $2
	jal func__println
	lw $66 8($23)
	sub $67 $66 1
	bge $40 $67 main_2

# Read: 2 69 23 40 55 72 73 70 30 71 75 76 74 42 77 49
# Write: 69 70 55 72 73 71 30 75 76 74 77 49
main_1_loop:
	jal func__random
	rem $69 $2 10
	add $70 $69 1
	lw $55 12($23)
	mul $72 $40 4
	add $73 $55 $72
	lw $71 0($73)
	la $30 0($73)
	move $71 $70
	sw $71 0($30)
	lw $55 12($23)
	mul $75 $40 4
	add $76 $55 $75
	lw $74 0($76)
	la $30 0($76)
	add $77 $74 $42
	lw $49 0($23)
	ble $77 $49 main_3

# Read: 2 79 23 40 55 82 83 80 30 81
# Write: 79 80 55 82 83 81 30
main_1_loop_loop:
	jal func__random
	rem $79 $2 10
	add $80 $79 1
	lw $55 12($23)
	mul $82 $40 4
	add $83 $55 $82
	lw $81 0($83)
	la $30 0($83)
	move $81 $80
	sw $81 0($30)

# Read: 23 40 55 85 86 84 42 87 49
# Write: 55 85 86 84 30 87 49
main_1_loop_loopTail:
	lw $55 12($23)
	mul $85 $40 4
	add $86 $55 $85
	lw $84 0($86)
	la $30 0($86)
	add $87 $84 $42
	lw $49 0($23)
	bgt $87 $49 main_1_loop_loop

# Read: 23 40 55 90 91 42 89 92
# Write: 55 90 91 89 30 92 42
main_3:
	lw $55 12($23)
	mul $90 $40 4
	add $91 $55 $90
	lw $89 0($91)
	la $30 0($91)
	add $92 $42 $89
	move $42 $92

# Read: 40 23 66 94
# Write: 40 66 94
main_1_loopTail:
	add $40 $40 1
	lw $66 8($23)
	sub $94 $66 1
	blt $40 $94 main_1_loop

# Read: 23 49 42 66 97 55 99 100 96 30 98 2 101
# Write: 49 96 55 66 97 99 100 98 30 101
main_2:
	lw $49 0($23)
	sub $96 $49 $42
	lw $55 12($23)
	lw $66 8($23)
	sub $97 $66 1
	mul $99 $97 4
	add $100 $55 $99
	lw $98 0($100)
	la $30 0($100)
	move $98 $96
	sw $98 0($30)
	jal func__show
	jal func__merge
	jal func__win
	xor $101 $2 1
	beq $101 0 main_4

# Read: 44 2 103 104
# Write: 44 4 5 103 104
main_2_loop:
	lw $3 4($29)
	add $44 $44 1
	sw $31 4($29)
	lw $3 4($29)
	move $4 $44
	jal func__toString
	la $4 String2
	move $5 $2
	jal func__stringConcatenate
	move $103 $2
	move $4 $103
	la $5 String3
	jal func__stringConcatenate
	move $104 $2
	move $4 $104
	jal func__println
	jal func__move
	jal func__merge
	jal func__show

# Read: 2 105
# Write: 105
main_2_loopTail:
	jal func__win
	xor $105 $2 1
	bne $105 0 main_2_loop

# Read: 44 2 106 107 38
# Write: 4 5 106 107 2 31
main_4:
	lw $3 4($29)
	move $4 $44
	jal func__toString
	la $4 String4
	move $5 $2
	jal func__stringConcatenate
	move $106 $2
	move $4 $106
	la $5 String5
	jal func__stringConcatenate
	move $107 $2
	move $4 $107
	jal func__println
	li $2 0
	lw $3 0($29)
	move $31 $38
	add $29 $29 8
	jr $ra
	lw $3 0($29)
	move $31 $38
	add $29 $29 8
	jr $ra

# local: 2 23 32 34 36 31 46 45 47 48 50 52 53 54 35 33 56 57 59 60 62 63 64 65 67 69 72 73 70 30 71 75 76 74 77 79 82 83 80 81 85 86 84 87 90 91 89 92 94 97 99 100 96 98 101 103 104 105 106 107
# localSaved: 49 66 55
# global: 40 42
# Save in address: 38 44
# times: $4: 18  $2: 23  $23: 46  $32: 3  $30: 18  $34: 3  $36: 3  $31: 4  $38: 4  $40: 10  $42: 6  $44: 5  $46: 2  $45: 2  $47: 2  $48: 3  $50: 3  $52: 3  $53: 2  $54: 3  $35: 4  $33: 4  $56: 2  $57: 3  $59: 2  $60: 3  $49: 8  $62: 2  $63: 2  $64: 2  $65: 3  $66: 8  $67: 2  $69: 2  $70: 2  $55: 12  $72: 2  $73: 3  $71: 3  $75: 2  $76: 3  $74: 2  $77: 2  $79: 2  $80: 2  $82: 2  $83: 3  $81: 3  $85: 2  $86: 3  $84: 2  $87: 2  $90: 2  $91: 3  $89: 2  $92: 2  $94: 2  $96: 2  $97: 2  $99: 2  $100: 3  $98: 3  $101: 2  $5: 4  $103: 2  $104: 2  $105: 2  $106: 2  $107: 2 
# Read: 31 23 37 58 33 109 61 111 110 112 113 115
# Write: 108 33 37 58 109 110 61 111 112 113 115
func__random:
	sub $29 $29 8
	move $108 $31
	sw $31 4($29)
	lw $33 16($23)
	lw $37 32($23)
	lw $58 24($23)
	rem $109 $37 $58
	mul $110 $33 $109
	lw $61 28($23)
	lw $37 32($23)
	lw $58 24($23)
	div $111 $37 $58
	mul $112 $61 $111
	sub $113 $110 $112
	move $115 $113
	sw $31 0($29)
	lw $3 0($29)
	bge $115 0 func__random_branch_then

# Read: 23 115 35 117 37
# Write: 35 117 37 30
func__random_branch_else:
	lw $35 20($23)
	lw $3 0($29)
	add $117 $115 $35
	lw $37 32($23)
	la $30 32($23)
	move $37 $117
	sw $37 32($23)
	b func__random_0

# Read: 23 115 118
# Write: 118 30
func__random_branch_then:
	lw $118 32($23)
	la $30 32($23)
	lw $3 0($29)
	move $118 $115
	sw $118 32($23)

# Read: 23 119 108
# Write: 119 2 31
func__random_0:
	lw $119 32($23)
	move $2 $119
	lw $3 4($29)
	move $31 $108
	add $29 $29 8
	jr $ra
	lw $3 4($29)
	move $31 $108
	add $29 $29 8
	jr $ra

# local: 31 23 58 33 109 61 111 110 112 113 35 117 118 119
# localSaved:
# global: 37
# Save in address: 115 108
# times: $31: 3  $108: 3  $23: 14  $33: 2  $37: 7  $58: 4  $109: 2  $110: 2  $61: 2  $111: 2  $112: 2  $113: 2  $115: 4  $35: 2  $117: 2  $30: 2  $118: 3  $119: 2  $2: 1 
# Read: 31 4 23 121 119 120
# Write: 120 121 119 30 31
func__initialize:
	move $120 $31
	move $121 $4
	lw $119 32($23)
	la $30 32($23)
	move $119 $121
	sw $119 32($23)
	move $31 $120
	jr $ra

# local: 31 4 23 121 119 120
# localSaved:
# global:
# Save in address:
# times: $31: 2  $120: 2  $4: 1  $121: 2  $23: 3  $119: 3  $30: 1 
# Read: 31 4 5 23 124 55 127 128 126 125 132 133 135 136 131 30 134 138 139 130 137 123
# Write: 123 124 125 55 127 128 126 30 130 132 133 131 135 136 134 138 139 137 31
func__swap:
	move $123 $31
	move $124 $4
	move $125 $5
	lw $55 12($23)
	mul $127 $124 4
	add $128 $55 $127
	lw $126 0($128)
	la $30 0($128)
	move $130 $126
	lw $55 12($23)
	mul $132 $125 4
	add $133 $55 $132
	lw $131 0($133)
	la $30 0($133)
	lw $55 12($23)
	mul $135 $124 4
	add $136 $55 $135
	lw $134 0($136)
	la $30 0($136)
	move $134 $131
	sw $134 0($30)
	lw $55 12($23)
	mul $138 $125 4
	add $139 $55 $138
	lw $137 0($139)
	la $30 0($139)
	move $137 $130
	sw $137 0($30)
	move $31 $123
	jr $ra

# local: 31 4 5 23 124 127 128 126 125 132 133 135 136 131 30 134 138 139 130 137 123
# localSaved: 55
# global:
# Save in address:
# times: $31: 2  $123: 2  $4: 1  $124: 3  $5: 1  $125: 3  $23: 4  $55: 8  $127: 2  $128: 3  $126: 2  $30: 6  $130: 2  $132: 2  $133: 3  $131: 2  $135: 2  $136: 3  $134: 3  $138: 2  $139: 3  $137: 3 
# Read: 31 4 23 51 141
# Write: 140 141 51
func__pd:
	sub $29 $29 8
	move $140 $31
	sw $31 4($29)
	move $141 $4
	sw $31 0($29)
	lw $51 4($23)
	lw $2 0($29)
	bgt $51 $141 func__pd_0

# Read: 23 51 143 144 141 145
# Write: 51 143 144 145
func__pd_loop:
	lw $51 4($23)
	lw $51 4($23)
	add $143 $51 1
	mul $144 $51 $143
	div $145 $144 2
	lw $3 0($29)
	beq $141 $145 func__pd_loop_branch_then

# Read:
# Write:
func__pd_loop_branch_else:
	b func__pd_1

# Read: 140
# Write: 2 31
func__pd_loop_branch_then:
	li $2 1
	lw $3 4($29)
	move $31 $140
	add $29 $29 8
	jr $ra

# Read:
# Write:
func__pd_1:

# Read: 23 51 141
# Write: 51
func__pd_loopTail:
	lw $51 4($23)
	add $51 $51 1
	sw $51 4($23)
	lw $51 4($23)
	lw $2 0($29)
	ble $51 $141 func__pd_loop

# Read: 140
# Write: 2 31
func__pd_0:
	li $2 0
	lw $3 4($29)
	move $31 $140
	add $29 $29 8
	jr $ra
	lw $3 4($29)
	move $31 $140
	add $29 $29 8
	jr $ra

# local: 31 4 23 51 143 144 145
# localSaved:
# global:
# Save in address: 141 140
# times: $31: 4  $140: 4  $4: 1  $141: 4  $23: 6  $51: 12  $143: 2  $144: 2  $145: 2  $2: 2 
# Read: 31 23 151 66
# Write: 149 151 66
func__show:
	sub $29 $29 4
	move $149 $31
	sw $31 0($29)
	li $151 0
	lw $66 8($23)
	bge $151 $66 func__show_0

# Read: 23 151 55 154 155 153 2 156
# Write: 55 154 155 153 30 4 5 156
func__show_loop:
	lw $55 12($23)
	mul $154 $151 4
	add $155 $55 $154
	lw $153 0($155)
	la $30 0($155)
	move $4 $153
	jal func__toString
	move $4 $2
	la $5 String6
	jal func__stringConcatenate
	move $156 $2
	move $4 $156
	jal func__print

# Read: 151 23 66
# Write: 151 66
func__show_loopTail:
	add $151 $151 1
	lw $66 8($23)
	blt $151 $66 func__show_loop

# Read: 149
# Write: 4 31
func__show_0:
	la $4 String7
	jal func__println
	lw $3 0($29)
	move $31 $149
	add $29 $29 4
	jr $ra

# local: 31 23 154 155 153 2 156
# localSaved: 66 55
# global: 151
# Save in address: 149
# times: $31: 2  $149: 2  $151: 6  $23: 3  $66: 4  $55: 2  $154: 2  $155: 3  $153: 2  $30: 1  $4: 4  $2: 2  $5: 1  $156: 2 
# Read: 31 2 160 161 23 66 51
# Write: 159 4 2 160 161 163 66 51
func__win:
	sub $29 $29 4
	move $159 $31
	sw $31 0($29)
	li $4 4
	li $2 9
	syscall
	li $160 100
	sw $160 0($2)
	mul $4 $160 8
	li $2 9
	syscall
	move $161 $2
	move $163 $161
	lw $66 8($23)
	lw $51 4($23)
	bne $66 $51 func__win_branch_then

# Read:
# Write:
func__win_branch_else:
	b func__win_0

# Read: 159
# Write: 2 31
func__win_branch_then:
	li $2 0
	lw $3 0($29)
	move $31 $159
	add $29 $29 4
	jr $ra

# Read: 23 165 66
# Write: 165 66
func__win_0:
	li $165 0
	lw $66 8($23)
	bge $165 $66 func__win_1

# Read: 23 165 55 168 169 163 171 172 167 30 170
# Write: 55 168 169 167 30 171 172 170
func__win_0_loop:
	lw $55 12($23)
	mul $168 $165 4
	add $169 $55 $168
	lw $167 0($169)
	la $30 0($169)
	mul $171 $165 4
	add $172 $163 $171
	lw $170 0($172)
	la $30 0($172)
	move $170 $167
	sw $170 0($30)

# Read: 165 23 66
# Write: 165 66
func__win_0_loopTail:
	add $165 $165 1
	lw $66 8($23)
	blt $165 $66 func__win_0_loop

# Read: 23 66 175 176
# Write: 175 66 176
func__win_1:
	li $175 0
	lw $66 8($23)
	sub $176 $66 1
	bge $175 $176 func__win_2

# Read: 175 178 23 165 66
# Write: 178 165 66
func__win_1_loop:
	add $178 $175 1
	move $165 $178
	lw $66 8($23)
	bge $165 $66 func__win_3

# Read: 175 163 181 182 165 184 185 180 183
# Write: 181 182 180 30 184 185 183
func__win_1_loop_loop:
	mul $181 $175 4
	add $182 $163 $181
	lw $180 0($182)
	la $30 0($182)
	mul $184 $165 4
	add $185 $163 $184
	lw $183 0($185)
	la $30 0($185)
	bgt $180 $183 func__win_1_loop_loop_branch_then

# Read:
# Write:
func__win_1_loop_loop_branch_else:
	b func__win_4

# Read: 175 163 188 189 187 165 192 193 195 196 191 30 194 198 199 190 197
# Write: 188 189 187 30 190 192 193 191 195 196 194 198 199 197
func__win_1_loop_loop_branch_then:
	mul $188 $175 4
	add $189 $163 $188
	lw $187 0($189)
	la $30 0($189)
	move $190 $187
	mul $192 $165 4
	add $193 $163 $192
	lw $191 0($193)
	la $30 0($193)
	mul $195 $175 4
	add $196 $163 $195
	lw $194 0($196)
	la $30 0($196)
	move $194 $191
	sw $194 0($30)
	mul $198 $165 4
	add $199 $163 $198
	lw $197 0($199)
	la $30 0($199)
	move $197 $190
	sw $197 0($30)

# Read:
# Write:
func__win_4:

# Read: 165 23 66
# Write: 165 66
func__win_1_loop_loopTail:
	add $165 $165 1
	lw $66 8($23)
	blt $165 $66 func__win_1_loop_loop

# Read:
# Write:
func__win_3:

# Read: 175 23 66 203
# Write: 175 66 203
func__win_1_loopTail:
	add $175 $175 1
	lw $66 8($23)
	sub $203 $66 1
	blt $175 $203 func__win_1_loop

# Read: 23 175 66
# Write: 175 66
func__win_2:
	li $175 0
	lw $66 8($23)
	bge $175 $66 func__win_5

# Read: 175 163 207 208 206 209
# Write: 207 208 206 30 209
func__win_2_loop:
	mul $207 $175 4
	add $208 $163 $207
	lw $206 0($208)
	la $30 0($208)
	add $209 $175 1
	bne $206 $209 func__win_2_loop_branch_then

# Read:
# Write:
func__win_2_loop_branch_else:
	b func__win_6

# Read: 159
# Write: 2 31
func__win_2_loop_branch_then:
	li $2 0
	lw $3 0($29)
	move $31 $159
	add $29 $29 4
	jr $ra

# Read:
# Write:
func__win_6:

# Read: 175 23 66
# Write: 175 66
func__win_2_loopTail:
	add $175 $175 1
	lw $66 8($23)
	blt $175 $66 func__win_2_loop

# Read: 159
# Write: 2 31
func__win_5:
	li $2 1
	lw $3 0($29)
	move $31 $159
	add $29 $29 4
	jr $ra
	lw $3 0($29)
	move $31 $159
	add $29 $29 4
	jr $ra

# local: 31 2 160 161 23 51 168 169 171 172 167 30 170 176 178 181 182 184 185 180 183 188 189 187 192 193 195 196 191 194 198 199 190 197 203 207 208 206 209
# localSaved: 66 165 55 163 175
# global:
# Save in address: 159
# times: $31: 5  $159: 5  $4: 2  $2: 7  $160: 3  $161: 2  $163: 9  $23: 11  $66: 18  $51: 2  $165: 15  $55: 2  $168: 2  $169: 3  $167: 2  $30: 12  $171: 2  $172: 3  $170: 3  $175: 16  $176: 2  $178: 2  $181: 2  $182: 3  $180: 2  $184: 2  $185: 3  $183: 2  $188: 2  $189: 3  $187: 2  $190: 2  $192: 2  $193: 3  $191: 2  $195: 2  $196: 3  $194: 3  $198: 2  $199: 3  $197: 3  $203: 2  $207: 2  $208: 3  $206: 2  $209: 2 
# Read: 31 23 215 66
# Write: 213 215 66
func__merge:
	sub $29 $29 4
	move $213 $31
	sw $31 0($29)
	li $215 0
	lw $66 8($23)
	bge $215 $66 func__merge_0

# Read: 23 215 55 218 219 217
# Write: 55 218 219 217 30
func__merge_loop:
	lw $55 12($23)
	mul $218 $215 4
	add $219 $55 $218
	lw $217 0($219)
	la $30 0($219)
	beq $217 0 func__merge_loop_branch_then

# Read:
# Write:
func__merge_loop_branch_else:
	b func__merge_1

# Read: 215 221 23 223 66
# Write: 221 223 66
func__merge_loop_branch_then:
	add $221 $215 1
	move $223 $221
	lw $66 8($23)
	bge $223 $66 func__merge_2

# Read: 23 223 55 226 227 225
# Write: 55 226 227 225 30
func__merge_loop_branch_then_loop:
	lw $55 12($23)
	mul $226 $223 4
	add $227 $55 $226
	lw $225 0($227)
	la $30 0($227)
	bne $225 0 func__merge_loop_branch_then_loop_branch_then

# Read:
# Write:
func__merge_loop_branch_then_loop_branch_else:
	b func__merge_3

# Read: 215 223
# Write: 4 5
func__merge_loop_branch_then_loop_branch_then:
	move $4 $215
	move $5 $223
	jal func__swap
	b func__merge_2

# Read:
# Write:
func__merge_3:

# Read: 223 23 66
# Write: 223 66
func__merge_loop_branch_then_loopTail:
	add $223 $223 1
	lw $66 8($23)
	blt $223 $66 func__merge_loop_branch_then_loop

# Read:
# Write:
func__merge_2:

# Read:
# Write:
func__merge_1:

# Read: 215 23 66
# Write: 215 66
func__merge_loopTail:
	add $215 $215 1
	lw $66 8($23)
	blt $215 $66 func__merge_loop

# Read: 23 215 66
# Write: 215 66
func__merge_0:
	li $215 0
	lw $66 8($23)
	bge $215 $66 func__merge_4

# Read: 23 215 55 235 236 234
# Write: 55 235 236 234 30
func__merge_0_loop:
	lw $55 12($23)
	mul $235 $215 4
	add $236 $55 $235
	lw $234 0($236)
	la $30 0($236)
	beq $234 0 func__merge_0_loop_branch_then

# Read:
# Write:
func__merge_0_loop_branch_else:
	b func__merge_5

# Read: 23 215 66
# Write: 66 30
func__merge_0_loop_branch_then:
	lw $66 8($23)
	la $30 8($23)
	move $66 $215
	sw $66 8($23)
	b func__merge_0

# Read:
# Write:
func__merge_5:

# Read: 215 23 238
# Write: 215 238
func__merge_0_loopTail:
	add $215 $215 1
	lw $238 8($23)
	blt $215 $238 func__merge_0_loop

# Read: 213
# Write: 31
func__merge_4:
	lw $3 0($29)
	move $31 $213
	add $29 $29 4
	jr $ra

# local: 31 23 218 219 217 221 226 227 225 235 236 234
# localSaved: 66 55 238
# global: 215 223
# Save in address: 213
# times: $31: 2  $213: 2  $215: 15  $23: 12  $66: 13  $55: 6  $218: 2  $219: 3  $217: 2  $30: 4  $221: 2  $223: 7  $226: 2  $227: 3  $225: 2  $4: 1  $5: 1  $235: 2  $236: 3  $234: 2  $238: 2 
# Read: 31 23 243 238
# Write: 241 243 238
func__move:
	sub $29 $29 4
	move $241 $31
	sw $31 0($29)
	li $243 0
	lw $238 8($23)
	bge $243 $238 func__move_0

# Read: 23 243 55 246 247 245 30 249
# Write: 55 246 247 245 30 249 243
func__move_loop:
	lw $55 12($23)
	mul $246 $243 4
	add $247 $55 $246
	lw $245 0($247)
	la $30 0($247)
	sub $245 $245 1
	sw $245 0($30)
	add $249 $243 1
	move $243 $249

# Read: 23 243 238
# Write: 238
func__move_loopTail:
	lw $238 8($23)
	blt $243 $238 func__move_loop

# Read: 23 238 55 252 253 30 251 241
# Write: 238 55 252 253 251 30 31
func__move_0:
	lw $238 8($23)
	lw $55 12($23)
	lw $238 8($23)
	mul $252 $238 4
	add $253 $55 $252
	lw $251 0($253)
	la $30 0($253)
	move $251 $238
	sw $251 0($30)
	lw $238 8($23)
	add $238 $238 1
	sw $238 8($23)
	lw $3 0($29)
	move $31 $241
	add $29 $29 4
	jr $ra

# local: 31 23 246 247 245 30 249 252 253 251
# localSaved: 238 55
# global: 243
# Save in address: 241
# times: $31: 2  $241: 2  $243: 6  $23: 8  $238: 12  $55: 4  $246: 2  $247: 3  $245: 4  $30: 4  $249: 2  $252: 2  $253: 3  $251: 3 
# local: 2 23 32 34 36 31 46 45 47 48 50 52 53 54 35 33 56 57 59 60 62 63 64 65 67 69 72 73 70 30 71 75 76 74 77 79 82 83 80 81 85 86 84 87 90 91 89 92 94 97 99 100 96 98 101 103 104 105 106 107 58 109 61 111 110 112 113 117 118 119 4 121 120 5 124 127 128 126 125 132 133 135 136 131 134 138 139 130 137 123 51 143 144 145 154 155 153 156 160 161 168 169 171 172 167 170 176 178 181 182 184 185 180 183 188 189 187 192 193 195 196 191 194 198 199 190 197 203 207 208 206 209 218 219 217 221 226 227 225 235 236 234 246 247 245 249 252 253 251
# localSaved: 49 66 55 165 163 175 238
# global: 40 42 37 151 215 223 243
# Save in address: 38 44 115 108 141 140 149 159 213 241
# times: $4: 28  $2: 35  $23: 107  $32: 3  $30: 48  $34: 3  $36: 3  $31: 26  $38: 4  $40: 10  $42: 6  $44: 5  $46: 2  $45: 2  $47: 2  $48: 3  $50: 3  $52: 3  $53: 2  $54: 3  $35: 6  $33: 6  $56: 2  $57: 3  $59: 2  $60: 3  $49: 8  $62: 2  $63: 2  $64: 2  $65: 3  $66: 43  $67: 2  $69: 2  $70: 2  $55: 34  $72: 2  $73: 3  $71: 3  $75: 2  $76: 3  $74: 2  $77: 2  $79: 2  $80: 2  $82: 2  $83: 3  $81: 3  $85: 2  $86: 3  $84: 2  $87: 2  $90: 2  $91: 3  $89: 2  $92: 2  $94: 2  $96: 2  $97: 2  $99: 2  $100: 3  $98: 3  $101: 2  $5: 7  $103: 2  $104: 2  $105: 2  $106: 2  $107: 2  $108: 3  $37: 7  $58: 4  $109: 2  $110: 2  $61: 2  $111: 2  $112: 2  $113: 2  $115: 4  $117: 2  $118: 3  $119: 5  $120: 2  $121: 2  $123: 2  $124: 3  $125: 3  $127: 2  $128: 3  $126: 2  $130: 2  $132: 2  $133: 3  $131: 2  $135: 2  $136: 3  $134: 3  $138: 2  $139: 3  $137: 3  $140: 4  $141: 4  $51: 14  $143: 2  $144: 2  $145: 2  $149: 2  $151: 6  $154: 2  $155: 3  $153: 2  $156: 2  $159: 5  $160: 3  $161: 2  $163: 9  $165: 15  $168: 2  $169: 3  $167: 2  $171: 2  $172: 3  $170: 3  $175: 16  $176: 2  $178: 2  $181: 2  $182: 3  $180: 2  $184: 2  $185: 3  $183: 2  $188: 2  $189: 3  $187: 2  $190: 2  $192: 2  $193: 3  $191: 2  $195: 2  $196: 3  $194: 3  $198: 2  $199: 3  $197: 3  $203: 2  $207: 2  $208: 3  $206: 2  $209: 2  $213: 2  $215: 15  $218: 2  $219: 3  $217: 2  $221: 2  $223: 7  $226: 2  $227: 3  $225: 2  $235: 2  $236: 3  $234: 2  $238: 14  $241: 2  $243: 6  $246: 2  $247: 3  $245: 4  $249: 2  $252: 2  $253: 3  $251: 3 
