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

# Read:
# Write:
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
	li $32 12000
	sw $32 0($2)
	mul $4 $32 8
	li $2 9
	syscall
	move $33 $2
	lw $34 32($23)
	la $30 32($23)
	move $34 $33
	sw $34 32($23)
	li $4 4
	li $2 9
	syscall
	li $36 12000
	sw $36 0($2)
	mul $4 $36 8
	li $2 9
	syscall
	move $37 $2
	lw $38 36($23)
	la $30 36($23)
	move $38 $37
	sw $38 36($23)
	jal main_0
	li $2 10
	syscall

# Read:
# Write:
main_0:
	move $40 $31
	li $4 106
	jal func__origin
	jal func__getInt
	lw $41 0($23)
	la $30 0($23)
	move $41 $2
	sw $41 0($23)
	lw $42 0($23)
	sub $43 $42 1
	lw $44 20($23)
	la $30 20($23)
	move $44 $43
	sw $44 20($23)
	lw $46 16($23)
	la $30 16($23)
	move $46 $44
	sw $46 16($23)
	lw $48 56($23)
	la $30 56($23)
	li $48 0
	sw $48 56($23)
	lw $49 56($23)
	lw $42 0($23)
	slt $50 $49 $42
	beq $50 0 main_0_next

# Read:
# Write:
main_0_loop:
	lw $51 60($23)
	la $30 60($23)
	li $51 0
	sw $51 60($23)
	lw $52 60($23)
	lw $42 0($23)
	slt $53 $52 $42
	beq $53 0 main_0_loop_next

# Read:
# Write:
main_0_loop_loop:
	li $55 1
	neg $54 $55
	lw $56 52($23)
	lw $49 56($23)
	mul $58 $49 4
	add $59 $56 $58
	lw $57 0($59)
	lw $52 60($23)
	mul $61 $52 4
	add $62 $57 $61
	lw $60 0($62)
	la $30 0($62)
	move $60 $54
	sw $60 0($30)

# Read:
# Write:
main_0_loop_loopTail:
	lw $52 60($23)
	add $52 $52 1
	sw $52 60($23)
	lw $52 60($23)
	lw $42 0($23)
	slt $64 $52 $42
	bne $64 0 main_0_loop_loop

# Read:
# Write:
main_0_loop_next:

# Read:
# Write:
main_0_loopTail:
	lw $49 56($23)
	add $49 $49 1
	sw $49 56($23)
	lw $49 56($23)
	lw $42 0($23)
	slt $66 $49 $42
	bne $66 0 main_0_loop

# Read:
# Write:
main_0_next:
	lw $67 4($23)
	lw $68 40($23)
	sle $69 $67 $68
	beq $69 0 main_0_next_next

# Read:
# Write:
main_0_next_loop:
	lw $35 32($23)
	lw $67 4($23)
	mul $71 $67 4
	add $72 $35 $71
	lw $70 0($72)
	la $30 0($72)
	lw $73 24($23)
	la $30 24($23)
	move $73 $70
	sw $73 24($23)
	lw $39 36($23)
	lw $67 4($23)
	mul $76 $67 4
	add $77 $39 $76
	lw $75 0($77)
	la $30 0($77)
	lw $78 28($23)
	la $30 28($23)
	move $78 $75
	sw $78 28($23)
	lw $56 52($23)
	lw $74 24($23)
	mul $81 $74 4
	add $82 $56 $81
	lw $80 0($82)
	lw $79 28($23)
	mul $84 $79 4
	add $85 $80 $84
	lw $83 0($85)
	la $30 0($85)
	lw $86 48($23)
	la $30 48($23)
	move $86 $83
	sw $86 48($23)
	lw $74 24($23)
	sub $88 $74 1
	move $4 $88
	lw $79 28($23)
	sub $89 $79 2
	move $5 $89
	jal func__addList
	lw $74 24($23)
	sub $90 $74 1
	move $4 $90
	lw $79 28($23)
	add $91 $79 2
	move $5 $91
	jal func__addList
	lw $74 24($23)
	add $92 $74 1
	move $4 $92
	lw $79 28($23)
	sub $93 $79 2
	move $5 $93
	jal func__addList
	lw $74 24($23)
	add $94 $74 1
	move $4 $94
	lw $79 28($23)
	add $95 $79 2
	move $5 $95
	jal func__addList
	lw $74 24($23)
	sub $96 $74 2
	move $4 $96
	lw $79 28($23)
	sub $97 $79 1
	move $5 $97
	jal func__addList
	lw $74 24($23)
	sub $98 $74 2
	move $4 $98
	lw $79 28($23)
	add $99 $79 1
	move $5 $99
	jal func__addList
	lw $74 24($23)
	add $100 $74 2
	move $4 $100
	lw $79 28($23)
	sub $101 $79 1
	move $5 $101
	jal func__addList
	lw $74 24($23)
	add $102 $74 2
	move $4 $102
	lw $79 28($23)
	add $103 $79 1
	move $5 $103
	jal func__addList
	lw $104 44($23)
	seq $105 $104 1
	bne $105 0 main_0_next_loop_branch_then

# Read:
# Write:
main_0_next_loop_branch_else:
	b main_0_next_loop_next

# Read:
# Write:
main_0_next_loop_branch_then:
	b main_0_next_next

# Read:
# Write:
main_0_next_loop_next:
	lw $67 4($23)
	add $106 $67 1
	lw $67 4($23)
	la $30 4($23)
	move $67 $106
	sw $67 4($23)

# Read:
# Write:
main_0_next_loopTail:
	lw $107 4($23)
	lw $68 40($23)
	sle $108 $107 $68
	bne $108 0 main_0_next_loop

