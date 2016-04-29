package MIPS.Instruction;

/**
 * Created by Bill on 2016/4/26.
 */
public class FastInstruction extends TernaryInstruction{
    Integer rDest,vDest;
    FastInstruction(){}
    public FastInstruction(String OP,int dest,int src1,int src2,boolean isRegister){
        operator = OP;
        isReg = isRegister;
        vDest = dest;
        vSrc1 = src1;
        vSrc2 = 0;
        if (isReg) vSrc1 = src2;
        else immediate = src2;
    }

    public String toString(){
        return operator + " " + "$" + rDest + " " + "$" + rSrc1 + " " + (isReg ? "$" + rSrc2 : immediate) + "\n";
    }

    public String virtualPrint(){
        return operator + " " + "$" + vDest + " " + "$" + vSrc1 + " " + (isReg ? "$" + vSrc2 : immediate) + "\n";
    }
}
