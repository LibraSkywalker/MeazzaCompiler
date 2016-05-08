package MIPS.Instruction;

import MIPS.BasicBlock;
import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static MIPS.TextControler.GlobalState;
import static RegisterControler.RegisterName.*;
import static RegisterControler.VirtualRegister.order;

/**
 * Created by Bill on 2016/4/26.
 */
public abstract class Instruction {
    public String operator;
    boolean isReg;
    public abstract String toString();
    public abstract String virtualPrint();
    public abstract int configure(Function func,LinkedList<Instruction> BlockStat, int position);
    void setOperator(String now){
        operator = now;
    }
    String Translate(Function func,Integer virtualRegister){
        if (virtualRegister == null) return "undefined";
        if (virtualRegister < 32) {
            //System.out.println(virtualRegister);
            return virtualRegister.toString();
        }
        if (GlobalState.property(virtualRegister) == SaveInAddress)
            return "Memory";
        if (GlobalState.property(virtualRegister) == 0)
            return "";
        if (GlobalState.property(virtualRegister) == localSaved)
            return "t" + (func.localState.Dic[localSaved].indexOf(virtualRegister) + 1);
        if (GlobalState.property(virtualRegister) == global)
            return "s" + GlobalState.Dic[global].indexOf(virtualRegister) ;
        if (GlobalState.property(virtualRegister) == local){
            Integer result = order(virtualRegister);
            if (result != -1) return result.toString();
            else return "localMemory";
        }
        return "+++";
    }
    public abstract void globalize(Function Func);
    public abstract void update(VirtualReadWrite usage);
}
