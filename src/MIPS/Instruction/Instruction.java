package MIPS.Instruction;

/**
 * Created by Bill on 2016/4/26.
 */
public abstract class Instruction {
    String operator;
    boolean isReg;
    public abstract String toString();
    public abstract String virtualPrint();
    void setOperator(String now){
        operator = now;
    }
}
