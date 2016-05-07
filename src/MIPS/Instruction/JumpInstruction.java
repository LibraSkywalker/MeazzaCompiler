package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import java.util.LinkedList;

import static RegisterControler.RegisterName.*;
import static RegisterControler.RegisterName.Rdest;
import static RegisterControler.RegisterName.s_p;

/**
 * Created by Bill on 2016/4/26.
 */
public class JumpInstruction extends Instruction {
    String label;
    int vSrc;
    String rSrc;
    public JumpInstruction(){
        operator = "jr";
        isReg = true;
    }

    public int configure(Function func, LinkedList<Instruction> BlockStat, int position){
        return position;
    }

    public JumpInstruction(String op, String lbl){
        label = lbl;
        operator = op;
        isReg = false;
    }

    public String toString(){
        return operator + " " + (isReg ? "$ra"  : label) + "\n";
    }

    public String virtualPrint(){
        return operator + " " + (isReg ? "$ra" : label) + "\n";
    }

    public void update(VirtualReadWrite usage){}

    @Override
    public void globalize(Function Func) {
        if (operator.equals("jal")){
            if (label.equals(Func.FuncName))
                Func.localState.selfCall();
            else Func.localState.call();
        }
    }
}
