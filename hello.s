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

# Read:
# Write:
main:
	li $4 4
	li $2 9
	syscall
	li $4 12
	li $2 9
	syscall
	move $23 $2
	lw $32 0($23)
	la $30 0($23)
	li $32 1
	sw $32 0($23)
	lw $34 4($23)
	la $30 4($23)
	li $34 1
	sw $34 4($23)
	lw $36 8($23)
	la $30 8($23)
	li $36 1
	sw $36 8($23)
	jal main_0
	li $2 10
	syscall

# Read:
# Write:
main_0:
	move $38 $31
	lw $37 8($23)
	li $40 1
	sll $39 $40 29
	slt $41 $37 $39
	lw $37 8($23)
	li $43 1
	sll $42 $43 29
	neg $44 $42
	sgt $45 $37 $44
	and $46 $41 $45
	beq $46 0 main_1

# Read:
# Write:
main_0_loop:
	lw $37 8($23)
	lw $33 0($23)
	sub $47 $37 $33
	lw $35 4($23)
	add $48 $47 $35
	lw $33 0($23)
	lw $35 4($23)
	add $49 $33 $35
	sub $50 $48 $49
	lw $37 8($23)
	lw $33 0($23)
	sub $51 $37 $33
	lw $35 4($23)
	add $52 $51 $35
	lw $33 0($23)
	lw $35 4($23)
	add $53 $33 $35
	sub $54 $52 $53
	add $55 $50 $54
	lw $37 8($23)
	lw $33 0($23)
	sub $56 $37 $33
	lw $35 4($23)
	add $57 $56 $35
	lw $33 0($23)
	lw $35 4($23)
	add $58 $33 $35
	sub $59 $57 $58
	lw $37 8($23)
	lw $33 0($23)
	sub $60 $37 $33
	lw $35 4($23)
	add $61 $60 $35
	add $62 $59 $61
	add $63 $55 $62
	lw $33 0($23)
	lw $35 4($23)
	add $64 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $65 $37 $33
	lw $35 4($23)
	add $66 $65 $35
	add $67 $64 $66
	lw $33 0($23)
	lw $35 4($23)
	add $68 $33 $35
	sub $69 $67 $68
	lw $37 8($23)
	lw $33 0($23)
	sub $70 $37 $33
	lw $35 4($23)
	add $71 $70 $35
	lw $33 0($23)
	lw $35 4($23)
	add $72 $33 $35
	sub $73 $71 $72
	lw $37 8($23)
	lw $33 0($23)
	sub $74 $37 $33
	lw $35 4($23)
	add $75 $74 $35
	add $76 $73 $75
	add $77 $69 $76
	sub $78 $63 $77
	lw $33 0($23)
	lw $35 4($23)
	add $79 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $80 $37 $33
	lw $35 4($23)
	add $81 $80 $35
	add $82 $79 $81
	lw $33 0($23)
	lw $35 4($23)
	add $83 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $84 $37 $33
	lw $35 4($23)
	add $85 $84 $35
	add $86 $83 $85
	sub $87 $82 $86
	lw $33 0($23)
	lw $35 4($23)
	add $88 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $89 $37 $33
	lw $35 4($23)
	add $90 $89 $35
	add $91 $88 $90
	lw $33 0($23)
	lw $35 4($23)
	add $92 $33 $35
	sub $93 $91 $92
	sub $94 $87 $93
	lw $37 8($23)
	lw $33 0($23)
	sub $95 $37 $33
	lw $35 4($23)
	add $96 $95 $35
	lw $33 0($23)
	lw $35 4($23)
	add $97 $33 $35
	sub $98 $96 $97
	lw $37 8($23)
	lw $33 0($23)
	sub $99 $37 $33
	lw $35 4($23)
	add $100 $99 $35
	add $101 $98 $100
	lw $33 0($23)
	lw $35 4($23)
	add $102 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $103 $37 $33
	lw $35 4($23)
	add $104 $103 $35
	add $105 $102 $104
	lw $33 0($23)
	lw $35 4($23)
	add $106 $33 $35
	sub $107 $105 $106
	sub $108 $101 $107
	add $109 $94 $108
	sub $110 $78 $109
	lw $37 8($23)
	lw $33 0($23)
	sub $111 $37 $33
	lw $35 4($23)
	add $112 $111 $35
	lw $33 0($23)
	lw $35 4($23)
	add $113 $33 $35
	sub $114 $112 $113
	lw $37 8($23)
	lw $33 0($23)
	sub $115 $37 $33
	lw $35 4($23)
	add $116 $115 $35
	lw $33 0($23)
	lw $35 4($23)
	add $117 $33 $35
	sub $118 $116 $117
	add $119 $114 $118
	lw $37 8($23)
	lw $33 0($23)
	sub $120 $37 $33
	lw $35 4($23)
	add $121 $120 $35
	lw $33 0($23)
	lw $35 4($23)
	add $122 $33 $35
	sub $123 $121 $122
	lw $37 8($23)
	lw $33 0($23)
	sub $124 $37 $33
	lw $35 4($23)
	add $125 $124 $35
	add $126 $123 $125
	add $127 $119 $126
	lw $33 0($23)
	lw $35 4($23)
	add $128 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $129 $37 $33
	lw $35 4($23)
	add $130 $129 $35
	add $131 $128 $130
	lw $33 0($23)
	lw $35 4($23)
	add $132 $33 $35
	sub $133 $131 $132
	lw $37 8($23)
	lw $33 0($23)
	sub $134 $37 $33
	lw $35 4($23)
	add $135 $134 $35
	lw $33 0($23)
	lw $35 4($23)
	add $136 $33 $35
	sub $137 $135 $136
	lw $37 8($23)
	lw $33 0($23)
	sub $138 $37 $33
	lw $35 4($23)
	add $139 $138 $35
	add $140 $137 $139
	add $141 $133 $140
	sub $142 $127 $141
	lw $33 0($23)
	lw $35 4($23)
	add $143 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $144 $37 $33
	lw $35 4($23)
	add $145 $144 $35
	add $146 $143 $145
	lw $33 0($23)
	lw $35 4($23)
	add $147 $33 $35
	sub $148 $146 $147
	lw $37 8($23)
	lw $33 0($23)
	sub $149 $37 $33
	lw $35 4($23)
	add $150 $149 $35
	lw $33 0($23)
	lw $35 4($23)
	add $151 $33 $35
	sub $152 $150 $151
	lw $37 8($23)
	lw $33 0($23)
	sub $153 $37 $33
	lw $35 4($23)
	add $154 $153 $35
	add $155 $152 $154
	add $156 $148 $155
	lw $33 0($23)
	lw $35 4($23)
	add $157 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $158 $37 $33
	lw $35 4($23)
	add $159 $158 $35
	add $160 $157 $159
	lw $33 0($23)
	lw $35 4($23)
	add $161 $33 $35
	sub $162 $160 $161
	lw $37 8($23)
	lw $33 0($23)
	sub $163 $37 $33
	lw $35 4($23)
	add $164 $163 $35
	lw $33 0($23)
	lw $35 4($23)
	add $165 $33 $35
	sub $166 $164 $165
	lw $37 8($23)
	lw $33 0($23)
	sub $167 $37 $33
	lw $35 4($23)
	add $168 $167 $35
	add $169 $166 $168
	add $170 $162 $169
	sub $171 $156 $170
	sub $172 $142 $171
	add $173 $110 $172
	lw $33 0($23)
	lw $35 4($23)
	add $174 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $175 $37 $33
	lw $35 4($23)
	add $176 $175 $35
	add $177 $174 $176
	lw $33 0($23)
	lw $35 4($23)
	add $178 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $179 $37 $33
	lw $35 4($23)
	add $180 $179 $35
	add $181 $178 $180
	sub $182 $177 $181
	lw $33 0($23)
	lw $35 4($23)
	add $183 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $184 $37 $33
	lw $35 4($23)
	add $185 $184 $35
	add $186 $183 $185
	lw $33 0($23)
	lw $35 4($23)
	add $187 $33 $35
	sub $188 $186 $187
	sub $189 $182 $188
	lw $37 8($23)
	lw $33 0($23)
	sub $190 $37 $33
	lw $35 4($23)
	add $191 $190 $35
	lw $33 0($23)
	lw $35 4($23)
	add $192 $33 $35
	sub $193 $191 $192
	lw $37 8($23)
	lw $33 0($23)
	sub $194 $37 $33
	lw $35 4($23)
	add $195 $194 $35
	add $196 $193 $195
	lw $33 0($23)
	lw $35 4($23)
	add $197 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $198 $37 $33
	lw $35 4($23)
	add $199 $198 $35
	add $200 $197 $199
	lw $33 0($23)
	lw $35 4($23)
	add $201 $33 $35
	sub $202 $200 $201
	sub $203 $196 $202
	add $204 $189 $203
	lw $37 8($23)
	lw $33 0($23)
	sub $205 $37 $33
	lw $35 4($23)
	add $206 $205 $35
	lw $33 0($23)
	lw $35 4($23)
	add $207 $33 $35
	sub $208 $206 $207
	lw $37 8($23)
	lw $33 0($23)
	sub $209 $37 $33
	lw $35 4($23)
	add $210 $209 $35
	add $211 $208 $210
	lw $33 0($23)
	lw $35 4($23)
	add $212 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $213 $37 $33
	lw $35 4($23)
	add $214 $213 $35
	add $215 $212 $214
	lw $33 0($23)
	lw $35 4($23)
	add $216 $33 $35
	sub $217 $215 $216
	sub $218 $211 $217
	lw $37 8($23)
	lw $33 0($23)
	sub $219 $37 $33
	lw $35 4($23)
	add $220 $219 $35
	lw $33 0($23)
	lw $35 4($23)
	add $221 $33 $35
	sub $222 $220 $221
	lw $37 8($23)
	lw $33 0($23)
	sub $223 $37 $33
	lw $35 4($23)
	add $224 $223 $35
	add $225 $222 $224
	lw $33 0($23)
	lw $35 4($23)
	add $226 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $227 $37 $33
	lw $35 4($23)
	add $228 $227 $35
	add $229 $226 $228
	lw $33 0($23)
	lw $35 4($23)
	add $230 $33 $35
	sub $231 $229 $230
	sub $232 $225 $231
	add $233 $218 $232
	add $234 $204 $233
	lw $37 8($23)
	lw $33 0($23)
	sub $235 $37 $33
	lw $35 4($23)
	add $236 $235 $35
	lw $33 0($23)
	lw $35 4($23)
	add $237 $33 $35
	sub $238 $236 $237
	lw $37 8($23)
	lw $33 0($23)
	sub $239 $37 $33
	lw $35 4($23)
	add $240 $239 $35
	lw $33 0($23)
	lw $35 4($23)
	add $241 $33 $35
	sub $242 $240 $241
	add $243 $238 $242
	lw $37 8($23)
	lw $33 0($23)
	sub $244 $37 $33
	lw $35 4($23)
	add $245 $244 $35
	lw $33 0($23)
	lw $35 4($23)
	add $246 $33 $35
	sub $247 $245 $246
	lw $37 8($23)
	lw $33 0($23)
	sub $248 $37 $33
	lw $35 4($23)
	add $249 $248 $35
	add $250 $247 $249
	add $251 $243 $250
	lw $33 0($23)
	lw $35 4($23)
	add $252 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $253 $37 $33
	lw $35 4($23)
	add $254 $253 $35
	add $255 $252 $254
	lw $33 0($23)
	lw $35 4($23)
	add $256 $33 $35
	sub $257 $255 $256
	lw $37 8($23)
	lw $33 0($23)
	sub $258 $37 $33
	lw $35 4($23)
	add $259 $258 $35
	lw $33 0($23)
	lw $35 4($23)
	add $260 $33 $35
	sub $261 $259 $260
	lw $37 8($23)
	lw $33 0($23)
	sub $262 $37 $33
	lw $35 4($23)
	add $263 $262 $35
	add $264 $261 $263
	add $265 $257 $264
	sub $266 $251 $265
	lw $33 0($23)
	lw $35 4($23)
	add $267 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $268 $37 $33
	lw $35 4($23)
	add $269 $268 $35
	add $270 $267 $269
	lw $33 0($23)
	lw $35 4($23)
	add $271 $33 $35
	sub $272 $270 $271
	lw $37 8($23)
	lw $33 0($23)
	sub $273 $37 $33
	lw $35 4($23)
	add $274 $273 $35
	lw $33 0($23)
	lw $35 4($23)
	add $275 $33 $35
	sub $276 $274 $275
	lw $37 8($23)
	lw $33 0($23)
	sub $277 $37 $33
	lw $35 4($23)
	add $278 $277 $35
	add $279 $276 $278
	add $280 $272 $279
	lw $33 0($23)
	lw $35 4($23)
	add $281 $33 $35
	lw $37 8($23)
	lw $33 0($23)
	sub $282 $37 $33
	lw $35 4($23)
	add $283 $282 $35
	add $284 $281 $283
	lw $33 0($23)
	lw $35 4($23)
	add $285 $33 $35
	sub $286 $284 $285
	lw $37 8($23)
	lw $33 0($23)
	sub $287 $37 $33
	lw $35 4($23)
	add $288 $287 $35
	lw $33 0($23)
	lw $35 4($23)
	add $289 $33 $35
	sub $290 $288 $289
	lw $37 8($23)
	lw $33 0($23)
	sub $291 $37 $33
	lw $35 4($23)
	add $292 $291 $35
	add $293 $290 $292
	add $294 $286 $293
	sub $295 $280 $294
	sub $296 $266 $295
	add $297 $234 $296
	sub $298 $173 $297
	lw $33 0($23)
	la $30 0($23)
	move $33 $298
	sw $33 0($23)
	lw $37 8($23)
	lw $299 0($23)
	sub $300 $37 $299
	lw $35 4($23)
	add $301 $300 $35
	lw $299 0($23)
	lw $35 4($23)
	add $302 $299 $35
	sub $303 $301 $302
	lw $37 8($23)
	lw $299 0($23)
	sub $304 $37 $299
	lw $35 4($23)
	add $305 $304 $35
	lw $299 0($23)
	lw $35 4($23)
	add $306 $299 $35
	sub $307 $305 $306
	add $308 $303 $307
	lw $37 8($23)
	lw $299 0($23)
	sub $309 $37 $299
	lw $35 4($23)
	add $310 $309 $35
	lw $299 0($23)
	lw $35 4($23)
	add $311 $299 $35
	sub $312 $310 $311
	lw $37 8($23)
	lw $299 0($23)
	sub $313 $37 $299
	lw $35 4($23)
	add $314 $313 $35
	add $315 $312 $314
	add $316 $308 $315
	lw $299 0($23)
	lw $35 4($23)
	add $317 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $318 $37 $299
	lw $35 4($23)
	add $319 $318 $35
	add $320 $317 $319
	lw $299 0($23)
	lw $35 4($23)
	add $321 $299 $35
	sub $322 $320 $321
	lw $37 8($23)
	lw $299 0($23)
	sub $323 $37 $299
	lw $35 4($23)
	add $324 $323 $35
	lw $299 0($23)
	lw $35 4($23)
	add $325 $299 $35
	sub $326 $324 $325
	lw $37 8($23)
	lw $299 0($23)
	sub $327 $37 $299
	lw $35 4($23)
	add $328 $327 $35
	add $329 $326 $328
	add $330 $322 $329
	sub $331 $316 $330
	lw $299 0($23)
	lw $35 4($23)
	add $332 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $333 $37 $299
	lw $35 4($23)
	add $334 $333 $35
	add $335 $332 $334
	lw $299 0($23)
	lw $35 4($23)
	add $336 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $337 $37 $299
	lw $35 4($23)
	add $338 $337 $35
	add $339 $336 $338
	sub $340 $335 $339
	lw $299 0($23)
	lw $35 4($23)
	add $341 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $342 $37 $299
	lw $35 4($23)
	add $343 $342 $35
	add $344 $341 $343
	lw $299 0($23)
	lw $35 4($23)
	add $345 $299 $35
	sub $346 $344 $345
	sub $347 $340 $346
	lw $37 8($23)
	lw $299 0($23)
	sub $348 $37 $299
	lw $35 4($23)
	add $349 $348 $35
	lw $299 0($23)
	lw $35 4($23)
	add $350 $299 $35
	sub $351 $349 $350
	lw $37 8($23)
	lw $299 0($23)
	sub $352 $37 $299
	lw $35 4($23)
	add $353 $352 $35
	add $354 $351 $353
	lw $299 0($23)
	lw $35 4($23)
	add $355 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $356 $37 $299
	lw $35 4($23)
	add $357 $356 $35
	add $358 $355 $357
	lw $299 0($23)
	lw $35 4($23)
	add $359 $299 $35
	sub $360 $358 $359
	sub $361 $354 $360
	add $362 $347 $361
	sub $363 $331 $362
	lw $37 8($23)
	lw $299 0($23)
	sub $364 $37 $299
	lw $35 4($23)
	add $365 $364 $35
	lw $299 0($23)
	lw $35 4($23)
	add $366 $299 $35
	sub $367 $365 $366
	lw $37 8($23)
	lw $299 0($23)
	sub $368 $37 $299
	lw $35 4($23)
	add $369 $368 $35
	lw $299 0($23)
	lw $35 4($23)
	add $370 $299 $35
	sub $371 $369 $370
	add $372 $367 $371
	lw $37 8($23)
	lw $299 0($23)
	sub $373 $37 $299
	lw $35 4($23)
	add $374 $373 $35
	lw $299 0($23)
	lw $35 4($23)
	add $375 $299 $35
	sub $376 $374 $375
	lw $37 8($23)
	lw $299 0($23)
	sub $377 $37 $299
	lw $35 4($23)
	add $378 $377 $35
	add $379 $376 $378
	add $380 $372 $379
	lw $299 0($23)
	lw $35 4($23)
	add $381 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $382 $37 $299
	lw $35 4($23)
	add $383 $382 $35
	add $384 $381 $383
	lw $299 0($23)
	lw $35 4($23)
	add $385 $299 $35
	sub $386 $384 $385
	lw $37 8($23)
	lw $299 0($23)
	sub $387 $37 $299
	lw $35 4($23)
	add $388 $387 $35
	lw $299 0($23)
	lw $35 4($23)
	add $389 $299 $35
	sub $390 $388 $389
	lw $37 8($23)
	lw $299 0($23)
	sub $391 $37 $299
	lw $35 4($23)
	add $392 $391 $35
	add $393 $390 $392
	add $394 $386 $393
	sub $395 $380 $394
	lw $299 0($23)
	lw $35 4($23)
	add $396 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $397 $37 $299
	lw $35 4($23)
	add $398 $397 $35
	add $399 $396 $398
	lw $299 0($23)
	lw $35 4($23)
	add $400 $299 $35
	sub $401 $399 $400
	lw $37 8($23)
	lw $299 0($23)
	sub $402 $37 $299
	lw $35 4($23)
	add $403 $402 $35
	lw $299 0($23)
	lw $35 4($23)
	add $404 $299 $35
	sub $405 $403 $404
	lw $37 8($23)
	lw $299 0($23)
	sub $406 $37 $299
	lw $35 4($23)
	add $407 $406 $35
	add $408 $405 $407
	add $409 $401 $408
	lw $299 0($23)
	lw $35 4($23)
	add $410 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $411 $37 $299
	lw $35 4($23)
	add $412 $411 $35
	add $413 $410 $412
	lw $299 0($23)
	lw $35 4($23)
	add $414 $299 $35
	sub $415 $413 $414
	lw $37 8($23)
	lw $299 0($23)
	sub $416 $37 $299
	lw $35 4($23)
	add $417 $416 $35
	lw $299 0($23)
	lw $35 4($23)
	add $418 $299 $35
	sub $419 $417 $418
	lw $37 8($23)
	lw $299 0($23)
	sub $420 $37 $299
	lw $35 4($23)
	add $421 $420 $35
	add $422 $419 $421
	add $423 $415 $422
	sub $424 $409 $423
	sub $425 $395 $424
	add $426 $363 $425
	lw $299 0($23)
	lw $35 4($23)
	add $427 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $428 $37 $299
	lw $35 4($23)
	add $429 $428 $35
	add $430 $427 $429
	lw $299 0($23)
	lw $35 4($23)
	add $431 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $432 $37 $299
	lw $35 4($23)
	add $433 $432 $35
	add $434 $431 $433
	sub $435 $430 $434
	lw $299 0($23)
	lw $35 4($23)
	add $436 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $437 $37 $299
	lw $35 4($23)
	add $438 $437 $35
	add $439 $436 $438
	lw $299 0($23)
	lw $35 4($23)
	add $440 $299 $35
	sub $441 $439 $440
	sub $442 $435 $441
	lw $37 8($23)
	lw $299 0($23)
	sub $443 $37 $299
	lw $35 4($23)
	add $444 $443 $35
	lw $299 0($23)
	lw $35 4($23)
	add $445 $299 $35
	sub $446 $444 $445
	lw $37 8($23)
	lw $299 0($23)
	sub $447 $37 $299
	lw $35 4($23)
	add $448 $447 $35
	add $449 $446 $448
	lw $299 0($23)
	lw $35 4($23)
	add $450 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $451 $37 $299
	lw $35 4($23)
	add $452 $451 $35
	add $453 $450 $452
	lw $299 0($23)
	lw $35 4($23)
	add $454 $299 $35
	sub $455 $453 $454
	sub $456 $449 $455
	add $457 $442 $456
	lw $37 8($23)
	lw $299 0($23)
	sub $458 $37 $299
	lw $35 4($23)
	add $459 $458 $35
	lw $299 0($23)
	lw $35 4($23)
	add $460 $299 $35
	sub $461 $459 $460
	lw $37 8($23)
	lw $299 0($23)
	sub $462 $37 $299
	lw $35 4($23)
	add $463 $462 $35
	add $464 $461 $463
	lw $299 0($23)
	lw $35 4($23)
	add $465 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $466 $37 $299
	lw $35 4($23)
	add $467 $466 $35
	add $468 $465 $467
	lw $299 0($23)
	lw $35 4($23)
	add $469 $299 $35
	sub $470 $468 $469
	sub $471 $464 $470
	lw $37 8($23)
	lw $299 0($23)
	sub $472 $37 $299
	lw $35 4($23)
	add $473 $472 $35
	lw $299 0($23)
	lw $35 4($23)
	add $474 $299 $35
	sub $475 $473 $474
	lw $37 8($23)
	lw $299 0($23)
	sub $476 $37 $299
	lw $35 4($23)
	add $477 $476 $35
	add $478 $475 $477
	lw $299 0($23)
	lw $35 4($23)
	add $479 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $480 $37 $299
	lw $35 4($23)
	add $481 $480 $35
	add $482 $479 $481
	lw $299 0($23)
	lw $35 4($23)
	add $483 $299 $35
	sub $484 $482 $483
	sub $485 $478 $484
	add $486 $471 $485
	add $487 $457 $486
	lw $37 8($23)
	lw $299 0($23)
	sub $488 $37 $299
	lw $35 4($23)
	add $489 $488 $35
	lw $299 0($23)
	lw $35 4($23)
	add $490 $299 $35
	sub $491 $489 $490
	lw $37 8($23)
	lw $299 0($23)
	sub $492 $37 $299
	lw $35 4($23)
	add $493 $492 $35
	lw $299 0($23)
	lw $35 4($23)
	add $494 $299 $35
	sub $495 $493 $494
	add $496 $491 $495
	lw $37 8($23)
	lw $299 0($23)
	sub $497 $37 $299
	lw $35 4($23)
	add $498 $497 $35
	lw $299 0($23)
	lw $35 4($23)
	add $499 $299 $35
	sub $500 $498 $499
	lw $37 8($23)
	lw $299 0($23)
	sub $501 $37 $299
	lw $35 4($23)
	add $502 $501 $35
	add $503 $500 $502
	add $504 $496 $503
	lw $299 0($23)
	lw $35 4($23)
	add $505 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $506 $37 $299
	lw $35 4($23)
	add $507 $506 $35
	add $508 $505 $507
	lw $299 0($23)
	lw $35 4($23)
	add $509 $299 $35
	sub $510 $508 $509
	lw $37 8($23)
	lw $299 0($23)
	sub $511 $37 $299
	lw $35 4($23)
	add $512 $511 $35
	lw $299 0($23)
	lw $35 4($23)
	add $513 $299 $35
	sub $514 $512 $513
	lw $37 8($23)
	lw $299 0($23)
	sub $515 $37 $299
	lw $35 4($23)
	add $516 $515 $35
	add $517 $514 $516
	add $518 $510 $517
	sub $519 $504 $518
	lw $299 0($23)
	lw $35 4($23)
	add $520 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $521 $37 $299
	lw $35 4($23)
	add $522 $521 $35
	add $523 $520 $522
	lw $299 0($23)
	lw $35 4($23)
	add $524 $299 $35
	sub $525 $523 $524
	lw $37 8($23)
	lw $299 0($23)
	sub $526 $37 $299
	lw $35 4($23)
	add $527 $526 $35
	lw $299 0($23)
	lw $35 4($23)
	add $528 $299 $35
	sub $529 $527 $528
	lw $37 8($23)
	lw $299 0($23)
	sub $530 $37 $299
	lw $35 4($23)
	add $531 $530 $35
	add $532 $529 $531
	add $533 $525 $532
	lw $299 0($23)
	lw $35 4($23)
	add $534 $299 $35
	lw $37 8($23)
	lw $299 0($23)
	sub $535 $37 $299
	lw $35 4($23)
	add $536 $535 $35
	add $537 $534 $536
	lw $299 0($23)
	lw $35 4($23)
	add $538 $299 $35
	sub $539 $537 $538
	lw $37 8($23)
	lw $299 0($23)
	sub $540 $37 $299
	lw $35 4($23)
	add $541 $540 $35
	lw $299 0($23)
	lw $35 4($23)
	add $542 $299 $35
	sub $543 $541 $542
	lw $37 8($23)
	lw $299 0($23)
	sub $544 $37 $299
	lw $35 4($23)
	add $545 $544 $35
	add $546 $543 $545
	add $547 $539 $546
	sub $548 $533 $547
	sub $549 $519 $548
	add $550 $487 $549
	sub $551 $426 $550
	lw $35 4($23)
	la $30 4($23)
	move $35 $551
	sw $35 4($23)
	lw $37 8($23)
	lw $299 0($23)
	sub $553 $37 $299
	lw $552 4($23)
	add $554 $553 $552
	lw $299 0($23)
	lw $552 4($23)
	add $555 $299 $552
	sub $556 $554 $555
	lw $37 8($23)
	lw $299 0($23)
	sub $557 $37 $299
	lw $552 4($23)
	add $558 $557 $552
	lw $299 0($23)
	lw $552 4($23)
	add $559 $299 $552
	sub $560 $558 $559
	add $561 $556 $560
	lw $37 8($23)
	lw $299 0($23)
	sub $562 $37 $299
	lw $552 4($23)
	add $563 $562 $552
	lw $299 0($23)
	lw $552 4($23)
	add $564 $299 $552
	sub $565 $563 $564
	lw $37 8($23)
	lw $299 0($23)
	sub $566 $37 $299
	lw $552 4($23)
	add $567 $566 $552
	add $568 $565 $567
	add $569 $561 $568
	lw $299 0($23)
	lw $552 4($23)
	add $570 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $571 $37 $299
	lw $552 4($23)
	add $572 $571 $552
	add $573 $570 $572
	lw $299 0($23)
	lw $552 4($23)
	add $574 $299 $552
	sub $575 $573 $574
	lw $37 8($23)
	lw $299 0($23)
	sub $576 $37 $299
	lw $552 4($23)
	add $577 $576 $552
	lw $299 0($23)
	lw $552 4($23)
	add $578 $299 $552
	sub $579 $577 $578
	lw $37 8($23)
	lw $299 0($23)
	sub $580 $37 $299
	lw $552 4($23)
	add $581 $580 $552
	add $582 $579 $581
	add $583 $575 $582
	sub $584 $569 $583
	lw $299 0($23)
	lw $552 4($23)
	add $585 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $586 $37 $299
	lw $552 4($23)
	add $587 $586 $552
	add $588 $585 $587
	lw $299 0($23)
	lw $552 4($23)
	add $589 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $590 $37 $299
	lw $552 4($23)
	add $591 $590 $552
	add $592 $589 $591
	sub $593 $588 $592
	lw $299 0($23)
	lw $552 4($23)
	add $594 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $595 $37 $299
	lw $552 4($23)
	add $596 $595 $552
	add $597 $594 $596
	lw $299 0($23)
	lw $552 4($23)
	add $598 $299 $552
	sub $599 $597 $598
	sub $600 $593 $599
	lw $37 8($23)
	lw $299 0($23)
	sub $601 $37 $299
	lw $552 4($23)
	add $602 $601 $552
	lw $299 0($23)
	lw $552 4($23)
	add $603 $299 $552
	sub $604 $602 $603
	lw $37 8($23)
	lw $299 0($23)
	sub $605 $37 $299
	lw $552 4($23)
	add $606 $605 $552
	add $607 $604 $606
	lw $299 0($23)
	lw $552 4($23)
	add $608 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $609 $37 $299
	lw $552 4($23)
	add $610 $609 $552
	add $611 $608 $610
	lw $299 0($23)
	lw $552 4($23)
	add $612 $299 $552
	sub $613 $611 $612
	sub $614 $607 $613
	add $615 $600 $614
	sub $616 $584 $615
	lw $37 8($23)
	lw $299 0($23)
	sub $617 $37 $299
	lw $552 4($23)
	add $618 $617 $552
	lw $299 0($23)
	lw $552 4($23)
	add $619 $299 $552
	sub $620 $618 $619
	lw $37 8($23)
	lw $299 0($23)
	sub $621 $37 $299
	lw $552 4($23)
	add $622 $621 $552
	lw $299 0($23)
	lw $552 4($23)
	add $623 $299 $552
	sub $624 $622 $623
	add $625 $620 $624
	lw $37 8($23)
	lw $299 0($23)
	sub $626 $37 $299
	lw $552 4($23)
	add $627 $626 $552
	lw $299 0($23)
	lw $552 4($23)
	add $628 $299 $552
	sub $629 $627 $628
	lw $37 8($23)
	lw $299 0($23)
	sub $630 $37 $299
	lw $552 4($23)
	add $631 $630 $552
	add $632 $629 $631
	add $633 $625 $632
	lw $299 0($23)
	lw $552 4($23)
	add $634 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $635 $37 $299
	lw $552 4($23)
	add $636 $635 $552
	add $637 $634 $636
	lw $299 0($23)
	lw $552 4($23)
	add $638 $299 $552
	sub $639 $637 $638
	lw $37 8($23)
	lw $299 0($23)
	sub $640 $37 $299
	lw $552 4($23)
	add $641 $640 $552
	lw $299 0($23)
	lw $552 4($23)
	add $642 $299 $552
	sub $643 $641 $642
	lw $37 8($23)
	lw $299 0($23)
	sub $644 $37 $299
	lw $552 4($23)
	add $645 $644 $552
	add $646 $643 $645
	add $647 $639 $646
	sub $648 $633 $647
	lw $299 0($23)
	lw $552 4($23)
	add $649 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $650 $37 $299
	lw $552 4($23)
	add $651 $650 $552
	add $652 $649 $651
	lw $299 0($23)
	lw $552 4($23)
	add $653 $299 $552
	sub $654 $652 $653
	lw $37 8($23)
	lw $299 0($23)
	sub $655 $37 $299
	lw $552 4($23)
	add $656 $655 $552
	lw $299 0($23)
	lw $552 4($23)
	add $657 $299 $552
	sub $658 $656 $657
	lw $37 8($23)
	lw $299 0($23)
	sub $659 $37 $299
	lw $552 4($23)
	add $660 $659 $552
	add $661 $658 $660
	add $662 $654 $661
	lw $299 0($23)
	lw $552 4($23)
	add $663 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $664 $37 $299
	lw $552 4($23)
	add $665 $664 $552
	add $666 $663 $665
	lw $299 0($23)
	lw $552 4($23)
	add $667 $299 $552
	sub $668 $666 $667
	lw $37 8($23)
	lw $299 0($23)
	sub $669 $37 $299
	lw $552 4($23)
	add $670 $669 $552
	lw $299 0($23)
	lw $552 4($23)
	add $671 $299 $552
	sub $672 $670 $671
	lw $37 8($23)
	lw $299 0($23)
	sub $673 $37 $299
	lw $552 4($23)
	add $674 $673 $552
	add $675 $672 $674
	add $676 $668 $675
	sub $677 $662 $676
	sub $678 $648 $677
	add $679 $616 $678
	lw $299 0($23)
	lw $552 4($23)
	add $680 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $681 $37 $299
	lw $552 4($23)
	add $682 $681 $552
	add $683 $680 $682
	lw $299 0($23)
	lw $552 4($23)
	add $684 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $685 $37 $299
	lw $552 4($23)
	add $686 $685 $552
	add $687 $684 $686
	sub $688 $683 $687
	lw $299 0($23)
	lw $552 4($23)
	add $689 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $690 $37 $299
	lw $552 4($23)
	add $691 $690 $552
	add $692 $689 $691
	lw $299 0($23)
	lw $552 4($23)
	add $693 $299 $552
	sub $694 $692 $693
	sub $695 $688 $694
	lw $37 8($23)
	lw $299 0($23)
	sub $696 $37 $299
	lw $552 4($23)
	add $697 $696 $552
	lw $299 0($23)
	lw $552 4($23)
	add $698 $299 $552
	sub $699 $697 $698
	lw $37 8($23)
	lw $299 0($23)
	sub $700 $37 $299
	lw $552 4($23)
	add $701 $700 $552
	add $702 $699 $701
	lw $299 0($23)
	lw $552 4($23)
	add $703 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $704 $37 $299
	lw $552 4($23)
	add $705 $704 $552
	add $706 $703 $705
	lw $299 0($23)
	lw $552 4($23)
	add $707 $299 $552
	sub $708 $706 $707
	sub $709 $702 $708
	add $710 $695 $709
	lw $37 8($23)
	lw $299 0($23)
	sub $711 $37 $299
	lw $552 4($23)
	add $712 $711 $552
	lw $299 0($23)
	lw $552 4($23)
	add $713 $299 $552
	sub $714 $712 $713
	lw $37 8($23)
	lw $299 0($23)
	sub $715 $37 $299
	lw $552 4($23)
	add $716 $715 $552
	add $717 $714 $716
	lw $299 0($23)
	lw $552 4($23)
	add $718 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $719 $37 $299
	lw $552 4($23)
	add $720 $719 $552
	add $721 $718 $720
	lw $299 0($23)
	lw $552 4($23)
	add $722 $299 $552
	sub $723 $721 $722
	sub $724 $717 $723
	lw $37 8($23)
	lw $299 0($23)
	sub $725 $37 $299
	lw $552 4($23)
	add $726 $725 $552
	lw $299 0($23)
	lw $552 4($23)
	add $727 $299 $552
	sub $728 $726 $727
	lw $37 8($23)
	lw $299 0($23)
	sub $729 $37 $299
	lw $552 4($23)
	add $730 $729 $552
	add $731 $728 $730
	lw $299 0($23)
	lw $552 4($23)
	add $732 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $733 $37 $299
	lw $552 4($23)
	add $734 $733 $552
	add $735 $732 $734
	lw $299 0($23)
	lw $552 4($23)
	add $736 $299 $552
	sub $737 $735 $736
	sub $738 $731 $737
	add $739 $724 $738
	add $740 $710 $739
	lw $37 8($23)
	lw $299 0($23)
	sub $741 $37 $299
	lw $552 4($23)
	add $742 $741 $552
	lw $299 0($23)
	lw $552 4($23)
	add $743 $299 $552
	sub $744 $742 $743
	lw $37 8($23)
	lw $299 0($23)
	sub $745 $37 $299
	lw $552 4($23)
	add $746 $745 $552
	lw $299 0($23)
	lw $552 4($23)
	add $747 $299 $552
	sub $748 $746 $747
	add $749 $744 $748
	lw $37 8($23)
	lw $299 0($23)
	sub $750 $37 $299
	lw $552 4($23)
	add $751 $750 $552
	lw $299 0($23)
	lw $552 4($23)
	add $752 $299 $552
	sub $753 $751 $752
	lw $37 8($23)
	lw $299 0($23)
	sub $754 $37 $299
	lw $552 4($23)
	add $755 $754 $552
	add $756 $753 $755
	add $757 $749 $756
	lw $299 0($23)
	lw $552 4($23)
	add $758 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $759 $37 $299
	lw $552 4($23)
	add $760 $759 $552
	add $761 $758 $760
	lw $299 0($23)
	lw $552 4($23)
	add $762 $299 $552
	sub $763 $761 $762
	lw $37 8($23)
	lw $299 0($23)
	sub $764 $37 $299
	lw $552 4($23)
	add $765 $764 $552
	lw $299 0($23)
	lw $552 4($23)
	add $766 $299 $552
	sub $767 $765 $766
	lw $37 8($23)
	lw $299 0($23)
	sub $768 $37 $299
	lw $552 4($23)
	add $769 $768 $552
	add $770 $767 $769
	add $771 $763 $770
	sub $772 $757 $771
	lw $299 0($23)
	lw $552 4($23)
	add $773 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $774 $37 $299
	lw $552 4($23)
	add $775 $774 $552
	add $776 $773 $775
	lw $299 0($23)
	lw $552 4($23)
	add $777 $299 $552
	sub $778 $776 $777
	lw $37 8($23)
	lw $299 0($23)
	sub $779 $37 $299
	lw $552 4($23)
	add $780 $779 $552
	lw $299 0($23)
	lw $552 4($23)
	add $781 $299 $552
	sub $782 $780 $781
	lw $37 8($23)
	lw $299 0($23)
	sub $783 $37 $299
	lw $552 4($23)
	add $784 $783 $552
	add $785 $782 $784
	add $786 $778 $785
	lw $299 0($23)
	lw $552 4($23)
	add $787 $299 $552
	lw $37 8($23)
	lw $299 0($23)
	sub $788 $37 $299
	lw $552 4($23)
	add $789 $788 $552
	add $790 $787 $789
	lw $299 0($23)
	lw $552 4($23)
	add $791 $299 $552
	sub $792 $790 $791
	lw $37 8($23)
	lw $299 0($23)
	sub $793 $37 $299
	lw $552 4($23)
	add $794 $793 $552
	lw $299 0($23)
	lw $552 4($23)
	add $795 $299 $552
	sub $796 $794 $795
	lw $37 8($23)
	lw $299 0($23)
	sub $797 $37 $299
	lw $552 4($23)
	add $798 $797 $552
	add $799 $796 $798
	add $800 $792 $799
	sub $801 $786 $800
	sub $802 $772 $801
	add $803 $740 $802
	sub $804 $679 $803
	lw $37 8($23)
	la $30 8($23)
	move $37 $804
	sw $37 8($23)

# Read:
# Write:
main_0_loopTail:
	lw $805 8($23)
	li $807 1
	sll $806 $807 29
	slt $808 $805 $806
	lw $805 8($23)
	li $810 1
	sll $809 $810 29
	neg $811 $809
	sgt $812 $805 $811
	and $813 $808 $812
	bne $813 0 main_0_loop

# Read:
# Write:
main_1:
	lw $299 0($23)
	move $4 $299
	jal func__toString
	move $4 $2
	la $5 String0
	jal func__stringConcatenate
	move $814 $2
	lw $552 4($23)
	move $4 $552
	jal func__toString
	move $4 $814
	move $5 $2
	jal func__stringConcatenate
	move $815 $2
	move $4 $815
	la $5 String1
	jal func__stringConcatenate
	move $816 $2
	lw $805 8($23)
	move $4 $805
	jal func__toString
	move $4 $816
	move $5 $2
	jal func__stringConcatenate
	move $817 $2
	move $4 $817
	jal func__println
	li $2 0
	move $31 $38
	jr $ra
	move $31 $38
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
