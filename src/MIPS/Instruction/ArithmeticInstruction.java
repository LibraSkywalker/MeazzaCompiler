package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import static MIPS.IRControler.state;
import static RegisterControler.ReservedRegister.global;
import static RegisterControler.ReservedRegister.globalSaved;

/**
 * Created by Bill on 2016/4/26.
 */
public class ArithmeticInstruction extends TernaryInstruction{
    Integer rDest,vDest;
    ArithmeticInstruction(){}
    public ArithmeticInstruction(String OP, int dest, int src1, int src2, boolean isRegister){
        operator = OP;
        isReg = isRegister;
        vDest = dest;
        vSrc1 = src1;
        if (isReg) vSrc2 = src2;
        else immediate = src2;
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + "$" + rSrc1 + " " + (isReg ? "$" + rSrc2 : immediate) + "\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + "$" + vSrc1 + " " + (isReg ? "$" + vSrc2 : immediate) + "\n";
    }

    public void update(VirtualReadWrite usage){
        if (vSrc1 != null) usage.addReader(vSrc1);
        if (vSrc2 != null) usage.addReader(vSrc2);
        usage.addWriter(vDest);
    }

    @Override
    public void globalize(Function Func) {
        if (vSrc1 != null) Func.state.update(vSrc1);
        if (vSrc2 != null) Func.state.update(vSrc2);
        Func.state.set(vDest);
    }
}
