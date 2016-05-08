package MIPS;

/**
 * Created by Bill on 2016/5/3.
 */
public class buildIn {
    static String buildIn_data = "\n" +
            "_end: .asciiz \"\\n\"\n" +
            "\t.align 2\n" +
            "_buffer: .space 256\n" +
            "\t.align 2\n" +
            "VReg: .space 3600\n";

    static String buildIn_text = "# copy the string in $a0 to buffer in $a1, with putting '\\0' in the end of the buffer\n" +
            "###### Checked ######\n" +
            "# used $v0, $a0, $a1\n" +
            "_string_copy:\n" +
            "\t_begin_string_copy:\n" +
            "\tlb $v0, 0($a0)\n" +
            "\tbeqz $v0, _exit_string_copy\n" +
            "\tsb $v0, 0($a1)\n" +
            "\tadd $a0, $a0, 1\n" +
            "\tadd $a1, $a1, 1\n" +
            "\tj _begin_string_copy\n" +
            "\t_exit_string_copy:\n" +
            "\tsb $zero, 0($a1)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0\n" +
            "###### Checked ######\n" +
            "# Change(5/4): you don't need to preserve reg before calling it\n" +
            "func__print:\n" +
            "\tli $v0, 4\n" +
            "\tsyscall\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0\n" +
            "###### Checked ######\n" +
            "# Change(5/4): you don't need to preserve reg before calling it\n" +
            "func__println:\n" +
            "\tli $v0, 4\n" +
            "\tsyscall\n" +
            "\tla $a0, _end\n" +
            "\tsyscall\n" +
            "\tjr $ra\n" +
            "\n" +
            "# count the length of given string in $a0\n" +
            "###### Checked ######\n" +
            "# used $v0, $v1, $a0\n" +
            "_count_string_length:\n" +
            "\tmove $v0, $a0\n" +
            "\n" +
            "\t_begin_count_string_length:\n" +
            "\tlb $v1, 0($a0)\n" +
            "\tbeqz $v1, _exit_count_string_length\n" +
            "\tadd $a0, $a0, 1\n" +
            "\tj _begin_count_string_length\n" +
            "\n" +
            "\t_exit_count_string_length:\n" +
            "\tsub $v0, $a0, $v0\n" +
            "\tjr $ra\n" +
            "\n" +
            "# non arg, string in $v0\n" +
            "###### Checked ######\n" +
            "# used $a0, $a1, $t0, $v0, (used in _count_string_length) $v1\n" +
            "func__getString:\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\tla $a0, _buffer\n" +
            "\tli $a1, 255\n" +
            "\tli $v0, 8\n" +
            "\tsyscall\n" +
            "\n" +
            "\tjal _count_string_length\n" +
            "\n" +
            "\tmove $a1, $v0\t\t\t# now $a1 contains the length of the string\n" +
            "\tadd $a0, $v0, 5\t\t\t# total required space = length + 1('\\0') + 1 word(record the length of the string)\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tsw $a1, 0($v0)\n" +
            "\tadd $v0, $v0, 4\n" +
            "\tla $a0, _buffer\n" +
            "\tmove $a1, $v0\n" +
            "\tmove $t0, $v0\n" +
            "\tjal _string_copy\n" +
            "\tmove $v0, $t0\n" +
            "\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 4\n" +
            "\tjr $ra\n" +
            "\n" +
            "# non arg, int in $v0\n" +
            "###### Checked ######\n" +
            "# Change(5/4): you don't need to preserve reg before calling it\n" +
            "func__getInt:\n" +
            "\tli $v0, 5\n" +
            "\tsyscall\n" +
            "\tjr $ra\n" +
            "\n" +
            "# int arg in $a0\n" +
            "###### Checked ######\n" +
            "# Bug fixed(5/2): when the arg is a neg number\n" +
            "# Change(5/4): use less regs, you don't need to preserve reg before calling it\n" +
            "# used $v0, $v1\n" +
            "func__toString:\n" +
            "\tsubu $sp, $sp, 24\n" +
            "\tsw $a0, 0($sp)\n" +
            "\tsw $t0, 4($sp)\n" +
            "\tsw $t1, 8($sp)\n" +
            "\tsw $t2, 12($sp)\n" +
            "\tsw $t3, 16($sp)\n" +
            "\tsw $t5, 20($sp)\n" +
            "\n" +
            "\t# first count the #digits\n" +
            "\tli $t0, 0\t\t\t# $t0 = 0 if the number is a negnum\n" +
            "\tbgez $a0, _skip_set_less_than_zero\n" +
            "\tli $t0, 1\t\t\t# now $t0 must be 1\n" +
            "\tneg $a0, $a0\n" +
            "\t_skip_set_less_than_zero:\n" +
            "\tbeqz $a0, _set_zero\n" +
            "\n" +
            "\tli $t1, 0\t\t\t# the #digits is in $t1\n" +
            "\tmove $t2, $a0\n" +
            "\tmove $t3, $a0\n" +
            "\tli $t5, 10\n" +
            "\n" +
            "\t_begin_count_digit:\n" +
            "\tdiv $t2, $t5\n" +
            "\tmflo $v0\t\t\t# get the quotient\n" +
            "\tmfhi $v1\t\t\t# get the remainder\n" +
            "\tbgtz $v0 _not_yet\n" +
            "\tbgtz $v1 _not_yet\n" +
            "\tj _yet\n" +
            "\t_not_yet:\n" +
            "\tadd $t1, $t1, 1\n" +
            "\tmove $t2, $v0\n" +
            "\tj _begin_count_digit\n" +
            "\n" +
            "\t_yet:\n" +
            "\tbeqz $t0, _skip_reserve_neg\n" +
            "\tadd $t1, $t1, 1\n" +
            "\t_skip_reserve_neg:\n" +
            "\tadd $a0, $t1, 5\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tsw $t1, 0($v0)\n" +
            "\tadd $v0, $v0, 4\n" +
            "\tadd $t1, $t1, $v0\n" +
            "\tsb $zero, 0($t1)\n" +
            "\tsub $t1, $t1, 1\n" +
            "\n" +
            "\t_continue_toString:\n" +
            "\tdiv $t3, $t5\n" +
            "\tmfhi $v1\n" +
            "\tadd $v1, $v1, 48\t# in ascii 48 = '0'\n" +
            "\tsb $v1, 0($t1)\n" +
            "\tsub $t1, $t1, 1\n" +
            "\tmflo $t3\n" +
            "\t# bge $t1, $v0, _continue_toString\n" +
            "\tbnez $t3, _continue_toString\n" +
            "\n" +
            "\tbeqz $t0, _skip_place_neg\n" +
            "\tli $v1, 45\n" +
            "\tsb $v1, 0($t1)\n" +
            "\t_skip_place_neg:\n" +
            "\t# lw $ra, 0($sp)\n" +
            "\t# addu $sp, $sp, 4\n" +
            "\n" +
            "\tlw $a0, 0($sp)\n" +
            "\tlw $t0, 4($sp)\n" +
            "\tlw $t1, 8($sp)\n" +
            "\tlw $t2, 12($sp)\n" +
            "\tlw $t3, 16($sp)\n" +
            "\tlw $t5, 20($sp)\n" +
            "\n" +
            "\taddu $sp, $sp, 24\n" +
            "\tjr $ra\n" +
            "\n" +
            "\t_set_zero:\n" +
            "\tli $a0, 6\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tli $a0, 1\n" +
            "\tsw $a0, 0($v0)\n" +
            "\tadd $v0, $v0, 4\n" +
            "\tli $a0, 48\n" +
            "\tsb $a0, 0($v0)\n" +
            "\n" +
            "\tlw $a0, 0($sp)\n" +
            "\tlw $t0, 4($sp)\n" +
            "\tlw $t1, 8($sp)\n" +
            "\tlw $t2, 12($sp)\n" +
            "\tlw $t3, 16($sp)\n" +
            "\tlw $t5, 20($sp)\n" +
            "\n" +
            "\taddu $sp, $sp, 24\n" +
            "\tjr $ra\n" +
            "\n" +
            "\n" +
            "# string arg in $v0\n" +
            "# the zero in the end of the string will not be counted\n" +
            "###### Checked ######\n" +
            "# you don't need to preserve reg before calling it\n" +
            "func__string.length:\n" +
            "\tlw $v0, -4($v0)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0, left in $a1, right in $a2\n" +
            "###### Checked ######\n" +
            "# used $a0, $a1, $t0, $t1, $t2, $v1, $v0\n" +
            "func__string.substring:\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\tmove $t0, $v0\n" +
            "\tmove $t3, $a0\n" +
            "\tsub $t1, $a1, $a0\n" +
            "\tadd $t1, $t1, 1\t\t# $t1 is the length of the substring\n" +
            "\tadd $a0, $t1, 5\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tsw $t1, 0($v0)\n" +
            "\tadd $v1, $v0, 4\n" +
            "\n" +
            "\tadd $a0, $t0, $t3\n" +
            "\tadd $t2, $t0, $a1\n" +
            "\tlb $t1, 1($t2)\t\t# store the ori_begin + right + 1 char in $t1\n" +
            "\tsb $zero, 1($t2)\t# change it to 0 for the convenience of copying\n" +
            "\tmove $a1, $v1\n" +
            "\tjal _string_copy\n" +
            "\tmove $v0, $v1\n" +
            "\tsb $t1, 1($t2)\n" +
            "\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 4\n" +
            "\tjr $ra" +
            "\n" +
            "# string arg in\n" +
            "###### Checked ######\n" +
            "# 16/5/4 Fixed a serious bug: can not parse negtive number\n" +
            "# used $v0, $v1\n" +
            "func__string.parseInt:\n" +
            "\tmove $a0, $v0\n" +
            "\tli $v0, 0\n" +
            "\n" +
            "\tlb $t1, 0($a0)\n" +
            "\tli $t2, 45\n" +
            "\tbne $t1, $t2, _skip_parse_neg\n" +
            "\tli $t1, 1\t\t\t#if there is a '-' sign, $t1 = 1\n" +
            "\tadd $a0, $a0, 1\n" +
            "\tj _skip_set_t1_zero\n" +
            "\n" +
            "\t_skip_parse_neg:\n" +
            "\tli $t1, 0\n" +
            "\t_skip_set_t1_zero:\n" +
            "\tmove $t0, $a0\n" +
            "\tli $t2, 1\n" +
            "\n" +
            "\t_count_number_pos:\n" +
            "\tlb $v1, 0($t0)\n" +
            "\tbgt $v1, 57, _begin_parse_int\n" +
            "\tblt $v1, 48, _begin_parse_int\n" +
            "\tadd $t0, $t0, 1\n" +
            "\tj _count_number_pos\n" +
            "\n" +
            "\t_begin_parse_int:\n" +
            "\tsub $t0, $t0, 1\n" +
            "\n" +
            "\t_parsing_int:\n" +
            "\tblt $t0, $a0, _finish_parse_int\n" +
            "\tlb $v1, 0($t0)\n" +
            "\tsub $v1, $v1, 48\n" +
            "\tmul $v1, $v1, $t2\n" +
            "\tadd $v0, $v0, $v1\n" +
            "\tmul $t2, $t2, 10\n" +
            "\tsub $t0, $t0, 1\n" +
            "\tj _parsing_int\n" +
            "\n" +
            "\t_finish_parse_int:\n" +
            "\tbeqz $t1, _skip_neg\n" +
            "\tneg $v0, $v0\n" +
            "\t_skip_neg:\n" +
            "\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0, pos in $a1\n" +
            "###### Checked ######\n" +
            "# used $v0, $v1\n" +
            "func__string.ord:\n" +
            "\tadd $v0, $v0, $a0\n" +
            "\tlb $v0, 0($v0)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# array arg in $a0\n" +
            "# used $v0\n" +
            "func__array.size:\n" +
            "\tlw $v0, -4($v0)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "###### Checked ######\n" +
            "# change(16/5/4): use less regs, you don't need to preserve reg before calling it\n" +
            "# used $v0, $v1\n" +
            "func__stringConcatenate:\n" +
            "\n" +
            "\tsubu $sp, $sp, 24\n" +
            "\tsw $ra, 0($sp)\n" +
            "\tsw $a0, 4($sp)\n" +
            "\tsw $a1, 8($sp)\n" +
            "\tsw $t0, 12($sp)\n" +
            "\tsw $t1, 16($sp)\n" +
            "\tsw $t2, 20($sp)\n" +
            "\n" +
            "\tlw $t0, -4($a0)\t\t# $t0 is the length of lhs\n" +
            "\tlw $t1, -4($a1)\t\t# $t1 is the length of rhs\n" +
            "\tadd $t2, $t0, $t1\n" +
            "\n" +
            "\tmove $t1, $a0\n" +
            "\n" +
            "\tadd $a0, $t2, 5\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\n" +
            "\tsw $t2, 0($v0)\n" +
            "\tmove $t2, $a1\n" +
            "\n" +
            "\tadd $v0, $v0, 4\n" +
            "\tmove $v1, $v0\n" +
            "\n" +
            "\tmove $a0, $t1\n" +
            "\tmove $a1, $v1\n" +
            "\tjal _string_copy\n" +
            "\n" +
            "\tmove $a0, $t2\n" +
            "\tadd $a1, $v1, $t0\n" +
            "\t# add $a1, $a1, 1\n" +
            "\tjal _string_copy\n" +
            "\n" +
            "\tmove $v0, $v1\n" +
            "\tlw $ra, 0($sp)\n" +
            "\tlw $a0, 4($sp)\n" +
            "\tlw $a1, 8($sp)\n" +
            "\tlw $t0, 12($sp)\n" +
            "\tlw $t1, 16($sp)\n" +
            "\tlw $t2, 20($sp)\n" +
            "\taddu $sp, $sp, 24\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "###### Checked ######\n" +
            "# change(16/5/4): use less regs, you don't need to preserve reg before calling it\n" +
            "# used $a0, $a1, $v0, $v1\n" +
            "func__stringIsEqual:\n" +
            "\t# subu $sp, $sp, 8\n" +
            "\t# sw $a0, 0($sp)\n" +
            "\t# sw $a1, 4($sp)\n" +
            "\n" +
            "\tlw $v0, -4($a0)\n" +
            "\tlw $v1, -4($a1)\n" +
            "\tbne $v0, $v1, _not_equal\n" +
            "\n" +
            "\t_continue_compare_equal:\n" +
            "\tlb $v0, 0($a0)\n" +
            "\tlb $v1, 0($a1)\n" +
            "\tbeqz $v0, _equal\n" +
            "\tbne $v0, $v1, _not_equal\n" +
            "\tadd $a0, $a0, 1\n" +
            "\tadd $a1, $a1, 1\n" +
            "\tj _continue_compare_equal\n" +
            "\n" +
            "\t_not_equal:\n" +
            "\tli $v0, 0\n" +
            "\tj _compare_final\n" +
            "\n" +
            "\t_equal:\n" +
            "\tli $v0, 1\n" +
            "\n" +
            "\t_compare_final:\n" +
            "\t# lw $a0, 0($sp)\n" +
            "\t# lw $a1, 4($sp)\n" +
            "\t# addu $sp, $sp, 8\n" +
            "\tjr $ra\n" +
            "\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "###### Checked ######\n" +
            "# change(16/5/4): use less regs, you don't need to preserve reg before calling it\n" +
            "# used $a0, $a1, $v0, $v1\n" +
            "func__stringLess:\n" +
            "\t# subu $sp, $sp, 8\n" +
            "\t# sw $a0, 0($sp)\n" +
            "\t# sw $a1, 4($sp)\n" +
            "\n" +
            "\t_begin_compare_less:\n" +
            "\tlb $v0, 0($a0)\n" +
            "\tlb $v1, 0($a1)\n" +
            "\tblt $v0, $v1, _less_correct\n" +
            "\tbgt $v0, $v1, _less_false\n" +
            "\tbeqz $v0, _less_false\n" +
            "\tadd $a0, $a0, 1\n" +
            "\tadd $a1, $a1, 1\n" +
            "\tj _begin_compare_less\n" +
            "\n" +
            "\t_less_correct:\n" +
            "\tli $v0, 1\n" +
            "\tj _less_compare_final\n" +
            "\n" +
            "\t_less_false:\n" +
            "\tli $v0, 0\n" +
            "\n" +
            "\t_less_compare_final:\n" +
            "\n" +
            "\t# lw $a0, 0($sp)\n" +
            "\t# lw $a1, 4($sp)\n" +
            "\t# addu $sp, $sp, 8\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "# used $a0, $a1, $v0, $v1\n" +
            "func__stringLarge:\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\tjal func__stringLess\n" +
            "\n" +
            "\txor $v0, $v0, 1\n" +
            "\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 4\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "# used $a0, $a1, $v0, $v1\n" +
            "func__stringLeq:\n" +
            "\tsubu $sp, $sp, 12\n" +
            "\tsw $ra, 0($sp)\n" +
            "\tsw $a0, 4($sp)\n" +
            "\tsw $a1, 8($sp)\n" +
            "\n" +
            "\tjal func__stringLess\n" +
            "\n" +
            "\tbnez $v0, _skip_compare_equal_in_Leq\n" +
            "\n" +
            "\tlw $a0, 4($sp)\n" +
            "\tlw $a1, 8($sp)\n" +
            "\tjal func__stringIsEqual\n" +
            "\n" +
            "\t_skip_compare_equal_in_Leq:\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 12\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "# used $a0, $a1, $v0, $v1\n" +
            "func__stringGeq:\n" +
            "\tsubu $sp, $sp, 12\n" +
            "\tsw $ra, 0($sp)\n" +
            "\tsw $a0, 4($sp)\n" +
            "\tsw $a1, 8($sp)\n" +
            "\n" +
            "\tjal func__stringLess\n" +
            "\n" +
            "\tbeqz $v0, _skip_compare_equal_in_Geq\n" +
            "\n" +
            "\tlw $a0, 4($sp)\n" +
            "\tlw $a1, 8($sp)\n" +
            "\tjal func__stringIsEqual\n" +
            "\txor $v0, $v0, 1\n" +
            "\n" +
            "\t_skip_compare_equal_in_Geq:\n" +
            "\txor $v0, $v0, 1\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 12\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "# used $a0, $a1, $v0, $v1\n" +
            "func__stringNeq:\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\tjal func__stringIsEqual\n" +
            "\n" +
            "\txor $v0, $v0, 1\n" +
            "\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 4\n" +
            "\tjr $ra\n\n";
}
