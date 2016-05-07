.data

_end: .asciiz "\n"
	.align 2
_buffer: .word 0
	length0: 	.word 	0
	String0: 	.asciiz 	""


.text

_buffer_init:
	li $a0, 256
	li $v0, 9
	syscall
	sw $v0, _buffer
	jr $ra

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
func_print:
	li $v0, 4
	syscall
	jr $ra

# string arg in $a0
###### Checked ######
func_println:
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
# used $a0, $a1, $v0, $t0
func_getString:
	subu $sp, $sp, 4
	sw $ra, 0($sp)


	lw $a0, _buffer
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
	lw $a0, _buffer
	move $a1, $v0
	move $t0, $v0
	jal _string_copy
	move $v0, $t0

	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra

# non arg, int in $v0
###### Checked ######
func_getInt:
	li $v0, 5
	syscall
	jr $ra

# int arg in $a0
###### Checked ######
# Bug fixed(5/2): when the arg is a neg number
# used $a0, $t0, $t1, $t2, $t3, $t5, $v0, $v1
func_toString:
	# subu $sp, $sp, 4
	# sw $ra, 0($sp)
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
	jr $ra


# string arg in $a0
# the zero in the end of the string will not be counted
###### Checked ######
func_string.length:
	lw $v0, -4($a0)
	jr $ra

# string arg in $a0, left in $a1, right in $a2
###### Checked ######
# used $a0, $a1, $t0, $t1, $t2, $t3, $t4, $v0,
func_string.substring:
	subu $sp, $sp, 4
	sw $ra, 0($sp)

	move $t0, $a0

	sub $t1, $a2, $a1
	add $t1, $t1, 1		# $t1 is the length of the substring
	add $a0, $t1, 5
	li $v0, 9
	syscall
	sw $t1, 0($v0)
	add $v0, $v0, 4

	add $a0, $t0, $a1
	add $t2, $t0, $a2
	lb $t3, 1($t2)		# store the ori_begin + right + 1 char in $t3
	sb $zero, 1($t2)	# change it to 0 for the convenience of copying
	move $a1, $v0
	move $t4, $v0
	jal _string_copy
	move $v0, $t4
	sb $t3, 1($t2)

	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra

# string arg in $a0
###### Checked ######
# used $t0, $t1, $t2, $v0
func_string.parseInt:
	li $v0, 0
	move $t0, $a0
	li $t2, 1

	_count_number_pos:
	lb $t1, 0($t0)
	bgt $t1, 57, _begin_parse_int
	blt $t1, 48, _begin_parse_int
	add $t0, $t0, 1
	j _count_number_pos

	_begin_parse_int:
	sub $t0, $t0, 1

	_parsing_int:
	blt $t0, $a0, _finish_parse_int
	lb $t1, 0($t0)
	sub $t1, $t1, 48
	mul $t1, $t1, $t2
	add $v0, $v0, $t1
	mul $t2, $t2, 10
	sub $t0, $t0, 1
	j _parsing_int

	_finish_parse_int:
	jr $ra

# string arg in $a0, pos in $a1
###### Checked ######
# used $a0, $v0
func_string.ord:
	add $a0, $a0, $a1
	lb $v0, 0($a0)
	jr $ra

# array arg in $a0
# used $v0
func__array.size:
	lw $v0, -4($a0)
	jr $ra

# string1 in $a0, string2 in $a1
###### Checked ######
# used $a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, $v0
func_stringConcatenate:

	subu $sp, $sp, 4
	sw $ra, 0($sp)

	move $t2, $a0
	move $t3, $a1

	lw $t0, -4($a0)		# $t0 is the length of lhs
	lw $t1, -4($a1)		# $t1 is the length of rhs
	add $t5, $t0, $t1
	add $a0, $t5, 5
	li $v0, 9
	syscall
	sw $t5, 0($v0)
	add $v0, $v0, 4
	move $t4, $v0

	move $a0, $t2
	move $a1, $t4
	jal _string_copy

	move $a0, $t3
	add $a1, $t4, $t0
	# add $a1, $a1, 1
	jal _string_copy

	move $v0, $t4
	lw $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra

