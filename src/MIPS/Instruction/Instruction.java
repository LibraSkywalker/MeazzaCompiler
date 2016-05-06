package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

/**
 * Created by Bill on 2016/4/26.
 */
public abstract class Instruction {
    public String operator;
    boolean isReg;
    public abstract String toString();
    public abstract String virtualPrint();
    void setOperator(String now){
        operator = now;
    }
    public abstract void globalize(Function Func);
    public abstract void update(VirtualReadWrite usage);
}