# Read:
# Write:
main_0_next_next:
	lw $104 44($23)
	seq $109 $104 1
	bne $109 0 main_0_next_next_branch_then

# Read:
# Write:
main_0_next_next_branch_else:
	la $4 String0
	jal func__print
	b main_0_next_next_next

# Read:
# Write:
main_0_next_next_branch_then:
	lw $56 52($23)
	lw $47 16($23)
	mul $111 $47 4
	add $112 $56 $111
	lw $110 0($112)
	lw $45 20($23)
	mul $114 $45 4
	add $115 $110 $114
	lw $113 0($115)
	la $30 0($115)
	move $4 $113
	jal func__toString
	move $4 $2
	jal func__println

# Read:
# Write:
main_0_next_next_next:
	li $2 0
	move $31 $40
	jr $ra
	move $31 $40
	jr $ra

# local:
# localSaved:
# global:
# Save in address:
# times:
# Read:
# Write:
func__origin:
	move $116 $31
	move $117 $4
	li $4 4
	li $2 9
	syscall
	sw $117 0($2)
	mul $4 $117 8
	li $2 9
	syscall
	move $118 $2
	lw $56 52($23)
	la $30 52($23)
	move $56 $118
	sw $56 52($23)
	lw $49 56($23)
	la $30 56($23)
	li $49 0
	sw $49 56($23)
	lw $120 56($23)
	slt $121 $120 $117
	beq $121 0 func__origin_next

# Read:
# Write:
func__origin_loop:
	li $4 4
	li $2 9
	syscall
	sw $117 0($2)
	mul $4 $117 8
	li $2 9
	syscall
	move $122 $2
	lw $119 52($23)
	lw $120 56($23)
	mul $124 $120 4
	add $125 $119 $124
	lw $123 0($125)
	la $30 0($125)
	move $123 $122
	sw $123 0($30)
	lw $52 60($23)
	la $30 60($23)
	li $52 0
	sw $52 60($23)
	lw $126 60($23)
	slt $127 $126 $117
	beq $127 0 func__origin_loop_next

# Read:
# Write:
func__origin_loop_loop:
	lw $119 52($23)
	lw $120 56($23)
	mul $129 $120 4
	add $130 $119 $129
	lw $128 0($130)
	lw $126 60($23)
	mul $132 $126 4
	add $133 $128 $132
	lw $131 0($133)
	la $30 0($133)
	li $131 0
	sw $131 0($30)

# Read:
# Write:
func__origin_loop_loopTail:
	lw $126 60($23)
	add $126 $126 1
	sw $126 60($23)
	lw $126 60($23)
	slt $135 $126 $117
	bne $135 0 func__origin_loop_loop

# Read:
# Write:
func__origin_loop_next:

# Read:
# Write:
func__origin_loopTail:
	lw $120 56($23)
	add $120 $120 1
	sw $120 56($23)
	lw $120 56($23)
	slt $137 $120 $117
	bne $137 0 func__origin_loop

# Read:
# Write:
func__origin_next:
	move $31 $116
	jr $ra

# local:
# localSaved:
# global:
# Save in address:
# times:
# Read:
# Write:
func__check:
	move $138 $31
	move $139 $4
	move $140 $5
	slt $141 $139 $140
	sge $142 $139 0
	and $143 $141 $142
	move $2 $143
	move $31 $138
	jr $ra
	move $31 $138
	jr $ra

# local:
# localSaved:
# global:
# Save in address:
# times:
# Read:
# Write:
func__addList:
	move $144 $31
	move $145 $4
	move $146 $5
	move $4 $145
	lw $42 0($23)
	move $5 $42
	jal func__check
	move $4 $146
	lw $42 0($23)
	move $5 $42
	jal func__check
	and $147 $2 $2
	lw $119 52($23)
	mul $149 $145 4
	add $150 $119 $149
	lw $148 0($150)
	mul $152 $146 4
	add $153 $148 $152
	lw $151 0($153)
	la $30 0($153)
	li $155 1
	neg $154 $155
	seq $156 $151 $154
	and $157 $147 $156
	bne $157 0 func__addList_branch_then

# Read:
# Write:
func__addList_branch_else:
	b func__addList_next

# Read:
# Write:
func__addList_branch_then:
	lw $68 40($23)
	add $158 $68 1
	lw $68 40($23)
	la $30 40($23)
	move $68 $158
	sw $68 40($23)
	lw $35 32($23)
	lw $159 40($23)
	mul $161 $159 4
	add $162 $35 $161
	lw $160 0($162)
	la $30 0($162)
	move $160 $145
	sw $160 0($30)
	lw $39 36($23)
	lw $159 40($23)
	mul $164 $159 4
	add $165 $39 $164
	lw $163 0($165)
	la $30 0($165)
	move $163 $146
	sw $163 0($30)
	lw $87 48($23)
	add $166 $87 1
	lw $119 52($23)
	mul $168 $145 4
	add $169 $119 $168
	lw $167 0($169)
	mul $171 $146 4
	add $172 $167 $171
	lw $170 0($172)
	la $30 0($172)
	move $170 $166
	sw $170 0($30)
	lw $47 16($23)
	seq $173 $145 $47
	lw $45 20($23)
	seq $174 $146 $45
	and $175 $173 $174
	bne $175 0 func__addList_branch_then_branch_then

# Read:
# Write:
func__addList_branch_then_branch_else:
	b func__addList_branch_then_next

# Read:
# Write:
func__addList_branch_then_branch_then:
	lw $104 44($23)
	la $30 44($23)
	li $104 1
	sw $104 44($23)

# Read:
# Write:
func__addList_branch_then_next:

# Read:
# Write:
func__addList_next:
	move $31 $144
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
