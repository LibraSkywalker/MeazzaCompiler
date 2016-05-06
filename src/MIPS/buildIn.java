package MIPS;

/**
 * Created by Bill on 2016/5/3.
 */
public class buildIn {
    static String buildIn_data = "\n" +
            "_end: .asciiz \"\\n\"\n" +
            "\t.align 2\n" +
            "_buffer: .word 0\n";

    static String buildIn_text = "_buffer_init:\n" +
            "\tli $a0, 256\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tsw $v0, _buffer\n" +
            "\tjr $ra\n" +
            "\n" +
            "# copy the string in $a0 to buffer in $a1, with putting '\\0' in the end of the buffer\n" +
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
            "func_print:\n" +
            "\tli $v0, 4\n" +
            "\tsyscall\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0\n" +
            "###### Checked ######\n" +
            "func_println:\n" +
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
            "# used $a0, $a1, $v0, $t0\n" +
            "func_getString:\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\n" +
            "\tlw $a0, _buffer\n" +
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
            "\tlw $a0, _buffer\n" +
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
            "func_getInt:\n" +
            "\tli $v0, 5\n" +
            "\tsyscall\n" +
            "\tjr $ra\n" +
            "\n" +
            "# int arg in $a0\n" +
            "###### Checked ######\n" +
            "# Bug fixed(5/2): when the arg is a neg number\n" +
            "# used $a0, $t0, $t1, $t2, $t3, $t5, $v0, $v1\n" +
            "func_toString:\n" +
            "\t# subu $sp, $sp, 4\n" +
            "\t# sw $ra, 0($sp)\n" +
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
            "\tjr $ra\n" +
            "\n" +
            "\n" +
            "# string arg in $a0\n" +
            "# the zero in the end of the string will not be counted\n" +
            "###### Checked ######\n" +
            "func_string.length:\n" +
            "\tlw $v0, -4($a0)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0, left in $a1, right in $a2\n" +
            "###### Checked ######\n" +
            "# used $a0, $a1, $t0, $t1, $t2, $t3, $t4, $v0,\n" +
            "func_string.substring:\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\tmove $t0, $a0\n" +
            "\n" +
            "\tsub $t1, $a2, $a1\n" +
            "\tadd $t1, $t1, 1\t\t# $t1 is the length of the substring\n" +
            "\tadd $a0, $t1, 5\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tsw $t1, 0($v0)\n" +
            "\tadd $v0, $v0, 4\n" +
            "\n" +
            "\tadd $a0, $t0, $a1\n" +
            "\tadd $t2, $t0, $a2\n" +
            "\tlb $t3, 1($t2)\t\t# store the ori_begin + right + 1 char in $t3\n" +
            "\tsb $zero, 1($t2)\t# change it to 0 for the convenience of copying\n" +
            "\tmove $a1, $v0\n" +
            "\tmove $t4, $v0\n" +
            "\tjal _string_copy\n" +
            "\tmove $v0, $t4\n" +
            "\tsb $t3, 1($t2)\n" +
            "\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 4\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0\n" +
            "###### Checked ######\n" +
            "# used $t0, $t1, $t2, $v0\n" +
            "func_string.parseInt:\n" +
            "\tli $v0, 0\n" +
            "\tmove $t0, $a0\n" +
            "\tli $t2, 1\n" +
            "\n" +
            "\t_count_number_pos:\n" +
            "\tlb $t1, 0($t0)\n" +
            "\tbgt $t1, 57, _begin_parse_int\n" +
            "\tblt $t1, 48, _begin_parse_int\n" +
            "\tadd $t0, $t0, 1\n" +
            "\tj _count_number_pos\n" +
            "\n" +
            "\t_begin_parse_int:\n" +
            "\tsub $t0, $t0, 1\n" +
            "\n" +
            "\t_parsing_int:\n" +
            "\tblt $t0, $a0, _finish_parse_int\n" +
            "\tlb $t1, 0($t0)\n" +
            "\tsub $t1, $t1, 48\n" +
            "\tmul $t1, $t1, $t2\n" +
            "\tadd $v0, $v0, $t1\n" +
            "\tmul $t2, $t2, 10\n" +
            "\tsub $t0, $t0, 1\n" +
            "\tj _parsing_int\n" +
            "\n" +
            "\t_finish_parse_int:\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string arg in $a0, pos in $a1\n" +
            "###### Checked ######\n" +
            "# used $a0, $v0\n" +
            "func_string.ord:\n" +
            "\tadd $a0, $a0, $a1\n" +
            "\tlb $v0, 0($a0)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# array arg in $a0\n" +
            "# used $v0\n" +
            "func__array.size:\n" +
            "\tlw $v0, -4($a0)\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "###### Checked ######\n" +
            "# used $a0, $a1, $t0, $t1, $t2, $t3, $t4, $t5, $v0\n" +
            "func_stringConcatenate:\n" +
            "\n" +
            "\tsubu $sp, $sp, 4\n" +
            "\tsw $ra, 0($sp)\n" +
            "\n" +
            "\tmove $t2, $a0\n" +
            "\tmove $t3, $a1\n" +
            "\n" +
            "\tlw $t0, -4($a0)\t\t# $t0 is the length of lhs\n" +
            "\tlw $t1, -4($a1)\t\t# $t1 is the length of rhs\n" +
            "\tadd $t5, $t0, $t1\n" +
            "\tadd $a0, $t5, 5\n" +
            "\tli $v0, 9\n" +
            "\tsyscall\n" +
            "\tsw $t5, 0($v0)\n" +
            "\tadd $v0, $v0, 4\n" +
            "\tmove $t4, $v0\n" +
            "\n" +
            "\tmove $a0, $t2\n" +
            "\tmove $a1, $t4\n" +
            "\tjal _string_copy\n" +
            "\n" +
            "\tmove $a0, $t3\n" +
            "\tadd $a1, $t4, $t0\n" +
            "\t# add $a1, $a1, 1\n" +
            "\tjal _string_copy\n" +
            "\n" +
            "\tmove $v0, $t4\n" +
            "\tlw $ra, 0($sp)\n" +
            "\taddu $sp, $sp, 4\n" +
            "\tjr $ra\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "###### Checked ######\n" +
            "# used $a0, $a1, $t0, $t1, $v0\n" +
            "func_stringIsEqual:\n" +
            "\n" +
            "\tlw $t0, -4($a0)\n" +
            "\tlw $t1, -4($a1)\n" +
            "\tbne $t0, $t1, _not_equal\n" +
            "\n" +
            "\t_continue_compare_equal:\n" +
            "\tlb $t0, 0($a0)\n" +
            "\tlb $t1, 0($a1)\n" +
            "\tbeqz $t0, _equal\n" +
            "\tbne $t0, $t1, _not_equal\n" +
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
            "\tjr $ra\n" +
            "\n" +
            "\n" +
            "# string1 in $a0, string2 in $a1\n" +
            "###### Checked ######\n" +
            "# used $a0, $a1, $t0, $t1, $v0\n" +
            "func_stringLess:\n" +
            "\n" +
            "\t_begin_compare_less:\n" +
            "\tlb $t0, 0($a0)\n" +
            "\tlb $t1, 0($a1)\n" +
            "\tblt $t0, $t1, _less_correct\n" +
            "\tbgt $t0, $t1, _less_false\n" +
            "\tbeqz $t0, _less_false\n" +
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
            "\tjr $ra\n\n";
}
