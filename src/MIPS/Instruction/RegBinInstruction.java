package MIPS.Instruction;

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
        vSrc = 0;
        if (isReg) vSrc = src;
        else immediate = src;
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + ( isReg ? "$" + rSrc : immediate) +"\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + ( isReg ? "$" + vSrc : immediate) +"\n";
    }
}
