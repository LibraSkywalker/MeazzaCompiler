package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

/**
 * Created by Bill on 2016/4/26.
 */
public class JumpInstruction extends Instruction {
    String label;
    int vSrc,rSrc;
    public JumpInstruction(){
        operator = "jr";
        isReg = true;
    }

    public JumpInstruction(String op, String lbl){
        label = lbl;
        operator = op;
        isReg = false;
    }

    public JumpInstruction(String op, int src){
        vSrc = src;
        operator = op;
        isReg = true;
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
                Func.state.selfCall();
            else Func.state.call();
        }
    }
}