# string1 in $a0, string2 in $a1
###### Checked ######
# used $a0, $a1, $t0, $t1, $v0
func_stringIsEqual:

	lw $t0, -4($a0)
	lw $t1, -4($a1)
	bne $t0, $t1, _not_equal

	_continue_compare_equal:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	beqz $t0, _equal
	bne $t0, $t1, _not_equal
	add $a0, $a0, 1
	add $a1, $a1, 1
	j _continue_compare_equal

	_not_equal:
	li $v0, 0
	j _compare_final

	_equal:
	li $v0, 1

	_compare_final:
	jr $ra


# string1 in $a0, string2 in $a1
###### Checked ######
# used $a0, $a1, $t0, $t1, $v0
func_stringLess:

	_begin_compare_less:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	blt $t0, $t1, _less_correct
	bgt $t0, $t1, _less_false
	beqz $t0, _less_false
	add $a0, $a0, 1
	add $a1, $a1, 1
	j _begin_compare_less

	_less_correct:
	li $v0, 1
	j _less_compare_final

	_less_false:
	li $v0, 0

	_less_compare_final:
	jr $ra

main:
	jal _buffer_init
	li $4 4
	li $2 9
	syscall
	li $4 4
	li $2 9
	syscall
	move $23 $2
	li $4 4
	li $2 9
	syscall
	li $3 4
	sw $3 0($2)
	sll $4 $3 2
	li $2 9
	syscall
	move $3 $2
	lw $4 0($23)
	la $30 0($23)
	move $4 $3
	sw $4 0($30)
	jal main_0
	li $2 10
	syscall

main_0:
	move $s2 $31
	li $4 4
	li $2 9
	syscall
	li $3 4
	sw $3 0($2)
	sll $4 $3 2
	li $2 9
	syscall
	move $3 $2
	move $s0 $3
	lw $3 0($23)
	lw $4 0($s0)
	la $30 0($s0)
	move $4 $3
	sw $4 0($30)
	lw $3 0($23)
	lw $4 4($s0)
	la $30 4($s0)
	move $4 $3
	sw $4 0($30)
	lw $3 0($23)
	lw $4 8($s0)
	la $30 8($s0)
	move $4 $3
	sw $4 0($30)
	lw $3 0($23)
	lw $4 12($s0)
	la $30 12($s0)
	move $4 $3
	sw $4 0($30)
	move $4 $s0
	jal func__array.size
	move $3 $2
	move $4 $3
	jal func_toString
	move $4 $2
	jal func_println
	li $s1 0
	lw $3 0($s0)
	la $30 0($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	bge $s1 $3 main_1

main_0_loop:
	jal func_getInt
	lw $3 0($s0)
	mul $s1 $s1 4
	add $3 $3 $s1
	lw $4 0($3)
	la $30 0($3)
	move $4 $2
	sw $4 0($30)

main_0_loopTail:
	add $s1 $s1 1
	lw $3 0($s0)
	la $30 0($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	blt $s1 $3 main_0_loop

main_1:
	li $s1 0
	lw $3 4($s0)
	la $30 4($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	bge $s1 $3 main_2

main_1_loop:
	lw $3 4($s0)
	mul $s1 $s1 4
	add $3 $3 $s1
	lw $4 0($3)
	la $30 0($3)
	move $4 $4
	jal func_toString
	move $4 $2
	jal func_print

main_1_loopTail:
	add $s1 $s1 1
	lw $3 4($s0)
	la $30 4($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	blt $s1 $3 main_1_loop

main_2:
	la $4 String0
	jal func_println
	li $s1 0
	lw $3 8($s0)
	la $30 8($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	bge $s1 $3 main_3

main_2_loop:
	lw $3 8($s0)
	mul $s1 $s1 4
	add $3 $3 $s1
	lw $4 0($3)
	la $30 0($3)
	li $4 0
	sw $4 0($30)

main_2_loopTail:
	add $s1 $s1 1
	lw $3 8($s0)
	la $30 8($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	blt $s1 $3 main_2_loop

main_3:
	li $s1 0
	lw $3 12($s0)
	la $30 12($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	bge $s1 $3 main_4

main_3_loop:
	lw $3 12($s0)
	mul $s1 $s1 4
	add $3 $3 $s1
	lw $4 0($3)
	la $30 0($3)
	move $4 $4
	jal func_toString
	move $4 $2
	jal func_print

main_3_loopTail:
	add $s1 $s1 1
	lw $3 12($s0)
	la $30 12($s0)
	move $4 $3
	jal func__array.size
	move $3 $2
	blt $s1 $3 main_3_loop

main_4:
	move $31 $s2
	jr $ra

