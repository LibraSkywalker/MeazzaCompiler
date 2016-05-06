package MIPS.Instruction;

import MIPS.Function;
import RegisterControler.VirtualReadWrite;

import static MIPS.IRControler.state;

/**
 * Created by Bill on 2016/4/26.
 */
public class RegBinInstruction extends BinaryInstruction{
    Integer rDest,vDest,rSrc,vSrc,immediate;
    RegBinInstruction(){}

    public RegBinInstruction(String OP, int dest, int src, boolean isRegister){
        operator = OP;
        vDest = dest;
        isReg = isRegister;
        if (isReg) vSrc = src;
        else immediate = src;
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + ( isReg ? "$" + rSrc : immediate) +"\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + ( isReg ? "$" + vSrc : immediate) +"\n";
    }



    public void update(VirtualReadWrite usage){
        if (vSrc != null) usage.addReader(vSrc);
        usage.addWriter(vDest);
    }

    @Override
    public void globalize(Function Func) {
        if (vSrc != null) Func.state.update(vSrc);
        Func.state.set(vDest);
    }
}
